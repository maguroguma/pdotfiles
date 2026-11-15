#!/usr/bin/env bash
#
# 作業ディレクトリの slides.md と narration/NN.txt から、音声・字幕付きの解説動画を作る。
# 出力: <work_dir>/out/<name>.mp4 と <name>.srt (中間ファイルは <work_dir>/build/)
#
# 使い方:
#   bash build.sh <work_dir> [--name NAME] [--tts auto|voicevox|say|espeak|none]
#                 [--speaker ID] [--speed X] [--port N] [--voice NAME] [--subtitle on|off]
#
# 音声エンジン (--tts auto のとき、上から順に使えるものを選ぶ):
#   1. VOICEVOX (127.0.0.1:<port>)。話者の既定は 6 (四国めたん ツンツン)
#   2. macOS の say (日本語の声。Premium → Enhanced → Kyoko の順に選ぶ)
#   3. espeak-ng (日本語)
#   4. 音声なし (字幕だけ。表示時間は文字数から決める)
# VOICEVOX の接続先は 127.0.0.1 に固定し、変えられるのはポート番号 (数字のみ) だけにしている。
# marp (Chrome) は sandbox-exec (marp-sandbox.sb) の中で動かし、外部への通信とホームの読み書きを禁止する。
# 依存: macOS, marp (Chrome), ffmpeg, ffprobe, python3, bc (VOICEVOX を使うときは curl, jq も)

set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
assets_dir="$script_dir/../assets"
readonly MARKER=".explainer-video"

tts=auto
tts_explicit=false
say_voice=""
say_rate=175
vv_port=50021
vv_speaker=6 # 6: 四国めたん (ツンツン)。一覧は vv-check.sh で確認できる
vv_speed=1.05
subtitle=on
name=""
tail_pad=0.8  # 各スライドの最後に入れる無音 (秒)
max_chars=38  # 字幕 1 枚あたりの最大文字数 (超える文は読点で区切る)。ほぼ 1 行に収まる長さ
band_h=170    # 字幕の帯の高さ (px)。スライドは残りの高さに 16:9 で縮小して置く

# usage はエラーメッセージ $1 と使い方を表示して終了する。
usage() {
  echo "error: $1" >&2
  sed -n '6,8p' "$0" | sed 's/^# *//' >&2
  exit 2
}

# warn は警告を標準エラーに出す。
warn() {
  echo "warning: $*" >&2
}

[ $# -ge 1 ] || usage "work_dir is required"
work_dir="$1"
shift
while [ $# -gt 0 ]; do
  [ $# -ge 2 ] || usage "missing value for $1"
  case "$1" in
    --name) name="$2" ;;
    --tts) tts="$2"; [ "$2" = auto ] || tts_explicit=true ;; # auto は指定なしと同じ (自動で切り替える)
    --port) vv_port="$2" ;;
    --speaker) vv_speaker="$2" ;;
    --speed) vv_speed="$2" ;;
    --voice) say_voice="$2" ;;
    --subtitle) subtitle="$2" ;;
    *) usage "unknown option: $1" ;;
  esac
  shift 2
done

[[ "$tts" =~ ^(auto|voicevox|say|espeak|none)$ ]] || usage "--tts must be auto, voicevox, say, espeak or none"
[[ "$vv_port" =~ ^[0-9]{1,5}$ ]] && [ "$vv_port" -ge 1 ] && [ "$vv_port" -le 65535 ] || usage "invalid --port"
[[ "$vv_speaker" =~ ^[0-9]{1,6}$ ]] || usage "invalid --speaker"
[[ "$vv_speed" =~ ^[0-9]{1,2}(\.[0-9]{1,3})?$ ]] || usage "invalid --speed"
# jq --argjson は先頭の 0 (06 など) を受け付けないため、数値として正規化する
vv_speaker=$((10#$vv_speaker))
vv_speed="$(awk -v s="$vv_speed" 'BEGIN { if (s + 0 < 0.5 || s + 0 > 2.0) exit 1; printf "%g", s + 0 }')" \
  || usage "--speed must be between 0.5 and 2.0"
[ -z "$say_voice" ] || [[ "$say_voice" =~ ^[A-Za-z0-9\ ()_-]+$ ]] || usage "invalid --voice"
[[ "$subtitle" =~ ^(on|off)$ ]] || usage "--subtitle must be on or off"
vv_url="http://127.0.0.1:$vv_port"

# 作業ディレクトリの検証。読み書き・削除する範囲を、一時作業用の場所 (リポジトリの __tmp/ai-coding-agent/ の下か、
# 自分の uid の Claude の scratchpad の下) で、自分が所有するディレクトリに限る
[ -d "$work_dir" ] || usage "work_dir not found: $work_dir"
work_dir="$(cd "$work_dir" && pwd -P)"
case "$work_dir" in
  */__tmp/ai-coding-agent/?* | "/private/tmp/claude-$(id -u)/"?*) ;;
  *) usage "work_dir must be under <repo>/__tmp/ai-coding-agent/ or /tmp/claude-$(id -u)/: $work_dir" ;;
esac
[ -O "$work_dir" ] || usage "work_dir is not owned by you: $work_dir"
[ -f "$work_dir/slides.md" ] || usage "slides.md not found in $work_dir"
[ -d "$work_dir/narration" ] || usage "narration/ not found in $work_dir"
ls "$work_dir"/narration/*.txt >/dev/null 2>&1 || usage "no narration/*.txt in $work_dir"

# 入力にシンボリックリンクやハードリンクがあると、work_dir の外のファイル (秘密鍵など) が字幕や動画に
# 焼き込まれるため拒否する (ハードリンクは、リンク数が 2 以上の通常ファイルとして見分ける)
links="$(find "$work_dir/slides.md" "$work_dir/narration" "$work_dir/caption-dict.tsv" "$work_dir/images" \
  \( -type l -o \( -type f -links +1 \) \) 2>/dev/null || true)"
[ -z "$links" ] || usage "symlinks and hard links are not allowed in inputs: $(printf '%s' "$links" | tr '\n' ' ')"
[ -n "$name" ] || name="$(basename "$work_dir")"
[[ "$name" =~ ^[A-Za-z0-9._-]+$ ]] || usage "invalid --name (use [A-Za-z0-9._-]): $name"

for cmd in marp ffmpeg ffprobe python3 bc sandbox-exec; do
  command -v "$cmd" >/dev/null || { echo "missing command: $cmd" >&2; exit 1; }
done

# voicevox_ready は VOICEVOX エンジンに接続できるとき 0 を返す。
# 同じポートで別のサービスが動いていても台本を送らないよう、/version の応答がバージョン番号の形かも確かめる
voicevox_ready() {
  local version
  command -v curl >/dev/null && command -v jq >/dev/null || return 1
  version="$(curl -sf -m 3 "$vv_url/version")" || return 1
  [[ "$version" =~ ^\"[0-9]+\.[0-9]+\.[0-9]+[^\"]*\"$ ]]
}

# pick_say_voice は say で使える日本語の声を、品質の高い順に 1 つ選んで出力する。
pick_say_voice() {
  local voices
  voices="$(say -v '?' 2>/dev/null | sed -n 's/^\(.*[^ ]\)  *ja_JP .*/\1/p')" || return 1
  [ -n "$voices" ] || return 1
  printf '%s\n' "$voices" | grep -m1 'Premium' \
    || printf '%s\n' "$voices" | grep -m1 'Enhanced' \
    || printf '%s\n' "$voices" | grep -m1 '^Kyoko' \
    || printf '%s\n' "$voices" | head -1
}

# 音声エンジンを決める。明示指定されたエンジンが使えない場合はエラー、auto なら次の候補へ進む
if [ "$tts" = auto ] || [ "$tts" = voicevox ]; then
  if voicevox_ready; then
    tts=voicevox
  elif $tts_explicit; then
    echo "VOICEVOX エンジンに接続できません ($vv_url)。VOICEVOX アプリを起動してください" >&2
    exit 1
  else
    warn "VOICEVOX に接続できないため、ほかの音声エンジンを探します ($vv_url)"
    tts=auto
  fi
fi
if [ "$tts" = auto ] || [ "$tts" = say ]; then
  # --voice の書き間違いで、スライドを作り終えたあとに合成が失敗しないよう、先に声があるか確かめる
  if [ -n "$say_voice" ] && command -v say >/dev/null \
    && ! say -v '?' 2>/dev/null | sed -n 's/^\(.*[^ ]\)  *[a-z][a-z]_[A-Za-z0-9]* .*/\1/p' | grep -Fxq -- "$say_voice"; then
    echo "say に声 '$say_voice' がありません (say -v '?' で一覧を確認)" >&2
    exit 1
  fi
  if command -v say >/dev/null && { [ -n "$say_voice" ] || say_voice="$(pick_say_voice)"; }; then
    tts=say
  elif $tts_explicit; then
    echo "say で使える日本語の声が見つかりません" >&2
    exit 1
  else
    tts=auto
  fi
fi
if [ "$tts" = auto ] || [ "$tts" = espeak ]; then
  if command -v espeak-ng >/dev/null; then
    tts=espeak
  elif $tts_explicit; then
    echo "espeak-ng が見つかりません" >&2
    exit 1
  else
    warn "使える音声エンジンが無いため、音声なし (字幕のみ) で作ります"
    tts=none
  fi
fi

# クレジット表記 (slides.md の {{VOICE_CREDIT}} に入れる)。VOICEVOX は規約上「VOICEVOX:キャラクター名」が必要
case "$tts" in
  voicevox)
    speakers_json="$(curl -sf -m 30 "$vv_url/speakers")" \
      || { echo "VOICEVOX から話者の一覧を取得できません ($vv_url/speakers)" >&2; exit 1; }
    speaker_name="$(printf '%s' "$speakers_json" \
      | jq -r --argjson id "$vv_speaker" 'first(.[] | select(any(.styles[]; .id == $id)) | .name) // empty')" \
      || { echo "VOICEVOX の話者の一覧を解釈できません ($vv_url/speakers)" >&2; exit 1; }
    [ -n "$speaker_name" ] || { echo "話者 ID $vv_speaker が見つかりません (vv-check.sh で確認)" >&2; exit 1; }
    credit="VOICEVOX:$speaker_name"
    grep -q '{{VOICE_CREDIT}}' "$work_dir/slides.md" \
      || warn "slides.md に {{VOICE_CREDIT}} がありません。VOICEVOX の利用規約ではクレジット表記が必要です"
    ;;
  say) credit="macOS say ($say_voice)" ;;
  espeak) credit="espeak-ng" ;;
  none) credit="なし" ;;
esac

# synthesize は台本ファイル $1 を読み上げ、24kHz mono の wav として $2 に書き出す。
synthesize() {
  local txt="$1" out="$2" raw="$2.raw"
  case "$tts" in
    voicevox)
      # audio_query で読み・抑揚を作り、話速を調整して synthesis に渡す
      # -m で上限時間を決め、エンジンが応答しなくなってもビルドが止まり続けないようにする
      curl -sf -m 60 -X POST -G --data-urlencode "text@$txt" --data-urlencode "speaker=$vv_speaker" "$vv_url/audio_query" \
        | jq --argjson s "$vv_speed" '.speedScale = $s' \
        | curl -sf -m 120 -X POST -H 'Content-Type: application/json' --data-binary @- \
            "$vv_url/synthesis?speaker=$vv_speaker" -o "$raw"
      ;;
    say) say -v "$say_voice" -r "$say_rate" -f "$txt" -o "$raw.aiff" && mv "$raw.aiff" "$raw" ;;
    espeak) espeak-ng -v ja -f "$txt" -w "$raw" ;;
    none)
      # 字幕を読める時間だけ無音にする (1 文字 0.13 秒、最短 1.5 秒)
      local secs
      secs="$(python3 -I -c 'import sys; n = len(open(sys.argv[1], encoding="utf-8").read().strip()); print(max(1.5, n * 0.13))' "$txt")"
      ffmpeg -v error -y -f lavfi -i "anullsrc=r=24000:cl=mono" -t "$secs" -f wav "$raw"
      ;;
  esac || { echo "音声合成に失敗しました ($tts): $txt" >&2; return 1; }
  # 連結できるよう、エンジンによらず形式を揃える
  ffmpeg -v error -y -i "$raw" -ar 24000 -ac 1 -c:a pcm_s16le "$out" && rm -f "$raw"
}

# duration_of は音声・動画ファイル $1 の長さ (秒) を出力する。
duration_of() {
  ffprobe -v error -show_entries format=duration -of csv=p=0 "$1"
}

# srt_time は秒数 $1 を SRT の時刻表記 (HH:MM:SS,mmm) にする。
srt_time() {
  awk -v t="$1" 'BEGIN { ms = int(t * 1000 + 0.5); printf "%02d:%02d:%02d,%03d", ms/3600000, (ms/60000)%60, (ms/1000)%60, ms%1000 }'
}

# reset_dir はこのスクリプトが作ったディレクトリ (マーカーあり) だけを作り直す。
reset_dir() {
  local dir="$1"
  if [ -e "$dir" ]; then
    if [ -L "$dir" ] || [ ! -f "$dir/$MARKER" ]; then
      echo "$dir はこのスクリプトが作ったものではないため、消さずに終了します" >&2
      exit 1
    fi
    rm -rf -- "$dir"
  fi
  mkdir -p "$dir" && : >"$dir/$MARKER"
}

build="$work_dir/build"
out="$work_dir/out"
reset_dir "$build"
# out/ は別の --name で作った動画を残すため作り直さず、同じ名前のファイルだけを上書きする
if [ ! -d "$out" ]; then
  mkdir -p "$out" && : >"$out/$MARKER"
elif [ -L "$out" ] || [ ! -f "$out/$MARKER" ]; then
  echo "$out はこのスクリプトが作ったものではないため、書き込まずに終了します" >&2
  exit 1
fi
# 動画と字幕は build/ に作り、すべて成功したときだけ out/ へ移す (失敗しても前回の出力を壊さないため)
mp4="$out/$name.mp4"
srt="$out/$name.srt"
mp4_tmp="$build/$name.mp4"
srt_tmp="$build/$name.srt"

# run_marp は marp を sandbox-exec の中で実行する。外部への通信、build/ と macOS のユーザー用一時領域以外への
# 書き込み、ホームの中のファイル (作業ディレクトリなどを除く) の読み込みを OS のレベルで禁止する。
# 外から sandbox をかけると Chrome 自身の sandbox が起動できないため、CHROME_NO_SANDBOX でそちらは切る
home="$(cd ~ && pwd -P)"

# home_root_of はコマンド $1 の実体がホームの中にあれば、ホーム直下のその置き場 (~/.volta, ~/.asdf など) を出力する。
# ホームの外 (Homebrew など) なら、sandbox に渡しても何も許さない存在しないパスを出力する。
home_root_of() {
  local real rest root
  real="$(python3 -I -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$(command -v "$1")")"
  case "$real" in
    "$home"/*) ;;
    *) echo "/nonexistent-explainer-video"; return ;;
  esac
  rest="${real#"$home"/}"
  root="$home/${rest%%/*}"
  # 読み込みを許すのはツールの置き場らしいドットディレクトリだけにする (~/Documents などを丸ごと許さない)
  case "${rest%%/*}" in
    .ssh | .aws | .gnupg | .claude | .config | .kube | .docker) ;;
    .?*) echo "$root"; return ;;
  esac
  echo "$1 の置き場 ($root) は sandbox で読み込みを許せません。$1 をホーム直下のツール用ディレクトリか Homebrew に入れてください" >&2
  exit 1
}

run_marp() {
  local user_tmp skill_dir marp_root node_root log="$build/marp.log"
  skill_dir="$(cd "$script_dir/.." && pwd -P)"
  marp_root="$(home_root_of marp)" || exit 1
  node_root="$(home_root_of node)" || exit 1
  # Chrome は TMPDIR によらずこの領域に書き込む。環境変数ではなく OS から取り、想定の場所であることを確かめる
  user_tmp="$(cd "$(getconf DARWIN_USER_TEMP_DIR)" && pwd -P)" || { echo "DARWIN_USER_TEMP_DIR を取得できません" >&2; exit 1; }
  case "$user_tmp" in
    /private/var/folders/?*/?*/T) ;;
    *) echo "想定外のユーザー用一時領域です: $user_tmp" >&2; exit 1 ;;
  esac
  mkdir -p "$build/tmp"
  # marp はカレントディレクトリの設定ファイル (.marprc, marp.config.js など) を読むため、build/ の中で動かし、
  # 中身の無い設定ファイルを明示して、work_dir に置かれた設定が使われないようにする。
  # --no-stdin が無いと、標準入力が閉じていない環境で marp が入力を待ち続ける。
  # 失敗したらその場で止める (後段で「台本とスライドが対応しない」などの誤解を招くエラーにしないため)
  # marp は変換に失敗しても終了コード 0 で返ることがあるため、ログの [ ERROR ] も見る
  if (cd "$build" && TMPDIR="$build/tmp" CHROME_NO_SANDBOX=1 sandbox-exec -f "$script_dir/marp-sandbox.sb" \
    -D OUT_DIR="$build" -D USER_TMP="$user_tmp" -D HOME_DIR="$home" \
    -D WORK_DIR="$work_dir" -D SKILL_DIR="$skill_dir" -D MARP_ROOT="$marp_root" -D NODE_ROOT="$node_root" \
    marp --no-stdin --config-file "$assets_dir/marp-config.json" "$@" </dev/null) >"$log" 2>&1 \
    && ! grep -q '\[ *ERROR *\]' "$log"; then
    return 0
  fi
  echo "marp が失敗しました (marp $*)。ログの末尾:" >&2
  grep -v '^ *at ' "$log" | tail -n 8 >&2
  echo "sandbox (marp-sandbox.sb) が、marp に必要なファイルの読み書きを止めた可能性もあります" >&2
  exit 1
}

# check_resources は marp で Markdown $1 を HTML にし、外部や作業ディレクトリ外のリソースを読み込まないか確かめる。
# 通信は run_marp の sandbox でも止めているが、止められた画像が黙って欠けないよう、ここで理由つきで知らせる
check_resources() {
  local md="$1" html="${1%.md}.check.html"
  run_marp -o "$html" "$md"
  python3 -I "$script_dir/check-resources.py" "$html" "$(dirname "$md")" "$work_dir" || exit 1
}

# 1. スライドを PNG に書き出す (slides.001.png, ...)。クレジットはここで差し込む
#    画像は work_dir/images/ に置けば、build/ にコピーして slides.md と同じ相対パス (images/x.png) で読める
#    --allow-local-files が無いと、枚数が多いときに Chrome の読み込みがタイムアウトする
python3 -I -c 'import sys; src, dst, credit = sys.argv[1:]; text = open(src, encoding="utf-8").read(); open(dst, "w", encoding="utf-8").write(text.replace("{{VOICE_CREDIT}}", credit))' \
  "$work_dir/slides.md" "$build/slides.md" "$credit"
if [ -d "$work_dir/images" ]; then
  cp -R "$work_dir/images" "$build/images"
fi
check_resources "$build/slides.md"
run_marp --images png --image-scale 1.5 --allow-local-files -o "$build/slides.png" "$build/slides.md"

# 2. 台本を字幕・音声の単位に分け、字幕画像を作る (cap.001.png, ...)。辞書は作業ディレクトリのものが優先
dicts=("$assets_dir/caption-dict.tsv")
[ -f "$work_dir/caption-dict.tsv" ] && dicts+=("$work_dir/caption-dict.tsv")
python3 -I "$script_dir/prep.py" "$work_dir/narration" "$build" "$max_chars" "${dicts[@]}"
# 台本の番号がスライドの 1..N とちょうど対応しているか確かめる (台本の無いスライドは動画から黙って抜けるため)
n_slides="$(find "$build" -maxdepth 1 -name 'slides.*.png' | wc -l | tr -d ' ')"
expected="$(awk -v n="$n_slides" 'BEGIN { for (i = 1; i <= n; i++) printf "%d ", i }')"
actual="$(cut -f1 "$build/units.tsv" | uniq | awk '{ printf "%d ", $1 }')"
[ "$expected" = "$actual" ] || {
  echo "台本の番号 ($actual) がスライド ($n_slides 枚: $expected) と対応していません" >&2
  exit 1
}
if [ "$subtitle" = on ]; then
  check_resources "$build/captions.md"
  run_marp --images png --image-scale 1.5 --allow-local-files -o "$build/cap.png" "$build/captions.md"
  # 字幕の枚数が単位の数と違うと、以降の字幕がすべてずれるため止める
  n_caps="$(find "$build" -maxdepth 1 -name 'cap.*.png' | wc -l | tr -d ' ')"
  n_units="$(wc -l <"$build/units.tsv" | tr -d ' ')"
  [ "$n_caps" = "$n_units" ] || { echo "字幕画像の枚数 ($n_caps) が字幕の単位の数 ($n_units) と一致しません" >&2; exit 1; }
fi

# 字幕ありのときは、スライドを上に縮小して置き、下に字幕の帯を作る
slide_h=$((1080 - band_h))
slide_w=$((slide_h * 16 / 9 / 2 * 2))
slide_x=$(((1920 - slide_w) / 2))

# 各スライドの末尾に入れる無音
ffmpeg -v error -y -f lavfi -i "anullsrc=r=24000:cl=mono" -t "$tail_pad" -c:a pcm_s16le "$build/silence.wav"

: >"$build/frames.txt"
: >"$build/audio.txt"
: >"$srt_tmp"
t=0 n=0 last_frame=""
total_units="$(wc -l <"$build/units.tsv" | tr -d ' ')"
# 各行の末尾に「スライドの最後の単位か (1/0)」を付ける。ループの中で毎回ファイルを読み直さずに済むよう、先読みしておく
awk -F'\t' 'NR > 1 { print prev "\t" ($1 != prev_slide) } { prev = $0; prev_slide = $1 } END { if (NR) print prev "\t1" }' \
  "$build/units.tsv" >"$build/units-last.tsv"
while IFS=$'\t' read -r slide unit caption is_last; do
  n=$((n + 1))
  png="$build/slides.$(printf '%03d' "$((10#$slide))").png"
  [ -f "$png" ] || { echo "slide not found: $png (narration/$slide.txt に対応するスライドがありません)" >&2; exit 1; }

  # 3. 1 単位ぶんの音声を作る
  synthesize "$build/u_$unit.txt" "$build/a_$unit.wav"
  dur="$(duration_of "$build/a_$unit.wav")"
  [[ "$dur" =~ ^[0-9]+(\.[0-9]+)?$ ]] || { echo "音声の長さを取得できません ($dur): $build/a_$unit.wav" >&2; exit 1; }
  echo "file 'a_$unit.wav'" >>"$build/audio.txt"

  # スライドの最後の単位なら、無音を足して区切りを作る
  if [ "$is_last" = 1 ]; then
    echo "file 'silence.wav'" >>"$build/audio.txt"
    dur="$(echo "$dur + $tail_pad" | bc)"
  fi

  # 4. 1 単位ぶんの静止画を作る (スライド + 字幕の帯)。字幕なしならスライドごとに 1 枚だけ作って使い回す
  if [ "$subtitle" = on ]; then
    frame_name="f_$unit.png"
    cap="$build/cap.$(printf '%03d' "$n").png"
    [ -f "$cap" ] || { echo "caption image not found: $cap" >&2; exit 1; }
    ffmpeg -v error -y -i "$png" -i "$cap" -filter_complex \
      "[0]scale=$slide_w:$slide_h,pad=1920:1080:$slide_x:0:color=0x282828[bg];[1]scale=1920:1080,crop=1920:$band_h:0:$slide_h[c];[bg][c]overlay=0:$slide_h" \
      -frames:v 1 "$build/$frame_name"
  else
    frame_name="f_s$((10#$slide)).png"
    [ -f "$build/$frame_name" ] || ffmpeg -v error -y -i "$png" -vf "scale=1920:1080" -frames:v 1 "$build/$frame_name"
  fi
  printf "file '%s'\nduration %s\n" "$frame_name" "$dur" >>"$build/frames.txt"
  last_frame="$frame_name"

  # 5. 字幕ファイル (SRT) に追記する
  end="$(echo "$t + $dur" | bc)"
  printf '%d\n%s --> %s\n%s\n\n' "$n" "$(srt_time "$t")" "$(srt_time "$end")" "$caption" >>"$srt_tmp"
  t="$end"
  printf '\r[%d/%d] slide %s' "$n" "$total_units" "$slide" >&2
done <"$build/units-last.tsv"
echo >&2
# concat demuxer は最後の画像の duration を使わないため、最後の画像をもう一度並べる
echo "file '$last_frame'" >>"$build/frames.txt"

# 6. 静止画の列と音声を 1 本にまとめる
ffmpeg -v error -y -f concat -safe 0 -i "$build/audio.txt" -c copy "$build/narration.wav"
ffmpeg -v error -y -f concat -safe 0 -i "$build/frames.txt" -i "$build/narration.wav" \
  -c:v libx264 -tune stillimage -pix_fmt yuv420p -r 30 \
  -c:a aac -b:a 160k -ar 48000 -ac 2 -shortest -movflags +faststart "$mp4_tmp"

# 7. out/ へ移す。出力先がシンボリックリンクだと、リンク先のファイルを壊すおそれがあるため拒否する
for f in "$mp4" "$srt"; do
  if [ -L "$f" ] || { [ -e "$f" ] && [ ! -f "$f" ]; }; then
    echo "$f が通常のファイルではないため、上書きせずに終了します (作った動画は $build に残っています)" >&2
    exit 1
  fi
done
mv -f "$mp4_tmp" "$mp4"
mv -f "$srt_tmp" "$srt"

# 結果の要約。longest は字幕のはみ出し確認用 (build/f_<unit>.png を見る)
# macOS の awk の length() はバイト数を返すため、文字数で比べられる python で選ぶ
longest="$(python3 -I -c 'import sys; rows = [l.rstrip("\n").split("\t") for l in open(sys.argv[1], encoding="utf-8")]; print(max(rows, key=lambda r: len(r[2]))[1])' "$build/units.tsv")"
echo "video: $mp4"
echo "srt: $srt"
echo "tts: $tts / credit: $credit / subtitle: $subtitle / units: $total_units / longest caption: $build/f_$longest.png"
duration_of "$mp4" | awk '{ printf "duration: %d:%02d\n", $1/60, $1%60 }'

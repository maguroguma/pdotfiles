package calc

import (
	"log"
	"testing"
)

// テスト全体の前処理・後処理が必要な場合は、TestMainを用意する
func TestMain(m *testing.M) {
	// テスト全体の実行前
	setup()
	// テスト全体の実行後
	defer teardown()

	// 各テスト関数はすべてこれを経由して実行される
	m.Run()
}

func setup() {
	log.Println("setup")
}
func teardown() {
	log.Println("teardown")
}

func TestCalc(t *testing.T) {
	// 引数セットは構造体にしておくと便利
	type args struct {
		a        int
		b        int
		operator string
	}

	tests := []struct {
		name    string // テストケース名をt.Runにそのまま渡せる
		args    args
		want    int // got, wantというペアで覚える
		wantErr bool
	}{
		{
			name: "足し算",
			args: args{
				a:        10,
				b:        2,
				operator: "+",
			},
			want:    12,
			wantErr: false,
		},
		{
			name: "不正な演算子を指定",
			args: args{
				a:        10,
				b:        2,
				operator: "?",
			},
			wantErr: true,
		},
	}

	// テスト関数の実行前
	t.Log("Start TestCalc")
	// テスト関数の実行後
	defer func() {
		t.Log("End TestCalc")
	}()

	for _, tt := range tests {
		// 各テストケースをサブテストで実行することで、
		// 失敗したテストケースがあっても、後続のテストケースをすべて処理できる
		t.Run(tt.name, func(t *testing.T) {
			// テストケースの実行前
			t.Log("Start", tt.name)
			// テストケースの実行後
			defer func() {
				t.Log("End", tt.name)
			}()

			got, err := Calc(tt.args.a, tt.args.b, tt.args.operator)
			if (err != nil) != tt.wantErr {
				t.Errorf("Calc() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if got != tt.want {
				t.Errorf("Calc() = %v, want %v", got, tt.want)
			}
		})
	}
}

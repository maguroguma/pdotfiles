# リモートリポジトリの情報からgithubのhttpsのリンクを作成する
git remote -v | grep "github" | cut -d":" -f2 | cut -d"." -f1 | sort | uniq | awk '{print "https://github.com/"$1"/pulls?q=is:pr is:closed "}'

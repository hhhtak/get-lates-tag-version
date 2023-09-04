# get-lates-tag-version

Git で最新のタグを取得する(Get latest tags in Git)

# 使い方

実行したいディレクトリに移動する

```
cd ../hoge
```

RELEASE_TAG_LIST に対象となるタグの名前を追加する

```
RELEASE_TAG_LIST=("release-hoge-v" "release-hoge2-v")
```

シェルを実行する

```
sh getLatestTagVersion.sh
```

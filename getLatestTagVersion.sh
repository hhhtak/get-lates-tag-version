#!/bin/sh

git fetch > /dev/null

TAGS=`git tag -l`
ARRAY_TAG=(${TAGS// / })

RELEASE_TAG_LIST=("release-hoge-v" "release-hoge2-v")

filterTag () {
    FILTER_TAGS=()
    for TNAME in "${ARRAY_TAG[@]}"
    do
        if $(echo $TNAME | grep $RNAME > /dev/null) ; then
            FILTER_TAGS=(${FILTER_TAGS[@]} ${TNAME})
        fi
    done
}

compare () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi

    local IFS=.
    local i ver1=($1) ver2=($2)
    # ver1の空のフィールドをゼロで埋める
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done

    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # ver2の空のフィールドをゼロで埋める
            ver2[i]=0
        fi

        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi

        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

getLatest () {
    LATEST_VERSION=0.0.0
    LATEST_TAG=""
    for TAG in "${FILTER_TAGS[@]}"
    do
        TARGET_VERSION=`echo $TAG | tr -d $RNAME`
        compare $LATEST_VERSION $TARGET_VERSION
        RESULT=$?
        if [ $((RESULT)) -eq 2 ] ; then
            LATEST_VERSION=$TARGET_VERSION
            LATEST_TAG=$TAG
        fi
    done
    echo $LATEST_TAG
}

echo "〓 start 〓 〓 〓 〓 〓 〓 〓 〓"
for RNAME in "${RELEASE_TAG_LIST[@]}"
do
    filterTag
    getLatest
done
echo "〓 end 〓 〓 〓 〓 〓 〓 〓 〓"

#!/bin/bash

WATDIV_HOME="$MYHOME/watdiv"

[ $# -lt 2 ] && echo "usage: $0 <scale> <count>" && exit 1

BASEDIR=$(cd "`dirname $0`"; pwd)

SCALE=$1
COUNT=$2

rm -rf "$BASEDIR/scale_$1/queries"
mkdir "$BASEDIR/scale_$1/queries"
cd "$BASEDIR/scale_$1"

for i in ../sparql/*; do
    [ -z "`grep '#mapping' "$i"`" ] && THISCOUNT=1 || THISCOUNT=$COUNT
    "$WATDIV_HOME/bin/Release/watdiv" -q "$WATDIV_HOME/model/wsdbm-data-model-short-pred.txt" "$i" $THISCOUNT 1 |\
    grep -v '^$' |\
    sed 's/[<>]//g' |\
    csplit -s -n 1 -z - '/SELECT/' '{*}'
    FILENAME="`basename "$i"`"
    QUERYNAME="${FILENAME%%.*}"
    for ((j = 0; j < $THISCOUNT; ++j)); do
        mv xx$j "queries/$QUERYNAME-$(expr $j + 1)__VP_SO-OS-SS-VP.in"
    done
done


#!/bin/bash

BASEDIR=$(cd "`dirname $0`"; pwd)
. "$BASEDIR/conf.sh"

[ $# -lt 2 ] && echo "usage: $0 <scale> <count>" && exit 1

SCALE=$1
COUNT=$2

rm -rf "$BASEDIR/scale_$1/queries"
mkdir "$BASEDIR/scale_$1/queries"
mkdir "$BASEDIR/scale_$1/queries/s2rdf"
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
        FNAME="$QUERYNAME-$(expr $j + 1)"
        mv xx$j "queries/${FNAME}.txt"
        cat "$S2RDF_HOME/QueryTranslator/WatDivQuerySet/SPARQL/prefix.txt" "queries/${FNAME}.txt" > "queries/s2rdf/${FNAME}__VP_SO-OS-SS-VP.in"
    done
done


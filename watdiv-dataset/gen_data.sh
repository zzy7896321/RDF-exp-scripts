#!/bin/bash

WATDIV_HOME="$MYHOME/watdiv"

[ $# -lt 1 ] && echo "usage: $0 <scale>" && exit 1

BASEDIR=$(cd "`dirname $0`"; pwd)

rm -rf "$BASEDIR/scale_$1"
mkdir "$BASEDIR/scale_$1"
cd "$BASEDIR/scale_$1"

hdfs dfs -rm -r watdiv/scale_$1
hdfs dfs -mkdir -p watdiv/scale_$1
"$WATDIV_HOME/bin/Release/watdiv" -d "$WATDIV_HOME/watdiv/model/wsdbm-data-model-short-pred.txt" $1 | hdfs dfs -put - watdiv/scale_$1/raw_triplets.txt



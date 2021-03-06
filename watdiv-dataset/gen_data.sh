#!/bin/bash

BASEDIR=$(cd "`dirname $0`"; pwd)
. "$BASEDIR/conf.sh"

[ $# -lt 1 ] && echo "usage: $0 <scale>" && exit 1

rm -rf "$BASEDIR/scale_$1"
mkdir "$BASEDIR/scale_$1"
cd "$BASEDIR/scale_$1"

hdfs dfs -rm -r -f watdiv/scale_$1
hdfs dfs -mkdir -p watdiv/scale_$1
"$WATDIV_HOME/bin/Release/watdiv" -d "$WATDIV_HOME/model/wsdbm-data-model-short-pred.txt" $1 | hdfs dfs -put - watdiv/scale_$1/raw_triplets.txt



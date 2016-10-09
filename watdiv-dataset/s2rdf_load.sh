#!/bin/bash

BASEDIR=$(cd "`dirname $0`"; pwd)
. "$BASEDIR/conf.sh"

[ $# -lt 2 ] && echo "usage: $0 <scale> <selUB>" && exit 1

SCALE=$1
SELUB=`echo $2 | awk '{ printf("%.2f", $1); }'`

[ ! -e "$BASEDIR/scale_$SCALE/saved.txt" ] && $BASEDIR/gen $SCALE

rm -rf "$BASEDIR/scale_$SCALE/$SELUB"
mkdir "$BASEDIR/scale_$SCALE/$SELUB"
cd "$BASEDIR/scale_$SCALE/$SELUB"

echo "spark_master = \"$SPARK_MASTER\"" > "$S2RDF_HOME/master.conf"
"$S2RDF_HOME"/DataSetCreator/DataSetCreator.py -i "$HDFS_HOME/watdiv/scale_$SCALE/raw_triplets.txt" -s $SELUB

hdfs dfs -rm -f -r "$HDFS_HOME/watdiv/scale_$SCALE/$SELUB"
hdfs dfs -mkdir "$HDFS_HOME/watdiv/scale_$SCALE/$SELUB"
hdfs dfs -mv "$HDFS_HOME/watdiv/scale_$SCALE/base.parquet" "$HDFS_HOME/watdiv/scale_$SCALE/VP" "$HDFS_HOME/watdiv/scale_$SCALE/ExtVP" "$HDFS_HOME/watdiv/scale_$SCALE/$SELUB/"


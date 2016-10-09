#!/bin/bash

S2RDF_HOME="$MYHOME/S2RDF"
HDFS_HOME=hdfs://ravenserv2.cs.utah.edu:9000/user/zyzhao
SPARK_MASTER=spark://ravenserv1.cs.utah.edu:10077

[ $# -lt 2 ] && echo "usage: $0 <scale> <selUB>" && exit 1

SCALE=$1
SELUB=`echo $2 | awk '{ printf("%.2f", $1); }'`

BASEDIR="$(cd "`dirname "$0"`"; pwd)"

[ ! -e "$BASEDIR/scale_$SCALE/saved.txt" ] && $BASEDIR/generate_watdiv.sh $SCALE

rm -rf "$BASEDIR/scale_$SCALE/$SELUB"
mkdir "$BASEDIR/scale_$SCALE/$SELUB"
cd "$BASEDIR/scale_$SCALE/$SELUB"

echo "spark_master = \"$SPARK_MASTER\"" > "$S2RDF_HOME/master.conf"
"$S2RDF_HOME"/DataSetCreator/DataSetCreator.py -i "$HDFS_HOME/watdiv/scale_$SCALE/raw_triplets.txt" -s $SELUB

hdfs dfs -rm -f -r "$HDFS_HOME/watdiv/scale_$SCALE/$SELUB"
hdfs dfs -mkdir "$HDFS_HOME/watdiv/scale_$SCALE/$SELUB"
hdfs dfs -mv "$HDFS_HOME/watdiv/scale_$SCALE/base.parquet" "$HDFS_HOME/watdiv/scale_$SCALE/VP" "$HDFS_HOME/watdiv/scale_$SCALE/ExtVP" "$HDFS_HOME/watdiv/scale_$SCALE/$SELUB/"




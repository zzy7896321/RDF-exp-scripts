#!/bin/bash

BASEDIR=$(cd "`dirname $0`"; pwd)
. "$BASEDIR/conf.sh"

[ $# -lt 2 ] && echo "usage: $0 <scale> <selUB>" && exit 1

SCALE=$1
SELUB=`echo $2 | awk '{ printf("%.2f", $1); }'`
cd "$BASEDIR/scale_$SCALE/$SELUB"

"$S2RDF_HOME/QueryTranslator/WatDivQuerySet/translateWatDivQueries.py" -s "$BASEDIR/scale_$SCALE/queries/s2rdf" -t "$BASEDIR/scale_$SCALE/$SELUB/s2rdf_sql"  -a "$BASEDIR/scale_$SCALE/$SELUB" -d WatDiv_${SCALE}_${SELUB} -u $SELUB


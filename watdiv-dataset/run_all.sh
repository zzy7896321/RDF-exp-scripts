#!/bin/bash

for i in 1 10 100 1000 10000; do
    echo "scale $i"
    ./gen $i
    ./s2rdf_prepare $i 1
    ./s2rdf_run $i 1
done

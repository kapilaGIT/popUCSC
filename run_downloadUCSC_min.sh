#!/bin/bash

VAR=( $(awk -F'\t' '{print $1}' ./variables ) )

TABLES=( $(awk -F'\t' '{print $1}' ./default_table.txt) )

SIZE=$(echo ${#TABLES[*]})

echo $SIZE

#for k in {1..46..1}; do

for (( k=1; k<=$SIZE; k++ ))

do

echo "${TABLES[$k-1]}"


wget http://${VAR[0]}${TABLES[$k-1]}.sql

wget http://${VAR[0]}${TABLES[$k-1]}.txt.gz

gunzip ${TABLES[$k-1]}.txt.gz

done

./run_loadTxtFilesNew.sh ${VAR[1]} ${VAR[2]}



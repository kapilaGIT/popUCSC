#!/bin/bash


VAR=( $(awk -F'\t' '{print $1}' ./variables ) )

rsync -avzP rsync://${VAR[0]} .

gunzip *.gz

./run_loadTxtFilesNew.sh ${VAR[1]} ${VAR[2]}



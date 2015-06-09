#!/bin/bash


for SQL in `ls -d ./*.sql`

do

SQLF=$( echo $SQL |sed "s#\.\/##1" |sed 's#\/##1' |sed 's#\.sql##1')

echo $SQLF >> default_table.txt

done

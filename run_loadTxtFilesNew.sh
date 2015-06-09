#!/bin/bash

module load apps/kent/303.1/gcc-4.4.7
DATABASE=$1
ORGANISM=$2

if [[ $1 == "test" ]]
then
	for SQL in `ls -d ./*.sql`
	do
		SQLF=$( echo $SQL |sed "s#\.\/##1" |sed 's#\/##1' |sed 's#\.sql##1')
		echo ""
		echo "hgsql $DATABASE < $SQLF.sql"
		echo ""
		echo "hgsql $DATABASE -e 'load data local infile "$SQLF.txt" into table $SQLF;'"
		echo ""
	done
	exit		

elif [[ $1 == "" || $1 == "-h" || $1 == "--help" ]]
then
      	echo "please provide two inputs."
      	echo ""
      	echo "bash loadChain.sh <database e.g. galGal4> <organism e.g. Chicken> without <>."
      	echo ""
      	echo "The first input is the database name"
      	echo ""
      	echo "Second input is the track type based on file type, currently this only takes Net or Chain files"
      	echo ""
      	exit
elif [[ $2 == "" ]]
then
	echo "please provide two inputs."
      	echo ""
      	echo "bash loadChain.sh <database e.g. galGal4> <organism e.g. Chicken> without <>."
      	echo ""
      	echo "The first input is the database name"
      	echo ""
      	echo "Second input is the track type based on file type, currently this only takes Net or Chain files"
      	echo ""
      	exit
else
	echo ""
    	echo "It seems you have entered both inputs, but chack whether they are correct"
        echo ""
	echo "Database name: $DATABASE"
        echo ""
	echo "Organism name: $ORGANISM"
        read -p "Do you think they are correct? (y/n) " RESP
	if [ "$RESP" = "n" ]; then
        	echo ""
		echo "Please re-run the script with correct inputs"
        	echo ""
		echo"I will try to add an option to correct the incorrect input, but it is not the time"
        	exit
	else
		echo "perfect! It seems that you have provided correct inputs"


		for SQL in `ls -d ./*.sql`
		do
			SQLF=$( echo $SQL |sed "s#\.\/##1" |sed 's#\/##1' |sed 's#\.sql##1')
			echo ""
			echo "hgsql $DATABASE < $SQLF.sql"
			hgsql $DATABASE < $SQLF.sql 
			echo ""
			echo "hgsql $DATABASE -e 'load data local infile "$SQLF.txt" into table $SQLF;'"
			hgsql $DATABASE -e "load data local infile '"$SQLF".txt' into table $SQLF;"
		done
	echo ""
	echo "hgTrackDb $ORGANISM $DATABASE trackDb $KENTDIR/share/trackDb.sql /users/ucscadmins/gbdb/$DATABASE/"
	hgTrackDb $ORGANISM $DATABASE trackDb $KENTDIR/share/trackDb.sql /users/ucscadmins/gbdb/$DATABASE/
	echo ""
	echo "hgsql $DATABASE -e 'load data local infile "trackDb.txt" into table trackDb;'"
	hgsql $DATABASE -e 'load data local infile "trackDb.txt" into table trackDb;'
	fi
fi

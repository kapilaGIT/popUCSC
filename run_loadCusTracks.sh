#!/bin/bash

module load apps/kent/303.1/gcc-4.4.7

track=( $(awk -F'\t' '{print $1}' ./species_name.txt) )

common=( $(awk -F'\t' '{print $2}' ./species_name.txt) )

org=$1
type=$2
tail=$3
organism=$4

echo ""
echo "Hi this script will assist you to populate .maf .net and .chain files in the database of your organism of interest"
echo ""
echo "you need to create a file with species names. you need this if you want to populatte Chain or Nets files"
echo ""
echo "The files should have the species info in the following (tab delimited)"
echo ""
echo -e "SciName_1\tcommon-name_1"
echo -e "SciName_2\tcommon-name_2"
echo -e "SciName_3\tcommon-name_3"
echo -e "....\t....."
echo ""
echo "type touch species_name.txt in the command lione terminal"
echo ""
echo "Then use your favourite text editor"
echo ""
echo "if you dont have one do the following"
echo ""
echo "nano species_name.txt"
echo ""
echo "key the scientific name according to the UCSC nomenclature i.e. Bos taurus is written bosTauN. N is the genome version number"
echo ""
echo "if your organism is not included in NCBI or UCSC then do the same but replace N with 1"
echo ""
echo "Then press tab and type in the common name. If there are more than one name add underscore _ between words without spaces"
echo ""
echo "Then re run this script"
echo ""

if [[ $1 == "" || $1 == "-h" || $1 == "--help" ]]
then
      echo "please provide four inputs."
      echo ""
      echo "bash loadChain.sh <database e.g. galGal4> <track type e.g. Chain/Net/Maf> <file tail e.g. .chain/.net/.maf > <organism e.g. Chicken> without <>."
      echo ""
      echo "The first input is the database name"
      echo ""
      echo "Second input is the track type based on file type, currently this only takes Net or Chain files"
      echo ""
      echo "Third input is the file tail. Again it has to end with either .net or .chain"
      echo ""
      echo "The last input is the common name of the organism"
      echo ""
      exit
elif [[ $4 == "" ]]
then
      echo "please provide four inputs."
      echo ""
      echo "bash loadChain.sh <database e.g. galGal4> <track type e.g. Chain/Net/Maf> <file tail e.g. .chain/.net/.maf> <organism e.g. Chicken> without <>."
      echo ""
      echo "The first input is the database name"
      echo ""
      echo "Second input is the track type based on file type, currently this only takes Net or Chain files"
      echo ""
      echo "Third input is the file tail. Again it has to end with either .net or .chain"
      echo ""
      echo "The last input is the common name of the organism"
      echo ""	
      exit
else
	echo "It seems you have entered all four inputs, but chack whether they are correct"
	echo "Database name: $org"
	echo "Track type: $type"
	echo "File tail: $tail"
	echo "Organism name: $organism"
	read -p "Do you think they are correct? (y/n) " RESP
if [ "$RESP" = "n" ]; then
  	echo "Please re-run the script with correct inputs"
	echo"I will try to add an option to correct the incorrect input, but it is not the time"
	exit
else
echo "perfect! It seems that you have provided correct inputs"

	cnt=0

	#for trackpath in `ls -1 $tracktype/*.$tail`
	#for file in $(grep -il "" *.tab)
	#for i in "${track[@]}" 
	for i in `echo $track`
	do

		tracktype=$( echo $i$type )
		trackpath=$( ls -1 $tracktype/*.$tail )

		if [[ $type == "Net" ]]
		then
			echo "hgLoadNet $org $tracktype ./$trackpath -warn"

			hgLoadNet $org $tracktype ./$trackpath -warn

			echo -e "\n" >> trackDbtest.txt
			echo -e "track\t$tracktype" >> trackDbtest.txt
			echo -e "\tshortLabel $i $tail" >> trackDbtest.txt
			echo -e "\tlongLabel ${common[$cnt]} Alignment $tail" >> trackDbtest.txt
			echo -e "\ttype netAlign $i $tracktype" >> trackDbtest.txt
			echo -e "\totherDb $i" >> trackDbtest.txt
			echo -e "\tmatrix 16 91,-114,-31,-123,-114,100,-125,-31,-31,-125,100,-114,-123,-31,-114,91" >> trackDbtest.txt
			echo -e "\tmatrixHeader A,C,G,T" >> trackDbtest.txt
			echo -e "\tchainMinScore 1000" >> trackDbtest.txt
			echo -e "\tchainLinearGap medium" >> trackDbtest.txt
			echo -e "\tgroup compGeno" >> trackDbtest.txt
			echo -e "\tpriority 134" >> trackDbtest.txt
			echo -e "\tvisibility full" >> trackDbtest.txt
			echo -e "\tspectrum on" >> trackDbtest.txt
			echo -e "\tchainLinearGap medium" >> trackDbtest.txt

		elif [[ $type == "Chain" ]]
		then

			echo "hgLoadChain $org $tracktype ./$trackpath"

			hgLoadChain $org $tracktype ./$trackpath

			echo -e "\n" >> trackDbtest.txt
			echo -e "track\t$tracktype" >> trackDbtest.txt
			echo -e "\tshortLabel $i $tail" >> trackDbtest.txt
			echo -e "\tlongLabel ${common[$cnt]} $tail" >> trackDbtest.txt
			echo -e "\tmatrix 16 91,-114,-31,-123,-114,100,-125,-31,-31,-125,100,-114,-123,-31,-114,91" >> trackDbtest.txt
			echo -e "\tmatrixHeader A,C,G,T" >> trackDbtest.txt
			echo -e "\tchainMinScore 1000" >> trackDbtest.txt
			echo -e "\tgroup compGeno" >> trackDbtest.txt
			echo -e "\tpriority 125" >> trackDbtest.txt
			echo -e "\tvisibility hide" >> trackDbtest.txt
			echo -e "\tcolor 100,50,0" >> trackDbtest.txt
			echo -e "\taltColor 255,240,200" >> trackDbtest.txt
			echo -e "\tspectrum on" >> trackDbtest.txt
			echo -e "\ttype $tail $tracktype" >> trackDbtest.txt
			echo -e "\totherDb $i" >> trackDbtest.txt
			echo -e "\tchainLinearGap medium" >> trackDbtest.txt

		elif [[ $type == "Maf" ]]
		then

			echo "hgLoadMaf $org $tracktype "

			hgLoadMaf $org $tracktype

			echo "hgLoadMafSummary $org ${tracktype}Summary ./$trackpath"

			hgLoadMafSummary $org ${tracktype}Summary ./$trackpath

			echo -e "\n" >> trackDbtest.txt
			echo -e "track\t$tracktype" >> trackDbtest.txt
			echo -e "\tshortLabel $tracktype " >> trackDbtest.txt
			echo -e "\tlongLabel Multiple alignment key your species list here" >> trackDbtest.txt
        		echo -e "\tgroup cne_repeats" >> trackDbtest.txt
        		echo -e "\tpriority 70" >> trackDbtest.txt
        		echo -e "\tvisibility full" >> trackDbtest.txt
        		echo -e "\tcolor 160,160,160" >> trackDbtest.txt
        		echo -e "\taltcolor 160,160,160" >> trackDbtest.txt
        		echo -e "\ttype wigMaf" >> trackDbtest.txt
        		echo -e "\tmaxHeightPixels 100:100:100" >> trackDbtest.txt
        		echo -e "\tautoScale Off" >> trackDbtest.txt
        		echo -e "\tspeciesOrder again specifiy the species order here" >> trackDbtest.txt
        		echo -e "\tsummary  avianMafSummary" >> trackDbtest.txt

		else 
			echo "Did you enter the type"
		fi

cnt=`expr $cnt + 1`

done

hgsql $org -e 'load data local infile "chromInfo.txt" into table chromInfo;'
hgTrackDb $organism $org trackDb $KENTDIR/share/trackDb.sql /users/ucscadmins/gbdb/$org/

fi
fi

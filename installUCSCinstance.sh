#!/bin/bash

##################################################################################
# This pipe-line help you to install the UCSC browser instance based on the      #
# organism of interest.								 #
#										 #
# This was written by Dr. Kapila Gunasekera on the 27th March 2015		 #
#										 #
# You need to provide the resync URL of the organism of interests e.g.		 #
#										 #
# rsync -avzP rsync://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/ .	 #
#										 #
# rsync is a file transfer method if you don't know what it does. the last dot   #
# indicate the script that the files be synchronised to the current directory,   #
# the location where this script is executed 					 #
#										 #
# I will try to provide more details interactively				 #
##################################################################################


# We need to load the module that helps to upload sql files and tables to the UCSC
# local database 
echo ""
module load apps/kent/303.1/gcc-4.4.7
URLL=$1
DATABASE=$2
ORGANISM=$3

if [[ -e "variables" ]]
then
	rm variables
fi

touch variables

echo "Thhis script was written by Dr. Kapila Gunasekera"
echo ""
echo "Not a very complex one and it could make your life easy, when it come to installing UCSC instance in already running local mirror"
echo ""
echo "usage ./installUCSCinstance.sh  <rsync-link> <database e.g. mm9> <organism e.g. Mouse> without <>."
echo ""
echo "If you think you need more help do this"
echo ""
echo "./installUCSCinstance.sh -h or --help"
echo ""
echo "in the run_downloadUCSC.pbs file make the following changes. Open it with your favourite editor"
echo "A simple one would be nano run_downloadUCSC.pbs and then make the changes, as suggested and then"
echo "press ctrl and x buttons and then type y and enter.  Quite simple isn't it :--)) "
echo ""
echo "#$ -l h_vmem=NG - change N to something reasonable value e.g. 16. N is the memory allocation in GB"
echo ""
echo "#$ -q byslot.q@node0N - if you are allowed only one node then change N to the node number, if not"
echo "remove the line completely"
echo ""
echo "If you need assistance to understand drop us an email"
echo ""
echo "mfbelmonte@rvc.ac.uk"
echo ""
echo "kgunasekera@rvc.ac.uk"
echo ""

if [[ $1 == "" || $1 == "-h" || $1 == "--help" ]]
then
    	echo "please provide three inputs in the following order."
	echo ""
	echo "./installUCSCinstance.sh  <rsync-link> <database e.g. mm9> <organism e.g. Mouse> without <>."
	echo ""
        echo "The first input is the rsync-link"
	echo ""
        echo "rsync link e.g. hgdownload.cse.ucsc.edu/goldenPath/mm9/database/"
        echo ""
	echo "The second input is your database e.g. mm9"
	echo ""
        echo "The third input is the common name of the organism. e.g. Mouse. if the name has more than one word insert underscore _ inbetween words e.g. Zebra finch should be Zebra_finch"
        echo ""
        exit
elif [[ $3 == "" ]]
then
	echo "please provide three inputs in the following order."
        echo ""
	echo "./installUCSCinstance.sh  <rsync-link> <database e.g. mm9> <organism e.g. Mouse> without <>."
        echo ""
        echo "The first input is the rsync-link"
        echo ""
        echo "rsync link e.g. hgdownload.cse.ucsc.edu/goldenPath/mm9/database/"
        echo ""
        echo "The second input is your database e.g. mm9"
        echo ""
        echo "The third input is the common name of the organism. e.g. Mouse. if the name has more than one word insert underscore _ inbetween words e.g. Zebra finch should be Zebra_finch"
        echo ""
        exit
else
	echo ""
    	echo "It seems you have entered all three inputs, but chack whether they are correct"
        echo ""
	echo -e "rsync-link:\t$URLL"
	echo ""
	echo -e "Database name:\t$DATABASE"
        echo ""
	echo -e "Organism name:\t$ORGANISM"
        echo ""
	read -p "Do you think that they are correct? (y/n) " RESP
	if [ "$RESP" = "n" ]; then
        	echo ""
		echo "Please re-run the script with correct inputs"
        	echo ""
		echo"I will try to add an option to correct the incorrect input, but it is not the time"
        	echo ""
		exit
	else
		echo ""
		read -p "Do you want to test that there will be no errors? (y/n) " RESP2
		if [ "$RESP2" = "y" ]; then
			echo ""
			echo "WE are testing"	
			echo ""
			echo "This what you should get"
			echo ""
			echo "The next line should tell you whether your URL is correct" 
			echo ""
			echo -e "\trsync -avzP $URLL ."
			echo ""
			echo -e "\tgunzip *.gz"
			echo ""
			echo -e "\t./run_loadTxtFilesNew.sh $DATABASE $ORGANISM"			
			echo ""
			echo -e "\t./run_loadTxtFilesNew.sh test"
			./run_loadTxtFilesNew.sh test
			echo ""
			echo "perfect! It seems that you have provided correct inputs"
			echo ""
			read -p "Did it produce errors? (y/n) " RESP3	
				if [ "$RESP3" = "y" ]; then
					echo ""
					echo "Ok you need to check whether you could resolve the errors"
					echo ""
					echo "If not please drop Marta or me an e-mail"
					echo ""
					echo "mfbelmonte@rvc.ac.uk"
					echo ""
					echo "kgunasekera@rvc.ac.uk" 
					echo ""
					exit
				fi
			echo "perfect! It seems that you have provided correct inputs and the test run hasn't produced any errors"
			echo ""
			echo "Ok one last step before we install your instance of your organisam of interest"
			echo $URLL >> variables
			echo $DATABASE >> variables
			echo $ORGANISM >> variables
			echo ""
			read -p "Do you want to install the minimum number of tables that you need for up and running or all the tables at UCSC? (m/a) " RESP4
			if [ "$RESP4" = "m" ]; then
				echo ""
				echo "Here we go. Grab a cofee or do something else while I am downloading the tables and populating the database"
				echo ""
				qsub run_downloadUCSC_min.pbs
			else
				echo ""
				echo "Here we go. Grab a cofee or do something else while I am downloading the tables and populating the database"
				echo ""
				qsub run_downloadUCSC.pbs
			fi
		else
		echo "perfect! It seems that you have provided correct inputs and the test run hasn't produced any errors"
                echo ""
                echo "Ok one last step before we install your instance of your organisam of interest"
                echo $URLL >> variables
                echo $DATABASE >> variables
                echo $ORGANISM >> variables
                echo ""
                read -p "Do you want to install the minimum number of tables that you need for up and running or all the tables at UCSC? (m/a) " RESP4
               		if [ "$RESP4" = "m" ]; then
                        	echo ""
                        	echo "Here we go. Grab a cofee or do something else while I am downloading the tables and populating the database"
                        	echo ""
                        	qsub run_downloadUCSC_min.pbs
                        else
                             	echo ""
                                echo "Here we go. Grab a cofee or do something else while I am downloading the tables and populating the database"
                                echo ""
                                qsub run_downloadUCSC.pbs
                        fi
		fi
	fi
fi

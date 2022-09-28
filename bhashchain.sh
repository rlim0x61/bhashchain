#!/bin/bash

#########################################################################
#                                                                       #
# hashchain.sh - Hash comparison and change detection                   #
#                                                                       #
# Author: Rafael Lima (dfir.rj@gmail.com)       			            #
# Date: 09/11/2022 (mm/dd/yyyy)                                    	    #
#                                                                       #
# Description: Computes hashes from two directories,                    #
# detect and report differences on the hashchain.                       #
#                                                                       #
# Usage: ./hashchain.sh [OPTIONS]... [SOURCE DIRECTORY]    	            #
#                                                                       #
#########################################################################

#################################################################
#MAIN PROGRAM FUNCTIONS						#
#################################################################

#BANNERS
Warning() { #warnning messages
	echo ""
	echo "|----------------------------------------------------------------------------------"
	echo "| [Presenting Results]                                                             "
	echo "|----------------------------------------------------------------------------------"
	echo "| [!] WARNING: different number of objects:                                        "
	echo "|----------------------------------------------------------------------------------"
	echo "| $DIR1: $TotalNumberHashesDir1 objects                                            "
	echo "|----------------------------------------------------------------------------------"
	echo "| $DIR2: $TotalNumberHashesDir2 objects                                            "
	echo "|----------------------------------------------------------------------------------"
	echo "| [*] Missing file/files:                                                          "
	echo "|----------------------------------------------------------------------------------"
	echo ""
}

MatchHashes() { #when all hashes match
	echo ""
	echo "|----------------------------------------------------------------------------------"
	echo "| [Presenting Results]                                                             "
	echo "|----------------------------------------------------------------------------------"
	echo "| [==] All hashes from both directories match.                                     "
	echo "|----------------------------------------------------------------------------------"
	echo ""
}

UnmatchHashes() { #when one or more hashes unmatch
	echo ""
	echo "|----------------------------------------------------------------------------------"
	echo "| [Presenting Results]                                                             "
	echo "|----------------------------------------------------------------------------------"
	echo "| [!=] Unmatched hashes:                                                           "
	echo "-----------------------------------------------------------------------------------"
	echo "$READ_REPORT                                                                       "
	echo "-----------------------------------------------------------------------------------"
}

WrongUsage() { #when user executes the script incorrectly
	echo ""
	echo "|-------------------------------------------------------------------------------------"
	echo "| [WRONG USAGE]                                                                       "
	echo "|-------------------------------------------------------------------------------------"
	echo "| Type: $0 -a [algorithm] -d [/absolute/path/to/first-directory-name/]                "
	echo "|-------------------------------------------------------------------------------------"
	echo "| See $0 -h and take a look on -a option to see the supported algorithms              "
	echo "|-------------------------------------------------------------------------------------"
	echo ""
}

DirectoryError() { #when user types wrong directory or it doesn't exist
	echo ""
	echo "|-------------------------------------------------------------------------------------"
	echo "| [Directory Error]                                                                   "
	echo "|-------------------------------------------------------------------------------------"
	echo "| Type: $0 -a [algorithm] -d [/absolute/path/to/first-directory-name/]                "
	echo "|-------------------------------------------------------------------------------------"
	echo "| Seems like you mistype the directory names or it doesn't exist                      "
	echo "|-------------------------------------------------------------------------------------"
	echo ""
}

#End of banner section

CheckRequirements () {
	REQSARRAY=("coreutils" "libpopt0") #requirements array
	for REQ in `echo ${REQSARRAY[@]}`;
	do
		if ! dpkg -l |grep "$REQ" > /dev/null
		then
			echo ""
			echo "$REQ is missing: run sudo apt update && sudo apt install $REQ -y"
	 		echo ""
	 		exit 2
	 	fi
	done
}

Help()
{
   # Display Help
   echo "Help Menu."
   echo "Usage examples:"
   echo " ./hashchain.sh -a [algorithm] -d [/absolute/path/to/first-directory-name/]"
   echo
   echo -e "Description: Computes hashes from two directories,"
   echo "detect and report differences on the hashchain"
   echo "Syntax: ./bshashchain [-a|d|D|h|L|V]"
   echo "options:"
   echo "-a --algorithm     md5sum|sha1sum|sha256sum|sha512sum"
   echo -e "\t\t   With -d calculates hash values from two directories"
   echo -e "\t\t   and compares the respective hash lists"
   echo "-d --directory     Asks for path and directory name input"
   echo "-D --debug-info    Presents exit codes and their meaning "
   echo "-h --help          Prints help menu"
   echo "-L --license-info  Prints license information"
   echo "-V --version       Print software version and exit"
   echo "------------------------------------------------------------------"
}

# Prints version info
VersionInfo()
{
   echo "bhashchain.sh version 1.1"
   echo "Written by Rafael Lima"
   echo "------------------------------------------------------------------"
}

# Prints version info
LicenseInfo()
{
   echo -e "bhashchain.sh computes hashes from two directories,\ndetect and report differences on the hashchain."
   echo ""
   echo "Copyright (C) 2022 by Rafael Lima"
   echo "Full license notice: https://github.com/rlim0x61/bhashchain/blob/main/LICENSE   "
   echo "--------------------------------------------------------------------------------"
}

DebugInfo () {
	echo "-----------------------------------------------------------------"
	echo "Exit codes: "
	echo ""
	echo "0 - Success"
	echo "1 - Wrong number of parameters. See echo $#"
	echo "2 - Requirements or dependencies missing. See CheckRequirements()"
	echo "3 - Algorithm type not supported. See CheckAlgInput()"
	echo "4 - Different number of objects on directories. See DataProcess()"
	echo "5 - Unmatched hashes found. See StoreReport()"
	echo "6 - Invalid script option. See $0 -h"
	echo "-----------------------------------------------------------------" 
}

# Validates algorithm input
CheckAlgInput () {
	ALGLOWER=`echo "$ALG" |tr A-Z a-z` # convert all A-Z chars to lowercase a-z arguments
	if [ "$ALGLOWER" != "md5sum" -a "$ALGLOWER" != "sha1sum" -a "$ALGLOWER" != "sha256sum" -a "$ALGLOWER" != "sha512sum" ];
	then
		Help
		exit 3
	fi
}

#Triggered by -d option
DirDataInput () {
	echo "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd"
	echo "d                                                              d"
	echo "d [+] DATA INPUT: please insert the following information:     d"
	echo "d                                                              d"
	echo "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd"
	sleep 2
	echo ""
	read -p "Path AND name to directory 2: " DIR2
	echo ""
	echo "Comparing $DIR1 and $DIR2 ..."
	sleep 2
}

#Parses the hashlist to detect changes
ParsesHashList () {
	#Local variables that stores total number of hash values on each list
	local TotalNumberHashesDir1=`cat checksum1 |wc -l`
	local TotalNumberHashesDir2=`cat checksum2 |wc -l`

	#this condition is important to establish different flows when dir1 -lt dir2
	if [ `cat checksum1 |wc -l` -lt `cat checksum2 |wc -l` ]
	then
		for HASH in `cat checksum2 |awk '{print $1}'`;
		do 
			if ! grep "$HASH" checksum1 > /dev/null; # means if grep doesn't find a match for $HASH inside dir1
			then
				grep "$HASH" checksum2 >> checksum-unmatched
			fi
		done	
	else
		for HASH in `cat checksum1 |awk '{print $1}'`;
		do 
			if ! grep "$HASH" checksum2 > /dev/null; # means if grep doesn't find a match for $HASH inside dir2
			then
				grep "$HASH" checksum1 >> checksum-unmatched
			fi
		done
	fi
}

StoreReport () {
	#deals with reporting objects: directory and file report
	if [ ! -d ./compara_hashes ]
	then
		mkdir -p ./compara_hashes 2> /dev/null
	fi			
	cp checksum-unmatched ./compara_hashes/checksum-unmatched_$(date +%Y%m%d%H%M) 2> /dev/null
	local READ_REPORT=`cat checksum-unmatched`
	if [ $? -eq 0 ]
	then
		UnmatchHashes #banner
	fi
	rm -rf *checksum*
	exit 5
}

#Process the data by performing: dir lookup, recursively hashsum, create reports results and exhibits to stdout
DataProcess () {
	# Cals hash values recursively inside directory
	find $DIR1 -type f -exec $ALGLOWER {} + > checksum1
	find $DIR2 -type f -exec $ALGLOWER {} + > checksum2

	# Makes temp files only to compare checksum file lists
	cat checksum1 |awk '{print $1}' > temp-checksum1
	cat checksum2 |awk '{print $1}' > temp-checksum2

	#Local variables that stores total number of hash values on each list
	local TotalNumberHashesDir1=`cat temp-checksum1 |wc -l`
	local TotalNumberHashesDir2=`cat temp-checksum2 |wc -l`

	#evaluates the total number of hashes (objects on each list)
	if [ $TotalNumberHashesDir1 -eq $TotalNumberHashesDir2 ]
	then
		#if temp checksum lists are the same (have the same hash value) all hash chain matches
		if [ `$ALGLOWER temp-checksum1 |awk '{print $1}'` == `$ALGLOWER temp-checksum2 |awk '{print $1}'` ]
		then
			MatchHashes #banner
		else # if hash chain is not the same calcs the sum again to spot differences
			ParsesHashList
			StoreReport
		fi
	else
		Warning #banner
		ParsesHashList
		cat checksum-unmatched
		echo ""
		cp checksum-unmatched ./compara_hashes/checksum-unmatched_$(date +%Y%m%d%H%M)
		rm -rf *checksum*
		exit 4
	fi
}

#########################################################################
# Validation and Checks                                                 #
#########################################################################
CheckRequirements #Function that checks if some requirements are present

#evaluates first execution with single options
if [ "$1" == "-h" ] 
then
	Help
	exit 0
elif [ "$1" == "-D" ]
then
	DebugInfo
	exit 0
elif [ "$1" == "-V" ]
then
	VersionInfo
	exit 0
elif [ "$1" == "-L" ]
then
	LicenseInfo
	exit 0
#evaluates execution with composed options
elif [ $# -ne 4 ] #Checks the number of parameters
then
	Help
	VersionInfo
	exit 1
elif [ "$1" == "-a" -a "$3" == "-d" ] #Make sure user executes ./bhashchain.sh -a [argument] -d [argument]
then
	if ! [ -d "$4" -o  -d "$DIR1" -o -d "$DIR2" ] #make sure -d option and $DIR2 var receive an existent directory
	then
		DirectoryError
		exit 6
	else
		################################################################################
		# Process the input options.							                       #
		################################################################################
		while getopts "a:d:DhLV" option; do #options stores options -a -d -h ...
		   	case $option in
		   		a) # algorithm
					ALG=${OPTARG} #OPTARG stores arguments
					CheckAlgInput

		   			;;
		   		d) # directory
					DIR1=($OPTARG) # Array that stores more -d arguments
					DirDataInput
					DataProcess
		   			;; 
		   		D) # show useful information to understand exit codes
					DebugInfo
		   			;; 
					
		      	h) # Display help
		      		Help
		      		VersionInfo
		      		;;
		      	\?) # incorrect option
		         	echo "Error: Invalid option"
		         	echo "Type $0 -h for further instructions."
		         	exit 6 ;;
		   	esac
		done
		shift $((OPTIND -1))
	fi
else
	WrongUsage
	exit 6
fi

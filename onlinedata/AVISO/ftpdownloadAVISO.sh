#!/bin/bash
#
# You should specify 5 variables below to download AVISO data:
#   - USERID: your AVISO user id.
#   - USERPW: your AVISO password.
#   - outputdir: path of the folder you want to save the data in.
#   - initdate: initial date.
#   - finldate: final date.
#
# Download AVISO data from ftp.aviso.altimetry.fr/ -- if you
# have an account newer than Jun/2016, you have to download
# data from the repository managed by Copernicus.
#
# Olavo Badaro Marques, 22/Dec/2016.

#################################################
# User id and password information

USERID=""

USERPW=""


#################################################
# Specify directory to save files
outputdir=pwd

cd $outputdir

printf "\n Saving data at directory $outputdir \n \n"

#################################################
# Initial and final date to get data

initdate=20160420   # yyyymmdd
finldate=20160421   # yyyymmdd

# Subset the first 4 digits of the variables above
# and create sequence of all the years in between
allyears=$(seq ${initdate:0:4} ${finldate:0:4})

#echo $allyears | awk '{print $2}'
#awk '{print $2}' <<< $allyears


#################################################
# Remote FTP and data directory in it

remoteFTP="ftp.aviso.altimetry.fr/"


#################################################
# Filename structure (I could use this, but it is
# not easily useful for AVISO data because the filenames
# contain a date, that is probably the last time
# when the file was updated)

#dt_global_allsat_madt_h_20150101_20150914.nc.gz


#################################################
# Go to the appropriate directory:

datadir="global/delayed-time/grids/madt/all-sat-merged/h/"


#################################################
# Log in through FTP:

strFTP="ftp://$USERID:$USERPW@$remoteFTP"

#ftp $strFTP

#################################################
# Start looping through year directories in allyears
for i in $allyears
  do
    datadowndir=$strFTP$datadir$i/
    echo "Loading data from: $datadowndir"

    #################################################
    # Get the name of all files in the data
    # folder and put in a *.txt file
    #curl -l $strFTP$datadir | sort > allfilenames.txt
    curl -l $datadowndir | sort > allfilenames.txt


    #################################################
    #

    while read onefilename
    do

        if [ ${onefilename:24:8} -ge $initdate -a ${onefilename:24:8} -le $finldate ]
        then

            printf "\n Downloading data from ${onefilename:24:8} \n \n"
            #echo "Downloading data from ${onefilename:24:8}"
            ftp $datadowndir$onefilename

            # Decompress *.gz file (which already removes the *.gz file)
            gunzip ./$onefilename

            # Remove *.gz file
            #rm ./$onefilename

        fi


    done < allfilenames.txt
  done


#################################################
# Erase allfilenames.txt file

rm allfilenames.txt

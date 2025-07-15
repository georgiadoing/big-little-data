#!/bin/bash

########################################################################
#Script Name: sra2sal_byx_DCC.sh
#Description: linker script to run experiment based on job array index
#Args:        job array index
#Author:      Georgia Doing
#Date:        04-11-25
#Email:       georgia.doing@duke.edu
########################################################################
#cd $SLURM_SUBMIT_DIR
pwd
cd ../slurm_scripts
pwd
readarray SRXS < <(find $3 -mindepth 2 -maxdepth 2 -type d)

echo $3
echo $1
echo ${#SRXS[@]}

if  (( $1 >  ${#SRXS[@]} )) ; then
    echo 'no accession'
    exit 203
fi

../shell_scripts/salPa_byx_DCC.sh ${SRXS[$1]} $2

exit


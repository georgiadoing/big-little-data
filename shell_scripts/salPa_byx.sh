#!/bin/bash -l
####################################################################
#Script Name: salPa_byx.sh
#Description: Runs sra experiments through salmon
#Args:        dir containing txt file with all run numbers
#Author:      Georgia Doing
#Date:        12-17-20
#Email:       Georgia.Doing.GR@Dartmouth.edu  
####################################################################
#cd $PBS_O_WORKDIR

# set local scratch
#echo "/repository/user/main/public/root = \"/scratch/sra_out\"" >> $HOME/.ncbi/user-settings.mkfg
#echo "/repository/user/default-path = \"/scratch/sra_out\"" >> $HOME/.ncbi/user-settings.mkfg

# load modules
#module load sratoolkit
conda activate micro-seq-comp



# check if this accession-index pair has already been processed
if du -hac -d 1 /fastscratch/doingg/salmon/$2/$1/salmon/quant.sf ; then
    echo "/salmon/$2/$1 already processed"
    DT=$(date)
    echo "Attempt $SLURM_JOB_ID $DT" >> /fastscratch/doingg/salmon/$2/$1/processes.log
    rm -r /fastscratch/doingg/$SLURM_JOB_ID
    exit 200
fi


mkdir -p /fastscratch/doingg/salmon/$2/$1
DT=$(date)
echo "Processed $SLURM_JOB_ID $DT" > /fastscratch/doingg/salmon/$2/$1/processes.log

#echo ls /dartfs-hpc/scratch/f002bx6/salmon/$2/$1/
# create temp dirs on local scratch
mkdir -p /fastscratch/doingg/$SLURM_JOB_ID/salmon_out/$2
mkdir -p /fastscratch/doingg/$SLURM_JOB_ID/sra_out/$1

# read in sra run accessions
readarray SRFILES < <(find $1 -type f -regex ".*txt")
echo SRFILES:
echo ${SRFILES}
readarray SRRS < ${SRFILES}
echo SRRS:
echo ${SRRS}

# download each sra run, one at a time
for f in $SRRS
do
    if ! fasterq-dump $f -O /fastscratch/doingg/$SLURM_JOB_ID/sra_out/$1 -t /fastscratch/doingg/$SLURM_JOB_ID/sra_out/tmp -f ; then
        echo "fasterq-dump failed on $f"
        exit 201
    fi
done

# read in fastq files and run together
#FQFILES=(/scratch/$PBS_JOBID/sra_out/$1/*)
readarray FQFILES < <(find /fastscratch/doingg/$SLURM_JOB_ID/sra_out/$1 -type f -regex ".*fastq")
echo FQFILES:
echo ${FQFILES[*]}

for fq in $FQFILES
do
    wc -l $fq
done

if ! \
salmon quant -i  ../t_indxs/$2 \
    --softclip \
    --softclipOverhangs \
    --minScoreFraction 0.65 \
    --fldMean 51 \
    --seqBias \
    --libType U \
    -r ${FQFILES[*]} \
    -o /fastscratch/doingg/salmon/$2/$1/salmon
then
    echo 'salmon failed'
    exit 202
fi
# move from local scratch to dartfs scratch
#mkdir -p /fastscratch/doingg/salmon/$2/$1
#cp -r /fastscratch/doingg/$SLURM_JOB_ID/salmon_out/$2/$1.salmon /fastscratch/doingg/salmon/$2/$1/

# cleanup
du -h --max-depth 0 /fastscratch/doingg/$SLURM_JOB_ID
rm -r /fastscratch/doingg/$SLURM_JOB_ID
[ ! -e /fastscratch/doingg/$SLURM_JOB_ID ] && echo "/fastscratch/doingg/$SLURM_JOB_ID deleted"


exit


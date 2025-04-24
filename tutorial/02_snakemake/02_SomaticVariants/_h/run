#!/bin/bash

#SBATCH -J sra_tools
#SBATCH -p defq
#SBATCH -N 1
#SBATCH --time=2:00:00
#login01SBATCH --cpus-per-task=4
#SBATCH --output=Array_test.%A_%a.out
#SBATCH --array=1-101

ml sra-tools/3.0.0

# Bioproject PRJEB10849 samples

sra_numbers=($(echo {1016570..1016671}))

sra_id='ERR'${sra_numbers[ $SLURM_ARRAY_TASK_ID - 1 ]}

prefetch --max-size 100G $sra_id --force yes --verify no
fastq-dump --outdir . --gzip --skip-technical  --readids --read-filter pass --dumpbase --split-3 --clip ${sra_id}/${sra_id}.sra

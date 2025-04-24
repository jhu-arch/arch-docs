#!/bin/bash

#SBATCH -J cutadapt
#SBATCH -p defq
#SBATCH --time=2:00:00
#SBATCH --cpus-per-task=4
#SBATCH --output=cutadapt.job.%j.out

module load snakemake/7.6.0

# Syntax to run it on Rockfish cluster
snakemake --jobs 200 --latency-wait 240 --cluster 'sbatch --parsable --distribution=arbitrary' --snakefile ../_h/snakemake.slurm.script

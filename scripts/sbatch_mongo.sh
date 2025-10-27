#!/bin/bash
#SBATCH -N 1
#SBATCH -C cpu
#SBATCH -q shared
#SBATCH -J fireworks_db
#SBATCH --mail-user=andrew.cudd@colorado.edu
#SBATCH --mail-type=ALL
#SBATCH -A m3249
#SBATCH -t 24:00:00
#SBATCH -n 1
#SBATCH -c 2

#Get job timelimit (and subtract 30 seconds so job registers as complete rathern than timeout)
#Not really necessary, but doing it anyway
MIN=$(sacct -n -j $SLURM_JOB_ID -o "Timelimitraw" | tr -d '[:space:]')
SEC=$(($MIN * 60 - 30))

#Start container in job as background process
srun --cpu-bind=cores init_mongo_container.sh

#Sleep to keep job alive
srun --cpu-bind=cores sleep $SEC

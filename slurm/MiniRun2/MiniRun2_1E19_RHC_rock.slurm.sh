#!/usr/bin/env bash
#SBATCH --account=dune
#SBATCH --qos=regular
#SBATCH --constraint=cpu
#SBATCH --time=2:00:00
#SBATCH --ntasks-per-node=256

name=MiniRun2_1E19_RHC_rock

logdir=${SCRATCH}/logs.${name}/${SLURM_JOBID}
mkdir -p "$logdir"

srun -o "$logdir"/output-%j.%t.txt \
    scripts/run_rlaunch.sh "$name" singleshot

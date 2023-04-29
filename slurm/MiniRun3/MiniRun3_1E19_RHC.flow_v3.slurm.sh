#!/usr/bin/env bash
#SBATCH --account=dune
#SBATCH --qos=regular
#SBATCH --constraint=haswell
#SBATCH --time=2:00:00
#SBATCH --ntasks-per-node=64

name=MiniRun3_1E19_RHC.flow_v3

basedir=$PWD

logdir=${SCRATCH}/logs.${name}/${SLURM_JOBID}
mkdir -p "$logdir"

launchdir=${SCRATCH}/launchers.${name}
# launchdir=launchers.${name}
mkdir -p "$launchdir"
cd "$launchdir" || exit

srun -o "$logdir"/output-%j.%t.txt \
    "$basedir"/scripts/run_rlaunch.sh "$name" rapidfire

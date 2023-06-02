#!/usr/bin/env bash
#SBATCH --account=dune
#SBATCH --qos=regular
#SBATCH --constraint=cpu
#SBATCH --time=1:00:00
#SBATCH --ntasks-per-node=32

name=MiniProdN1p1_NDLAr_1E19_RHC.nu.hadd

basedir=$PWD

logdir=${SCRATCH}/logs.${name}/${SLURM_JOBID}
mkdir -p "$logdir"

launchdir=${SCRATCH}/launchers.${name}
# launchdir=launchers.${name}
mkdir -p "$launchdir"
cd "$launchdir" || exit

srun -o "$logdir"/output-%j.%t.txt \
    "$basedir"/scripts/run_rlaunch.sh "$name" rapidfire

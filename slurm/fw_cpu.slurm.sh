#!/usr/bin/env bash
#SBATCH --account=dune
#SBATCH --qos=regular
#SBATCH --constraint=cpu
#SBATCH --time=1:00:00
#SBATCH --ntasks-per-node=256

name=$1; shift
rlaunch_args=("$@"); shift $#

basedir=$PWD

logdir=${SCRATCH}/slurm_logs/${name}/${SLURM_JOBID}
mkdir -p "$logdir"

launchdir=${SCRATCH}/launchers/${name}/${SLURM_JOBID}
# launchdir=launchers.${name}
mkdir -p "$launchdir"
cd "$launchdir" || exit

srun -o "$logdir"/output-%j.%t.txt --kill-on-bad-exit=0 \
    "$basedir"/scripts/run_rlaunch.sh "$name" "${rlaunch_args[@]}"

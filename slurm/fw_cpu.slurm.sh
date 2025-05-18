#!/usr/bin/env bash
#SBATCH --account=m3249
#SBATCH --qos=regular
#SBATCH --constraint=cpu
#SBATCH --time=1:00:00
#SBATCH --ntasks-per-node=256

category=$1; shift
rlaunch_args=("$@"); shift $#

basedir=$PWD

logdir=${FW4DUNE_SCRATCH:-$SCRATCH}/logs_slurm/${category}/${SLURM_JOBID}
mkdir -p "$logdir"

launchdir=${FW4DUNE_SCRATCH:-$SCRATCH}/launchers/${category}/${SLURM_JOBID}
mkdir -p "$launchdir"
cd "$launchdir" || exit

srun -o "$logdir"/output-%j.%t.txt --kill-on-bad-exit=0 \
    "$basedir"/scripts/run_rlaunch.sh "$category" "${rlaunch_args[@]}"

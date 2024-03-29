#!/usr/bin/env bash
#SBATCH --account=dune
#SBATCH --qos=regular
#SBATCH --constraint=gpu
#SBATCH --time=1:00:00
#SBATCH --ntasks-per-node=4
#SBATCH --gpus-per-task=1
#SBATCH --cpus-per-task=32

name=MiniRun3_1E19_RHC.larnd

basedir=$PWD

logdir=${SCRATCH}/logs.${name}/${SLURM_JOBID}
mkdir -p "$logdir"

launchdir=${SCRATCH}/launchers.${name}
# launchdir=launchers.${name}
mkdir -p "$launchdir"
cd "$launchdir" || exit

srun -o "$logdir"/output-%j.%t.txt \
    "$basedir"/scripts/run_rlaunch.sh "$name" rapidfire --timeout $((60 * 40))

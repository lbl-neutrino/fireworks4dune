#!/usr/bin/env bash
#SBATCH --account=dune
#SBATCH --qos=regular
#SBATCH --constraint=cpu
#SBATCH --time=2:00:00
#SBATCH --ntasks-per-node=256

fw_confdir=$(realpath $(dirname $FW_CONFIG_FILE))

fw_launchdir=$SCRATCH/fw_launches
mkdir -p $fw_launchdir
cd $fw_launchdir

logdir=$SCRATCH/logs.edep_sim_job_fw/$SLURM_JOBID
mkdir -p $logdir

# srun rlaunch -w $fw_confdir/fworker_edep_sim.yaml rapidfire
srun -o "$logdir"/output-%j.%t.txt rlaunch -w $fw_confdir/fworker_edep_sim.yaml singleshot

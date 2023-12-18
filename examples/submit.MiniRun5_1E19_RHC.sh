#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC

name=MiniRun5_1E19_RHC
# start=0
# single_size=100
# spill_size=10
logdir=$SCRATCH/logs.$name
export FW4DUNE_SLEEP_SEC=60

scripts/load_yaml.py --replace specs/SimFor2x2_v4.yaml specs/$name/*.yaml

mkdir -p "$logdir"

workflows/MiniRun5_1E19_RHC.workflow.py

# lpad admin tuneup --full

sbatch -o "$logdir"/slurm-%j.txt --array=1-10 -N 4 -t 180 slurm/fw_cpu.slurm.sh cpu_hours rapidfire
sbatch -o "$logdir"/slurm-%j.txt --array=1-2 -N 4 -t 30 slurm/fw_cpu.slurm.sh cpu_seconds rapidfire

sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 4 -t 240 slurm/fw_gpu.slurm.sh -C "gpu&hbm80g" gpu_minutes rapidfire

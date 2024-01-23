#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC

name=MiniRun4.5_1E19_RHC
# start=0
# single_size=100
# spill_size=10
logdir=$SCRATCH/logs.$name
export FW4DUNE_SLEEP_SEC=60

scripts/load_yaml.py --replace specs/SimFor2x2_v5.yaml specs/$name/*.yaml

mkdir -p "$logdir"

workflows/fwsub.MiniRun4.5_1E19_RHC.py

# lpad admin tuneup --full

sbatch -o "$logdir"/slurm-%j.txt --array=1-2 -N 4 -t 30 slurm/fw_cpu.slurm.sh mini45_cpu_minutes rapidfire

# gpu&hbm80g
sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 4 -t 240 slurm/fw_gpu.slurm.sh -C "gpu" mini45_gpu_minutes rapidfire

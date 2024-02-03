#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC
umask 002

name=MiniRun4.5_1E19_RHC

logdir=$SCRATCH/slurm_logs/SBATCH
mkdir -p "$logdir"
export FW4DUNE_SLEEP_SEC=60

scripts/load_yaml.py --replace specs/SimFor2x2_v5.yaml specs/$name/*.yaml

workflows/fwsub.MiniRun4.5_1E19_RHC.py

# lpad admin tuneup --full

sbatch -o "$logdir"/slurm-%j.txt --array=1-2 -N 4 -t 30 slurm/fw_cpu.slurm.sh mini45_cpu_minutes rapidfire

# gpu&hbm80g
sbatch -o "$logdir"/slurm-%j.txt --array=1-7 -N 4 -t 90 -C "gpu" slurm/fw_gpu.slurm.sh mini45_gpu_minutes rapidfire

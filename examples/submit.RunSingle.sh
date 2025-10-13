#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC

name=FSD_CosmicRun2
logdir=$SCRATCH/logs.$name
export FW4DUNE_SLEEP_SEC=60

mkdir -p "$logdir"

# edep-sim convert
# sbatch --parsable -o "$logdir"/slurm-%j.txt --array=1-1 -N 4 -t 30 slurm/fw_cpu.slurm.sh cpu_seconds rapidfire

# larnd-sim, spine
# sbatch --parsable -C "gpu&hbm80g" \
    # -o "$logdir"/slurm-%j.txt -N 4 -t 180 slurm/fw_gpu.slurm.sh gpu_minutes rapidfire

sbatch --parsable -C "gpu&hbm80g" \
    -o "$logdir"/slurm-%j.txt -N 1 -t 60 slurm/fw_gpu.slurm.sh gpu_minutes rapidfire
    # -o "$logdir"/slurm-%j.txt --array=1-2 -N 2 -t 150 slurm/fw_gpu.slurm.sh gpu_minutes rapidfire

# nd-flow, flow2supera, cafs
# sbatch --parsable \
    # -o "$logdir"/slurm-%j.txt -N 2 --ntasks-per-node=128 -t 60 slurm/fw_cpu.slurm.sh cpu_minutes rapidfire
    # -o "$logdir"/slurm-%j.txt --array=1-2 -N 3 --ntasks-per-node=15 -t 60 slurm/fw_cpu.slurm.sh cpu_minutes rapidfire

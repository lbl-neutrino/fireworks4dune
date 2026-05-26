#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC

name=FSDCubeSim_v1
logdir=$SCRATCH/logs.$name
export FW4DUNE_SLEEP_SEC=30

scripts/load_yaml.py --replace specs/SimForFSD_v1.yaml specs/$name/*.yaml

mkdir -p "$logdir"

workflows/fwsub.FSDCubeSim.py --size 256

# larnd-sim
GPU_MIN_JOBID=$(sbatch --parsable -C "gpu&hbm80g" \
    -o "$logdir"/slurm-%j.txt -N 12 -t 180 slurm/fw_gpu.slurm.sh gpu_minutes rapidfire)
    #-o "$logdir"/slurm-%j.txt -N 5 -t 60 slurm/fw_gpu.slurm.sh gpu_minutes rapidfire)

# nd-flow, flow2supera
CPU_MIN_JOBID=$(sbatch --parsable \
    -o "$logdir"/slurm-%j.txt -N 1 --ntasks-per-node=128 -t 60 slurm/fw_cpu.slurm.sh cpu_minutes rapidfire)

# spine
#GPU_MIN_JOBID=$(sbatch --parsable -C "gpu" \
#  -o "$logdir"/slurm-%j.txt -N 4 -t 120 slurm/fw_gpu.slurm.sh gpu_minutes rapidfire)

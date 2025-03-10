#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC

name=FSD_CosmicRun1
logdir=$SCRATCH/logs.$name
export FW4DUNE_SLEEP_SEC=30

scripts/load_yaml.py --replace specs/SimFor2x2_v6.yaml specs/$name/*.yaml

mkdir -p "$logdir"

workflows/fwsub.FSD_CosmicRun1.py

# additional time to delay start of jobs with dependencies
START_DELAY=30 # minutes

# CORSIKA, edep-sim, convert2h5
sbatch --parsable -o "$logdir"/slurm-%j.txt -N 1 -t 30 slurm/fw_cpu.slurm.sh cpu_seconds rapidfire

# larnd-sim, spine
GPU_MIN_JOBID=$(sbatch --parsable -C "gpu&hbm80g" \
    -o "$logdir"/slurm-%j.txt -N 4 -t 120 slurm/fw_gpu.slurm.sh gpu_minutes rapidfire)
    # -o "$logdir"/slurm-%j.txt --array=1-1  -N 4 -t 150 slurm/fw_gpu.slurm.sh gpu_minutes rapidfire)

# nd-flow, flow2supera, cafs
CPU_MIN_JOBID=$(sbatch --parsable -d after:$GPU_MIN_JOBID+$START_DELAY \
    -o "$logdir"/slurm-%j.txt -N 1 -t 60 slurm/fw_cpu.slurm.sh cpu_minutes rapidfire)
    # -o "$logdir"/slurm-%j.txt --array=1-5 -N 2 -t 60 slurm/fw_cpu.slurm.sh cpu_minutes rapidfire)

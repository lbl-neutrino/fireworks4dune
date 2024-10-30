#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC

name=MiniRun6_Snowstorm_1E19_RHC
logdir=$SCRATCH/logs.$name
export FW4DUNE_SLEEP_SEC=60

scripts/load_yaml.py --replace specs/SimFor2x2_v6.yaml specs/$name/*.yaml

mkdir -p "$logdir"

workflows/fwsub.MiniRun6_Snowstorm_RHC.py --size 100

# lpad admin tuneup --full

# additional time to delay start of jobs with dependencies
START_DELAY=5 # minutes

# edep-sim convert
CPU_SEC_JOBID=$(sbatch --parsable -o "$logdir"/slurm-%j.txt --array=1-1  -N 4 -t 30 slurm/fw_cpu.slurm.sh cpu_seconds rapidfire)

# larnd-sim, spine
GPU_MIN_JOBID=$(sbatch --parsable -d after:$CPU_SEC_JOBID+$START_DELAY -C "gpu&hbm80g" \
    -o "$logdir"/slurm-%j.txt --array=1-1  -N 4 -t 240 slurm/fw_gpu.slurm.sh gpu_minutes rapidfire)

# nd-flow, flow2supera, cafs
CPU_MIN_JOBID=$(sbatch --parsable -d after:$GPU_MIN_JOBID+$START_DELAY \
    -o "$logdir"/slurm-%j.txt --array=1-10 -N 4 -t 60 slurm/fw_cpu.slurm.sh cpu_minutes rapidfire)

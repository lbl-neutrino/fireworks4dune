#!/usr/bin/env bash

source admin/load_fireworks.sh

name=SPINE_train_ND_2512

scripts/load_yaml.py specs/SPINETrainForNDLAr_v1.yaml specs/$name/*.yaml
workflows/fwsub.SPINE_train_ND.py --size 1

mkdir -p $SCRATCH/mkramer/output/$name
mkdir -p $SCRATCH/mkramer/logs/$name

# Spread out the worker startups so they don't all connect to Mongo DB at once
export FW4DUNE_SLEEP_SEC=60

logdir=$SCRATCH/mkramer/slurm_logs/$name
mkdir -p "$logdir"

# Run edep-sim and convert2h5
sbatch -A m3249 -o "$logdir"/slurm-%j.txt --array=1-1 -N 1 -t 60 slurm/fw_cpu.slurm.sh cpu rapidfire

# Run larnd-sim
sbatch -A m3249 -o "$logdir"/slurm-%j.txt --array=1-1 -N 1 -t 60 slurm/fw_gpu.slurm.sh gpu_long rapidfire

# Run flow and flow2supera
sbatch -A m3249 -o "$logdir"/slurm-%j.txt --array=1-1 -N 1 -t 60 slurm/fw_cpu.slurm.sh cpu_long rapidfire

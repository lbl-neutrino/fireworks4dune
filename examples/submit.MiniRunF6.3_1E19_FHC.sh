#!/usr/bin/env bash

source admin/load_fireworks.sh

name=MiniRunF6.3_1E19_FHC

scripts/load_yaml.py --replace specs/SimFor2x2_v6.yaml specs/$name/*.yaml
workflows/fwsub.MiniRun5_1E19_RHC.py

# Spread out the worker startups so they don't all connect to Mongo DB at once
export FW4DUNE_SLEEP_SEC=60

logdir=$SCRATCH/slurm_logs/$name
mkdir -p "$logdir"

# Do the rock stuff
sbatch -o "$logdir"/slurm-%j.txt --array=1-10 -N 4 -t 180 slurm/fw_cpu.slurm.sh cpu_slow rapidfire

# Do all the other pre-larnd-sim stuff
sbatch -o "$logdir"/slurm-%j.txt --array=1-2 -N 4 -t 240 slurm/fw_cpu.slurm.sh cpu_fast rapidfire

# Run larnd-sim
sbatch -o "$logdir"/slurm-%j.txt --array=1-10 -N 4 -t 240 slurm/fw_gpu.slurm.sh gpu_slow rapidfire

# Run flow and flow2root (reducing tasks-per-node from 256 to 16 due to high memory requirement)
sbatch -o "$logdir"/slurm-%j.txt --ntasks-per-node=16 --array=1-4 -N 4 -t 240 slurm/fw_cpu.slurm.sh cpu_highmem rapidfire

# Run flow2supera and Pandora
sbatch -o "$logdir"/slurm-%j.txt --array=1-4 -N 4 -t 240 slurm/fw_cpu.slurm.sh cpu_slow rapidfire

# Run SPINE
sbatch -o "$logdir"/slurm-%j.txt -N 1 -t 240 slurm/fw_gpu.slurm.sh gpu_fast rapidfire

# Run the CAFmaker
sbatch -o "$logdir"/slurm-%j.txt --ntasks-per-node=16 --array=1-4 -N 4 -t 240 slurm/fw_cpu.slurm.sh cpu_highmem rapidfire

# Make validation plots
sbatch -o "$logdir"/slurm-%j.txt -N 1 -t 240 slurm/fw_cpu.slurm.sh validation rapidfire

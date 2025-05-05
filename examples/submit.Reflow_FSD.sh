#!/usr/bin/env bash

source admin/load_fireworks.sh

name=Reflow_FSD_v3
inputs=/pscratch/sd/d/dunepro/mkramer/install/Reflow_FSD_v2/inputs.fsd.cosmics.json

scripts/load_yaml.py specs/Reflow_v1.yaml specs/Reflow_FSD/*.yaml

workflows/fwsub.reflow_plus_downstream.py --name Reflow_FSD -i $inputs

logdir=${FW4DUNE_SCRATCH:-$SCRATCH}/slurm_logs/$name

mkdir -p "$logdir"

# TODO: Update job parameters
sbatch --array=1-6 -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 192 slurm/fw_cpu.slurm.sh Reflow_FSD.flow rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh Reflow_FSD.flow2supera rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 4 slurm/fw_gpu.slurm.sh Reflow_FSD.spine rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh Reflow_FSD.flow2root rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh Reflow_FSD.pandora rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh Reflow_FSD.caf rapidfire

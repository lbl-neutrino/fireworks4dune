#!/usr/bin/env bash

source admin/load_fireworks.sh

name=Reflow_FSD
inputs=/pscratch/sd/d/dunepro/mkramer/install/Reflow_FSD_v2/inputs.fsd.cosmics.json

scripts/load_yaml.py specs/Reflow_v1.yaml specs/$name/*.yaml

workflows/fwsub.reflow_plus_downstream.py --name Reflow_FSD -i $inputs

logdir=${FW4DUNE_SCRATCH:-$SCRATCH}/slurm_logs/$name

mkdir -p "$logdir"

# TODO: Update job parameters
sbatch --array=1-10 -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh $name.flow rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh $name.flow2supera rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 4 slurm/fw_gpu.slurm.sh $name.spine rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh $name.flow2root rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh $name.pandora rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh $name.caf rapidfire

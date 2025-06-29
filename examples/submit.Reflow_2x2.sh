#!/usr/bin/env bash

source admin/load_fireworks.sh

name=Reflow_2x2_v11
# inputs=/pscratch/sd/d/dunepro/mkramer/install/Reflow_2x2_v9/inputs.2x2.v0p3.json
inputs=/pscratch/sd/d/dunepro/mkramer/install/Reflow_2x2_v11/inputs.2x2.sandbox.json

scripts/load_yaml.py specs/Reflow_v1.yaml specs/Reflow_2x2/*.yaml

workflows/fwsub.reflow_plus_downstream.py -i $inputs -n Reflow_2x2

logdir=${FW4DUNE_SCRATCH:-$SCRATCH}/slurm_logs/$name

mkdir -p "$logdir"

# TODO: Update job parameters
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 192 slurm/fw_cpu.slurm.sh Reflow_2x2.flow rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh Reflow_2x2.flow2supera rapidfire
sbatch --array=1-2 -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 4 slurm/fw_gpu.slurm.sh Reflow_2x2.spine rapidfire
sbatch --array=1-3 -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 20 slurm/fw_cpu.slurm.sh Reflow_2x2.flow2root rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh Reflow_2x2.pandora rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh Reflow_2x2.caf rapidfire

#!/usr/bin/env bash

source admin/load_fireworks.sh

name=Reflow_2x2
inputs=/pscratch/sd/d/dunepro/mkramer/install/Reflow_2x2/ndlar_reflow/inputs.2x2_beam.json

scripts/load_yaml.py specs/Reflow_v1.yaml specs/$name/*.yaml

workflows/fwsub.reflow.py -b $name.flow -i $inputs

logdir=${FW4DUNE_SCRATCH:-$SCRATCH}/slurm_logs/$name

mkdir -p "$logdir"

sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh $name.flow rapidfire

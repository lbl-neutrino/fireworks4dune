#!/usr/bin/env bash

source admin/load_fireworks.sh

name=Reflow_2x2_Run2_v0.LightBased
inputs1=/pscratch/sd/d/dunepro/mkramer/install/Reflow_2x2_Run2_v0/inputs.60116.light_based.json # AmBe
inputs2=/pscratch/sd/d/dunepro/mkramer/install/Reflow_2x2_Run2_v0/inputs.60130.light_based.json # cosmics

scripts/load_yaml.py specs/Reflow.yaml specs/Reflow_2x2_Run2_LightBased/ALL.Reflow_2x2_Run2_LightBased.yaml
workflows/fwsub.reflow_plus_downstream.py -i $inputs1 -n Reflow_2x2_Run2_LightBased
workflows/fwsub.reflow_plus_downstream.py -i $inputs2 -n Reflow_2x2_Run2_LightBased

logdir=${FW4DUNE_SCRATCH:-$SCRATCH}/slurm_logs/$name

mkdir -p "$logdir"

# TODO: Update job parameters
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 192 slurm/fw_cpu.slurm.sh Reflow_2x2.flow rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh Reflow_2x2.flow2supera rapidfire
sbatch --array=1-2 -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 4 slurm/fw_gpu.slurm.sh Reflow_2x2.spine rapidfire
sbatch --array=1-3 -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 20 slurm/fw_cpu.slurm.sh Reflow_2x2.flow2root rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh Reflow_2x2.pandora rapidfire
sbatch -o "$logdir"/slurm-%j.txt -N 4 -t 240 --ntasks-per-node 128 slurm/fw_cpu.slurm.sh Reflow_2x2.caf rapidfire

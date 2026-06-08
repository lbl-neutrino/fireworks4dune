#!/usr/bin/env bash

source admin/load_fireworks.sh

name=MiniProdN5_NDComplex_ReSPINE

lpad reset
scripts/load_yaml.py specs/NDComplex_v1.yaml specs/$name/*.yaml
workflows/fwsub.$name.py --start 0 --size 10
#workflows/fwsub.$name.py --start 0 --size 5000

mkdir -p $SCRATCH/mkramer/output/$name
mkdir -p $SCRATCH/mkramer/logs/$name

# Spread out the worker startups so they don't all connect to Mongo DB at once
export FW4DUNE_SLEEP_SEC=60

logdir=$SCRATCH/mkramer/slurm_logs/$name
mkdir -p "$logdir"

sbatch -o "$logdir"/slurm-%j.txt -A m3249 --array=1-2 -N 4 -t 240 slurm/fw_gpu.slurm.sh spine rapidfire

#!/usr/bin/env bash

source admin/load_fireworks.sh

name=Shield_Plane_2601

scripts/load_yaml.py specs/SPINETrainForNDLAr_v1.yaml
scripts/load_yaml.py specs/$name/ALL.$name.yaml

start=0
size=1


# MPV/MPR in ND-LAr
workflows/fwsub.Shield_Plane_2601.py --start $start --size $size --config muon --run-edep --run-spine
workflows/fwsub.Shield_Plane_2601.py --start $start --size $size --config proton --run-edep --run-spine
workflows/fwsub.Shield_Plane_2601.py --start $start --size $size --config pion --run-edep
workflows/fwsub.Shield_Plane_2601.py --start $start --size $size --config two_protons --run-edep
workflows/fwsub.Shield_Plane_2601.py --start $start --size $size --config proton_plus_muon --run-edep

# MPV/MPR in gigacube
workflows/fwsub.Shield_Plane_2601.py --start $start --size $size --config pi0 --run-edep --run-spine
workflows/fwsub.Shield_Plane_2601.py --start $start --size $size --config electron --run-edep
workflows/fwsub.Shield_Plane_2601.py --start $start --size $size --config gamma --run-edep

# nu in ND-LAr
workflows/fwsub.Shield_Plane_2601.py --start $start --size $size --config beam_fhc
workflows/fwsub.Shield_Plane_2601.py --start $start --size $size --config nue_fhc


# adding some shield plane configs now
workflows/fwsub.Shield_Plane_2601.py --start $start --size $size --config two_protons --sim-mode noFar_withShield


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

# Run flow
sbatch -A m3249 -o "$logdir"/slurm-%j.txt --array=1-1 -N 1 -t 60 slurm/fw_cpu.slurm.sh cpu_long rapidfire

#!/usr/bin/env bash

source admin/load_fireworks.sh

name=Reflow_FSDCube_v3
inputs=/pscratch/sd/d/dunepro/mkramer/install/Reflow_FSDCube_v1/files.json

scripts/reset_db.py
scripts/load_yaml.py specs/Reflow_v4.yaml specs/Reflow_FSDCube/ALL.Reflow_FSDCube.yaml

workflows/fwsub.reflow_centralized.py --name "$name" --inputs-json "$inputs"


# TMP for testing

workflows/fwsub.FSDCubeSim_spine.sh

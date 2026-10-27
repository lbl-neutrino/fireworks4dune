#!/usr/bin/env bash

source admin/load_fireworks.sh

name=CentiRun7_1E20_RHC

scripts/load_yaml.py --replace specs/SimFor2x2_v7.yaml specs/$name/*.yaml

workflows/fwsub.$name.py --nu --size 10
workflows/fwsub.$name.py --rock --size 10
workflows/fwsub.$name.py --spill --size 10

## Full sample (10:1 rock reuse):

# workflows/fwsub.$name.py --nu --size 10000
# workflows/fwsub.$name.py --rock --size 1000
# workflows/fwsub.$name.py --spill --size 10000

## (separate DBs for batches of 1000?)

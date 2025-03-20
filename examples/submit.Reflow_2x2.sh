#!/usr/bin/env bash

scripts/load_yaml.py specs/Reflow_v1.yaml specs/Reflow_2x2/*.yaml

workflows/fwsub.reflow.py -b Reflow_2x2.flow -i /pscratch/sd/d/dunepro/mkramer/install/Reflow_2x2/ndlar_reflow/inputs.2x2_beam.json

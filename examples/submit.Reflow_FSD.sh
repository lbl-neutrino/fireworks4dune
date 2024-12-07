#!/usr/bin/env bash

scripts/load_yaml.py specs/Reflow_v1.yaml specs/Reflow_FSD/*.yaml

workflows/fwsub.reflow.py -b Reflow_FSD.flow -i /path/to/ndlar_reflow/inputs.json

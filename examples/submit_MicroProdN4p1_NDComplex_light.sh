#!/usr/bin/env bash

set +o posix

scripts/load_yaml.py specs/NDComplex_v1.yaml specs/MicroProdN4p1_NDComplex_light/*.yaml

logdir=/pscratch/sd/d/dunepro/mkramer/logs_sbatch/MicroProdN4p1
mkdir -p $logdir

workflows/fwsub.MicroProdN4p1_NDComplex_light.py

#!/usr/bin/env bash


set +o posix


scripts/load_yaml.py specs/NDComplex_v1.yaml specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.genie.ndlarfid.yaml --replace
scripts/load_yaml.py specs/NDComplex_v1.yaml specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.genie.rockantindlarfid.yaml --replace


start=1
single_size=256000
spill_size=2560


logdir=/pscratch/sd/d/dunepro/abooth/logs_sbatch/MicroProdN4p1
mkdir -p $logdir


scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MicroProdN4p1_NDComplex_FHC.genie.ndlarfid --size $single_size --start $start
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-10 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.genie.ndlarfid rapidfire


scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MicroProdN4p1_NDComplex_FHC.genie.rockantindlarfid --size $single_size --start $start
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-10 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.genie.rockantindlarfid rapidfire



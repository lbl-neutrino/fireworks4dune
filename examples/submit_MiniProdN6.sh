#!/usr/bin/env bash

set +o posix


#scripts/load_yaml.py specs/NDComplex_v1.yaml --replace


######################
## MiniProdN6p1

#scripts/load_yaml.py specs/MiniProdN6_NDComplex/MiniProdN6p1_NDComplex_FHC.genie.fid.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN6_NDComplex/MiniProdN6p1_NDComplex_FHC.genie.fid.sandstt.yaml --replace

######################

######################
## MiniProdN6p2

#scripts/load_yaml.py specs/MiniProdN6_NDComplex/MiniProdN6p2_NDComplex_RHC.genie.fid.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN6_NDComplex/MiniProdN6p2_NDComplex_RHC.genie.fid.sandstt.yaml --replace

######################

start_sanddrift=1
start_sandstt=64001
#start_sandstt=6401
single_size=64000
spill_size=6400
#start_sanddrift=1
##start_sandstt=16001
#start_sandstt=1601
#single_size=16000
#spill_size=1600


logdir=/pscratch/sd/d/dunepro/jclarkin/logs_sbatch/MiniProdN6
mkdir -p $logdir


######################
## MiniProdN6p1

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN6p1_NDComplex_FHC.genie.fid.sanddrift --size $single_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_cpu.slurm.sh MiniProdN6p1_NDComplex_FHC.genie.fid.sanddrift rapidfire

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN6p1_NDComplex_FHC.genie.rockantifid.sanddrift --size $single_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN6p1_NDComplex_FHC.genie.rockantifid.sanddrift rapidfire

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN6p1_NDComplex_FHC.genie.fid.sandstt --size $single_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN6p1_NDComplex_FHC.genie.fid.sandstt rapidfire

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN6p1_NDComplex_FHC.genie.rockantifid.sandstt --size $single_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN6p1_NDComplex_FHC.genie.rockantifid.sandstt rapidfire

######################


######################
## MiniProdN6p2

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN6p2_NDComplex_RHC.genie.fid.sanddrift --size $single_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN6p2_NDComplex_RHC.genie.fid.sanddrift rapidfire

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN6p2_NDComplex_RHC.genie.rockantifid.sanddrift --size $single_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-5 -N 1 slurm/fw_cpu.slurm.sh MiniProdN6p2_NDComplex_RHC.genie.rockantifid.sanddrift singleshot

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN6p2_NDComplex_RHC.genie.fid.sandstt --size $single_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN6p2_NDComplex_RHC.genie.fid.sandstt rapidfire

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN6p2_NDComplex_RHC.genie.rockantifid.sandstt --size $single_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-5 -N 1 slurm/fw_cpu.slurm.sh MiniProdN6p2_NDComplex_RHC.genie.rockantifid.sandstt singleshot

######################


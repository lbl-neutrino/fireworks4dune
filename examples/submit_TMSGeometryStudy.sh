#!/usr/bin/env bash


set +o posix


#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/TMSGeometryStudy_1E18_FHC/*.genie.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/TMSGeometryStudy_1E18_FHC/*.edep.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/TMSGeometryStudy_1E18_FHC/*.hadd.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/TMSGeometryStudy_1E18_FHC/*.spill.nu.yaml --replace
#scripts/load_yaml.py specs/ND_Production_v1.yaml specs/TMSGeometryStudy_1E18_FHC/*.tmsreco.nu.yaml --replace


start=1
single_size=2560
spill_size=256

# hybrid or stereo geometry. 
logdir=/pscratch/sd/m/mdolce/TMSGeometryStudy_1E18_FHC-stereo/logs_sbatch
mkdir -p $logdir


#scripts/fwsub.py --runner SimForNDLAr_v4_Genie --base-env TMSGeometryStudy_1E18_FHC.genie.nu --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-5 -N 1 slurm/fw_cpu.slurm.sh TMSGeometryStudy_1E18_FHC.genie.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Edep --base-env TMSGeometryStudy_1E18_FHC.edep.nu --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_cpu.slurm.sh TMSGeometryStudy_1E18_FHC.edep.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Hadd --base-env TMSGeometryStudy_1E18_FHC.nu.hadd --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh TMSGeometryStudy_1E18_FHC.nu.hadd rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_SpillBuild --base-env TMSGeometryStudy_1E18_FHC.spill.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh TMSGeometryStudy_1E18_FHC.spill.nu rapidfire


#scripts/fwsub.py --runner ND_Production_v1_TMSReco --base-env TMSGeometryStudy_1E18_FHC.tmsreco.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh TMSGeometryStudy_1E18_FHC.tmsreco.nu rapidfire

#!/usr/bin/env bash


set +o posix


scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr/*.genie.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr/*.edep.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr/*.hadd.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr/*.spill.nu.yaml --replace
#scripts/load_yaml.py specs/ND_Production_v1.yaml specs/MicroProdN3p1_NDLAr/*.tmsreco.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr/*.convert*.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr/*.larnd.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr/*.flow.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr/*.mlreco.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr/*.caf.nu.yaml --replace


start=1
single_size=2560
spill_size=256


logdir=/pscratch/sd/a/abooth/MicroProdN3p1/logs_sbatch
mkdir -p $logdir


scripts/fwsub.py --runner SimForNDLAr_v4_Genie --base-env MicroProdN3p1_NDLAr_2E18_FHC.genie.nu --size $single_size --start $start
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-5 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1_NDLAr_2E18_FHC.genie.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Edep --base-env MicroProdN3p1_NDLAr_2E18_FHC.edep.nu --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1_NDLAr_2E18_FHC.edep.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Hadd --base-env MicroProdN3p1_NDLAr_2E18_FHC.nu.hadd --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1_NDLAr_2E18_FHC.nu.hadd rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_SpillBuild --base-env MicroProdN3p1_NDLAr_2E18_FHC.spill.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1_NDLAr_2E18_FHC.spill.nu rapidfire


#scripts/fwsub.py --runner ND_Production_v1_TMSReco --base-env MicroProdN3p1_NDLAr_2E18_FHC.tmsreco.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1_NDLAr_2E18_FHC.tmsreco.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Convert2H5 --base-env MicroProdN3p1_NDLAr_2E18_FHC.convert2h5.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1_NDLAr_2E18_FHC.convert2h5.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_LArND --base-env MicroProdN3p1_NDLAr_2E18_FHC.larnd.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-64 -N 1 slurm/fw_gpu.slurm.sh MicroProdN3p1_NDLAr_2E18_FHC.larnd.nu singleshot


#scripts/fwsub.py --runner SimForNDLAr_v4_Flow --base-env MicroProdN3p1_NDLAr_2E18_FHC.flow.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-9 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1_NDLAr_2E18_FHC.flow.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Flow2Supera --base-env MicroProdN3p1_NDLAr_2E18_FHC.flow2supera.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-9 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1_NDLAr_2E18_FHC.flow2supera.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_MLreco_Spine --base-env MicroProdN3p1_NDLAr_2E18_FHC.mlreco_spine.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-4 -N 1 slurm/fw_gpu.slurm.sh MicroProdN3p1_NDLAr_2E18_FHC.mlreco_spine.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_CAFMaker --base-env MicroProdN3p1_NDLAr_2E18_FHC.caf.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1_NDLAr_2E18_FHC.caf.nu rapidfire

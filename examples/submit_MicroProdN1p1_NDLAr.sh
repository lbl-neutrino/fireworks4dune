#!/usr/bin/env bash


set +o posix


#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.genie.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.edep.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.edep.nu.no_zero_threshold_set.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.genie.rock.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.edep.rock.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.hadd.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.spill.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.spill.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.spill.nu.no_zero_threshold_set.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.convert*.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.convert*.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.convert*.nu.alldets.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.convert*.nu.no_zero_threshold_set.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.larnd.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.larnd.nu.yaml --replace
#scripts/load_yaml.py specs/ND_Production_v1.yaml specs/MicroProdN1p1_NDLAr/*.tmsreco.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.flow.yaml --replace
#scripts/load_yaml.py  specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.flow.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.mlreco.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.mlreco.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN1p1_NDLAr/*.caf.nu.yaml --replace


start=1
single_size=1280
spill_size=128

logdir=/pscratch/sd/a/abooth/MicroProdN1p1/logs_sbatch
mkdir -p $logdir


#scripts/fwsub.py --runner SimForNDLAr_v4_Genie --base-env MicroProdN1p1_NDLAr_1E18_RHC.genie.nu --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.genie.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Edep --base-env MicroProdN1p1_NDLAr_1E18_RHC.edep.nu --size $single_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v4_Edep --base-env MicroProdN1p1_NDLAr_1E18_RHC.edep.nu.no_zero_threshold_set --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.edep.nu rapidfire
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.edep.nu.no_zero_threshold_set rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Genie --base-env MicroProdN1p1_NDLAr_1E18_RHC.genie.rock --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.genie.rock rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Edep --base-env MicroProdN1p1_NDLAr_1E18_RHC.edep.rock --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.edep.rock rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Hadd --base-env MicroProdN1p1_NDLAr_1E18_RHC.nu.hadd --size $spill_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v4_Hadd --base-env MicroProdN1p1_NDLAr_1E18_RHC.nu.no_zero_threshold_set.hadd --size $spill_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v4_Hadd --base-env MicroProdN1p1_NDLAr_1E18_RHC.rock.hadd --size $spill_size --start $start
#
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.nu.hadd rapidfire
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.nu.no_zero_threshold_set.hadd rapidfire
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.rock.hadd rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_SpillBuild --base-env MicroProdN1p1_NDLAr_1E18_RHC.spill --size $spill_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v4_SpillBuild --base-env MicroProdN1p1_NDLAr_1E18_RHC.spill.nu --size $spill_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v4_SpillBuild --base-env MicroProdN1p1_NDLAr_1E18_RHC.spill.nu.no_zero_threshold_set --size $spill_size --start $start
#
# 2 to 3 hours per firework.
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.spill rapidfire
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.spill.nu rapidfire
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.spill.nu.no_zero_threshold_set rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Convert2H5 --base-env MicroProdN1p1_NDLAr_1E18_RHC.convert2h5 --size $spill_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v4_Convert2H5 --base-env MicroProdN1p1_NDLAr_1E18_RHC.convert2h5.nu --size $spill_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v4_Convert2H5 --base-env MicroProdN1p1_NDLAr_1E18_RHC.convert2h5.nu.alldets --size $spill_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v4_Convert2H5 --base-env MicroProdN1p1_NDLAr_1E18_RHC.convert2h5.nu.no_zero_threshold_set --size $spill_size --start $start
#
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.convert2h5 rapidfire
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.convert2h5.nu rapidfire
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.convert2h5.nu.alldets rapidfire
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.convert2h5.nu.no_zero_threshold_set rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_LArND --base-env MicroProdN1p1_NDLAr_1E18_RHC.larnd --size $spill_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v4_LArND --base-env MicroProdN1p1_NDLAr_1E18_RHC.larnd.nu --size $spill_size --start $start
#
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_gpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.larnd rapidfire
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-32 -N 1 slurm/fw_gpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.larnd.nu rapidfire


#scripts/fwsub.py --runner ND_Production_v1_TMSReco --base-env MicroProdN1p1_NDLAr_1E18_RHC.tmsreco.nu --size $spill_size --start $start
#
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.tmsreco.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Flow --base-env MicroProdN1p1_NDLAr_1E18_RHC.flow --size $spill_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v4_Flow --base-env MicroProdN1p1_NDLAr_1E18_RHC.flow.nu --size $spill_size --start $start

#sbatch -o "$logdir"/slurm-%j.txt --array=1-69 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.flow rapidfire
#sbatch -o "$logdir"/slurm-%j.txt --array=1-16 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.flow.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Flow2Supera --base-env MicroProdN1p1_NDLAr_1E18_RHC.flow2supera --size $spill_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v4_Flow2Supera --base-env MicroProdN1p1_NDLAr_1E18_RHC.flow2supera.nu --size $spill_size --start $start

#sbatch -o "$logdir"/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.flow2supera rapidfire
#sbatch -o "$logdir"/slurm-%j.txt --array=1-8 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.flow2supera.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_MLreco_Spine --base-env MicroProdN1p1_NDLAr_1E18_RHC.mlreco_spine.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-32 -N 1 slurm/fw_gpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.mlreco_spine.nu rapidfire
#sbatch -o "$logdir"/slurm-%j.txt -N 14 slurm/fw_gpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.mlreco_spine.nu singleshot


#scripts/fwsub.py --runner SimForNDLAr_v4_CAFMaker --base-env MicroProdN1p1_NDLAr_1E18_RHC.caf.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p1_NDLAr_1E18_RHC.caf.nu rapidfire

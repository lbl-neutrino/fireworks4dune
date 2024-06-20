#!/usr/bin/env bash

#source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC

#scripts/load_yaml.py specs/SimForNDLAr_v1.yaml specs/MiniProdN1p2_NDLAr/*.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v1.yaml specs/MiniProdN1p2_NDLAr/*.rock.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v1.yaml specs/MiniProdN1p2_NDLAr/*.hadd.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v1.yaml specs/MiniProdN1p2_NDLAr/*.spill.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v1.yaml specs/MiniProdN1p2_NDLAr/*.convert*.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v1.yaml specs/MiniProdN1p2_NDLAr/*.larnd*.yaml --replace
#scripts/load_yaml.py specs/ND_Production_v1.yaml specs/MiniProdN1p2_NDLAr/*.tmsreco.yaml --replace
#scripts/load_yaml.py --replace specs/SimForNDLAr_v2.yaml specs/MiniProdN1p2_NDLAr/*.flow.yaml

start=1
# 11008 fiducial edep-sim files after one round of draining.
# 10650 rock edep-sim files after two rounds of draining.
single_size=11008
# 11008 is not divisible by 10.
spill_size=1099
logdir=$SCRATCH/MiniProdN1p2-v1r1/job_logs.MiniProdN1p2_NDLAr_1E19_RHC

mkdir -p $logdir


#scripts/fwsub.py --runner SimForNDLAr_v1_GenieEdep --base-env MiniProdN1p2_NDLAr_1E19_RHC.nu --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p2_NDLAr_1E19_RHC.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v1_GenieEdep --base-env MiniProdN1p2_NDLAr_1E19_RHC.rock --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p2_NDLAr_1E19_RHC.rock rapidfire
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p2_NDLAr_1E19_RHC.rock singleshot


#scripts/fwsub.py --runner SimForNDLAr_v1_Hadd --base-env MiniProdN1p2_NDLAr_1E19_RHC.nu.hadd --size $spill_size --start $start
#scripts/fwsub.py --runner SimForNDLAr_v1_Hadd --base-env MiniProdN1p2_NDLAr_1E19_RHC.rock.hadd --size $spill_size --start $start
#
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p2_NDLAr_1E19_RHC.nu.hadd rapidfire
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p2_NDLAr_1E19_RHC.rock.hadd rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v1_SpillBuild --base-env MiniProdN1p2_NDLAr_1E19_RHC.spill --size $spill_size --start $start
#
# 2 to 3 hours per firework.
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p2_NDLAr_1E19_RHC.spill rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v1_Convert2H5 --base-env MiniProdN1p2_NDLAr_1E19_RHC.convert2h5 --size $spill_size --start $start
#
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p2_NDLAr_1E19_RHC.convert2h5 rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v1_LArND --base-env MiniProdN1p2_NDLAr_1E19_RHC.larnd --size $spill_size --start $start
#
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_gpu.slurm.sh MiniProdN1p2_NDLAr_1E19_RHC.larnd rapidfire


#scripts/fwsub.py --runner ND_Production_v1_TMSReco --base-env MiniProdN1p2_NDLAr_1E19_RHC.tmsreco --size $spill_size --start $start
#
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p2_NDLAr_1E19_RHC.tmsreco rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v2_Flow --base-env MiniProdN1p2_NDLAr_1E19_RHC.flow --size $spill_size --start $start

sbatch -o "$logdir"/slurm-%j.txt --array=1-69 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p2_NDLAr_1E19_RHC.flow rapidfire


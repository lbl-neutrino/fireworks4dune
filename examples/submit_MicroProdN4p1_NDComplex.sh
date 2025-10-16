#!/usr/bin/env bash


set +o posix


#scripts/load_yaml.py specs/NDComplex_v1.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.genie.ndlarfid.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.genie.rockantindlarfid.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.edep.ndlarfid.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.edep.rockantindlarfid.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.hadd.ndlarfid.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.hadd.rockantindlarfid.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.spill.full.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.convert2h5.full.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.larnd.full.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.flow.full.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.flow.full.v251016.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.flow2supera.full.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.spine.full.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.tmsreco.full.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.caf.full.spineonly.yaml --replace

#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.flow2supera.full.light.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.spine.full.light.yaml --replace
#scripts/load_yaml.py specs/MicroProdN4p1_NDComplex/MicroProdN4p1_NDComplex_FHC.caf.full.light.spineonly.yaml --replace


start=1
single_size=25600
spill_size=2560


logdir=/pscratch/sd/d/dunepro/abooth/logs_sbatch/MicroProdN4p1
mkdir -p $logdir


#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MicroProdN4p1_NDComplex_FHC.genie.ndlarfid --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.genie.ndlarfid rapidfire

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MicroProdN4p1_NDComplex_FHC.genie.rockantindlarfid --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-3 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.genie.rockantindlarfid singleshot


#scripts/fwsub.py --runner NDComplex_v1_Edep --base-env MicroProdN4p1_NDComplex_FHC.edep.ndlarfid --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.edep.ndlarfid rapidfire

#scripts/fwsub.py --runner NDComplex_v1_Edep --base-env MicroProdN4p1_NDComplex_FHC.edep.rockantindlarfid --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.edep.rockantindlarfid singleshot


#scripts/fwsub.py --runner NDComplex_v1_Hadd --base-env MicroProdN4p1_NDComplex_FHC.hadd.ndlarfid --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.hadd.ndlarfid singleshot

#scripts/fwsub.py --runner NDComplex_v1_Hadd --base-env MicroProdN4p1_NDComplex_FHC.hadd.rockantindlarfid --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.hadd.rockantindlarfid singleshot


#scripts/fwsub.py --runner NDComplex_v1_SpillBuild --base-env MicroProdN4p1_NDComplex_FHC.spill.full --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.spill.full singleshot


#scripts/fwsub.py --runner NDComplex_v1_Convert2H5 --base-env MicroProdN4p1_NDComplex_FHC.convert2h5.full --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.convert2h5.full singleshot


#scripts/fwsub.py --runner NDComplex_v1_LArND --base-env MicroProdN4p1_NDComplex_FHC.larnd.full --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_gpu.slurm.sh MicroProdN4p1_NDComplex_FHC.larnd.full rapidfire


#scripts/fwsub.py --runner NDComplex_v1_Flow --base-env MicroProdN4p1_NDComplex_FHC.flow.full --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.flow.full singleshot


#scripts/fwsub.py --runner NDComplex_v1_Flow --base-env MicroProdN4p1_NDComplex_FHC.flow.full.v251016 --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.flow.full.v251016 singleshot


#scripts/fwsub.py --runner NDComplex_v1_Flow2Supera --base-env MicroProdN4p1_NDComplex_FHC.flow2supera.full --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.flow2supera.full singleshot


#scripts/fwsub.py --runner NDComplex_v1_MLreco_Spine --base-env MicroProdN4p1_NDComplex_FHC.spine.full --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_gpu.slurm.sh MicroProdN4p1_NDComplex_FHC.spine.full rapidfire


#scripts/fwsub.py --runner NDComplex_v1_TMSReco --base-env MicroProdN4p1_NDComplex_FHC.tmsreco.full --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.tmsreco.full rapidfire


#scripts/fwsub.py --runner NDComplex_v1_CAFMaker --base-env MicroProdN4p1_NDComplex_FHC.caf.full.spineonly --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.caf.full.spineonly rapidfire


#scripts/fwsub.py --runner NDComplex_v1_Flow2Supera --base-env MicroProdN4p1_NDComplex_FHC.flow2supera.full.light --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.flow2supera.full.light singleshot


#scripts/fwsub.py --runner NDComplex_v1_MLreco_Spine --base-env MicroProdN4p1_NDComplex_FHC.spine.full.light --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_gpu.slurm.sh MicroProdN4p1_NDComplex_FHC.spine.full.light rapidfire


#scripts/fwsub.py --runner NDComplex_v1_CAFMaker --base-env MicroProdN4p1_NDComplex_FHC.caf.full.light.spineonly --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_cpu.slurm.sh MicroProdN4p1_NDComplex_FHC.caf.full.light.spineonly singleshot

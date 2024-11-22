#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix

scripts/load_yaml.py specs/Particle_Gun.yaml specs/Particle_Gun_mu-_300MeV_3GeV_1E10/*.edep.nu.yaml --replace
#scripts/load_yaml.py specs/Particle_Gun.yaml specs/Particle_Gun_mu-_300MeV_3GeV_1E10/*.hadd.nu.yaml --replace
#scripts/load_yaml.py specs/Particle_Gun.yaml specs/Particle_Gun_mu-_300MeV_3GeV_1E10/*.spill.nu.yaml --replace
#scripts/load_yaml.py specs/ND_Production_v1.yaml Particle_Gun_mu-_300MeV_3GeV_1E10/*.tmsreco.nu.yaml --replace
#scripts/load_yaml.py specs/Particle_Gun.yaml specs/Particle_Gun_mu-_300MeV_3GeV_1E10/*.convert*.nu.yaml --replace
#scripts/load_yaml.py specs/Particle_Gun.yaml specs/Particle_Gun_mu-_300MeV_3GeV_1E10/*.larnd.nu.yaml --replace
#scripts/load_yaml.py specs/Particle_Gun.yaml specs/Particle_Gun_mu-_300MeV_3GeV_1E10/*.flow.nu.yaml --replace
#scripts/load_yaml.py specs/Particle_Gun.yaml specs/Particle_Gun_mu-_300MeV_3GeV_1E10/*.mlreco.nu.yaml --replace
#scripts/load_yaml.py specs/Particle_Gun.yaml specs/Particle_Gun_mu-_300MeV_3GeV_1E10/*.caf.nu.yaml --replace

start=1
single_size=10
spill_size=1

logdir=/pscratch/sd/t/tta20/Particle_Gun_Production/logs_sbatch
mkdir -p $logdir

scripts/fwsub.py --runner Particle_Gun_Edep --base-env Particle_Gun_mu-.edep.nu --size $single_size --start $start
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_cpu.slurm.sh Particle_Gun_mu-.edep.nu rapidfire

#scripts/fwsub.py --runner Particle_Gun_Hadd --base-env Particle_Gun_mu-.nu.hadd --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh Particle_Gun_mu-.nu.hadd rapidfire


#scripts/fwsub.py --runner Particle_Gun_SpillBuild --base-env Particle_Gun_mu-.spill.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh Particle_Gun_mu-.spill.nu rapidfire


#scripts/fwsub.py --runner ND_Production_v1_TMSReco --base-env Particle_Gun_mu-.tmsreco.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh Particle_Gun_mu-.tmsreco.nu rapidfire


#scripts/fwsub.py --runner Particle_Gun_Convert2H5 --base-env Particle_Gun_mu-.convert2h5.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh Particle_Gun_mu-.convert2h5.nu rapidfire


#scripts/fwsub.py --runner Particle_Gun_LArND --base-env Particle_Gun_mu-.larnd.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-64 -N 1 slurm/fw_gpu.slurm.sh Particle_Gun_mu-.larnd.nu singleshot


#scripts/fwsub.py --runner Particle_Gun_Flow --base-env Particle_Gun_mu-.flow.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-9 -N 1 slurm/fw_cpu.slurm.sh Particle_Gun_mu-.flow.nu rapidfire


#scripts/fwsub.py --runner Particle_Gun_Flow2Supera --base-env Particle_Gun_mu-.flow2supera.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-9 -N 1 slurm/fw_cpu.slurm.sh Particle_Gun_mu-.flow2supera.nu rapidfire


#scripts/fwsub.py --runner Particle_Gun_MLreco_Spine --base-env Particle_Gun_mu-.mlreco_spine.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-4 -N 1 slurm/fw_gpu.slurm.sh Particle_Gun_mu-.mlreco_spine.nu rapidfire


#scripts/fwsub.py --runner Particle_Gun_CAFMaker --base-env Particle_Gun_mu-.caf.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh Particle_Gun_mu-.caf.nu rapidfire

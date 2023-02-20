# Initial setup (installing FireWorks client etc.)

``` bash
admin/install_fireworks.sh
```

Then edit `fw_config/my_launchpad.yaml` to specify the password for MongoDB.

# Loading the FireWorks environment

``` bash
source admin/load_fireworks.sh
```

# Adding repos, runners, environment variables

Load Mongo DB with the repository and two runners (GENIE+edep-sim, larnd-sim)
for the 2x2 simulation:

``` bash
scripts/load_yaml.py specs/SimFor2x2_v1.yaml
```

Load Mongo DB with environment variables for the 2x2 neutrino sim (2E15
POT/file):

``` bash
scripts/load_yaml.py specs/MiniRun1_1E19_RHC_nu.yaml
```

Likewise for the rock sim (5E14 POT/file):

``` bash
scripts/load_yaml.py specs/MiniRun1_1E19_RHC_rock_split4.yaml
```

# Loading FireWorks

Load 5,120 neutrino FireWorks, each 2E15 POT, total 1E19 POT:

``` bash
scripts/fwsub_edep.py --runner SimFor2x2_v1_GenieEdep --base-env MiniRun1_1E19_RHC_nu --size 5120
```

Load 20,480 rock Fireworks, each 5E14 POT, total 1E19 POT:

``` bash
scripts/fwsub_edep.py --runner SimFor2x2_v1_GenieEdep --base-env MiniRun1_1E19_RHC_rock_split4 --size 20480
```

# Submitting workers

On Perlmutter:

``` bash
sbatch -C cpu -N 20 -t 1:00:00 --ntasks-per-node=256 wrappers/edep-sim/edep_sim_job_fw_auto.sh MiniRun1_1E19_RHC_rock_nu

sbatch --array=1-4 -C cpu -N 20 -t 3:00:00 --ntasks-per-node=256 wrappers/edep-sim/edep_sim_job_fw_auto.sh MiniRun1_1E19_RHC_rock_split4
```

On Cori:

``` bash
sbatch --array=1-4 -C haswell -N 20 -t 2:00:00 --ntasks-per-node=64 wrappers/edep-sim/edep_sim_job_fw_auto.sh MiniRun1_1E19_RHC_rock_nu

sbatch --array=1-16 -C haswell -N 20 -t 3:00:00 --ntasks-per-node=64 wrappers/edep-sim/edep_sim_job_fw_auto.sh MiniRun1_1E19_RHC_rock_split4
```

Nodes-per-job and job array size can be tuned according to the queue wait plot
in MyNERSC (not available for Perlmutter yet).

# Dealing with failures

Jobs that "crashed" (i.e. nonzero exit code) will be automatically marked as
`FIZZLED` in Mongo DB. Jobs that "hung" (e.g. killed due to walltime limit) need
to be detected and marked as `FIZZLED` with the following command:

``` bash
lpad detect_lostruns --fizzle
```

All `FIZZLED` jobs can be reset to the `READY` state as follows:

``` bash
lpad rerun_fws -s FIZZLED
```

And then workers can be submitted as before.

## Stale locks

If either of the above two commands hang for five minutes and then complain
about a locked FireWork, you can manually unlock a single FireWork like:

``` bash
lpad admin unlock -i 18014
```

If there are a whole bunch of locked FireWorks, this becomes very painful.
Instead, following [this
thread](https://matsci.org/t/painful-resolution-of-lockedworkflowerror-with-large-jobs/40156),
you can temporarily edit `fw.venv/lib/python3.9/site-packages/fireworks/fw_config.py` as follows:

``` python
WFLOCK_EXPIRATION_SECS = 0  # wait this long for a WFLock before expiring
WFLOCK_EXPIRATION_KILL = True  # kill WFLock on expiration (or give a warning)
```

Then you will be able to sucessfully run `detect_lostruns` or `rerun_fws`. Don't
do this while jobs are running! And remember to revert the changes to
`fw_config.py`. These steps shouldn't be necessary under normal circumstances,
but if the Mongo DB server crashes, stale locks are in fact a possibility.

## Crash analysis in Jupyter

For a very basic example of using `pymongo` to examine a failed job, see
`notebooks/crash_check.ipynb`.

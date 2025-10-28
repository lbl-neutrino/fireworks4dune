# Initial setup (installing FireWorks client etc.)

``` bash
admin/install_fireworks.sh
```

Then edit `fw_config/my_launchpad.yaml` to specify the password for MongoDB.

If you are going to be using the fireworks web GUI, the default port number (5000) can be changed by specifying a new port number with `WEBSERVER_PORT` in `fw_config/FW_config.yaml`

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

# Loading FireWorks for edep-sim

Load 5,120 neutrino FireWorks, each 2E15 POT, total 1E19 POT:

``` bash
scripts/fwsub_edep.py --runner SimFor2x2_v1_GenieEdep --base-env MiniRun1_1E19_RHC_nu --size 5120
```

Load 20,480 rock Fireworks, each 5E14 POT, total 1E19 POT:

``` bash
scripts/fwsub_edep.py --runner SimFor2x2_v1_GenieEdep --base-env MiniRun1_1E19_RHC_rock_split4 --size 20480
```

To (hopefully) speed up the Mongo database in order to help jobs launch more
smoothly, you can then do:

``` bash
lpad admin tuneup --full
```

The FireWorks docs say that the full tuneup should only be done when no jobs are
running, but on any recent Mongo release it's "probably" fine to disregard that
advice.

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

# Checking the status of your FireWorks

To see how many are in each state (READY, RUNNING, FIZZLED, etc.):

``` bash
scripts/dump_status.py MiniRun1_1E19_RHC_nu
```


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

# Spill building

``` bash
scripts/load_yaml.py specs/MiniRun1_1E19_RHC_spills.yaml

scripts/fwsub.py --runner SimFor2x2_v1_SpillBuild --base-env MiniRun1_1E19_RHC_spills --size 5
```

Slurm job to be written, but it works when running rlaunch interactively.

# Self-hosted MongoDB instance

If the MongoDB on SPIN is down/inaccessible or a self-hosted DB is desired,
several scripts are available to accomplish this using the NERSC compute nodes.

## Running the DB

The idea is to host the MongoDB files on $SCRATCH and run the service on a compute node via container. 
This means the MongoDB is only available when the job is running, but due to only using two cores of a
shared node, it is extremely cheap to run.

The MongoDB service is run via a container that is setup using `init_mongo_container.sh`. See the script
for the DB settings, e.g. MongoDB user/pass, service port, etc. The database password needs to be set to
something! Some of these settings are different from the MongoDB defaults as to not conflict with other instances.

Since the MongoDB is hosted on a compute node, its IP changes each time it starts on a new node. The
fireworks config `my_launchpad.yaml` needs to be edited with the active IP address.

**The IP and port along with the MongoDB username and password need to be set within `my_launchpad.yaml`
so Fireworks knows the correct connection and authentication information.**

Follow these steps to start the service and connect to the MongoDB
1. Load the fireworks environment via `source admin/load_fireworks.sh`
2. Edit `init_mongo_container.sh` to set the DB password (and other settings if desired)
3. Submit the MongoDB job using `sbatch scripts/sbatch_mongo.sh`; by default it runs for 24 hours
4. Run `get_job_ip_addr.sh <job_id>` to retrieve the IP address of the job node after job is started
5. Edit `my_launchpad.yaml` with the IP address of the MongoDB compute node and DB password
6. Fireworks should function like normal (note that the connection may be slow initially)

By default the scripts will store the DB in `$fw4dune_dir/mongo_db`. Set the `$MONGODB_LOCAL_DIR`
environment variable to define a different DB location.

## Testing the connection

The connection to the MongoDB can be verified using the Mongo Shell (mongosh). Using the IP address and port
from the container initialization, connect to the MongoDB instance:
```bash
mongosh "mongodb://<node_ip_addr>:<container_port>" --username root
# for example mongodb://127.0.0.1:55555
```
Enter the password when prompted and if the connection is active a Mongo shell prompt will appear.

Using the Mongo Shell the Fireworks DB can be checked if it exists and queried. The following commands may
be helpful (and all of this is easily searchable) to view the Fireworks DB and production collection.
```
#View all DBs
show dbs
#Switch to DB
use <db_name>
#View all collections
show collections
#List all docs in a collection (with pretty printing)
db.<collection_name>.find({}).pretty()
```

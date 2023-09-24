#!/usr/bin/env python3

import os
from subprocess import check_call
import traceback

from fireworks.core.firework import FiretaskBase, FWAction
from fireworks.core.launchpad import LaunchPad


class RepoRunnerException(Exception):
    def __init__(self, data):
        self.tb = traceback.format_exc()
        self.data = data

    # called by rocket.run
    def to_dict(self):
        return {'stacktrace': self.tb,
                'data': self.data}


class RepoRunner(FiretaskBase):
    _fw_name = 'RepoRunner'

    def run_task(self, fw_spec):
        lpad = LaunchPad.auto_load()
        db = lpad.connection[lpad.name]

        env = os.environ

        if 'base_env' in fw_spec:
            base_env = db['base_envs'].find_one({'name': fw_spec['base_env']})
            assert type(base_env) is dict
            env |= base_env['env']

        if 'env' in fw_spec:
            assert type(fw_spec['env']) is dict
            env |= fw_spec['env']

        runner = db['runners'].find_one({'name': fw_spec['runner']})
        assert type(runner) is dict

        repo = db['repos'].find_one({'name': runner['repo']})
        assert type(repo) is dict

        reponameDotGit = repo['url'].split('/')[-1]
        assert reponameDotGit.endswith('.git')
        reponame = reponameDotGit[:-4]

        # TODO: Verify that repo['commit'] is what we're actually using

        repodir = os.path.join(os.environ['FW4DUNE_REPO_DIR'], reponame)
        assert os.path.exists(repodir)

        # e.g. for ease of looking up log files
        slurm_vars = ['SLURM_JOB_ID', 'SLURM_ARRAY_JOB_ID', 'SLURM_NTASKS_PER_NODE',
                      'SLURM_ARRAY_TASK_ID', 'SLURM_NODEID', 'SLURM_LOCALID']
        slurm_data = {v: os.getenv(v, default='') for v in slurm_vars}

        # here we go!
        try:
            check_call(runner['cmd'],
                       shell=True,
                       cwd=os.path.join(repodir, runner['workdir']),
                       env=env)
        except:
            raise RepoRunnerException(slurm_data)

        return FWAction(stored_data=slurm_data)

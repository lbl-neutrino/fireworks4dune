#!/usr/bin/env python3

from typing import Optional

from fireworks import Firework

from . import RepoRunner


class FwMaker:
    def __init__(self, base_env_prefix: str, repo: str, name: str):
        self.base_env_prefix = base_env_prefix
        self.repo = repo
        self.name = name

    def make(self, index: int, runner_postfix: str, step_postfix: str,
             category: Optional[str]) -> Firework:

        base_env = f'{self.base_env_prefix}.{step_postfix}'
        if category is None:
            category = base_env

        spec = {
            'runner': f'{self.repo}_{runner_postfix}',
            'base_env': base_env,
            'env': {
                'ARCUBE_OUT_NAME': f'{self.name}.{step_postfix}',
                'ARCUBE_INDEX': str(index)
            },
            '_category': category
        }

        return Firework(RepoRunner(), name=f'{self.name}.{step_postfix}', spec=spec)

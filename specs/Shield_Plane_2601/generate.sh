#!/bin/bash
for d in mpvmpr_gigacube mpvmpr_ndlar nu_ndlar; do
  pushd $d
  for f in *.jinja2; do minijinja-cli $f > $(basename $f .jinja2); done
  popd
done

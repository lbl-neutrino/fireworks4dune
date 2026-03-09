#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit

for d in mpvmpr_gigacube mpvmpr_ndlar nu_ndlar mpvmpr_2x2; do
  pushd $d || exit
  for f in *.jinja2; do minijinja-cli "$f" > "$(basename "$f" .jinja2)"; done
  popd || exit
done

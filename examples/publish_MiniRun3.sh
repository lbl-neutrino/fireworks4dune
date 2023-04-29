#!/usr/bin/env bash

name=MiniRun3_1E19_RHC

indir=/global/cfs/cdirs/dune/users/mkramer/mywork/2x2_sim
outdir=/global/cfs/cdirs/dune/www/data/2x2/simulation/productions/MiniRun3_1E19_RHC

mkdir -p $outdir

# or mv and ln -s this stuff?

# cp -r $indir/run-spill-build/output/${name}.spill $outdir
# cp -r $indir/run-larnd-sim/output/${name}.larnd.localSpillID $outdir
# cp -r $indir/run-ndlar-flow/output/${name}.larnd.localSpillID $outdir

move_and_link() {
    basedir=$1; shift
    suffix=$1; shift

    mv $indir/${basedir}/output/${name}.${suffix} $outdir
    ln -s $(realpath $outdir/${name}.${suffix}) $indir/${basedir}/output
}

# move_and_link run-spill-build spill
move_and_link run-larnd-sim larnd
move_and_link run-ndlar-flow flow
move_and_link validation plots
move_and_link run-convert2h5 convert2h5.withMinerva

chmod -R a+rX $outdir

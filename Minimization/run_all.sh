#!/bin/bash
#SBATCH --job-name=min
#SBATCH --output=min.out
#SBATCH --error=min.err
#SBATCH --time=24:00:00
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8

module load namd/2.13

#NCORES=$(expr $TOTAL_CORES - $NUM_GPU)
NCORES=8

for ab in 1E9 8G5; do
    cd $ab
    for sys in $(ls -d */); do
        cd $sys
        namd2 +p${NCORES} namd.conf > min.log
        cd ..
    done
    cd ..
done

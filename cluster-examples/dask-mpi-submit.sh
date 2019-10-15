#!/bin/bash
#SBATCH --account=cc-debug
#SBATCH --time=00:15:00
#SBATCH --tasks=8
#SBATCH --mem-per-cpu=4000M

source ~/virtualenv/dask/bin/activate

time srun python dask-mpi.py

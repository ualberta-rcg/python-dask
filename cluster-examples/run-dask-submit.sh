#!/bin/bash
#SBATCH --account=cc-debug
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem-per-cpu=1024M

export NUM_WORKERS=8
export THREADS_PER_WORKER=1
export MEM_PER_WORKER=256mb

# This file (created by the scheduler) communicates Dask network
# information between the scheduler, workers and the client program
export SCHEDULER_FILE=${SLURM_JOB_ID}-scheduler.json

source ~/virtualenv/dask/bin/activate

# Start a scheduler and wait for it to spin up
dask-scheduler --host 127.0.0.1 \
               --no-dashboard \
               --scheduler-file $SCHEDULER_FILE &
sleep 15

# Start a bunch of workers connected to the scheduler and wait
for worker in `seq $NUM_WORKERS`
do
dask-worker --scheduler-file $SCHEDULER_FILE \
            --no-dashboard \
            --no-nanny \
            --nprocs 1 \
            --nthreads $THREADS_PER_WORKER \
            --memory-limit $MEM_PER_WORKER &
done
sleep 15

# Run python script calling featuretools
time python run-dask.py

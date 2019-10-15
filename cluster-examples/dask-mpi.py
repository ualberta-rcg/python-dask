from dask_mpi import initialize
initialize()

from dask.distributed import Client
from dask import delayed

import os
import time
import socket

def whats_my_number(num):
    out ='The number on host ' + socket.gethostname() + ' is ' + str(num)
    time.sleep(2)
    return out

def report_results(results):
    out = 'Joining on host ' + socket.gethostname() + '\n'
    out += '\n'.join(results)
    return out

# How many seconds since start?
def elapsed(start):
    return str(time.time() - start) + ' seconds'

# Connect to the Dask network
scheduler_file = os.environ['SCHEDULER_FILE']
client = Client()

# Create the task graph
# 8 delayed calls to what's my number,
# Assemble output report

data = [1, 2, 3, 4, 5, 6, 7, 8]
results = []
for num in data:
    out = delayed(whats_my_number)(num)
    results.append(out)

report = delayed(report_results)(results)

# Run it
time1 = time.time()
result = report.compute()
print('Time to compute in seconds:', elapsed(time1))
print('\nResult:')
print(result)

print(client)

How Job Priority Is Calculated
##############################

When there are more jobs than free resources, Slurm starts the highest-priority jobs first. Each pending job's
priority is a weighted sum of these factors:

- **Fair share**: based on how much your project has used compared with its share. Projects that have used less
  get higher priority.
- **Job age**: jobs gain priority the longer they wait in the queue.
- **Job size**: a factor based on the size of the request.
- **QoS**: some allocations carry a priority boost through their QoS.

Slurm also **backfills**: a lower-priority job can start early if it fits into a gap without delaying
higher-priority jobs. Accurate ``--time`` requests make backfill work better for everyone.

Checking Priority
*****************

.. code-block:: console

   sprio -j <job_id>
   sprio -u $USER

- **PRIORITY**: the final score. Higher runs sooner.
- **AGE**, **FAIRSHARE**, **JOBSIZE**, **QOS**: each factor's weighted contribution.

``squeue --me --start`` shows Slurm's estimate of when your pending jobs will start.

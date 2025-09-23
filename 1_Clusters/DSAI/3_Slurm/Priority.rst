How Job Priority is Calculated
###############################

DSAI uses a multi-factor job priority system to determine which jobs run first. These factors work together to ensure equitable access while keeping the cluster as busy and efficient as possible. Understanding these can help users predict queue behavior and optimize job placement.

Slurm evaluates each pending job with a weighted formula combining the following components:

- **Fairshare**: Groups that have recently used less of their allocation get higher priority, and those that have consumed more see lower scores - based on the last 30 days of usage. This promotes equitable access.
- **Job Age**: Jobs gain priority the longer they wait in the queue.
- **Job Size**: Smaller jobs receive a small boost, particularly to improve backfilling opportunities — the ability for the scheduler to fit small jobs into idle gaps in hardware.

To inspect job priority components, use the `sprio` command:

.. code-block:: bash

   sprio -j <jobid>
   sprio -u <user>

   [root ~]$ sprio
            JOBID PARTITION   PRIORITY       SITE        AGE  FAIRSHARE    JOBSIZE
            100001 cpu              159          0        125          0         34
            100002 cpu              132          0         98          0         34
            100003 a100              36          0         15          0         22
            100004 nvl               37          0         15          0         23
            100005 h100              37          0         15          0         23
            100006 a100              40          0         12          0         29
            100007 h100              42          0         11          0         31
            100008 h100              41          0         10          0         31
            100009 h100              36          0          5          0         31
            100010 h100              31          0          0          0         31

- **PRIORITY**: Final computed score — higher numbers mean higher placement in the queue.
- **AGE**: Normalized value that reflects time in queue. Increases continuously until the job starts.
- **FAIRSHARE**: Normalized score based on your group's recent usage. Higher = better.
- **JOBSIZE**: Reflects node/core/memory request — used in backfilling calculations.
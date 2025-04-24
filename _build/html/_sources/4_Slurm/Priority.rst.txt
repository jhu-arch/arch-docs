Priority and Usage Calculation
##############################

Rockfish uses a multi-factor job priority system to determine which jobs run first. These factors work together to ensure equitable access while keeping the cluster as busy and efficient as possible. Understanding these can help users predict queue behavior and optimize job placement.

How Job Priority is Calculated
==============================

Slurm evaluates each pending job with a weighted formula combining the following components:

- **Fairshare**: Each PI or group is assigned a share based on their quarterly allocation (in core hours). Slurm tracks usage over time and adjusts each group's priority relative to their share. Groups that have recently used less of their allocation get higher priority, and those that have consumed more see lower scores. This promotes equitable access.
- **Job Age**: Jobs gain priority the longer they wait in the queue.
- **Job Size**: Smaller jobs receive a small boost, particularly to improve backfilling opportunities — the ability for the scheduler to fit small jobs into idle gaps in hardware.
- **Partition and QOS Priority**: Some partitions or QOS configurations may be assigned static priority tiers or usage caps.

To inspect job priority components, use the `sprio` command:

.. code-block:: bash

   sprio -j <jobid>
   sprio -u <user>

   [root@login01 ~]# sprio -u user123
             JOBID PARTITION     USER   PRIORITY       SITE        AGE  FAIRSHARE    JOBSIZE  PARTITION        QOS
            111111 parallel   user123      21904          0       1423        489      19990          1          0
            111112 parallel   user123      21904          0       1423        489      19990          1          0
            111113 parallel   user123      21904          0       1423        489      19990          1          0

- **PRIORITY**: Final computed score — higher numbers mean higher placement in the queue.
- **AGE**: Time in queue (in minutes). Increases continuously until the job starts.
- **FAIRSHARE**: Normalized score based on your group's recent usage. Higher = better.
- **JOBSIZE**: Reflects node/core/memory request — used in backfilling calculations.
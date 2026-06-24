How Job Priority is Calculated
###############################

SkipJack uses a multi-factor job priority system to determine which jobs run first. These factors work together to ensure equitable access while keeping the cluster as busy and efficient as possible. Understanding these can help users predict queue behavior and optimize job placement.

Slurm evaluates each pending job with a weighted formula combining the following components:

- **Fairshare**: Groups that have recently used less of their allocation get higher priority, and those that have consumed more see lower scores - based on **TODO**: Add fairshare window (e.g., "the last 30 days" or whatever SkipJack uses) of usage. This promotes equitable access.
- **Job Age**: Jobs gain priority the longer they wait in the queue.
- **Job Size**: Smaller jobs receive a small boost, particularly to improve backfilling opportunities - the ability for the scheduler to fit small jobs into idle gaps in hardware.

To inspect job priority components, use the `sprio` command:

.. code-block:: bash

   sprio -j <jobid>
   sprio -u <user>

- **PRIORITY**: Final computed score - higher numbers mean higher placement in the queue.
- **AGE**: Normalized value that reflects time in queue. Increases continuously until the job starts.
- **FAIRSHARE**: Normalized score based on your group's recent usage. Higher = better.
- **JOBSIZE**: Reflects node/core/memory request - used in backfilling calculations.

**TODO**: Add skipjack-specific sprio example output or any additional priority factors (e.g., QoS, account weighting).

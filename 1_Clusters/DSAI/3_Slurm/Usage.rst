Checking Resource Usage & Billing
=================================

DSAI charges jobs in **core-hours**.  A core-hour is one CPU-core used for
one hour — or the equivalent, when GPUs are involved.

Core-only partitions
--------------------

The classic formula is:

.. code-block:: text

   Core-hours =   Allocated CPU cores   ×   Wall-time (h)

Examples:

* 1-hour job using 16 cores → 16 core-h
* 6-hour job using 4 cores  → 24 core-h

To inspect the actual billing for a finished/active job:

.. code-block:: bash

   sacct -j <jobid> --format=JobID,User,Partition,State,Elapsed,CPUTime,NCPUS,AllocTRES

Viewing Allocation Usage with ``sbalance``
------------------------------------------

To view usage for a Slurm Allocation over the course of a billing quarter, use the ``sbalance`` tool. For example:

.. code-block:: bash

   sbalance

   The time of this report is: Fri May 09 11:42:39 2025

   Start Date: 2025-04-01T00:00:00 End Date: 2025-06-30T00:00:00
                                             Used          Account
                  Account        User   (core-hours) /    Allocated )
   ====================================================================
                 pi               870000.0 /      900000.0
   ....................................................................
                                  user01            250000.0
                                  user02             50000.0
                                  user03            100000.0
                                  user04             75000.0
                                  user05             40000.0
                                  user06             30000.0
                                  user07             20000.0
                                  user08             15000.0
                                  user09             10000.0
                                  user10             25000.0
                                  user11             35000.0
                                  user12             50000.0
                                  user13             60000.0
                                  user14             10000.0
                                  user15             10000.0

Use ``--usage`` to include a usage percentage column:

.. code-block:: bash

   sbalance --usage

This will show the same table, but with each user's percent of the allocation.

You can also use ``--hide-zero`` to omit users who have not yet used any core-hours.

GPU partitions
--------------

GPU nodes are billed at a rate of: **(GPUs requested * Billed Cores / Node) * Walltime**.  

The ratio of "Billed Cores / GPU" comes from the number of available cores and GPUs on the node. For example, in the A100 partition, each node has 4 GPUs and 48 CPU cores, so the ratio is 12.

.. list-table::
   :header-rows: 1
   :widths: 20 15 25

   * - **Partition**
     - **GPUs / node**
     - **Billed cores / GPU**
   * - ``l40s``
     - 8 × l40s 48GB
     - 16
   * - ``a100``
     - 8 × A100 80GB
     - 12
   * - ``h100``
     - 4 x H100 80GB
     - 32
   * - ``nvl``
     - 4 × H100-NVL 96GB
     - 32

**Billing formula**

.. code-block:: text

   Core-hours = ( GPUs × billed-cores/GPU ) × Wall-time(h)

**Example for a100 partition:**

2xA100 GPUs for 3 hours → (2 × 12) × 3 = 72 core-hours

Viewing Historical Usage and Efficiency
----------------------------------------

For more on viewing efficiency and job usage statistics, refer to the page:

:doc:`Job_Status`

This includes guidance on using:

- `sacct` for historical usage
- `seff` and `reportseff` for job efficiency
- `jobstats` for GPU and memory metrics
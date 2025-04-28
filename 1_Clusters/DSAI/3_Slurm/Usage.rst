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
=======================================

For more on viewing efficiency and job usage statistics, refer to the page:

:doc:`Job_Status`

This includes guidance on using:

- `sacct` for historical usage
- `seff` and `reportseff` for job efficiency
- `jobstats` for GPU and memory metrics
Checking Resource Usage & Billing
=================================

Rockfish charges jobs in **core-hours**.  A core-hour is one CPU-core used for
one hour — or the equivalent, when GPUs or very large memory requests are
involved.

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
   * - ``v100``
     - 4 × V100
     - 12
   * - ``a100``
     - 4 × A100
     - 12
   * - ``l40s``
     - 8 × L40S
     - 8
   * - ``ica100``
     - 4 × A100
     - 16
   * - ``mig_class``
     - 12 × A100-MIG (2g.20gb)
     - 5 (per slice)

**Billing formula**

.. code-block:: text

   Core-hours = ( GPUs × billed-cores/GPU ) × Wall-time(h)

**Example for a100 parttion:**

2xA100 GPUs for 3 hours → (2 × 12) × 3 = 72 core-hours

Bigmem partition
-----------------

On ``bigmem`` jobs are billed on the **largest of (CPU cores) or (memory/32 GiB)**,
because each core is paired with 32 GiB of RAM:

.. code-block:: text

   Effective cores = max( requested CPUs ,
                          requested memory (GiB) / 32 )

   Core-hours      = Effective cores × Wall-time(h)

**Example for bigmem partition:**  

400 GiB Memory for 4 hours → (400/32) * 4 = 50 core-hours

----------------------------------

Viewing Historical Usage and Efficiency
=======================================

For more on viewing efficiency and job usage statistics, refer to the page:

:doc:`Job_Status`

This includes guidance on using:

- `sacct` for historical usage
- `seff` and `reportseff` for job efficiency
- `jobstats` for GPU and memory metrics
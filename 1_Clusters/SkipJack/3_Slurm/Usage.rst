Checking Resource Usage & Billing
=================================

SkipJack charges jobs in **core-hours**.  A core-hour is one CPU-core used for one hour - or the equivalent, when GPUs or very large memory requests are involved.

Core-only partitions
--------------------

The classic formula is:

.. code-block:: text

   Core-hours =   Allocated CPU cores   x   Wall-time (h)

Examples:

- 1-hour job using 16 cores    →    16 core-h
- 6-hour job using 4 cores     →    24 core-h

To inspect the actual billing for a finished/active job:

.. code-block:: bash

   sacct -j <jobid> --format=JobID,User,Partition,State,Elapsed,CPUTime,NCPUS,AllocTRES

Viewing Allocation Usage with ``sbalance``
------------------------------------------

**TODO**: Confirm sbalance is available on SkipJack or replace with appropriate tool.

To view usage for a Slurm Allocation over the course of a billing quarter, use the ``sbalance`` tool:

.. code-block:: bash

   sbalance

Use ``--usage`` to include a usage percentage column:

.. code-block:: bash

   sbalance --usage

You can also use ``--hide-zero`` to omit users who have not yet used any core-hours.

GPU partitions
--------------

GPU nodes are billed at a rate of: **(GPUs requested * Billed Cores / Node) * Walltime**.  

The ratio of "Billed Cores / GPU" comes from the number of available cores and GPUs on the node.

.. list-table::
   :header-rows: 1
   :widths: 20 15 25

   * - **Partition**
     - **GPUs / node**
     - **Billed cores / GPU**
   * - **TODO**: Add billing ratio rows for each GPU partition

**Billing formula**

.. code-block:: text

   Core-hours = ( GPUs x billed-cores/GPU ) x Wall-time(h)

**Example**: **TODO**: Add example calculation with actual SkipJack numbers

Bigmem partition
-----------------

**TODO**: Add bigmem billing info if applicable, or remove this section.

Viewing Historical Usage and Efficiency
=======================================

For more on viewing efficiency and job usage statistics, refer to the page:

:doc:`Job_Status`

This includes guidance on using:

- `sacct` for historical usage
- `seff` and `reportseff` for job efficiency
- `jobstats` for GPU and memory metrics

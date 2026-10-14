Checking Your Job's Efficiency with jobstats
============================================

``jobstats`` shows how much of what you requested a job actually used: CPU cores, CPU memory, GPUs and GPU memory.
Run it after a job finishes and use the numbers to size your next request.

.. contents:: On this page
   :local:
   :depth: 1

Running jobstats
----------------

From a Skipjack login node:

.. code-block:: bash

   jobstats 1234567

.. important::
   From the login nodes, ``jobstats`` reports **finished jobs only**. Its summary is saved when the job ends;
   for a job that is still running, check back after it completes.

To find the IDs of your recent jobs:

.. code-block:: bash

   sacct -X -S now-7days -o JobID,JobName%20,Partition,State,Elapsed,AllocCPUS,ReqMem

.. note::
   Utilization is sampled every 30 seconds while the job runs, so jobs shorter than about a minute have
   little or no data.

Example
-------

A GPU job that asked for 12 cores, 64 GB of memory and one A100, and used very little of it:

.. code-block:: text

   ================================================================================
                                 Slurm Job Statistics
   ================================================================================
            Job ID: 1234567
      User/Account: jdoe1/pi_lab
          Job Name: train
             State: COMPLETED
             Nodes: 1
         CPU Cores: 12
        CPU Memory: 64GB (5.3GB per CPU-core)
              GPUs: 1
     QOS/Partition: jhu/a100
           Cluster: skipjack
        Start Time: Wed Oct 7, 2026 at 10:34 AM
          Run Time: 02:33:42
        Time Limit: 12:00:00

                                 Overall Utilization
   ================================================================================
     CPU utilization  [                                                1%]
     CPU memory usage [                                                1%]
     GPU utilization  [|||                                             6%]
     GPU memory usage [||||||||||||||||||||||||||||                   56%]

                                 Detailed Utilization
   ================================================================================
     CPU utilization per node (CPU time used/run time)
         ga134: 00:14:42/1-06:44:24 (efficiency=0.8%)

     CPU memory usage per node - used/allocated
         ga134: 447.0MB/64GB (37.2MB/5.3GB per core of 12)

     GPU utilization per node
         ga134 (GPU 6): 5.5%

     GPU memory usage per node - maximum used/total
         ga134 (GPU 6): 45.2GB/80GB (56.5%)

                                        Notes
   ================================================================================
     * The overall GPU utilization of this job is only 6%. ...

Reading the output
------------------

**CPU utilization**
   CPU time the job used, divided by *cores × run time*. A job that keeps all its cores busy shows 100%.
   Above, 12 cores for 2.5 hours could have done 30 hours of CPU work; the job did 15 minutes (0.8%).
   For CPU jobs, aim for **80% or more**. For GPU jobs, the CPU cores mostly feed the GPU, so low CPU
   utilization is normal, but the job should not request many more cores than it uses.
   See :doc:`CPU_Utilization`.

**CPU memory usage**
   The **peak** memory the job used, against what it requested. Above: 447 MB of 64 GB. A good request is the
   peak plus about 20%. See :doc:`CPU_Memory`.

**GPU utilization**
   The share of time the GPU was busy running your code, averaged over the job. Aim for as high as possible;
   below about 50% usually means the GPU is waiting on data loading, the CPU, or I/O. In the example (6%)
   the GPU sat idle for most of the 2.5 hours. See :doc:`GPU_Computing`.

**GPU memory usage**
   Peak GPU memory used, against the GPU's total. If a job uses a small fraction of a large GPU, a smaller GPU
   (or a MIG slice on ``interactive_gpu``) would do and usually starts sooner.

**Notes**
   ``jobstats`` adds suggestions at the bottom when something stands out (low utilization, too much memory
   requested, a GPU sitting idle, and so on), with links to the relevant page here.

What to do with the numbers
---------------------------

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - **If you see**
     - **Try**
   * - Low CPU utilization on a CPU job
     - Request fewer cores (``--cpus-per-task`` / ``--ntasks``), or make sure your code actually uses them
       (threads, MPI ranks, ``multiprocessing``). :doc:`CPU_Utilization`
   * - Memory used far below memory requested
     - Lower ``--mem`` / ``--mem-per-cpu`` to the peak + 20%. :doc:`CPU_Memory`
   * - Job ended with ``OUT_OF_MEMORY``
     - Raise the memory request; check the peak of a smaller test run first. :doc:`CPU_Memory`
   * - Low GPU utilization
     - Profile the job; common fixes are more data-loader workers, larger batches, and keeping data on fast
       storage. :doc:`GPU_Computing`
   * - GPU memory well below the GPU's size
     - Use a smaller GPU type or a MIG slice (``--partition=interactive_gpu --gres=gpu:2g.20gb:1``) for
       development and short jobs.
   * - Run time far below the time limit
     - Lower ``--time``: shorter requests fit into gaps in the schedule (backfill) and often start sooner.

Other tools
-----------

``seff <jobid>`` gives a short CPU and memory summary (no GPU information). ``sacct -j <jobid>
-o JobID,Elapsed,MaxRSS,TotalCPU,State`` shows the raw accounting data.

Questions? Email `arch@jhu.edu <mailto:arch@jhu.edu>`__ with the job ID.

.. rst-class:: source-credit

Adapted from Princeton Research Computing documentation.

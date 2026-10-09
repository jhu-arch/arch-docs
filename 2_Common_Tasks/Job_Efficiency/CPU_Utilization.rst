Using the CPU Cores You Request
===============================

**CPU utilization** (or *CPU efficiency*) is how busy the cores you requested actually were:

.. code-block:: text

   CPU utilization = CPU time used / (cores requested × run time)

A job that requests 8 cores for 10 hours has 80 core-hours to use. If it uses 10, its utilization is 12.5%,
and the other 70 core-hours sat idle while other jobs waited. For CPU jobs, aim for **80% or more**. Check any
job with ``jobstats <jobid>`` (see :doc:`Jobstats`).

.. contents:: On this page
   :local:
   :depth: 1

Why utilization is low
----------------------

**The code only uses one core.**
   Most scripts (Python, R, MATLAB without the Parallel Computing Toolbox, most compiled programs) run on a single
   core unless they are written to do otherwise. Asking for more cores does not make them faster. Request
   ``--cpus-per-task=1``.

**The code can use several cores, but isn't told how many.**
   Many libraries pick a thread count themselves, or use only one by default. Tell them what Slurm gave you:

   .. code-block:: bash

      #SBATCH --cpus-per-task=8
      export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK       # OpenMP, NumPy/SciPy (MKL, OpenBLAS)
      export MKL_NUM_THREADS=$SLURM_CPUS_PER_TASK

   In Python, ``os.cpu_count()`` and ``multiprocessing.cpu_count()`` return **all the cores on the node**, not
   the ones you were given. Use ``len(os.sched_getaffinity(0))`` or ``int(os.environ["SLURM_CPUS_PER_TASK"])``
   to size a ``multiprocessing.Pool``. In R, use ``as.integer(Sys.getenv("SLURM_CPUS_PER_TASK"))`` instead of
   ``parallel::detectCores()``.

**Tasks vs cores.**
   ``--ntasks`` is for MPI programs (separate processes started with ``srun``); ``--cpus-per-task`` is for
   threads within one process. A threaded program given ``--ntasks=8`` runs as one process on one core.

**The job waits on something else.**
   Reading or writing a lot of small files, downloading data, or waiting for a GPU keeps cores idle. For GPU jobs,
   some idle CPU is normal; just don't request many more cores than the data loading needs.

**Interactive sessions left open.**
   An ``salloc`` / Open OnDemand session that sits idle counts as allocated the whole time. End sessions when you
   are done, and use ``interactive_cpu`` (4 hours max) for short interactive work.

Finding the right number of cores
---------------------------------

More cores only help up to a point. Before running many large jobs, do a quick **scaling test**: run the same
(short) input with 1, 2, 4, 8 and 16 cores and note the run time.

.. list-table::
   :header-rows: 1
   :widths: 20 25 25 30

   * - **Cores**
     - **Run time**
     - **Speed-up**
     - **Efficiency**
   * - 1
     - 64 min
     - 1.0×
     - 100%
   * - 2
     - 33 min
     - 1.9×
     - 97%
   * - 4
     - 18 min
     - 3.6×
     - 89%
   * - 8
     - 11 min
     - 5.8×
     - 73%
   * - 16
     - 9 min
     - 7.1×
     - 44%

*Speed-up* = time on 1 core / time on N cores; *efficiency* = speed-up / N. In this example 4 cores is the sweet
spot; 16 cores is barely faster than 8 and wastes over half of what it asks for. Pick the largest core count
where efficiency stays above roughly 70-80%.

.. tip::
   Many small single-core jobs (one per input file, for example) are usually more efficient than one job with many
   cores. Use a job array: ``#SBATCH --array=1-100``. See :doc:`/3_Tutorials/workflows/Tutorial_Parallel`.

Examples
--------

Single-core job:

.. code-block:: bash

   #!/bin/bash
   #SBATCH --partition=med
   #SBATCH --cpus-per-task=1
   #SBATCH --mem=4G
   #SBATCH --time=02:00:00

   python analyze.py input.csv

Multithreaded job (8 threads):

.. code-block:: bash

   #!/bin/bash
   #SBATCH --partition=med
   #SBATCH --cpus-per-task=8
   #SBATCH --mem=16G
   #SBATCH --time=04:00:00

   export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
   ./simulate --threads $SLURM_CPUS_PER_TASK

MPI job (2 nodes, 64 ranks):

.. code-block:: bash

   #!/bin/bash
   #SBATCH --partition=med
   #SBATCH --nodes=2
   #SBATCH --ntasks-per-node=32
   #SBATCH --mem-per-cpu=3G
   #SBATCH --time=12:00:00

   srun ./mpi_program

Questions? Email `arch@jhu.edu <mailto:arch@jhu.edu>`__ with a job ID.

.. rst-class:: source-credit

Adapted from Princeton Research Computing documentation.

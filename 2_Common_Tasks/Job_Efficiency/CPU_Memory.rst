How Much CPU Memory to Request
==============================

Every Skipjack job gets a fixed amount of CPU memory (RAM). Ask for too little and Slurm kills the job when it
runs out; ask for far too much and the job waits longer to start and blocks memory other jobs could use.
The goal: **the job's peak memory plus about 20%**.

.. contents:: On this page
   :local:
   :depth: 1

Defaults on Skipjack
--------------------

If you don't ask for memory, each core you request comes with the partition's default amount. On Skipjack the
default is also the **maximum per core**:

.. list-table::
   :header-rows: 1
   :widths: 22 20 20 38

   * - **Partition**
     - **Memory per core**
     - **Max cores per node**
     - **Default per GPU (cores / memory)**
   * - ``med``
     - 4,000 MB
     - 108
     - (CPU only)
   * - ``agentic``, ``interactive_cpu``
     - 2,000 MB
     - 216
     - (CPU only)
   * - ``interactive_gpu``
     - 2,000 MB
     - 88
     - 3 cores / 6 GB per MIG slice
   * - ``a100``
     - 6,000 MB
     - 88
     - 10 cores / 60 GB
   * - ``l40s``
     - 6,000 MB
     - 124
     - 14 cores / 84 GB
   * - ``rtx6000``
     - 8,000 MB
     - 124
     - 15 cores / 120 GB
   * - ``h100``, ``h200``
     - 12,000 MB
     - 124
     - 30 cores / 360 GB
   * - ``b200``, ``b300``
     - 12,000 MB
     - 124
     - 15 cores / 180 GB

.. important::
   Because the default is also the maximum, **memory and cores are tied together**. If you ask for more memory
   than your cores come with, Slurm gives the job more cores to match (and they count against your
   allocation). For example, on ``med`` (4,000 MB per core) a job with ``--cpus-per-task=1 --mem=40G`` gets
   **11 cores**: 40 GB needs 10.24 cores' worth of memory, rounded up.
   If your job needs a lot of memory but few cores, that's expected; just don't ask for more memory than it
   needs.

Asking for memory
-----------------

Use **one** of these in your job script:

.. code-block:: bash

   #SBATCH --mem=16G            # memory per node (most jobs)
   #SBATCH --mem-per-cpu=3G     # memory per core (MPI jobs whose rank count varies)

For GPU jobs you can also use ``--mem-per-gpu``. If you set nothing, you get the defaults above.

Finding out what your job needs
-------------------------------

1. **Run a short test** with a generous request, for example ``--mem=32G``, on a representative input.
2. **Check the peak** after it finishes:

   .. code-block:: bash

      jobstats 1234567       # "CPU memory usage per node - used/allocated"
      seff 1234567           # "Memory Utilized"

3. **Set the request** to that peak plus about 20%. If your input sizes vary, size for the largest.

.. tip::
   Memory use usually grows with input size. If you scale up (more data, a bigger model), repeat the test
   rather than guessing.

When a job runs out of memory
-----------------------------

The job ends with state ``OUT_OF_MEMORY``, and the output file usually shows a line like:

.. code-block:: text

   slurmstepd: error: Detected 1 oom_kill event in StepId=1234567.batch. Some of your processes may have been killed by the cgroup out-of-memory handler.

To fix it:

* Raise ``--mem`` (check ``jobstats`` or ``seff`` for how close the job got).
* If one process loads everything into memory (a whole dataset, a large matrix), consider processing the data in
  chunks.
* Python: watch for copies of large arrays (``df.copy()``, list comprehensions over big data) and for
  ``multiprocessing`` workers that each load their own copy of the data.

How much is too much?
---------------------

``jobstats`` flags jobs that use well under what they asked for. As a rough guide:

* **Used under half** of the request: lower it next time.
* **Used 80-95%**: about right.
* **Used 100% / OUT_OF_MEMORY**: raise it.

The most memory a job can get on one node is *max cores per node × memory per core*: about 430 GB on ``med``
and ``agentic``, 530 GB on ``a100``, 740 GB on ``l40s``, 990 GB on ``rtx6000`` and 1.5 TB on
``h100``/``h200``/``b200``/``b300``. Jobs that need more than one node's memory must be written to use several
nodes (e.g. MPI). Email `arch@jhu.edu <mailto:arch@jhu.edu>`__ if you're unsure.

.. rst-class:: source-credit

Adapted from Princeton Research Computing documentation.

Submitting Jobs
###############

All compute work on Skipjack runs through Slurm. Login nodes are for editing files, submitting jobs and checking
output; do not run compute-heavy processes on them.

Overview of Job Types
*********************

- **Batch jobs**: non-interactive jobs submitted with ``sbatch``.
- **Interactive jobs**: a live shell on a compute node, started with ``srun --pty`` (or through
  :doc:`Open OnDemand </1_Clusters/Skipjack/ood>`).
- **Job arrays**: many related jobs from one script, using ``--array``.

Basic Commands
**************

Submit a batch script:

.. code-block:: console

   sbatch my_script.sh

Show your jobs:

.. code-block:: console

   squeue --me

Cancel a job:

.. code-block:: console

   scancel <job_id>

Example Batch Script
********************

.. code-block:: bash

   #!/bin/bash
   #SBATCH --job-name=my_job
   #SBATCH --account=<account>
   #SBATCH --partition=med
   #SBATCH --time=12:00:00
   #SBATCH --nodes=1
   #SBATCH --ntasks=1
   #SBATCH --cpus-per-task=8
   #SBATCH --mem-per-cpu=4G
   #SBATCH --output=%x_%j.out

   module load <software>
   srun ./my_program

- ``--account``: the Slurm account of the project you are working under. List yours with
  ``sacctmgr show assoc user=$USER format=account%30``.
- ``--time``: request close to what the job needs. Shorter requests can start sooner (backfill). If you leave it
  out, most partitions give a 12-hour default; the maximum is 72 hours on most partitions (see
  :doc:`Partitions`).
- ``--mem-per-cpu`` / ``--mem``: if you leave them out you get the partition's default memory per core.

Cost Confirmation
*****************

When you submit a job, Skipjack may show an estimated cost and ask you to confirm (``[BILLING] ... Proceed? [y/N]``).
Scripts and tools that submit jobs without a terminal (workflow managers, Open OnDemand-style launchers, CryoSPARC)
cannot answer the prompt; add this line to their job scripts:

.. code-block:: bash

   #SBATCH --comment=accept_cost

Interactive Jobs
****************

CPU session on the ``interactive_cpu`` partition (4-hour limit):

.. code-block:: console

   srun -p interactive_cpu -t 02:00:00 -c 4 --pty bash

GPU session on a 20 GB A100 MIG slice:

.. code-block:: console

   srun -p interactive_gpu -t 02:00:00 --gres=gpu:2g.20gb:1 --pty bash

Interactive sessions on other partitions work the same way; add ``-A <account>`` if you belong to more than one
project.

Job Arrays
**********

.. code-block:: bash

   #SBATCH --array=1-100%10      # 100 tasks, at most 10 running at once

   ./my_program input_${SLURM_ARRAY_TASK_ID}.dat

Prefer an array over submitting hundreds of separate jobs; it is much lighter on the scheduler.

Slurm Environment Variables
***************************

.. list-table::
   :header-rows: 1
   :widths: 30 40

   * - Variable
     - Description
   * - ``$SLURM_JOB_ID``
     - Unique ID of the current job
   * - ``$SLURM_JOB_NODELIST``
     - Nodes assigned to the job
   * - ``$SLURM_ARRAY_TASK_ID``
     - Task index for array jobs
   * - ``$SLURM_CPUS_PER_TASK``
     - Cores per task
   * - ``$SLURM_SUBMIT_DIR``
     - Directory where the job was submitted

Output File Routing
*******************

.. code-block:: bash

   #SBATCH -o logs/%x_%j.out
   #SBATCH -e logs/%x_%j.err

Where ``%j`` is the job ID and ``%x`` the job name. The ``logs`` directory must exist before the job starts.

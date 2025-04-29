Job Scheduling with Slurm
#########################

The DSAI Cluster uses **Slurm (Simple Linux Universal Resource Manager)** to manage job submission, scheduling, and resource allocation. It is a widely adopted, open-source workload manager used by many HPC centers.

All jobs must be submitted through Slurm — running compute-heavy processes directly on login nodes is not permitted

Overview of Job Types
*********************

- **Batch Jobs**: Standard non-interactive jobs submitted with `sbatch`.
- **Interactive Jobs**: Allocate compute resources for a live terminal session using `interact`.
- **Job Arrays**: Submit a group of related jobs with a single script using `--array`.


Basic Job Submission
*********************

Submit a batch script:

.. code-block:: console

   sbatch my_script.sh

Cancel a job:

.. code-block:: console

   scancel <job_id>

Display your jobs:

.. code-block:: console

   sqme

Example Batch Script
*********************

You can view some example batch scripts here: :doc:`Example_Sbatch`. 

Here’s a simple example:

.. code-block:: bash

   #!/bin/bash
   #SBATCH --job-name=MyJob
   #SBATCH --time=24:00:00
   #SBATCH --partition=$PARTITION
   #SBATCH --nodes=1
   #SBATCH --ntasks-per-node=24
   #SBATCH --mail-type=end
   #SBATCH --mail-user=userid@jhu.edu

   module load intel/2020.2 intel-mpi/2020.2
   mpirun -n $SLURM_NTASKS ./my_program.x > output.log

Interactive Jobs
****************

Use `interact` to request a live session on compute nodes:

.. code-block:: console

   interact -p parallel -n 4 -t 01:00:00

GPU interactive job:

.. code-block:: console

   interact -p a100 -g 1 -n 6 -t 02:00:00

See all interact options:

.. code-block:: console

   interact --usage

Slurm Environment Variables
****************************

.. list-table::
   :header-rows: 1
   :widths: 30 40

   * - Variable
     - Description
   * - `$SLURM_JOBID`
     - Unique ID of the current job
   * - `$SLURM_JOB_NODELIST`
     - Nodes assigned to the job
   * - `$SLURM_ARRAY_TASK_ID`
     - Task index for array jobs
   * - `$SLURM_CPUS_PER_TASK`
     - Cores per task
   * - `$SLURM_SUBMIT_DIR`
     - Directory where job was submitted


Output File Routing
********************

Customize standard output and error paths:

.. code-block:: bash

   #SBATCH -o /home/userid/logs/%j_%x.out
   #SBATCH -e /home/userid/logs/%j_%x.err

Where:

- `%j`: Job ID
- `%x`: Job name
Example Batch Scripts
######################

When submitting a job with `sbatch`, you should specify the resources your job requires using the options below. These flags determine how many nodes, CPUs, memory, and other resources Slurm will reserve for your job. Properly requesting resources ensures that your job runs efficiently and is scheduled appropriately. Include these options at the top of your Slurm batch script as `#SBATCH` directives.

Basic Example
*************

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

OpenMP Job Script
*****************

.. code-block:: bash

   #!/bin/bash -l
   #SBATCH --job-name=OpenMP-Job
   #SBATCH --output=myLog-file
   #SBATCH --partition=$PARTITION
   #SBATCH --time=00-01:30:15
   #SBATCH --nodes=1
   #SBATCH --ntasks-per-node=8
   #SBATCH --account=$SLURM_ACCOUNT
   #SBATCH --export=ALL

   ml purge
   ml intel intel-mpi intel-mkl
   export OMP_NUM_THREADS=8
   time ./a.out > MyOutput.log

Hybrid MPI + OpenMP Job Script
******************************

.. code-block:: bash

   #!/bin/bash -l
   #SBATCH --job-name=MyLMJob
   #SBATCH --output=myLog-file
   #SBATCH --partition=$PARTITION
   #SBATCH --time=02-01:30:15
   #SBATCH --nodes=1
   #SBATCH --ntasks-per-node=8
   #SBATCH --cpus-per-task=6
   #SBATCH --account=$SLURM_ACCOUNT
   #SBATCH --export=ALL

   ml gcc openmpi
   module load hwloc
   export CUDA_AUTO_BOOST=1
   mpirun -np 8 ./my_program

**TODO**: Add SkipJack-specific example scripts with actual partition names, accounts, and module loads.

GPU Job Script
**************

.. code-block:: bash

   #SBATCH --partition=TODO: Add GPU partition name
   #SBATCH --qos=TODO: Add QoS name for GPU jobs
   #SBATCH --account=TODO: Add account format/pattern
   #SBATCH --gres=gpu:N   # N = number of GPUs requested
   #SBATCH --time=24:00:00

   module load cuda/TODO: Add CUDA version
   srun python train.py

Job Array Script
****************

Job arrays are useful for submitting many similar jobs at once, such as parameter sweeps or batch processing with different input files.

.. code-block:: console

   sbatch --array=0-15%4 script.sh

Within your job script, you can use several environment variables:

- ``$SLURM_ARRAY_JOB_ID``: The master job ID (same for all array tasks)
- ``$SLURM_ARRAY_TASK_ID``: The index of the current array task (0-15 in this example)
- ``$SLURM_JOBID``: Unique job ID for each task

Common sbatch Options
********************

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Option
     - Description
   * - ``--job-name=MyJob``
     - Name of the job (shown in ``squeue`` and job reports)
   * - ``--time=24:00:00``
     - Walltime (HH:MM:SS) requested for the job
   * - ``--nodes=1``
     - Number of physical nodes to request
   * - ``--ntasks=24``
     - Total number of tasks (often used for MPI)
   * - ``--ntasks-per-node=24``
     - Number of tasks per node (used with MPI)
   * - ``--cpus-per-task=6``
     - Number of CPU cores allocated to each task (useful for multi-threading)
   * - ``--mem=120GB``
     - Total memory to allocate per node
   * - ``--mem-per-cpu=4GB``
     - Memory to allocate per CPU core
   * - ``--account=$SLURM_ACCOUNT``
     - Charge the job to the specified allocation account
   * - ``--qos=qos_gpu``
     - Assign a specific Quality of Service (QOS)
     **TODO**: Update QoS name for SkipJack
   * - ``--mail-type=end``
     - Send email notification at the end of the job
   * - ``--mail-user=your_email@jhu.edu``
     - Email address to send job notifications
   * - ``--requeue``
     - Allow job to be requeued if interrupted
   * - ``--export=ALL``
     - Export environment variables (ALL, NONE, or list)
   * - ``--workdir=/path/to/dir``
     - Set the working directory for job execution
   * - ``--array=0-15%4``
     - Submit a job array with optional concurrency limit (here, max 4 jobs run at a time)
   * - ``--constraint="XXX"``
     - Request nodes with specific features or hardware constraints

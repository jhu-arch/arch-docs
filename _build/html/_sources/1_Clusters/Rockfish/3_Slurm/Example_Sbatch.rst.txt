Example Batch Scripts
######################

When submitting a job with `sbatch`, you should specify the resources your job requires using the options below. These flags determine how many nodes, CPUs, memory, and other resources Slurm will reserve for your job. Properly requesting resources ensures that your job runs efficiently and is scheduled appropriately. Include these options at the top of your Slurm batch script as `#SBATCH` directives.

Basic Example
*************

.. code-block:: bash

   #!/bin/bash
   #SBATCH --job-name=MyJob
   #SBATCH --time=24:00:00
   #SBATCH --partition=shared
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
   #SBATCH --partition=shared
   #SBATCH --time=00-01:30:15
   #SBATCH --nodes=1
   #SBATCH --ntasks-per-node=8
   ###SBATCH --mem-per-cpu=4GB
   #SBATCH --account=XYAWA
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
   #SBATCH --partition=parallel
   #SBATCH --time=02-01:30:15
   #SBATCH --nodes=1
   #SBATCH --ntasks-per-node=8
   #SBATCH --cpus-per-task=6
   #SBATCH --account=XYAWA
   #SBATCH --export=ALL

   ml gcc openmpi
   module load hwloc
   module load boost
   module load gromacs/2016-mpi-plumed
   module load plumed/2.3b
   export CUDA_AUTO_BOOST=1
   mpirun -np 8 bin/gmx_mpi mdrun -deffnm options

Big Memory Job Script
*********************

.. code-block:: bash

   #!/bin/bash -l
   #SBATCH --job-name=MyLMJob
   #SBATCH --output=myLog-file
   #SBATCH --partition=bigmem
   #SBATCH --time=02-01:30:15
   #SBATCH --nodes=1
   #SBATCH --ntasks-per-node=8
   #SBATCH -A PI-userid_bigmem
   #SBATCH --export=ALL

   ml purge
   ml intel
   ./a.out > MyLog.out

GPU Job Script (NAMD, 4 GPUs)
*****************************

.. code-block:: bash

   #!/bin/bash -l
   #SBATCH --job-name=namd4gpu
   #SBATCH --time=48:00:00
   #SBATCH --partition=a100
   #SBATCH --qos=qos_gpu
   #SBATCH --nodes=1
   #SBATCH --ntasks-per-node=48
   ####SBATCH --mem-per-cpu=4G
   #SBATCH --gres=gpu:4
   #SBATCH -A Slurm-account_gpu

   ml purge
   module load namd/2.14-cuda-smp
   ml

   export CUDA_VISIBLE_DEVICES=0,1,2,3
   export CONV_RSH=ssh
   GPUS_PER_NODE=4
   NODELIST=$SLURM_JOBID.nodes
   JOBNODES=$(scontrol show hostname $SLURM_JOB_NODELIST)

   echo group main > $NODELIST
   for node in $JOBNODES; do
       echo host $node >> $NODELIST
   done

   PPN=$(( $SLURM_NTASKS_PER_NODE / $GPUS_PER_NODE - 1 ))
   P=$(( ( $SLURM_NTASKS_PER_NODE - $GPUS_PER_NODE ) * $SLURM_JOB_NUM_NODES ))

   COMMAND="$(which namd2) +ignoresharing +idlepoll +p 44 +setcpuaffinity +pemap 1-11,13-23,25-35,37-47 +commap 0,12,24,36 +devices 0,1,2,3"
   echo $COMMAND

   $COMMAND step1_NPT.conf > npt/npt.log
   $COMMAND step2_NVT.conf > nvt/nvt.log
   $COMMAND step3_Production.conf > production/production.log

Job Array Script
****************

Job arrays are useful for submitting many similar jobs at once, such as parameter sweeps or batch processing with different input files.

You can submit a job array using:

.. code-block:: console

   sbatch --array=0-15%4 script.sh

- Runs the job script 16 times (task IDs 0 through 15)
- `%4` limits the number of concurrently running tasks to 4 (optional)

Within your job script, you can use several environment variables:

- ``$SLURM_ARRAY_JOB_ID``: The master job ID (same for all array tasks)
- ``$SLURM_ARRAY_TASK_ID``: The index of the current array task (0–15 in this example)
- ``$SLURM_JOBID``: Unique job ID for each task (can differ from array task ID)

To control output file naming for each task:

.. code-block:: bash

   #SBATCH -o slurm-%A_%a.out

Where:

- ``%A`` is replaced with the array job ID
- ``%a`` is replaced with the array task index

This will create uniquely named output files like:

.. code-block:: text

   slurm-45000_0.out
   slurm-45000_1.out
   ...
   slurm-45000_15.out

You can also customize the array index pattern:

.. code-block:: console

   # Run only tasks 1, 3, 5, 7
   sbatch --array=1,3,5,7 script.sh

   # Run tasks 1 to 7 with a step of 2 (i.e., 1, 3, 5, 7)
   sbatch --array=1-7:2 script.sh

Job arrays provide a simple and scalable way to run multiple jobs with minor differences, while maintaining clean control over indexing and output.

.. code-block:: bash

   #!/bin/bash -l
   #SBATCH --job-name=small-array
   #SBATCH --time=48:00:00
   #SBATCH --partition=shared
   #SBATCH --nodes=1
   #SBATCH --ntasks-per-node=1
   ###SBATCH --mem-per-cpu=4G
   #SBATCH --array=1-1000%480

   ml purge
   module load intel
   ml

   file=$(ls zmat* | sed -n ${SLURM_ARRAY_TASK_ID}p)
   echo $file

   newstring="${file:4}"
   export basisdir=/scratch16/jcombar1/LC-tests
   export workdir=/scratch16/jcombar1/LC-tests
   export tmpdir=/scratch16/jcombar1/TMP/$SLURM_JOBID
   export PATH=/scratch16/jcombar1/LC/bin:$PATH
   export OMP_NUM_THREADS=1
   export MKL_NUM_THREADS=1

   mkdir -p $tmpdir
   cd $tmpdir

   cp $workdir/$file ZMAT
   cp $basisdir/GENBAS GENBAS

   ./a.out > $workdir/out.$newstring

   cd ..
   \rm -rf $tmpdir

Jupyter Notebook Job Script
***************************

.. code-block:: bash

   #!/bin/bash
   #SBATCH --ntasks-per-node=1
   ####SBATCH --mem-per-cpu=4G
   #SBATCH --time=1:00:00
   #SBATCH --job-name=jupyter-notebook
   #SBATCH --output=jupyter-notebook-%J.log

   ml anaconda
   ## or use your own python/conda environment

   XDG_RUNTIME_DIR=""
   port=$(shuf -i8000-9999 -n1)
   echo $port
   node=$(hostname -s)
   user=$(whoami)

   jupyter-notebook --no-browser --port=${port} --ip=${node}

.. note::

   Check the file `jupyter-notebook-JOBID.log` for your connection details.

   1. SSH tunnel command from your local machine:

      .. code-block:: bash

         ssh -N -L ${port}:${node}:${port} ${user}@login.rockfish.jhu.edu

   2. Copy the link provided in the log file into your browser (it starts with ``http://127.0.0.1:<PORT>``).

Common sbatch Options
***************************
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
   * - ``--account=myaccount``
     - Charge the job to the specified allocation account
   * - ``--qos=qos_gpu``
     - Assign a specific Quality of Service (QOS)
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
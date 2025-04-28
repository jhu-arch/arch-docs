Parallel-computing jobs
#######################

Some workloads are *embarrassingly parallel*: you simply submit a Slurm
**job array** and each task runs an independent serial program on its own
core.  When you need multiple CPU cores **co-operating on the *same*
problem**, an application must be written (or compiled) for one of the
parallel-programming models below.

.. contents::
   :local:
   :depth: 1


Shared-memory (threads)
***********************

* One executable starts; it then spawns **threads** that run
  concurrently on cores of the **same node**.
* All threads share a single address-space – every variable is visible
  to every thread.  Synchronisation primitives (e.g. *critical*, *atomic*,
  barriers, mutexes) prevent race-conditions.
* Typical APIs: **OpenMP**, **POSIX Threads (pthreads)**; on GPUs,
  CUDA/HIP threads follow a similar memory model.

OpenMP example::

   #SBATCH --nodes=1
   #SBATCH --cpus-per-task=8        # 8 CPU cores on the node
   export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
   srun --cpu-bind=cores ./my_openmp.exe

Distributed-memory (tasks)
**************************

* The program starts **MPI ranks (tasks)**; each has its *own* memory.
* Ranks exchange data by explicit **message passing** over InfiniBand or
  Ethernet.  Every `MPI_Send` must match an `MPI_Recv`.
* MPI transparently uses shared memory when ranks reside on the same
  node for best performance.

MPI example::

   #SBATCH --nodes=2
   #SBATCH --ntasks-per-node=16     # 32 ranks total
   #SBATCH --cpus-per-task=1
   module load OpenMPI
   srun --mpi=pmix_v3 ./my_mpi.exe

Hybrid model (MPI + OpenMP)
***************************

Large codes often place **one MPI rank per socket** and spawn several
OpenMP threads within that rank – combining the strengths of both
models.

Hybrid example::

   #SBATCH --nodes=4
   #SBATCH --ntasks-per-node=2      # 2 MPI ranks / node
   #SBATCH --cpus-per-task=8        # 8 threads per rank  (16 cores/node)
   export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
   srun ./my_hybrid.exe

.. tip::
   Make sure the total cores requested match
   ``ntasks-per-node × cpus-per-task × nodes``.

GPU parallelism
***************

GPU-accelerated programs (CUDA, HIP, OpenACC, …) still follow the
shared-memory idea, but the “threads” live on the GPU.  

Further reading
***************

* `OpenMP reference <https://openmp.org/specifications/>`_
* `MPI standard <https://www.mpi-forum.org/docs/>`_
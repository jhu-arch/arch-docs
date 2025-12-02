GPU Utilization: Measuring, Diagnosing, and Improving
=====================================================

This page explains how to check real-time GPU usage on a running job, review summary
statistics after the fact, and profile your code to uncover bottlenecks. It also
covers common causes of low or zero GPU utilization and offers practical fixes.

Measure GPU Utilization in Real Time
------------------------------------

1. **Find where your job is running**

.. code-block:: bash

   sqme
 
     USER       ACCOUNT        JOBID PARTITION       NAME NODES  CPUS MIN_MEMORY TIME_LIMIT     TIME NODELIST ST REASON
     user1      research       501234 cpu       analysis.s     1     6      4000M 3-00:00:00 12:30:53   cpu001 R None
     user1      research       501235 cpu       tokenize.s     1     1      4000M 2-00:00:00  9:36:50   cpu002 R None
     user2      projectA       501236 gpu       train_model.s  1     4     16000M 2-12:00:00  9:48:45   gpu001 R None
     user2      projectA       501237 l40s      preprocess.s   1     2      8000M 1-12:00:00  9:52:55   l40s01 R None

The column (``NODELIST``) shows the node for a *running* job.
If your job is queued, there is no node yet.

2. **SSH to the compute node**

   .. code-block:: bash

      ssh <compute-node>

3. **Watch GPU activity**

   .. code-block:: bash

      watch -n 1 nvidia-smi

   Look at the ``GPU-Util`` percentage, temperature, and memory usage.
   Press ``Ctrl+C`` to exit ``watch``, and ``exit`` to leave the node.

.. tip::
   ``nvidia-smi`` shows how often a GPU kernel is executing (duty cycle).
   It does *not* tell you kernel quality, SIMD occupancy, or how many CUDA cores
   are active. For deeper analysis, use profilers.

Reviewing GPU Job Statistics
----------------------------

For summary stats on completed and running jobs, there are several tools you can use:

* **Jobstats:**

  .. code-block:: bash

     # Replace 1234567 with your JobID
     jobstats 1234567

  Example output:

  .. code-block::

     ================================================================================
                                Slurm Job Statistics
     ================================================================================
              Job ID: 1234567
       User/Account: user1/research
            Job Name: bash
               State: RUNNING
               Nodes: 1
           CPU Cores: 86
          CPU Memory: 1032GB (12GB per CPU-core)
                GPUs: 4
       QOS/Partition: gpu/h100
             Cluster: cluster
          Start Time: Sun Sep 28, 2025 at 8:08 AM
            Run Time: 1-02:54:30 (in progress)
          Time Limit: 3-00:00:00

                                Overall Utilization
     ================================================================================
       CPU utilization  [|                                               3%]
       CPU memory usage [||||                                            8%]
       GPU utilization  [|||||||||||||||||||||||||||||||||||||||||||||| 92%]
       GPU memory usage [||||||||||||||||||||||||||||||||||||||||||||||100%]

                                Detailed Utilization
     ================================================================================
       CPU utilization per node (CPU time used/run time)
           node001: 4-06:45:51/139-00:39:39 (efficiency=3.1%)

       CPU memory usage per node - used/allocated
           node001: 80.1GB/1007.8GB (661.3MB/8.1GB per core of 124)

       GPU utilization per node
           node001 (GPU 0): 91.6%
           node001 (GPU 1): 92.2%
           node001 (GPU 2): 92.0%
           node001 (GPU 3): 92.0%

       GPU memory usage per node - maximum used/total
           node001 (GPU 0): 79.5GB/79.6GB (99.8%)
           node001 (GPU 1): 79.5GB/79.6GB (99.8%)
           node001 (GPU 2): 79.5GB/79.6GB (99.8%)
           node001 (GPU 3): 79.5GB/79.6GB (99.8%)

                                        Notes
     ================================================================================
       * Example job statistics output.

* **seff:**

  ``seff`` is a lightweight tool that summarizes efficiency data from the Slurm
  accounting database. It is most useful once a job has finished.

  .. code-block:: bash

     # Replace 1234567 with your JobID
     seff 1234567

  Example output:

  .. code-block::

     Job ID: 1234567
     Cluster: cluster
     User/Group: user1/research
     State: RUNNING
     Nodes: 1
     Cores per node: 86
     CPU Utilized: 00:00:00
     CPU Efficiency: 0.00% of 96-13:11:54 core-walltime
     Job Wall-clock time: 1-02:56:39
     Memory Utilized: 0.00 MB
     Memory Efficiency: 0.00% of 1007.81 GB (11.72 GB/core)
     WARNING: Efficiency statistics can only be obtained after the job has ended
              as seff is based on accounting database data.


How to Improve GPU Utilization
------------------------------

Think of each iteration as: (1) copy CPU→GPU, (2) run GPU kernels, (3) copy GPU→CPU.
Utilization suffers when the GPU is starved for data or when kernels don’t exploit
parallelism.

Practical remedies:

- **Feed the GPU faster**

  - Use multi-threaded data loaders (e.g., ``num_workers`` in PyTorch).
  - Stage data to high-performance storage (e.g., ``<your-scratch>`` or local SSD) instead of home or project space.
  - Avoid small, frequent I/O; prefer fewer, larger reads/writes.

- **Tune the workload**

  - Increase batch size (within memory limits) to amortize overhead.
  - Use vendor-optimized libraries (cuDNN, cuBLAS, NCCL).
  - Pin memory for host→device transfers when supported.

- **Right-size the hardware**

  - Verify one GPU is well-utilized before scaling to multiple.
  - If your job uses a tiny working set or short kernels, a smaller slice (e.g., MIG) may outperform a full A100/H100/H200 for cost and queue time.

Zero GPU Utilization (0%)
-------------------------

Common causes and fixes:

* **Non-GPU code path:** confirm your software is GPU-enabled and actually using CUDA
  (or ROCm, if applicable). Many tools fall back to CPU silently.
* **Environment not set up:** ensure the correct CUDA toolkit and drivers are in use;
  match major versions to the node driver. Modern accelerators often require CUDA 12+.
* **Interactive hoarding:** avoid long ``salloc`` sessions holding idle GPUs. For
  interactive exploration, consider smaller GPU slices (e.g., MIG) if offered.

Low GPU Utilization (< ~15–30%)
-------------------------------

Investigate and try:

* **Application/script configuration:** double-check command-line flags and config files.
* **Data loader parallelism:** increase CPU workers and prefetching.
* **Too many GPUs:** do a scaling sweep (1, 2, 4 GPUs) and pick the knee of the curve.
* **Storage choice:** write active job output to high-performance scratch
  (e.g., ``/scratch/$PI/``). Avoid home paths during training.

Common Mistakes
---------------

* Requesting GPUs for a CPU-only application.
* Assuming multi-GPU works automatically. Many frameworks require explicit multi-GPU code.
* Over-requesting resources “just in case.” Slurm fairshare/priority will reflect the
  *requested* resources, not only what your code actually used.

Build Your Skills
-----------------

Helpful starting points:

* Vendor tools and docs: CUDA Toolkit, cuDNN, Nsight Systems/Compute, NCCL.
* Framework profilers: PyTorch/TensorBoard, TensorFlow Profiler.

Getting Help
------------

* Open a support ticket to help@arch.jhu.edu including:
  * JobID(s), Slurm script, module list, and a short description.
  * A brief profiler report (``nsys`` or ``ncu``) if available.


*Adapted and expanded from community best practices. Portions inspired by Princeton
Research Computing’s GPU documentation:
`GPU Computing (Low Utilization) <https://researchcomputing.princeton.edu/support/knowledge-base/gpu-computing#low-util>`_.*
GPU Utilization: Measuring, Diagnosing, and Improving
=====================================================

This page explains how to review your GPU jobs' statistics after they finish, choose the right GPU, and find
and fix the common causes of low or zero GPU utilization.

Reviewing GPU Job Statistics
----------------------------

After a job finishes, ``jobstats <jobid>`` shows GPU utilization and peak GPU memory for each GPU the job used,
next to its CPU and memory use. :doc:`Jobstats` explains the output; for GPU jobs, look at:

* **GPU utilization**: the share of time each GPU was busy. Below about 50% usually means the GPU waits on data
  loading, the CPU or storage (see below).
* **GPU memory usage**: peak memory per GPU. A job using 10 GB of an 80 GB GPU would fit a smaller GPU or a MIG
  slice, which usually starts sooner.
* **CPU utilization**: for GPU jobs, the cores mostly feed data to the GPU, so low CPU utilization is normal. It
  still matters how many cores you *request* (see "Choosing a GPU" below).

.. note::
   For **MIG slices** (``interactive_gpu``), ``jobstats`` reports GPU memory but not GPU utilization: the GPU
   driver doesn't measure utilization per slice. ``seff <jobid>`` shows CPU and memory only, no GPU data.

.. _gpu-choosing:

Choosing a GPU on Skipjack
--------------------------

Request a GPU with ``--partition`` and ``--gres=gpu:<count>``. Each GPU comes with a default number of CPU cores
and CPU memory; ask for more only if your data loading needs it.

.. list-table::
   :header-rows: 1
   :widths: 16 28 18 38

   * - **Partition**
     - **GPU**
     - **GPUs per node**
     - **Default per GPU (cores / CPU memory)**
   * - ``interactive_gpu``
     - A100 MIG slice ``2g.20gb`` (20 GB)
     - 24 slices
     - 3 cores / 6 GB (1 slice per user, 4 hours)
   * - ``a100``
     - NVIDIA A100 80 GB
     - 8
     - 10 cores / 60 GB
   * - ``l40s``
     - NVIDIA L40S 48 GB
     - 8
     - 14 cores / 84 GB
   * - ``rtx6000``
     - NVIDIA RTX PRO 6000 96 GB
     - 4 or 8
     - 15 cores / 120 GB
   * - ``h100``
     - NVIDIA H100 80-94 GB
     - 4
     - 30 cores / 360 GB
   * - ``h200``
     - NVIDIA H200 141 GB
     - 4
     - 30 cores / 360 GB
   * - ``b200``
     - NVIDIA B200 180 GB
     - 8
     - 15 cores / 180 GB
   * - ``b300``
     - NVIDIA B300 ~280 GB
     - 8
     - 15 cores / 180 GB

Some rules of thumb:

* **Start small.** Develop and debug on a MIG slice
  (``--partition=interactive_gpu --gres=gpu:2g.20gb:1``) or a single A100/L40S before scaling up.
* **Match the GPU to your memory needs.** If ``jobstats`` shows your peak GPU memory fits an 80 GB GPU,
  an H200 or B200 won't make most jobs faster, and those partitions usually have longer waits.
* **One GPU first.** Make sure one GPU is well used before asking for several; many programs don't use extra
  GPUs unless they are written to.

How to Improve GPU Utilization
------------------------------

Think of each iteration as: (1) copy CPU→GPU, (2) run GPU kernels, (3) copy GPU→CPU.
Utilization suffers when the GPU is starved for data or when kernels don’t exploit
parallelism.

Practical remedies:

- **Feed the GPU faster**

  - Use multi-threaded data loaders (e.g., ``num_workers`` in PyTorch).
  - Stage data to your group's scratch directory (``/scratch/jhu/<PI>`` or ``/scratch/schmidt/<PI>``) instead of
    your home directory.
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
* **Storage choice:** read training data from and write active job output to your group's scratch directory
  (``/scratch/jhu/<PI>`` or ``/scratch/schmidt/<PI>``, where ``<PI>`` is your PI's group). Avoid your home
  directory during training.

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

* Open a support ticket to arch@jhu.edu including:
  * JobID(s), Slurm script, module list, and a short description.
  * A brief profiler report (``nsys`` or ``ncu``) if available.

.. rst-class:: source-credit

Adapted from Princeton Research Computing documentation.

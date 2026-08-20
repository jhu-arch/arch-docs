GPU Jobs
########

ARCH offers several GPU-equipped partitions for compute-intensive and
AI/ML workloads.  This page lists each partition, the **CPU-per-GPU
billing ratios**, access requirements, and submission examples.

.. contents::
   :local:
   :depth: 1


Available GPU partitions
************************

.. list-table::
   :header-rows: 1
   :widths: 15 18 12 20

   * - **Partition**
     - **GPUs / node**
     - **CPU cores billed per GPU**
     - **Typical use-case**
   * - ``l40s``
     - 8 × NVIDIA **L40 S** (48 GB)
     - **14**
     - Large-memory image /
       data analytics
   * - ``a100``
     - 8 × NVIDIA **A100-40 GB**
     - **10**
     - Mixed HPC + DL
   * - ``nvl``
     - 4 × NVIDIA **H100 (96 GB)** 
     - **30**
     - Highest-end
       training / inference
   * - ``h100``
     - 4 × NVIDIA **H100 (80 GB)**
     - **30**
     - Same hardware as *nvl*; kept separate
       for scheduling


**DefCpuPerGPU** from `scontrol show partition`; this is what Slurm
charges **per elapsed hour per GPU**.


GPU usage limits
****************

*QoS* limits are enforced cluster-wide. Most projects can have **up to 18 GPUs in use simultaneously**. This limit is applied to both per account and per user, whichever limit is hit first. 

Submitting a GPU batch job
**************************

Example – 2 × A100 GPUs for 24 h:

.. code-block:: bash

   #SBATCH --partition=a100
   #SBATCH --qos=qos_gpu
   #SBATCH --account=jsmith123_gpu
   #SBATCH --gres=gpu:2
   #SBATCH --cpus-per-task=24     # 12  cores / GPU × 2
   #SBATCH --time=24:00:00

   module load cuda/12.3
   srun python train.py --epochs 90

Monitoring GPUs
***************

List GPU nodes & load:

.. code-block:: bash

   sinfo -p l40s,a100,nvl,h100 -N -o "%N %G %T %m"

Per-job utilisation:

.. code-block:: bash

   jobstats <jobid>

Troubleshooting
***************

* **QOSMaxGRESPerAccount** → you’ve hit the GPU cap; wait or cancel
  other runs.
* **AssocGrpGRES** → wrong account/QoS pair.
* **Resources** → request fewer GPUs or shorter wall-time to back-fill.

Need help? Open a ticket or e-mail **arch@jhu.edu**.
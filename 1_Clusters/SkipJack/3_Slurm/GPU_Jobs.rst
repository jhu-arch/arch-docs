GPU Jobs
########

ARCH offers several GPU-equipped partitions for compute-intensive and AI/ML workloads.  This page lists each partition, the **CPU-per-GPU billing ratios**, access requirements, and submission examples.

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
   * - **TODO**: Add GPU partition rows with specs, billing ratios, and use-cases


**DefCpuPerGPU** from `scontrol show partition`; this is what Slurm charges **per elapsed hour per GPU**.


GPU usage limits
****************

**TODO**: Add SkipJack GPU usage limits (max GPUs per user/account, QoS names).

Submitting a GPU batch job
**************************

Example - 2 x TODO: Add GPU type for 24 h:

.. code-block:: bash

   #SBATCH --partition=TODO: Add partition name
   #SBATCH --qos=TODO: Add QoS name
   #SBATCH --account=TODO: Add account format
   #SBATCH --gres=gpu:2
   #SBATCH --cpus-per-task=24
   #SBATCH --time=24:00:00

   module load cuda/TODO: Add version
   srun python train.py --epochs 90

Monitoring GPUs
***************

List GPU nodes & load:

.. code-block:: bash

   sinfo -p TODO:Add comma-separated gpu partitions -N -o "%N %G %T %m"

Per-job utilisation:

.. code-block:: bash

   jobstats <jobid>

**TODO**: Confirm jobstats is available on SkipJack.

Troubleshooting
***************

- **QOSMaxGRESPerAccount** → you've hit the GPU cap; wait or cancel other runs.
- **AssocGrpGRES** → wrong account/QoS pair.
- **Resources** → request fewer GPUs or shorter wall-time to back-fill.

Need help? Open a ticket or e-mail **help@arch.jhu.edu**.

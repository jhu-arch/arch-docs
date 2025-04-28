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
   :widths: 15 18 12 20 35

   * - **Partition**
     - **GPUs / node**
     - **CPU cores billed per GPU**
     - **Typical use-case**
     - **Notes**
   * - ``l40s``
     - 8 × NVIDIA **L40 S** (48 GB)
     - **16**
     - Large-memory image /
       data analytics
     - *TRESBillingWeights* CPU =  5, GPU = 100  
       → 100 ÷ 5 ≈ **20**  
       (we cap at policy value 16)
   * - ``a100``
     - 8 × NVIDIA **A100-40 GB**
     - **12**
     - Mixed HPC + DL
     - CPU = 13, GPU = 180 → 180 ÷ 13 ≈ 14  
       Policy = 12
   * - ``nvl``
     - 4 × NVIDIA **H100 (80 GB)** 
     - **32**
     - Highest-end
       training / inference
     - CPU = 10, GPU = 380 → 38  
       Policy = 32
   * - ``h100``
     - 4 × NVIDIA **H100 (80 GB)**
     - **32**
     - Same hardware as *nvl*; kept separate
       for scheduling
     - identical weights to *nvl*


**DefCpuPerGPU** from `scontrol show partition`; this is what Slurm
charges **per elapsed hour per GPU**.

Access requirements
*******************

#. Your PI must request a **GPU allocation**.  
   Support: `help@arch.jhu.edu <mailto:help@arch.jhu.edu>`__
#. You will be added to a Slurm **account** ending in ``_gpu``  
   (e.g. ``jsmith123_gpu``).
#. Use the matching **QoS** at submission time:

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - **Partition(s)**
        - **Required QoS**
      * - ``a100``, ``nvl``, ``h100``, ``l40s``
        - ``qos_gpu``   (or ``qos_l40s`` for L40S)

GPU usage limits
****************

*QoS* limits are enforced cluster-wide:

* **Per-account GPU cap**

  .. code-block:: bash

     $ sacctmgr show qos format=Name,GrpTRES
        Name      GrpTRES
     ----------  ------------------
        normal   gres/gpu=16
       qos_gpu   –
      qos_l40s   gres/gpu=8

  • Most projects can have **up to 16 GPUs in use simultaneously**  
    (8 in ``qos_l40s``).

* Memory & CPU billing weights are applied automatically; you do **not**
  need to adjust your `--mem` request unless you need more than the node
  default.

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

Interactive session:

.. code-block:: bash

   interact -p l40s --gres=gpu:4 -c 64 -t 2:00:00 -A jsmith123_gpu -q qos_gpu

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

Need help? Open a ticket or e-mail **help@arch.jhu.edu**.
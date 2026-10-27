GPU Jobs
########

Skipjack has several GPU partitions; see :doc:`Partitions` for the node types and limits of each.

Requesting GPUs
***************

Request GPUs with ``--gres=gpu:<N>`` on a GPU partition:

.. code-block:: bash

   #!/bin/bash
   #SBATCH --account=<account>
   #SBATCH --partition=a100
   #SBATCH --gres=gpu:1
   #SBATCH --time=12:00:00
   #SBATCH --output=%x_%j.out

   module load <software>
   python train.py

If you don't ask for CPUs or memory, each GPU comes with the partition's default number of CPU cores and memory per
core. Ask for more only if your job uses them.

Check which GPUs the job was given:

.. code-block:: bash

   echo $CUDA_VISIBLE_DEVICES
   nvidia-smi

MIG Slices for Small Jobs
*************************

The ``interactive_gpu`` partition splits A100 80 GB GPUs into 20 GB MIG slices. Use it for development, debugging
and short jobs (4-hour limit):

.. code-block:: console

   srun -p interactive_gpu -t 02:00:00 --gres=gpu:2g.20gb:1 --pty bash

Choosing H100 SXM or NVL
************************

The ``h100`` partition has both H100 SXM (80 GB) and H100 NVL (94 GB) nodes. To prefer one type, add
``--prefer=h100_sxm`` or ``--prefer=h100_nvl``; to require it, use ``--constraint=h100_sxm`` or
``--constraint=h100_nvl``.

Tips
****

- Request only the GPUs your code uses. Extra GPUs increase your cost and your wait time.
- Multi-GPU jobs only help if your code is written for them (for example PyTorch DDP); check with ``jobstats``
  that every GPU is busy.
- If a job uses a small fraction of GPU memory, a MIG slice or a smaller GPU type will usually start sooner.
- See :doc:`/2_Common_Tasks/Job_Efficiency/GPU_Computing` for profiling and data-loading tips.

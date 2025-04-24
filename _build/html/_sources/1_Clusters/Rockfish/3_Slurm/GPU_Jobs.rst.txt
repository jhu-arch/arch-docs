GPU Jobs
########

Rockfish provides several partitions equipped with NVIDIA GPUs for compute-intensive workloads. This page outlines available GPU partitions, submission requirements, usage policies, and tools for tracking GPU utilization.

Available GPU Partitions
*************************

a100
----

A100 is designed for GPU-enabled workflows on 40 GB A100 cards.

- **GPUs**: 4× NVIDIA A100 (40 GB each)
- **Requirements**:
  
  - Slurm allocation: ``<PI_NAME>_gpu`` (e.g., ``jsmith123_gpu``)
  - QoS: ``qos_gpu``

- **Max Runtime**: 3 days

ica100
------

ICA100 is for GPU workflows on upgraded A100 hardware.

- **GPUs**: 4× NVIDIA A100 (80 GB each)
- **Requirements**:

  - Slurm allocation: ``<PI_NAME>_gpu``
  - QoS: ``qos_gpu``

- **Max Runtime**: 3 days

mig_class
---------

MIG_CLASS provides GPUs for classroom use. It uses Multi-Instance GPU (MIG) mode to create isolated GPU slices for student jobs.

- **GPUs**: 4× NVIDIA A100 (80 GB each), segmented into 12× 20 GB MIGs
- **Requirements**:

  - Slurm allocation: ``<class_name>-<PI_NAME>`` (e.g., ``cs601-jsmith123``)
  - QoS: ``mig_class``

- **Max Runtime**: 1 day

l40s
----

L40s is intended for high-performance workflows that benefit from large GPU memory and performance.

- **GPUs**: 8× NVIDIA L40s (48 GB each)
- **Requirements**:

  - Slurm allocation: ``<PI_NAME>_gpu``
  - QoS: ``qos_gpu``

- **Max Runtime**: 1 day

Access Requirements
********************

By default, GPU partitions are **not accessible** to all users. To gain access, PIs must:

1. **Request a GPU allocation** by contacting the Rockfish support team.
2. Be assigned to a project-specific Slurm account ending in ``_gpu`` (e.g., ``jsmith123_gpu``).
3. Submit jobs using that account and the corresponding QoS (e.g., ``qos_gpu``).

GPU Usage Limits
****************

The ``qos_gpu`` configuration enforces a strict usage limit:

.. code-block:: text

   MaxTRESPA: gres/gpu=10

This means that **no more than 10 GPUs can be in use at once per account**, regardless of partition or job size. If your job exceeds the limit, it will remain **pending** with the reason:

.. code-block:: text

   (QOSMaxGRESPerAccount)

To check the current GPU usage per account, administrators may use:

.. code-block:: bash

   squeue -o "%.18i %.9P %.8j %.8u %.2t %.10M %.6D %.6C %R" --qos=qos_gpu

GPU Job Submission Example
**************************

Submit a basic batch job requesting two GPUs:

.. code-block:: bash

   #SBATCH --partition=a100
   #SBATCH --qos=qos_gpu
   #SBATCH --account=jsmith123_gpu
   #SBATCH --gres=gpu:2
   #SBATCH --ntasks=2
   #SBATCH --cpus-per-task=6
   #SBATCH --time=24:00:00

Check assigned GPU devices:

.. code-block:: bash

   echo $CUDA_VISIBLE_DEVICES

Monitoring GPU Usage with `jobstats`
************************************

Rockfish provides the `jobstats` tool to evaluate GPU, CPU, and memory usage for completed and running jobs.

Basic usage:

.. code-block:: bash

   jobstats <jobid>

Output includes:

- GPU utilization over job duration
- Memory used per GPU
- Node assignments
- Efficiency metrics

For more on viewing job status and resource usage, visit: :doc:`Job_Status`

Helpful Commands
****************

- View available GPU partitions:

  .. code-block:: bash

     sinfo -p a100,ica100,l40s,mig_class


Additional Tips
***************

- Avoid requesting more GPUs than necessary — this may increase wait time.
- Always confirm that your Slurm account and QoS match the partition.
- Use `interact` with `--gres=gpu:<N>` to start a live GPU session.

.. note::

   If you're unsure whether your PI has GPU access, or you encounter errors submitting GPU jobs, please open a ticket on the Support page or contact the Rockfish administrators directly.
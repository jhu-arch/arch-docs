AlphaFold3
###########

AlphaFold3 is available on Rockfish as a two-stage workflow that combines CPU-based preprocessing and GPU-based inference. This guide will walk you through accessing the module, running jobs, and preparing batch or interactive sessions.

Accessing AlphaFold3
*********************

To access AlphaFold3, load the module:

.. code-block:: bash

   module load alphafold/3

After loading, the wrapper script `run_alphafold3.sh` becomes available. This script runs AlphaFold3 (`run_alphafold.py`) in two stages:

- **CPU Stage** – Data preparation (auto-submitted to a CPU node)
- **GPU Stage** – Model inference (runs on a GPU node)

.. note::
   Recommended GPU Partition: Use ``ica100`` for best compatibility with AlphaFold3's requirements.

Basic Usage
***********

.. code-block:: bash

   run_alphafold3.sh [OPTIONS] [ALPHAFOLD_EXTRA_OPTS]

Options
*******

Required Parameters
===================

- ``--input_dir=``: Path to directory containing input file(s)
- ``--output_dir=``: Path to directory where results will be saved (must already exist)
- ``--models_dir=``: Path to AF3 models → ``/scratch4/datasets/alphafold3_models``
- ``--db_dir=``: Path to AF3 databases → ``/scratch4/datasets/alphafold3``
- ``--input_file=``: Name of a JSON input file (for single inputs only)

Optional Parameters
===================

- ``--cpu_partition=``: Default is ``parallel``; use ``bigmem`` for large jobs or ``shared`` for small jobs
- ``--cpus=``: Number of CPU cores (default: 24)
- ``--account=``: Slurm account (required for ``bigmem`` partition)
- ``--qos=``: QoS flag (required for ``bigmem`` partition)

.. note::
   Additional options are forwarded directly to ``run_alphafold.py``.

Examples
********

Running with a Single Input (JSON)
==================================

.. code-block:: bash

   run_alphafold3.sh \
     --input_dir=/path/to/input \
     --output_dir=/path/to/output \
     --models_dir=/scratch4/datasets/alphafold3_models \
     --db_dir=/scratch4/datasets/alphafold3 \
     --input_file=my_input.json \
     --cpu_partition=parallel \
     --cpus=16

.. note::
   For single input jobs:
   - Use ``--input_dir`` with the full path to the directory.
   - Use ``--input_file`` with the JSON file name.

Running with Multiple Inputs
============================

.. code-block:: bash

   run_alphafold3.sh \
     --input_dir=/path/to/input \
     --output_dir=/path/to/output \
     --models_dir=/scratch4/datasets/alphafold3_models \
     --db_dir=/scratch4/datasets/alphafold3 \
     --cpu_partition=bigmem \
     --account=myPI_bigmem \
     --qos=qos_bigmem

.. note::
   For multiple input files, ``--input_file`` is not needed — use ``--input_dir`` with a directory of JSON files.

Data Pipeline Only (CPU Stage Only)
===================================

.. code-block:: bash

   run_alphafold3.sh \
     --input_dir=/path/to/input \
     --output_dir=/path/to/output \
     --models_dir=/scratch4/datasets/alphafold3_models \
     --db_dir=/scratch4/datasets/alphafold3 \
     --norun_inference

.. note::
   This will generate MSAs and templates only, skipping model inference.
   Output files can be used in later inference runs.

Model Inference Only (GPU Stage Only)
=====================================

.. code-block:: bash

   run_alphafold3.sh \
     --input_dir=/path/to/data_jsons \
     --output_dir=/path/to/output \
     --models_dir=/scratch4/datasets/alphafold3_models \
     --db_dir=/scratch4/datasets/alphafold3 \
     --norun_data_pipeline

.. note::
   This mode skips the CPU stage. JSON files must include precomputed MSAs and templates.

SLURM Batch Script Example
**************************

Recommended for production workloads:

.. code-block:: bash

   #!/bin/bash
   #SBATCH --job-name=my_job_af3
   #SBATCH --partition=ica100
   #SBATCH --account=MyAccount_gpu
   #SBATCH --qos=qos_gpu
   #SBATCH --time=48:00:00
   #SBATCH --nodes=1
   #SBATCH --gres=gpu:1

   module load alphafold/3

   run_alphafold3.sh \
     --input_dir=/path/to/input \
     --output_dir=/path/to/output \
     --models_dir=/scratch4/datasets/alphafold3_models \
     --db_dir=/scratch4/datasets/alphafold3 \
     --cpu_partition=shared \
     --cpus=16

.. note::
   Submit to a GPU partition **unless** you use ``--norun_inference``, which runs only the CPU portion.

Running Interactively
*********************

To launch AlphaFold3 interactively on a GPU node:

.. code-block:: bash

   interact -p ica100 -q qos_gpu -a MyAccount_gpu -t 02:00:00 -g 1

Once on the GPU node:

.. code-block:: bash

   module load alphafold/3

   run_alphafold3.sh \
     --input_dir=/path/to/input \
     --output_dir=/path/to/output \
     --models_dir=/scratch4/datasets/alphafold3_models \
     --db_dir=/scratch4/datasets/alphafold3 \
     --cpu_partition=shared \
     --cpus=12

..  Tip::
   Make sure to monitor your job’s resource usage and ensure it runs on a GPU node when required.
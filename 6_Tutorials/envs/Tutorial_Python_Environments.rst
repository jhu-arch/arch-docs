.. _python-envs:

Python Environments
###########################

ARCH supports **two** fully-featured ways to isolate Python and its
libraries:

* ``python -m venv`` – the **built-in virtual-environment** tool  
* **Conda** – the cross-language **package & environment manager**

The sections below explain **when to pick which** and give step-by-step
recipes for creating, activating, and using either type of environment
on Rockfish (and the other ARCH clusters).

.. note::
   Conda environments on Rockfish are currently only compatible with ``GCC/9.3.0``.  
   If you need to use a newer compiler (e.g., ``GCC/12.3.0``), use a Python virtual environment (venv) instead.

Choosing venv vs Conda
**********************

+--------------------------------------+------------------+
| **Use-case**                         | **Choose**       |
+======================================+==================+
| Needs native libraries (CUDA …)      | Conda            |
+--------------------------------------+------------------+
| Mixed languages / Jupyter kernels    | Conda            |
+--------------------------------------+------------------+
| Relocatable / sharable env           |Conda (conda-pack)|
+--------------------------------------+------------------+
| Requires newer compiler (GCC 12)     | venv             |
+--------------------------------------+------------------+
| Pure-Python, very small project      | venv             |
+--------------------------------------+------------------+

Quick summary: **start with venv** for light, pure-Python work
or when you need the latest system compilers; **switch to Conda**
as soon as native libraries, multi-language notebooks or reproducible
deployment become important.


.. contents::
   :local:
   :depth: 1


Connect to Rockfish (Login Node)
********************************

Open a terminal and run:

.. code-block:: bash

   ssh YourUserID@login.rockfish.jhu.edu

Enter your Rockfish password when prompted.

.. warning::

   Since computational tasks shouldn’t run on login nodes, you’ll next connect to a compute node.

Connect to a Compute Node
*************************

.. code-block:: bash

   interact -p shared -n 6 -t 02:00:00

Creating a Python venv
**********************

Example below uses the **GCC 12 toolchain** and Python 3.11 core module.

.. code-block:: bash

   # Load your preferred compiler + Python
   module load GCC/12.3.0
   module load Python/3.11.3-GCCcore-12.3.0

   # Create the venv (change path / name as you like)
   python3 -m venv ~/virtual/py_netlogo

.. tip::
   This creates a virtual environment named ``py_netlogo`` in the folder ``~/virtual/``.  
   You can change the name and path as needed.

Activate & install packages
===========================

.. code-block:: bash

   source ~/virtual/py_netlogo/bin/activate       # prompt changes
   python -m pip install --upgrade pip            # first upgrade pip
   pip install numpy pandas matplotlib            # add packages

Deactivate
==========

.. code-block:: bash

   deactivate

Reactivate later
================

.. code-block:: bash

   module load GCC/12.3.0 
   module load Python/3.11.3-GCCcore-12.3.0
   source ~/virtual/py_netlogo/bin/activate


Running code inside the venv
============================

**Batch job (`sbatch`)**

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name=python_job
    #SBATCH --time=01:00:00
    #SBATCH --output=pythonjob_output
    #SBATCH --partition=shared
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    #SBATCH --cpus-per-task=6
    #SBATCH --mail-type=END,FAIL
    #SBATCH --mail-user=YourEmail@jhu.edu

    module load GCC/12.3.0 Python/3.11.3-GCCcore-12.3.0
    source ~/virtual/py_netlogo/bin/activate
    python path/to/script.py

**Interactive test**

.. code-block:: bash

   interact -p shared -n 4 -t 02:00:00
   module reset
   module load GCC/12.3.0 Python/3.11.3-GCCcore-12.3.0
   source ~/virtual/py_netlogo/bin/activate
   python path/to/script.py

.. note::
   - ``-p``: Partition (e.g., ``express``, ``shared``, ``parallel``)
   - ``-n``: Number of CPUs (express ≤ 4, shared ≤ 32, parallel ≤ 48)
   - ``-t``: Time limit (express ≤ 8h, shared ≤ 36h, parallel ≤ 72h)

Creating a Conda environment
****************************

All Conda environments on ARCH are built against the **GCC 9.3.0**
toolchain – load the Anaconda module first.

.. code-block:: bash

   module reset
   module load anaconda3/2024.02-1      # provides the `conda` command

Create the env
==============

.. code-block:: bash

   conda create --name mypy_env python=3.11 -y

Set recommended channels and strict priority **inside** the env:

.. code-block:: bash

   conda activate mypy_env
   conda config --env --add channels defaults
   conda config --env --add channels bioconda
   conda config --env --add channels conda-forge
   conda config --env --set channel_priority strict

Once activated, all installed packages will be stored in the env folder.

Install packages
================

Example: Install `matplotlib` and `seaborn`:

.. code-block:: bash

   # via conda
   conda install -c conda-forge matplotlib -y

Deactivate & list envs
======================

.. code-block:: bash

   conda deactivate
   conda env list            # show all your environments

Re-activate in a new session
============================

.. code-block:: bash

   module load anaconda3/2024.02-1
   conda activate mypy_env


Conda environment in a SLURM job
================================

.. code-block:: bash

   #!/bin/bash
   #SBATCH --job-name=conda_py
   #SBATCH --partition=shared
   #SBATCH --time=02:00:00
   #SBATCH --cpus-per-task=8
   #SBATCH --output=conda_py.out

   module load anaconda3/2024.02-1
   conda activate mypy_env
   python path/to/script.py


Export / share the env
----------------------

.. code-block:: bash

   # Create a portable tarball
   conda pack -n mypy_env -o mypy_env.tar.gz

   # Unpack on another cluster or inside Singularity
   mkdir mypy_env && tar -xzf mypy_env.tar.gz -C mypy_env
   source mypy_env/bin/activate
   conda-unpack                 # fix hard-coded paths


Tips & gotchas
**************

* **Compiler mismatch** – Need `GCC 12` ? Use **venv** instead of Conda.
* **Disk quota** – Conda envs are larger; clean unused ones
  (`conda env remove -n oldenv`).
* **Jupyter kernels** – After activating an env:

  .. code-block:: bash

     pip install ipykernel
     ipython kernel install --user --name=mypy_env --display-name "Python – mypy_env"

  The kernel will appear in JupyterLab / VS Code.

* **Mixing pip & conda** – Works fine *inside* an activated Conda env,
  but prefer Conda builds when available – they include native libs.

Questions?  Reach us at **help@rockfish.jhu.edu**
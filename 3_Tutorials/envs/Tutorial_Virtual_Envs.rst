.. _virtual-environments:

Virtual Environments
####################

ARCH supports multiple ways to isolate projects, interpreters, libraries, and tools — without touching the system-wide stack.

We recommend one of the following:

* **Python venv** – lightweight, pure-Python virtual environments
* **Anaconda (Conda)** – cross-language package & environment manager
* **Spack** – compiler-aware package manager for advanced use

Start with venv for light, pure-Python work or when you need the latest system compilers; switch to Conda as soon as native libraries, multi-language notebooks or reproducible deployment become important.

.. contents::
   :local:
   :depth: 1
   :backlinks: none


Python venv
===========

Overview
--------

.. image:: https://readthedocs.org/projects/python/badge/?version=latest
   :target: https://python.readthedocs.io/en/latest/?badge=latest
   :alt: The Python programming language

Use a Python **virtual environment (venv)** when you need:

- Small, lightweight, pure-Python projects
- The latest compiler toolchains (e.g., ``GCC/12.3.0``)
- Fast environment activation with minimal storage overhead

Checking Installed Python Versions
-----------------------------------

Use `module spider` to see available versions:

.. code-block:: bash

   ml spider python

Example output:

.. code-block:: none

   Versions:
     python/3.7.9
     python/3.8.6
     python/3.9.0

Load a Python module:

.. code-block:: bash

   module load python/3.8.6

List available Python packages:

.. code-block:: bash

   module avail

Create and Use a venv
---------------------

Example below using the **GCC 12** toolchain and Python 3.11:

.. code-block:: bash

   module load GCC/12.3.0
   module load Python/3.11.3-GCCcore-12.3.0
   python -m venv ~/virtual/py_netlogo

Activate the venv:

.. code-block:: bash

   source ~/virtual/py_netlogo/bin/activate

Install packages:

.. code-block:: bash

   python -m pip install --upgrade pip
   pip install numpy pandas matplotlib

Deactivate the venv:

.. code-block:: bash

   deactivate

Reactivate the venv later:

.. code-block:: bash

   module load GCC/12.3.0
   module load Python/3.11.3-GCCcore-12.3.0
   source ~/virtual/py_netlogo/bin/activate

Running Python in a SLURM Job
-----------------------------

Example batch script:

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

Interactive session example:

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


Anaconda (Conda)
================

Overview
--------

.. image:: https://copr.fedorainfracloud.org/coprs/g/rhinstaller/Anaconda/package/anaconda/status_image/last_build.png
   :alt: Build status
   :target: https://copr.fedorainfracloud.org/coprs/g/rhinstaller/Anaconda/package/anaconda/

.. image:: https://readthedocs.org/projects/anaconda-installer/badge/?version=latest
   :alt: Anaconda Docs
   :target: https://anaconda-installer.readthedocs.io/en/latest/?badge=latest

Use **Conda** when you need:

- Native libraries (e.g., CUDA, HDF5, OpenBLAS)
- Multi-language projects (Python + R + Julia)
- Portable, relocatable environments (with `conda-pack`)

.. note::
   Conda environments on ARCH are compatible with **GCC/9.3.0**.  
   If you require a newer compiler, use a Python venv instead.

Creating a Conda Environment
-----------------------------

.. code-block:: bash

   module reset
   module load anaconda3/2024.02-1

   conda create --name my_env python=3.11 -y
   conda activate my_env

Set recommended Conda channels:

.. code-block:: bash

   conda config --env --add channels defaults
   conda config --env --add channels bioconda
   conda config --env --add channels conda-forge
   conda config --env --set channel_priority strict

Install packages:

.. code-block:: bash

   conda install -c conda-forge matplotlib -y

Deactivate / Manage Environments
--------------------------------

Deactivate:

.. code-block:: bash

   conda deactivate

List environments:

.. code-block:: bash

   conda env list

Delete an environment:

.. code-block:: bash

   conda env remove --name my_env

Running Conda in a SLURM Job
----------------------------

Example batch script:

.. code-block:: bash

   #!/bin/bash
   #SBATCH --job-name=conda_job
   #SBATCH --partition=shared
   #SBATCH --time=02:00:00
   #SBATCH --cpus-per-task=8
   #SBATCH --output=conda_job.out

   module load anaconda3/2024.02-1
   conda activate my_env
   python script.py

Using Conda-Pack to Relocate Environments
-----------------------------------------

Install `conda-pack`:

.. code-block:: bash

   conda install -c conda-forge conda-pack

Pack the environment:

.. code-block:: bash

   conda pack -n my_env -o my_env.tar.gz

On another system, unpack:

.. code-block:: bash

   mkdir my_env
   tar -xzf my_env.tar.gz -C my_env
   source my_env/bin/activate
   conda-unpack

Creating Conda Envs from YAML Files
-----------------------------------

Example environment.yml:

.. code-block:: yaml

   name: machine-learning-env
   dependencies:
     - python=3.6
     - matplotlib=3.1
     - pandas=1.0
     - scikit-learn=0.22
     - pip=20.0

Create the environment:

.. code-block:: bash

   conda env create -f environment.yml

Activate it:

.. code-block:: bash

   conda activate machine-learning-env


Spack
=====

Overview
--------

.. image:: https://readthedocs.org/projects/spack/badge/?version=latest
   :alt: Spack Documentation
   :target: https://spack.readthedocs.io/

Use **Spack** for advanced users who need:

- Compiler-aware builds (GCC, Intel, etc.)
- Fine control over build options and dependencies
- Massive HPC environments where multiple versions coexist

Installing and Using Spack
--------------------------

Clone Spack:

.. code-block:: bash

   git clone -c feature.manyFiles=true https://github.com/spack/spack.git
   cd spack

Install a package (example: zlib):

.. code-block:: bash

   ./bin/spack install zlib

Helpful Commands:

- `spack help`
- `spack help --all`
- `spack help --spec`

Spack documentation: https://spack.readthedocs.io/


Questions?
==========

Need help choosing or creating an environment?  
Contact **help@rockfish.jhu.edu**.
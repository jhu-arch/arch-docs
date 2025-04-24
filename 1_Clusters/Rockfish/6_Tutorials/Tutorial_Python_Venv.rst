Python Virtual Environments (venv)
##################################

Creating and Using a Python Virtual Environment (venv) on Rockfish
*********************************************************************

If you need to install Python packages for your project, you can do so by creating a **Python Virtual Environment (venv)** or a **Conda environment**.

.. note::
   Conda environments on Rockfish are currently only compatible with ``GCC/9.3.0``.  
   If you need to use a newer compiler (e.g., ``GCC/12.3.0``), use a Python virtual environment (venv) instead.

Create Your Python Virtual Environment
**********************************************

We’ll use ``Python/3.11.3-GCCcore-12.3.0`` in this example.

.. code-block:: bash

   module load GCC/12.3.0
   module load Python/3.11.3-GCCcore-12.3.0

   python3 -m venv ~/virtual/py_netlogo

.. tip::
   This creates a virtual environment named ``py_netlogo`` in the folder ``~/virtual/``.  
   You can change the name and path as needed.

Activate the Environment
********************************

.. code-block:: bash

   source ~/virtual/py_netlogo/bin/activate

Your terminal prompt should change to reflect the activated environment.

Install Python Packages
*******************************

First, upgrade pip:

.. code-block:: bash

   python -m pip install --upgrade pip

Then install packages as needed:

.. code-block:: bash

   pip install numpy
   pip install pandas

Deactivate the Environment
**********************************

.. code-block:: bash

   deactivate

Reactivate the Environment Later
****************************************

.. code-block:: bash

   module load GCC/12.3.0
   module load Python/3.11.3-GCCcore-12.3.0
   source ~/virtual/py_netlogo/bin/activate

Running Python Scripts in Your venv
***********************************

You can run your Python script in one of two ways:

Option 1: Submit a SLURM Job
============================

Create a SLURM script (e.g., ``slurm_pyjob.sh``):

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

   module load GCC/12.3.0
   module load Python/3.11.3-GCCcore-12.3.0
   source ~/virtual/py_netlogo/bin/activate

   python path/to/my_python_script.py

Submit the job:

.. code-block:: bash

   sbatch slurm_pyjob.sh

Option 2: Run in an Interactive Session
=======================================

Useful for testing or debugging.

Start an interactive session:

.. code-block:: bash

   interact -p shared -n 6 -t 02:00:00

.. note::
   - ``-p``: Partition (e.g., ``express``, ``shared``, ``parallel``)
   - ``-n``: Number of CPUs (express ≤ 4, shared ≤ 32, parallel ≤ 48)
   - ``-t``: Time limit (express ≤ 8h, shared ≤ 36h, parallel ≤ 72h)

Once on the compute node:

.. code-block:: bash

   module reset
   module load GCC/12.3.0
   module load Python/3.11.3-GCCcore-12.3.0
   source ~/virtual/py_netlogo/bin/activate
   python path/to/my_python_script.py
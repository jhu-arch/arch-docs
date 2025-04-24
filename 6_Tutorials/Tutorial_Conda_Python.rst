Conda Python
############

This tutorial guides you through creating your own Conda environment with Python on Rockfish.

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

Parameter Guide
===============

- ``-p``: Partition (``express``, ``shared``, ``parallel``)
- ``-n``: Number of cores  
  - ``express`` → up to 4 cores  
  - ``shared`` → up to 32 cores  
  - ``parallel`` → up to 48 cores
- ``-t``: Job time in ``HH:MM:SS``  
  - ``express``: up to 8 hours  
  - ``shared``: up to 36 hours  
  - ``parallel``: up to 72 hours

Load Anaconda Module
********************

.. code-block:: bash

   module reset
   module load anaconda3/2024.02-1

Create Conda Environment
************************

.. code-block:: bash

   conda create --name mypy_env python=3.11 -y

Explanation
===========

- ``--name mypy_env``: Name of your environment  
- ``python=3.11``: Python version  
- ``-y``: Auto-confirm installation

Set Conda Channels
******************

.. code-block:: bash

   conda config --env --add channels defaults
   conda config --env --add channels bioconda
   conda config --env --add channels conda-forge
   conda config --env --set channel_priority strict

Activate the Environment
************************

.. code-block:: bash

   conda activate mypy_env

Once activated, all installed packages will live inside this environment.

Install Packages
****************

Example: Install ``matplotlib``

.. code-block:: bash

   # Using pip
   pip install matplotlib

   # Or using conda
   conda install -c conda-forge matplotlib -y

List installed packages:

.. code-block:: bash

   conda list

.. note::

   🔍 Unsure whether a package is available via Conda or pip? Google usually knows.

Deactivate Environment (When Done)
**********************************

.. code-block:: bash

   conda deactivate

To reactivate later:

.. code-block:: bash

   module load anaconda3/2024.02-1
   conda activate mypy_env

List all your environments:

.. code-block:: bash

   conda env list

Exit the Compute Node
*********************

.. code-block:: bash

   exit
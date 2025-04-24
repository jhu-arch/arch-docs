Conda R
#######

This tutorial guides you through creating and using your own **Conda environment with R** on Rockfish.

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
  - ``express``: up to 4 cores  
  - ``shared``: up to 32 cores  
  - ``parallel``: up to 48 cores
- ``-t``: Job time in ``HH:MM:SS``  
  - ``express``: up to 8 hours  
  - ``shared``: up to 36 hours  
  - ``parallel``: up to 72 hours

Load Anaconda Module
********************

.. code-block:: bash

   module reset
   module load anaconda3/2024.02-1

Create the Conda Environment
****************************

.. code-block:: bash

   conda create --name myR_env r-base=4.4.1 -y

Explanation
===========

- ``--name myR_env``: Name of your environment  
- ``r-base=4.4.1``: R version  
- ``-y``: Auto-confirm prompts

Configure Conda Channels
************************

.. code-block:: bash

   conda config --env --add channels defaults
   conda config --env --add channels bioconda
   conda config --env --add channels conda-forge
   conda config --env --set channel_priority strict

Activate the Environment
************************

.. code-block:: bash

   conda activate myR_env

Once activated, all R packages will be installed inside this environment.

Install R Packages
******************

Example: Install ``devtools``

Option 1: Using Conda (recommended)
===================================

.. code-block:: bash

   conda install -c conda-forge r-devtools -y

Option 2: From within R
=======================

Start R:

.. code-block:: bash

   R

Inside R:

.. code-block:: r

   install.packages("devtools")

.. note::

   💡 If you encounter errors related to missing system libraries (e.g., ``libcurl``, ``git``, ``openssl``), use the Conda method instead — it handles system dependencies automatically.

   🔍 Not sure whether a package is available via Conda or CRAN? A quick Google search will usually help.

Deactivate the Environment
**************************

.. code-block:: bash

   conda deactivate

To reactivate it later:

.. code-block:: bash

   module load anaconda3/2024.02-1
   conda activate myR_env

List all your environments:

.. code-block:: bash

   conda env list

Exit the Compute Node
*********************

.. code-block:: bash

   exit
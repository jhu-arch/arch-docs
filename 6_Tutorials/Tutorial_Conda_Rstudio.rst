Link Conda to RStudio
#####################

Accessing RStudio on Rockfish Using R from a Conda Environment
*****************************************************************

This tutorial guides you through launching **RStudio Server** on Rockfish using **R installed inside a Conda environment**.

Connect to Rockfish (Login Node)
********************************

Open a terminal and run:

.. code-block:: bash

   ssh YourUserID@login.rockfish.jhu.edu

Enter your Rockfish password when prompted.

Create a Module for Your Conda Environment
**************************************************

1. Load Anaconda:

   .. code-block:: bash

      module load anaconda3/2024.02-1

2. Activate your Conda environment:

   .. code-block:: bash

      conda activate my_conda_env

3. Generate a modulefile for your environment:

   .. code-block:: bash

      conda_to_lua.sh

   This will create a module named after your Conda environment (e.g., ``my_conda_env``) in your user module path.

4. Deactivate the Conda environment:

   .. code-block:: bash

      conda deactivate

Create a SLURM Script with ``r-studio-server.sh``
**********************************************************

.. code-block:: bash

   r-studio-server.sh -c 10 -t 02:00:00 -p shared

Argument Explanation:

- ``-c``: Number of cores (each core provides ~4 GB RAM)
- ``-t``: Runtime in ``HH:MM:SS``
- ``-p``: Partition  
  - ``express``: up to 4 cores / 8 hours  
  - ``shared``: up to 32 cores / 36 hours  
  - ``parallel``: up to 48 cores / 72 hours

You can run ``r-studio-server.sh --help`` to view all available options.

Edit the Generated SLURM Script
***************************************

.. code-block:: bash

   nano R-Studio-Server.slurm.script

Inside the file:

1. Locate the line:

   .. code-block:: bash

      module restore

2. Directly below it, add a line to load your Conda module:

   .. code-block:: bash

      module load own my_conda_env

3. Find the line:

   .. code-block:: bash

      export R_LIBS_USER=${HOME}/R/4.2.1

4. Replace it with the path to your Conda environment’s R library:

   .. code-block:: bash

      export R_LIBS_USER=/home/YOUR_USERNAME/.conda/envs/my_conda_env/lib/R/library

Replace ``YOUR_USERNAME`` with your Rockfish username and ``my_conda_env`` with your Conda environment name.

**Save and exit:**

- ``Ctrl + O``, then Enter to save  
- ``Ctrl + X`` to exit

Update RStudio Configuration
************************************

.. code-block:: bash

   nano .r-studio-variables

Replace the following lines:

**Line 13:**

.. code-block:: bash

   module load gfbf/2023b RStudio-Server/2023.12.1+402-gfbf-2023b-Java-11-R-4.4.1

**Line 14:**

.. code-block:: bash

   ml -R/4.4.1-gfbf-2023b

**Save and exit:**

- ``Ctrl + O``, then Enter to save  
- ``Ctrl + X`` to exit

Submit the Job
**********************

.. code-block:: bash

   sbatch R-Studio-Server.slurm.script

This will generate a file named:

.. code-block:: none

   rstudio-server.job.<jobid>.out

Locate the Output File
******************************

.. code-block:: bash

   ls -ltr rstudio-server.job*

View Connection Instructions
************************************

.. code-block:: bash

   cat rstudio-server.job.<jobid>.out

Inside the file, you’ll find two important things:

- The **SSH tunnel command**
- The **localhost URL** to open in your browser

Set Up the SSH Tunnel (Local Machine)
**********************************************

On your local terminal (not logged into Rockfish), run:

.. code-block:: bash

   ssh -N -L <PORT>:<node>:<PORT> YourUserID@login.rockfish.jhu.edu

Replace values accordingly. You’ll be prompted for your password — enter it and leave this terminal open.

Access RStudio
**********************

From the ``.out`` file, copy the URL starting with:

.. code-block:: none

   http://localhost:<PORT>/...

Paste it into your web browser and log in with your Rockfish credentials.
Nextflow
##################################

This tutorial walks you through setting up **Nextflow**, writing a small test pipeline, and running it using a SLURM job on Rockfish.

Install and Set Up Nextflow
***********************************

1. Move to your home directory:

   .. code-block:: bash

      cd ~/

2. Load Java (required by Nextflow):

   .. code-block:: bash

      module load java/19

3. Download and install Nextflow:

   .. code-block:: bash

      curl -fsSL get.nextflow.io | bash

4. Move it to a folder in your ``$PATH`` (e.g., ``~/.local/bin``):

   .. code-block:: bash

      mkdir -p ~/.local/bin
      mv nextflow ~/.local/bin/

   .. note::
      ``~/.local/bin`` is typically included in your ``$PATH``. You can check with ``echo $PATH``.

Create a Test Script
****************************

1. Create a working directory and move into it:

   .. code-block:: bash

      mkdir ~/test_nextflow
      cd ~/test_nextflow

2. Create a file called ``hello.nf`` and paste the script below:

   .. code-block:: bash

      #!/usr/bin/env nextflow

      params.greeting = 'Hello world!'
      greeting_ch = Channel.of(params.greeting)

      process SPLITLETTERS {
          input:
          val x

          output:
          path 'chunk_*'

          script:
          """
          printf '$x' | split -b 6 - chunk_
          """
      }

      process CONVERTTOUPPER {
          input:
          path y

          output:
          stdout

          script:
          """
          cat $y | tr '[a-z]' '[A-Z]'
          """
      }

      workflow {
          letters_ch = SPLITLETTERS(greeting_ch)
          results_ch = CONVERTTOUPPER(letters_ch.flatten())
          results_ch.view { it }
      }

Write the SLURM Script
******************************

Create a SLURM batch script (e.g., ``slurm.script``):

.. code-block:: bash

   #!/bin/bash
   #SBATCH --job-name=Nextflow_test
   #SBATCH --time=00:10:00 
   #SBATCH --mail-user=YourEmail@jhu.edu
   #SBATCH --partition=shared
   #SBATCH --nodes=1
   #SBATCH --ntasks-per-node=1
   #SBATCH --cpus-per-task=4

   module load java/19

   nextflow run ~/test_nextflow/hello.nf

.. tip::
   Replace ``YourEmail@jhu.edu`` with your actual email address.

Make the Script Executable
**********************************

.. code-block:: bash

   chmod +x slurm.script

Submit the Job
**********************

.. code-block:: bash

   sbatch slurm.script

View the Output
***********************

After the job runs, check the output file:

.. code-block:: bash

   cat slurm-<jobid>.out

You should see something similar to:

.. code-block:: text

   N E X T F L O W  ~  version 23.10.1
   Launching `~/test_nextflow/hello.nf` [example_run] DSL2 - revision: f99aaf0587

   executor >  local (3)
   [de/4a8c0d] process > SPLITLETTERS (1)        [100%] 1 of 1 ✔
   [d6/e9d96f] process > CONVERTTOUPPER (2)      [100%] 2 of 2 ✔

   WORLD!
   HELLO
Job Dependencies
################################

Job Dependencies in SLURM
==========================

Job dependencies are used to **delay the execution of a job until specific conditions are met**, such as the completion of other jobs. In SLURM, dependencies are specified using the ``--dependency`` option with ``sbatch``.

This tutorial demonstrates how to **limit the number of concurrently running Abaqus jobs to 5**, using SLURM job dependencies.

Abaqus Job Script (``abaqus_job.sh``)
=====================================

This is the standard SLURM script for running a single Abaqus job:

.. code-block:: bash

   #!/bin/bash
   #SBATCH --job-name=abaqus_job
   #SBATCH --output=abaqus_job_%j.out
   #SBATCH --error=abaqus_job_%j.err
   #SBATCH --time=01:00:00            # Adjust time as needed
   #SBATCH --ntasks=1                 # Set appropriately for Abaqus
   #SBATCH --mem=4000M                # Adjust memory based on model requirements

   # Load the Abaqus module
   module load abaqus

   # Run Abaqus with your input file
   abaqus job=my_abaqus_input_file input=my_abaqus_input_file.inp

.. note::
   You can modify this script to dynamically insert input file names if needed.

Job Submission Script (``submit_jobs.sh``)
==========================================

This script submits multiple Abaqus jobs and uses dependencies to ensure that **only 5 jobs run concurrently**:

.. code-block:: bash

   #!/bin/bash

   # Total number of jobs to submit
   total_jobs=100  # Adjust this as needed

   # Function to submit a job and return its job ID
   submit_job() {
       job_id=$(sbatch --parsable abaqus_job.sh)
       echo "$job_id"
   }

   # Array to store job IDs
   declare -a job_ids

   # Submit the first 5 jobs (no dependencies)
   for i in $(seq 1 5); do
       job_ids[$i]=$(submit_job)
   done

   # Submit the remaining jobs with dependencies
   for i in $(seq 6 $total_jobs); do
       dep_index=$((i - 5))
       job_ids[$i]=$(sbatch --parsable --dependency=afterany:${job_ids[$dep_index]} abaqus_job.sh)
   done

.. tip::
   ``afterany:`` ensures the job will run after the dependent job finishes, regardless of success or failure. You could use ``afterok:`` if you want the next job to start **only** if the previous job **succeeds**.

Make Scripts Executable
========================

.. code-block:: bash

   chmod +x abaqus_job.sh
   chmod +x submit_jobs.sh

Submit the Abaqus Job Chain
===========================

.. code-block:: bash

   ./submit_jobs.sh

This will begin submitting your Abaqus jobs, with dependencies ensuring that no more than 5 are running at the same time.
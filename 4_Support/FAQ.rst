Frequently Asked Questions
##########################

.. contents::
   :local:
   :depth: 1

.. dropdown:: What type of data can I upload ARCH systems?

   Data subject to restrictions - including but not limited to, HIPAA, PHI, or CUI is **not permitted** on DSAI.  
   If your research involves an IRB and the data is de-identified, please reach out to  
   `help@arch.jhu.edu <mailto:help@arch.jhu.edu>`__ for further guidance, prior to storing or processing any data.

.. dropdown:: How do I connect to a cluster?

   Use your JHED ID and run:

   .. code-block:: console

      ssh -XY <your_jhed>@login.rockfish.jhu.edu (for Rockfish)
      ssh -XY <your_jhed>@dsailogin.arch.jhu.edu (for DSAI)

.. dropdown:: What default resources do I receive?

   On Rockfish, each user/group receives:
   
   - 50GB `/home/` directory
   - 10TB group allocation on `/data/`
   - 1TB group allocation on `/scratch4/`
   - /scratch16/ access available upon request

.. dropdown:: How do I request an allocation?

   PIs must submit a short proposal through the Coldfront Portal.  
   Allocations are available for standard, GPU, and large-memory usage.  
   Startup allocations are also available for benchmarking.
   For Rockfish, visit the `Allocations page for Rockfish <../1_Clusters/Rockfish/1_Resources/Allocation>`__.
   For DSAI, visit the `Allocations page for DSAI <../1_Clusters/DSAI/1_Resources/Allocation>`__.

.. dropdown:: How do I find my group or personal utilization?

   .. code-block:: console

      sbalance -a <group>
      test-sbalance -u $USER

.. dropdown:: How do I request interactive jobs?

   Use the `interact` utility to request interactive sessions.

   .. code-block:: console

      interact -usage

.. dropdown:: How do I select the correct Slurm account?

   If you have access to multiple accounts, specify one using:

   .. code-block:: console

      #SBATCH -A johndoe1

.. dropdown:: How do I attach to a compute node where my job is running?

   First, find the job and node using `sqme`, then attach:

   .. code-block:: console

      srun --jobid=<job_id> -w <node> --pty /bin/bash

.. dropdown:: How do I check job efficiency?

   Use `seff`, `reportseff`, or `jobstats` after your job completes:

   .. code-block:: console

      seff <job_id>
      reportseff <job_id>
      jobstats <job_id> 

   .. note::
      Jobstats is only available for GPU jobs.

.. dropdown:: How do I transfer large datasets?

   Use Globus to transfer data.  
   For large numbers of small files, compress them into tarballs first:

   For more information on using Globus, visit the 
   
   - :doc:`File Transfers for Rockfish <../1_Clusters/Rockfish/2_Navigating/File_Transfers>`
   - :doc:`File Transfers for DSAI <../1_Clusters/DSAI/2_Navigating/File_Transfers>`

   .. code-block:: console

      tar -czf mydata.tgz mydata/

.. dropdown:: How do I use FileZilla?

   - Host: `rfdtn1.rockfish.jhu.edu`
   - Port: `22`
   - Protocol: `SFTP – SSH File Transfer Protocol`
   - Login Type: `Interactive`
   - Limit simultaneous transfers to **1** in Transfer Settings

   Your Rockfish username should be used for login (e.g., `jdoe1234`).
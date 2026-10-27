Frequently Asked Questions
##########################

.. contents::
   :local:
   :depth: 2

General
*******

.. dropdown:: What type of data can I upload to ARCH systems?

   Data subject to restrictions - including but not limited to, HIPAA, PHI, or CUI is **not permitted** on ARCH systems.
   If your research involves an IRB and the data is de-identified, please reach out to
   `arch@jhu.edu <mailto:arch@jhu.edu>`__ for further guidance, prior to storing or processing any data.

.. dropdown:: How can I request a piece of software or feature become available?

   For requests related to software installations or new features, please use the following form:

   - `Software Request Form <https://jh.qualtrics.com/jfe/form/SV_d5aGrhrF7ytYMQK>`__

Skipjack
********

.. dropdown:: How do I connect to Skipjack?

   JHED ID and external users:

   .. code-block:: console

      ssh <your-username>@login.arch.jhu.edu

   Schmidt Sciences users connect to ``login.schmidtsciences.jhu.edu``. See :doc:`/1_Clusters/Skipjack/quickstart`.

.. dropdown:: What storage do I get?

   Every user has a home directory. Each PI group gets a free scratch directory (1 TB by default, up to 10 TB on
   request) and can request paid Project Storage. See :doc:`/1_Clusters/Skipjack/1_Resources/Storage`.

.. dropdown:: How do I request an allocation?

   PIs request projects, compute allocations and storage in the `ARCH Portal <https://portal.arch.jhu.edu>`__.
   See the :ref:`skipjack user guide`.

.. dropdown:: How do I request an interactive session?

   Use an interactive partition. For a CPU session:

   .. code-block:: console

      srun -p interactive_cpu -t 02:00:00 -c 4 --pty bash

   For a GPU session on a 20 GB A100 MIG slice:

   .. code-block:: console

      srun -p interactive_gpu -t 02:00:00 --gres=gpu:2g.20gb:1 --pty bash

   Interactive partitions have a 4-hour limit. Jupyter, RStudio and desktops are also available through
   :doc:`/1_Clusters/Skipjack/ood`.

.. dropdown:: How do I select the correct Slurm account?

   If you belong to more than one project, list your accounts and pick one with ``-A``:

   .. code-block:: console

      sacctmgr show assoc user=$USER format=account%30
      #SBATCH -A <account>

.. dropdown:: How do I attach to a compute node where my job is running?

   Find the job with ``squeue --me``, then open a shell inside it:

   .. code-block:: console

      srun --jobid=<job_id> --overlap --pty bash

.. dropdown:: How do I check job efficiency?

   Run ``jobstats`` after your job completes. It reports CPU, memory and GPU usage for both CPU and GPU jobs:

   .. code-block:: console

      jobstats <job_id>

   See :doc:`/2_Common_Tasks/Job_Efficiency/Jobstats`.

.. dropdown:: How do I transfer large datasets, or move my data from Rockfish?

   Use Globus; see :ref:`Data Transfer with Globus`. Rockfish filesystems are not mounted on Skipjack.
   For large numbers of small files, compress them into tarballs first:

   .. code-block:: console

      tar -czf mydata.tgz mydata/

Rockfish (until retirement)
***************************

.. dropdown:: How do I connect to Rockfish?

   .. code-block:: console

      ssh -XY <your_jhed>@login.rockfish.jhu.edu

.. dropdown:: What default resources do I receive on Rockfish?

   On Rockfish, each user/group receives:

   - 50GB `/home/` directory
   - 10TB group allocation on `/data/`
   - 1TB group allocation on `/scratch4/`
   - /scratch16/ access available upon request

.. dropdown:: How do I request a Rockfish allocation?

   PIs must submit a short proposal through the Coldfront Portal.
   Allocations are available for standard, GPU, and large-memory usage.
   Startup allocations are also available for benchmarking.
   See the :doc:`Allocations page for Rockfish </1_Clusters/Rockfish/4_Coldfront/AllocationCreate>`.

.. dropdown:: How do I find my group or personal utilization on Rockfish?

   .. code-block:: console

      sbalance -a <group>
      test-sbalance -u $USER

.. dropdown:: How do I request interactive jobs on Rockfish?

   Use the `interact` utility to request interactive sessions.

   .. code-block:: console

      interact -usage

.. dropdown:: How do I attach to a Rockfish compute node where my job is running?

   First, find the job and node using `sqme`, then attach:

   .. code-block:: console

      srun --jobid=<job_id> -w <node> --pty /bin/bash

.. dropdown:: How do I check job efficiency on Rockfish?

   Use `seff`, `reportseff`, or `jobstats` after your job completes:

   .. code-block:: console

      seff <job_id>
      reportseff <job_id>
      jobstats <job_id>

   .. note::
      On Rockfish, jobstats is only available for GPU jobs.

.. dropdown:: How do I transfer data to or from Rockfish?

   Use Globus. See :doc:`File Transfers for Rockfish <../1_Clusters/Rockfish/2_Navigating/File_Transfers>`.

.. dropdown:: How do I use FileZilla with Rockfish?

   - Host: `rfdtn1.rockfish.jhu.edu`
   - Port: `22`
   - Protocol: `SFTP – SSH File Transfer Protocol`
   - Login Type: `Interactive`
   - Limit simultaneous transfers to **1** in Transfer Settings

   Your Rockfish username should be used for login (e.g., `jdoe1234`).

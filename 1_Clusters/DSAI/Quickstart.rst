DSAI Quick Start
===========================

.. contents::
   :local:
   :depth: 2

What you need
**************

===============================  =======================================
Item                             Notes
===============================  =======================================
JHED *and* DSAI account          Request one on `Coldfront <https://ai-coldfront.arch.jhu.edu/>`__
Hopkins VPN (Pulse Secure)       Required from off-campus for some services
SSH client                       macOS/Linux: built-in • Windows: *OpenSSH* or *PuTTY*
===============================  =======================================

Log in
**************

.. code-block:: bash

   ssh <YourUserID>@dsailogin.arch.jhu.edu

*First time?* Type **yes** at the host-key prompt, then your DSAI password.


Submit your first batch job
****************************

Create *hello.slurm* :

.. code-block:: bash

   #!/bin/bash
   #SBATCH --job-name=hello
   #SBATCH --output=hello.%j.out
   #SBATCH --time=00:02:00
   #SBATCH --ntasks=1
   #SBATCH --cpus-per-task=1
   #SBATCH --partition=$Partition

   echo "Hello from $(hostname)!"
   sleep 30

Submit & monitor:

.. code-block:: bash

   sbatch hello.slurm      # submit
   squeue -u $USER         # check status
   tail -f hello.<jobID>.out

If the job is *PENDING* for more than a minute, reduce resources or pick another partition (see table below).

Partitions at a glance
----------------------

For available partitions, see: :doc:`3_Slurm/Partitions`

Managing Python, Jupyter, RStudio
***********************************

Work in Progress

Storage locations
*********************

.. list-table::
   :header-rows: 1
   :widths: 20 15 65

   * - **Path**
     - **Default quota**
     - **Intended for**
   * - ``/home/$USER``
     - 50 GB (backed up)
     - configs, notebooks, small scripts
   * - ``/scratch/$PI``
     - 1 TB
     - working data

For more information on available filesystems, see here: :doc:`1_Resources/Filesystems`

House-keeping
**************

* **Fair-share scheduler** – large jobs may wait if your lab has used more
  CPU-hours than average recently.
* **Login nodes** – *no heavy compute*.  Use ``sbatch`` instead.

Need help?
**************

* `Knowledge base <https://arch-docs.readthedocs.io>`__  
* Email: `help@arch.jhu.edu <mailto:help@arch.jhu.edu>`_  
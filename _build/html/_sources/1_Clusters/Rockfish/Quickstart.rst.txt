Rockfish Quick Start
===========================

.. contents::
   :local:
   :depth: 2

What you need
**************

===============================  =======================================
Item                             Notes
===============================  =======================================
JHED *and* Rockfish account      Request one on `Coldfront <https://coldfront.rockfish.jhu.edu/>`
Hopkins VPN (Pulse Secure)       Required from off-campus for some services
SSH client                       macOS/Linux: built-in • Windows: *OpenSSH* or *PuTTY*
===============================  =======================================

Log in
**************

.. code-block:: bash

   ssh <YourUserID>@login.rockfish.jhu.edu

*First time?* Type **yes** at the host-key prompt, then your Rockfish password.

Load software modules
**********************

Rockfish uses *Lmod* modules.

.. code-block:: bash

   module avail          # list all software
   module spider R       # list every R version
   module load R/4.4.1   # make it your default R for this session

Tip: add frequently-used modules to ``~/.bashrc`` with ``module load …``.

Quick interactive work
****************************

Short, exploratory commands belong on an **interactive compute node**.

.. code-block:: bash

   interact -c 4 -t 2:00:00        # 4 cores, 2 h in the *express* partition
   hostname                        # now you're on compute-XYZ, not a login node
   python                          # fire up IPython, R, etc.

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
   #SBATCH --partition=express

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

.. list-table::
   :header-rows: 1
   :widths: 18 55 27

   * - **Tool / service**
     - **Where to start**
     - **Docs**
   * - **JupyterLab**
     - Portal → *Jupyter Server* (GUI)\\
       ``jupyterlab.sh`` helper (CLI)
     - :doc:`6_Tutorials/Tutorial_Jupyter`
   * - **RStudio Server**
     - Portal → *RStudio Server* (GUI)\\
       ``r-studio-server.sh`` helper (CLI)
     - :doc:`6_Tutorials/Tutorial_R`
   * - **Conda environments**
     - ``module load anaconda``\\
       ``conda create -n myenv python=3.11``
     - :doc:`6_Tutorials/Tutorial_Conda_Envs`

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
   * - ``/scratch4/$PI``
     - 1 TB
     - small files, working data
   * - ``/scratch16/$PI``
     - By request
     - large files, working data
   * - ``/data/$PI``
     - 10 TB
     - long-term, high-value data

For more information on available filesystems, see here: :doc:`1_Resources/Filesystems`

House-keeping
**************

* **Purge policy** – anything in *scratch* > 30 days old **is deleted**.  
  Move results you wish to keep to `/data` or download them.
* **Fair-share scheduler** – large jobs may wait if your lab has used more
  CPU-hours than average recently.
* **Login nodes** – *no heavy compute*.  Use ``interact`` or ``sbatch`` instead.

Need help?
**************

* `Knowledge base <https://rockfish-docs.readthedocs.io>`__  
* Email: `help@rockfish.jhu.edu <mailto:help@rockfish.jhu.edu>`_  
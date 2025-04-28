==============================
R & RStudio
==============================

Rockfish offers **two complementary ways** of working with R:

* **RStudio Server** – a full-featured IDE you open in a web browser.  
* **Command-line R** – run R scripts or an interactive `R` prompt from the
  terminal (or inside Slurm batch jobs).

This page collects **all** R-related instructions in one place.

.. contents::
   :local:
   :depth: 2


------------------------------------------------------------------
1  Interactive RStudio Server
------------------------------------------------------------------

You can launch RStudio two ways.  Both end up running the same server
inside the cluster – choose whichever matches your workflow.

1.1  Open OnDemand (graphical, point-and-click)
***********************************************

1. **Connect to the Hopkins VPN** – the portal is JHU-internal.  
2. Open your browser and go to `https://portal.rockfish.jhu.edu`.  
3. Log in with your **Rockfish** credentials.  
4. On the dashboard click **RStudio Server**.  
5. Fill in the resource form:  

   * **R version** (e.g. ``R/4.4.1 – RStudio Server``)  
   * **R_LIBS_USER** – path to **your** personal R library  
   * **Wall time**, **cores**, **partition** (see cheatsheet below)

6. Click **Launch**.  When the session is *Running* hit
   **Connect to RStudio Server**.  
7. A new browser tab opens → happy coding!

1.2  Command-line helper script
*******************************

Prefer the shell, need repeatability, or want to embed RStudio in a
larger workflow?  Use `r-studio-server.sh`:

.. rubric:: Quick start

.. code-block:: bash

   # 1  SSH to Rockfish
   ssh <YourUserID>@login.rockfish.jhu.edu

   # 2  Generate a Slurm batch script
   r-studio-server.sh -n 1 -c 2 -m 8G -t 4:00:00 -p defq -e <you>@jhu.edu
   #             (run r-studio-server.sh -h for all flags)

   # 3  Submit the job
   sbatch R-Studio-Server.slurm.script

   # 4  Read the connection info once the job starts
   cat rstudio-server.job.<JOBID>.out

   # 5  On *your laptop* create the SSH tunnel it shows
   ssh -N -L 8787:node123:8787  <YourUserID>@login.rockfish.jhu.edu

   # 6  Open http://localhost:8787  →  RStudio Server

During the *first* run the helper also writes
a hidden config file ``.r-studio-variables`` that you may customise.

.. note::
   The script prints a full summary **before** submitting.
   Press *Ctrl-C* to cancel if anything looks wrong.

Parameter reference
===================

.. list-table::
   :header-rows: 1
   :widths: 10 90

   * - Flag
     - Meaning
   * - ``-n``
     - **Nodes** (default 1)
   * - ``-c``
     - **Cores per task** (≈ 4 GB RAM each)
   * - ``-m``
     - **Memory** – overrides *cores × 4 GB* if set
   * - ``-t``
     - **Wall time** ``HH:MM:SS`` or ``D-HH:MM``
   * - ``-p``
     - **Partition** (``express``, ``shared``, ``parallel``, ``a100``…)
   * - ``-q``
     - **QoS** (optional)
   * - ``-g``
     - **GPUs** (GPU partitions only)
   * - ``-e``
     - **E-mail** for job notifications
   * - ``-a``
     - **Account / PI group** (required on GPU partitions)

Partition cheatsheet
--------------------

For available partitions, see: :doc:`../../1_Clusters/Rockfish/3_Slurm/Partitions`


Helper-script output files
--------------------------

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - File
     - Purpose
   * - ``R-Studio-Server.slurm.script``
     - The Slurm batch script that starts the server
   * - ``rstudio-server.job.<JOBID>.out``
     - SSH-tunnel command + URL to open in a browser
   * - ``.r-studio-variables``
     - Hidden config (RStudio & module versions, ports, …)
   * - ``~/.config/rstudio/…``
     - Per-user RStudio settings (created on first launch)

Customising the R version
-------------------------

Edit ``.r-studio-variables`` and/or the Slurm script.  
Load the desired module, e.g.:

.. code-block:: bash

   module load gfbf/2023b  R/4.4.1-gfbf-2023b
   export R_LIBS_USER=${HOME}/rlibs/R-4.4.1-gfbf-2023b


------------------------------------------------------------------
2  Command-line R (outside RStudio)
------------------------------------------------------------------

2.1  Loading R modules
**********************

Rockfish’s **default R** is currently **4.4.1**.  
Load a different version with the module system:

.. code-block:: bash

   module avail r            # list every R build
   module load  r/3.6.3      # example: older version
   module load  r/4.4.1      # example: latest

Some domain-specific software bundles ship their *own* R:

.. code-block:: text

   module load  Seurat/4.1.1   # uses R 4.1.3 internally
   module load  edgeR/3.38.1   # uses R 4.2.0

2.2  Installing CRAN / Bioconductor packages
********************************************

The simplest way (installs into your **personal** library):

.. code-block:: bash

   module load r/4.4.1
   R
   > install.packages("hdf5r")

Installing from a source tarball:

.. code-block:: bash

   wget https://cran.r-project.org/src/contrib/LearnBayes_2.15.1.tar.gz
   module load r/4.4.1
   R CMD INSTALL -l ~/rlibs/R-4.4.1  LearnBayes_2.15.1.tar.gz

Tell R where to look for those packages (add to your `.bashrc`
or to Slurm scripts):

.. code-block:: bash

   export R_LIBS_USER=~/rlibs/R-4.4.1

2.3  Using Conda
****************

Conda can manage completely independent R stacks:

.. code-block:: bash

   module load anaconda
   conda create -n hdf5r  r-base=4.4.1  r-hdf5r  -c conda-forge
   conda activate hdf5r
   R
   > q()

You may add further packages later:

.. code-block:: bash

   conda activate hdf5r
   conda install  -c bioconda  bioconductor-limma
   conda install  -c conda-forge  r-patchwork

*Reminder:* activate the env **and** keep the `anaconda` module loaded
when your Slurm job starts.

2.4  Installing from GitHub (dev tools)
***************************************

.. code-block:: bash

   module load r/4.4.1
   R
   > install.packages("devtools")
   > devtools::install_github("davidaknowles/leafcutter/leafcutter",
                              lib = Sys.getenv("R_LIBS_USER"))

2.5  Checking package versions
******************************

.. code-block:: R

   packageVersion("leafcutter")


------------------------------------------------------------------
3  Troubleshooting & FAQ
------------------------------------------------------------------

* **RStudio job stuck in `PENDING`** – the partition is full;
  pick ``express`` or shorten the wall-time.
* **Cannot open RStudio / Jupyter URL** – verify the SSH tunnel on your
  laptop and that you are browsing `http://localhost:<port>`.
* **“Address already in use”** – change the **local** port
  in the tunnel (e.g. `-L 8899:node:8787`).
* **Package installs fail with permissions errors** – set
  ``R_LIBS_USER`` to a directory **you** own (e.g. `~/rlibs/R-4.4.1`).
* **Need GPU-accelerated R** – load ``cuda``/``a100`` modules and see
  the Rockfish *GPU guide* for Slurm flags.

Questions?  E-mail **help@rockfish.jhu.edu**.
JupyterLab on Rockfish
######################

JupyterLab is the modern, web-based interface for Jupyter notebooks,
code and data.  On Rockfish you can start it in **two ways**:

* **Graphical** – through the Open OnDemand (OOD) web portal.  
* **Command-line** – with the helper script ``jupyterlab.sh`` (creates a SLURM job).

Both methods ultimately launch the same Jupyter server inside the
cluster; choose the workflow you prefer.

.. contents::
   :local:
   :depth: 1


Method 1 – Open OnDemand portal
*******************************

1. **Connect to the Hopkins VPN** – the portal is JHU-internal.  
2. Point your browser to `https://portal.rockfish.jhu.edu`.  
3. **Log in** with your Rockfish username / password.  
4. Click the **Jupyter Server** tile on the dashboard.  
5. Pick your resources  

   * **Wall time**  
   * **Number of cores** (≈ 4 GB RAM each)  
   * **Partition** (``express``, ``shared``, ``parallel``, ``a100``, …)

6. Press **Launch**.  
   A new page appears; when the job is ready click **Connect to Jupyter**.  
7. Your JupyterLab session opens in a new browser tab.  *Done!*


Method 2 – Command-line helper script
*************************************

The script offers finer control (useful for automation or when you
prefer the shell).

.. rubric:: Quick start

.. code-block:: bash

   # 1. SSH to Rockfish
   ssh <YourUserID>@login.rockfish.jhu.edu

   # 2. Generate a Slurm batch script with desired resources
   jupyterlab.sh -n 1 -c 2 -m 8G -t 4:00:00 -p defq -e <you>@jhu.edu
                 # more examples: jupyterlab.sh -h

   # 3. Submit the job
   sbatch jupyter_lab.slurm.script

   # 4. When the job starts, read connection info
   cat Jupyter_lab.job.<JOBID>.login

   # 5. On *your laptop*, create the SSH tunnel it shows, e.g.
   ssh -N -L 8888:node123:8888 <YourUserID>@login.rockfish.jhu.edu

   # 6. Paste http://localhost:8888/?token=… into a browser → JupyterLab!

During the *first* run the script also creates/updates a lightweight
Python virtual-environment ``~/jp_lab`` containing ``jupyter-lab``,
``ipykernel``, and helpers.

.. note::
   The helper prints a complete summary **before** submitting.  
   Press *Ctrl-C* to cancel if something looks wrong.


Helper-script output files
==========================

.. list-table:: Output produced by ``jupyterlab.sh``
   :header-rows: 1
   :widths: 35 65

   * - **File name**
     - **Purpose**
   * - ``jupyter_lab.slurm.script``
     - The SLURM batch script that actually launches the server
   * - ``Jupyter_lab.job.<JOBID>.login``
     - SSH-tunnel command **and** the URL to open in a browser
   * - ``Jupyter_lab.info``
     - Environment variables & HTTPS details (advanced diagnostics)
   * - ``~/.jupyter/jupyter_notebook_config.py``
     - Per-user Jupyter configuration file


Parameter reference
===================

.. list-table:: ``jupyterlab.sh`` flags  (see ``jupyterlab.sh --help``)
   :header-rows: 1
   :widths: 10 90

   * - **Flag**
     - **Meaning**
   * - ``-n``
     - **Nodes** (default 1)
   * - ``-c``
     - **Cores per task** (≈ 4 GB RAM each)
   * - ``-m``
     - **Memory** (e.g. ``8G``) – overrides *cores × 4 GB* if set
   * - ``-t``
     - **Wall-time** ``HH:MM:SS`` *or* ``D-HH:MM``
   * - ``-p``
     - **Partition** (``express``, ``shared``, ``parallel`` …)
   * - ``-q``
     - **QoS** (optional)
   * - ``-g``
     - **GPUs** (GPU partitions such as ``a100``)
   * - ``-e``
     - **E-mail** for job notifications
   * - ``-a``
     - **Account / PI group** (required on GPU partitions)


Partition cheatsheet
--------------------

For available Rockfish partitions, see: :doc:`../../1_Clusters/Rockfish/3_Slurm/Partitions`


Adding extra Python / Conda environments
****************************************

You can register *any* Conda env or virtualenv as a kernel:

.. code-block:: bash

   # load preferred module or conda
   module load conda
   conda activate <myenv>

   # inside the env:
   pip install --upgrade ipykernel
   ipython kernel install --user --name <myenv> \
                          --display-name "Python (<myenv>)"

   # verify
   jupyter kernelspec list

The next time you open JupyterLab the new kernel appears in the launcher.

.. tip::
   To switch **R**, **Julia** or other languages, install the appropriate
   kernel package inside the env and register it the same way.


Troubleshooting
***************

* **Job sits in `PENDING`** – partition is full; try ``express`` or reduce cores/time.  
* **Can’t open URL** – ensure the SSH tunnel is running on your laptop and that you’re browsing `http://localhost:<port>`.  
* **“Address already in use”** – change the local port in the tunnel (e.g. ``-L 8899:…``).  
* **Need GPU** – specify ``-g <n> -p a100 -a <PI-account>_gpu`` in the helper.  
* **First-time password prompts twice** – the script validates credentials before generating the batch file; just enter the same Rockfish password.

Questions?  E-mail **help@rockfish.jhu.edu**.
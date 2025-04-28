Vscode
################################

Accessing VS Code on Rockfish
==============================

You can access Visual Studio Code on Rockfish in two ways:

Using Open OnDemand (Web Portal)
================================

1. Connect to the Hopkins VPN  
   Rockfish’s Open OnDemand (OOD) is only accessible within the JHU network.

2. Open the portal  
   Go to: https://portal.rockfish.jhu.edu

3. Login  
   Use your Rockfish credentials.

4. Launch VS Code  
   - On the dashboard, click "VSCode Server IDE/Editor"  
   - Choose your wall time, number of cores, and partition  
   - Click Launch

5. Connect  
   When the session is ready, click the "Connect to VS Code" button on the new page.

Using ``vscode-server.sh`` on the Command Line
===============================================

This method is great for advanced users who prefer working directly via Slurm.

Connect to Rockfish (login node)
--------------------------------

Create the Slurm script  
-----------------------

Run the script with desired parameters (use ``-h`` for help):

.. code-block:: bash

   vscode-server.sh -c 6 -t 02:00:00 -p parallel

Submit the job  
--------------

.. code-block:: bash

   sbatch VSCode-Server.slurm.script

Locate the output file  
-----------------------

.. code-block:: bash

   ls -ltr vscode-server.job*

This will output a file like: ``vscode-server.job.<jobid>.out``

Get SSH tunnel instructions  
---------------------------

.. code-block:: bash

   cat vscode-server.job.<jobid>.out

The file includes an ``ssh -N -L ...`` command for setting up the SSH tunnel.

Create the SSH tunnel (from your local machine)  
-----------------------------------------------

.. code-block:: bash

   ssh -N -L <local_port>:localhost:<remote_port> <your_user>@rockfish.jhu.edu

- Paste the full command from the ``.out`` file  
- Enter your Rockfish password when prompted  
- Leave this terminal open (minimized is fine)

Open VS Code in your browser  
----------------------------

Go to ``http://localhost:<local_port>`` (as provided in the ``.out`` file)

Notes
=====

- You can run ``vscode-server.sh -h`` to see available options and usage.
- Don’t forget to close your job when done:

.. code-block:: bash

   scancel -f <jobid>
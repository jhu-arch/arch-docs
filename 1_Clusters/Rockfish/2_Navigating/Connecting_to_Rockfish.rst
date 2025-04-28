Logging in to Rockfish
===========================

This section covers how to log into Rockfish and transfer files to and from the system.


Use Secure Shell (SSH) to connect:

.. code-block:: console

  ssh -XY <userid>@login.rockfish.jhu.edu

You can also use:

.. code-block:: console

  ssh -XY login.rockfish.jhu.edu -l <userid>

**Gateway:** ``login.rockfish.jhu.edu``  

Access to Login Node
********************

Once you establish a connection, SSH will prompt for your password. Once you have signed into the login node, you should see the Message of the Day "MOTD".

Quota information will be provided to users automatically on login, but users can use the ``quotas.py`` command at anytime to view quota and usage information.

.. code-block:: console

  Thu Mar 10 09:45:29 2022 from 172.28.3.75
   ____            _    _____ _     _
  |  _ \ ___   ___| | _|  ___(_)___| |__
  | |_) / _ \ / __| |/ / |_  | / __| |_ \
  |  _ < (_) | (__|   <|  _| | \__ \ | | |
  |_| \_\___/ \___|_|\_\_|   |_|___/_| |_|
  [STATUS] loading software modules
  [STATUS] modules are Lmod (https://lmod.readthedocs.io/en/latest/)
  [STATUS] software is Spack (https://spack.readthedocs.io/en/latest/)
  [STATUS] the default modules ("module restore") use GCC 9 and OpenMPI 3.1
  [STATUS] you can search available modules with: module spider <name>
  [STATUS] you can list available modules with: module avail
  [STATUS] loading a compiler, MPI, Python, or R will reveal new packages
  [STATUS] and you can check your loaded modules with: module list --terse
  [STATUS] to hide this message in the future: touch ~/.no_rf_banner
  [STATUS] restoring your default module collection now

  Quota and usage information. Updated hourly. Use 'gpfsquota'
  Usage for group MyGroup
  FS         Usage   Quota  Files_Count  File_Quota
  ---        ---     ---    ---          ---
  data       5.07T   10T    2287948      4194304
  scratch16  1.939T  10T    1005210      10240000
  scratch4   4.177T  10T    1159700      20480000
  [userid@login02 ~]$

Multiplexing SSH Connections
****************************

To avoid re-entering your password and two-factor code with each connection, you can enable SSH multiplexing:

1. Edit (or create) ``~/.ssh/config`` on your local Unix-based machine:

   .. code-block:: text

     Host login.rockfish.jhu.edu
         ControlMaster auto
         ControlPath ~/.ssh/control:%h:%p:%r

2. Start the master connection:

   .. code-block:: console

     ssh -fNM -X login.rockfish.jhu.edu -l <userid>

3. To stop the connection:

   .. code-block:: console

      ssh -O stop login.rockfish.jhu.edu

.. note::
   Large file transfers and terminal sessions may experience lag when using the same multiplexed connection.

**Windows users:** Use `PuTTY`_ or `MobaXterm` (Home Edition → Installer edition) to connect. MobaXterm includes an X11 server for GUI apps and supports SFTP file transfers.

**Mac users:** Use the built-in Terminal. For GUI support, install `XQuartz`.

.. _PuTTY: https://www.putty.org
.. _XQuartz: https://www.xquartz.org
.. _MobaXterm: https://mobaxterm.mobatek.net
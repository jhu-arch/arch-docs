Logging in to DSAI
===========================

This section covers how to log into the DSAI cluster and transfer files to and from the system.


Use Secure Shell (SSH) to connect:

.. code-block:: console

  ssh <YourUserID>@dsailogin.arch.jhu.edu

You can also use:

.. code-block:: console

  ssh -XY dsailogin.arch.jhu.edu -l <userid>

**Gateway:** ``dsailogin.arch.jhu.edu``  

Access to Login Node
********************

Once you establish a connection, SSH will prompt for your password. Once you have signed into the login node, you should see the Message of the Day "MOTD".

Quota information will be provided to users automatically on login, but users can use the ``quotas.py`` command at anytime to view quota and usage information.

.. code-block:: console

  Last login: Thu Apr 24 12:32:18 2025 from 174.172.66.209

Multiplexing SSH Connections
****************************

To avoid re-entering your password and two-factor code with each connection, you can enable SSH multiplexing:

1. Edit (or create) ``~/.ssh/config`` on your local Unix-based machine:

   .. code-block:: text

     Host dsailogin.arch.jhu.edu
         ControlMaster auto
         ControlPath ~/.ssh/control:%h:%p:%r

2. Start the master connection:

   .. code-block:: console

     ssh -fNM -X dsailogin.arch.jhu.edu -l <userid>

3. To stop the connection:

   .. code-block:: console

      ssh -O stop dsailogin.arch.jhu.edu

.. note::
   Large file transfers and terminal sessions may experience lag when using the same multiplexed connection.

**Windows users:** Use `PuTTY`_ or `MobaXterm` (Home Edition → Installer edition) to connect. MobaXterm includes an X11 server for GUI apps and supports SFTP file transfers.

**Mac users:** Use the built-in Terminal. For GUI support, install `XQuartz`.

.. _PuTTY: https://www.putty.org
.. _XQuartz: https://www.xquartz.org
.. _MobaXterm: https://mobaxterm.mobatek.net
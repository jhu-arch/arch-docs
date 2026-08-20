:orphan:

Running VS Code on a Skipjack Compute Node
===========================================

This guide shows how to run **VS Code** directly on a **Skipjack compute node** instead
of the login node. The editor, integrated terminal, package installs, and code execution
all run on the hardware Slurm allocates to you.


.. contents::
   :local:
   :depth: 2


What you get
############

You open VS Code, click a host (e.g. ``skipjack-compute``), and VS Code **automatically**:

- requests a job from Slurm (allocates a compute node for you);
- opens the connection directly to that node;
- runs the VS Code server there.

When you close VS Code, **the job is released automatically**. You never have to type
``salloc``, look up the node name, or deal with port forwarding by hand.


|

How it works
############

.. mermaid::

   flowchart LR
       A["Your computer<br/>(VS Code)"] -->|"1. SSH + OTP<br/>(once)"| B["Login node<br/>login0X.schmidtsciences.jhu.edu"]
       B -->|"2. salloc<br/>(allocate a node)"| C["Slurm"]
       C --> D["Compute node<br/>e.g. csr048"]
       B -.->|"3. tunnel via /dev/tcp<br/>to the node's port 22"| D
       A ==>|"4. VS Code Server runs HERE"| D

Key points:

- **The OTP is only requested once**, when you open a "master session" in a terminal.
  VS Code reuses that session (SSH ``ControlMaster``), so it does **not** ask for the OTP.
- Authentication **to the compute node** uses your **SSH key** (no OTP is needed once you
  have a job allocated there) — that is why `Step 2 — Create an SSH key and register it on the cluster`_
  is required.


|

Prerequisites
#############

+----------------------------+---------------------------------------------------------------------------+
| Item                       | Detail                                                                    |
+============================+===========================================================================+
| **A Skipjack account**     | Username, password, and **OTP** (6-digit code) already set up and working.|
+----------------------------+---------------------------------------------------------------------------+
| **Working login**          | You can run ``ssh YOUR_USER@login.arch.jhu.edu`` and get in               |
|                            | with password + OTP.                                                      |
+----------------------------+---------------------------------------------------------------------------+
| **VS Code installed**      | On your computer — https://code.visualstudio.com                          |
+----------------------------+---------------------------------------------------------------------------+
| **A terminal**             | Native on macOS or Linux. **Windows** users: see the                      |
|                            | `Windows`_ section.                                                       |
+----------------------------+---------------------------------------------------------------------------+


.. admonition:: Throughout this guide
   :class: hint

   Replace **YOUR_USER** with your cluster username (e.g. ``arochab1``).


|

----

Steps to Configure VS Code
##########################

Step 1 — Install the Remote-SSH extension
-----------------------------------------

In VS Code:

1. Open the **Extensions** panel (the blocks icon in the sidebar, or ``Cmd/Ctrl + Shift + X``).
2. Search for **Remote - SSH** (published by Microsoft).
3. Click **Install**.

This installs **Remote - SSH** and **Remote Explorer** (the monitor icon in the sidebar,
which you will use to connect).


|

Step 2 — Create an SSH key and register it on the cluster
---------------------------------------------------------

**Why:** inside the tunnel, VS Code authenticates directly to the compute node. That step
uses an **SSH key**, not password + OTP. Without a registered key, the connection fails
with ``Permission denied``.

In the **terminal on your computer** (not on the cluster):

.. code-block:: bash

   # 1) Create a dedicated key (if you don't have one). Press Enter at the prompts.
   ssh-keygen -t ed25519 -f ~/.ssh/id_skipjack -C "vscode-skipjack"

   # 2) Send the public key to the cluster (asks for password + OTP ONCE).
   ssh-copy-id -i ~/.ssh/id_skipjack.pub YOUR_USER@login.arch.jhu.edu

If ``ssh-copy-id`` is not available on your system, do it manually:

.. code-block:: bash

   cat ~/.ssh/id_skipjack.pub | ssh YOUR_USER@login.arch.jhu.edu \
     'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'

.. admonition:: Note
   :class: hint

   Your ``$HOME`` is the **same** on the login and compute nodes (shared filesystem), so the
   registered key automatically works on the compute nodes too.


|

Step 3 — Generate your launcher script on the cluster
-----------------------------------------------------

A helper called ``vscode_job.sh`` is available on every node (installed in ``/apps/helpers``,
already on your ``PATH``). You run it **once**, with the Slurm resources you want, and it writes
a personal launcher — ``~/vscode-jump.sh`` — that VS Code uses to allocate the job and tunnel
in. To change resources later, just run it again.

1. Connect to the cluster: ``ssh YOUR_USER@login.arch.jhu.edu``
2. Run ``vscode_job.sh`` with any ``salloc`` flags you like. Examples:

.. code-block:: bash

   # CPU session (partition "med"): 8 hours, 8 cores
   vscode_job.sh -p med -t 08:00:00 --cpus-per-task=8

   # GPU session (partition "a100"): 2 hours, 12 cores, 1 GPU
   vscode_job.sh -p a100 -t 02:00:00 --cpus-per-gpu=12 --gres=gpu:1

The helper prints where it wrote the launcher and the exact ``ProxyCommand`` line to use in the
next step:

.. code-block:: text

   Generated: /home/YOUR_USER/vscode-jump.sh
     salloc args: -p med -t 08:00:00 --cpus-per-task=8 --account=... --comment=accept_cost --job-name=vscode

   Next: on your computer, point a ~/.ssh/config compute host at it:

       ProxyCommand ssh skipjack "~/vscode-jump.sh"

You do **not** pass ``--account`` or ``--comment`` — the helper fills in your default account and
the required billing comment automatically. To use a different account, pass ``-A <account>``.

.. admonition:: Want more than one profile?
   :class: hint

   For example, a CPU one and a GPU one. Use ``--out`` to write to a
   different filename and point a separate SSH host at it:

   .. code-block:: bash

      vscode_job.sh --out ~/vscode-gpu.sh -p a100 -t 02:00:00 --gres=gpu:1

Run ``vscode_job.sh --help`` to see all options.


|

Step 4 — Configure ``~/.ssh/config`` on your computer
-----------------------------------------------------

On **your computer**, open the SSH config file at ``~/.ssh/config``.

Add the two blocks below (replace **YOUR_USER** with your username):

.. code-block:: none

   # ==== Skipjack: base connection (the OTP is entered HERE, once) ====
   Host skipjack
       HostName login.arch.jhu.edu
       User YOUR_USER
       IdentityFile ~/.ssh/id_skipjack
       ControlMaster auto
       ControlPersist 8h
       ControlPath ~/.ssh/cm-%r@%h:%p

   # ==== Skipjack: compute node via VS Code ====
   Host skipjack-compute
       User YOUR_USER
       IdentityFile ~/.ssh/id_skipjack
       ForwardAgent yes
       StrictHostKeyChecking no
       UserKnownHostsFile /dev/null
       ProxyCommand ssh skipjack "~/vscode-jump.sh"

.. admonition:: Note
   :class: hint

   The resources (partition, cores, GPU, time) live in ``~/vscode-jump.sh``, which you generated
   in `Step 3 — Generate your launcher script on the cluster`_. The ``ProxyCommand`` just
   runs it — no arguments here.

The 3 most common mistakes
^^^^^^^^^^^^^^^^^^^^^^^^^^

1. **User must match** across both blocks and the ``ProxyCommand``. If ``Host skipjack``
   uses ``User jdoe``, then ``skipjack-compute`` must also use ``jdoe``. The
   ``ProxyCommand ssh skipjack "..."`` **must** point at the base alias (``skipjack``). If it
   points at someone else's alias, VS Code logs in as the wrong user.
2. The name in ``ProxyCommand`` (``ssh skipjack``) **must exactly match** the base block's ``Host``.
   If you rename the base block to ``skj``, the ProxyCommand must become ``ssh skj "..."``.
3. **IdentityFile** must point at the key you created in
   `Step 2 — Create an SSH key and register it on the cluster`_.


|

Step 5 — Increase the VS Code connection timeout
------------------------------------------------

Allocating a job can take from a few seconds up to several minutes depending on the queue. The
VS Code default (15 s) can expire before the node is ready, causing the error
*"Connection timed out during banner exchange"*. Raise it to 5 minutes:

1. In VS Code: ``Cmd/Ctrl + Shift + P`` — **Preferences: Open User Settings (JSON)**.
2. Add (inside the ``{ }`` braces):

.. code-block:: json

   "remote.SSH.connectTimeout": 300

3. Save.


|

.. _step 6 — Open the master session:

Step 6 — Open the master session (enter the OTP once)
-----------------------------------------------------

This is the step that makes the OTP be requested **only once** (in 8 hours).

In the **terminal on your computer**:

.. code-block:: bash

   ssh skipjack

Enter your **password** and then the **OTP code**. Once you reach the cluster prompt,
**leave this terminal open** (it keeps the "master session" alive for 8 hours — the
``ControlPersist`` value).

.. admonition:: Note
   :class: hint

   While this session is active, VS Code reuses it and does **not** ask for the OTP.


|
|

----


Step 7 — Connect from VS Code
-----------------------------

1. Click the **Remote Explorer** icon in the sidebar (a monitor), or use
   ``Cmd/Ctrl + Shift + P`` — **Remote-SSH: Connect to Host...**
2. Choose **skipjack-compute**.
3. If it asks for the remote platform, choose **Linux**.
4. Wait. You will see VS Code server install messages at the bottom. The first time takes a
   little longer (it downloads and installs the server into your home directory).

When it finishes, the bottom-left corner shows something like **SSH: skipjack-compute** —
you are connected to the compute node.

.. admonition:: Warning
   :class: warning

   **Do not** connect to the ``skipjack`` host directly in Remote-SSH — that would leave you
   on the login node. Always use ``skipjack-compute`` (or another compute host you create).


|
|

----


Common adjustments
##################

To change resources, **re-run** ``vscode_job.sh`` **on the cluster** with different flags. It
overwrites ``~/vscode-jump.sh`` and the change takes effect on your next VS Code connection —
your ``~/.ssh/config`` does not change.


More CPUs
---------

.. code-block:: bash

   vscode_job.sh -p med -t 08:00:00 --cpus-per-task=30


Session length
--------------

``-t HH:MM:SS`` is the time limit. E.g. ``-t 04:00:00`` = 4 hours. When the time runs out, Slurm
ends the job and VS Code disconnects (just reconnect).


GPU
---

GPU partitions on Skipjack: ``a100``, ``b200``, ``b300`` (8 GPUs per node) and ``h200`` (4 per node).
Generate a launcher with a GPU request:

.. code-block:: bash

   vscode_job.sh --out ~/vscode-gpu.sh -p a100 -t 02:00:00 --cpus-per-task=12 --gres=gpu:1

Then add a matching host to your ``~/.ssh/config``:

.. code-block:: none

   Host skipjack-gpu
       User YOUR_USER
       IdentityFile ~/.ssh/id_skipjack
       ForwardAgent yes
       StrictHostKeyChecking no
       UserKnownHostsFile /dev/null
       ProxyCommand ssh skipjack "~/vscode-gpu.sh"

.. admonition:: Warning
   :class: warning

   **Your account must be allowed to use GPUs.** If the job is rejected or gets stuck with
   a reason mentioning ``gres/gpu`` (e.g. ``AssocGrpGRES``), the account has GPUs disabled
   (``gres/gpu=0``).


Choosing the Slurm account
^^^^^^^^^^^^^^^^^^^^^^^^^^

By default the helper uses your default account. To use another, pass ``-A <account>`` when
generating:

.. code-block:: bash

   vscode_job.sh -A myaccount -p med -t 08:00:00

To list the accounts you can use:

.. code-block:: bash

   sacctmgr -n -P show assoc user=$(id -un) format=Account,QOS


|
|

----


Ending the session
##################

- **Closing the VS Code window** (or ``Cmd/Ctrl + Shift + P`` —
  **Remote: Close Remote Connection**) ends the connection and the **job is released
  automatically**.
- To confirm nothing is left running, in the cluster terminal:

  .. code-block:: bash

     sqme

  If the "vscode" job is somehow still there, cancel it with ``scancel -f <JOBID>``.

- The master session (the terminal from
  `Step 6 — Open the master session (enter the OTP once)`_) can stay open; it expires
  on its own after 8 hours of inactivity.


|
|

----


Troubleshooting
###############

+----------------------------------------------------+-------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| Symptom                                            | Likely cause                                    | Fix                                                                                                                   |
+====================================================+=================================================+=======================================================================================================================+
| VS Code asks for **(user@login…) Password:**       | The master session was not open, **or** the     | Open ``ssh skipjack`` in a terminal first (`Step 6 — Open the master session`_); check that the ``User`` fields match |
| and never connects                                 | ``User`` in the ``ProxyCommand``/base block is  | (`Step 4 — Configure ``~/.ssh/config`` on your computer`_)                                                            |
|                                                    | wrong                                           |                                                                                                                       |
+----------------------------------------------------+-------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| Asks for the **wrong user's** password             | The ``ProxyCommand`` points at someone else's   | Fix it to ``ProxyCommand ssh <YOUR_BASE_ALIAS> "..."``                                                                |
|                                                    | base alias                                      |                                                                                                                       |
+----------------------------------------------------+-------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| **Connection timed out during banner exchange**    | Allocation took longer than the VS Code timeout | Do `Step 5 — Increase the VS Code connection timeout`_ (increase ``connectTimeout: 300``)                             |
+----------------------------------------------------+-------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| **Permission denied (publickey,…)**                | Your key is not in the cluster's                | Redo `Step 2 — Create an SSH key and register it on the cluster`_; check the ``IdentityFile`` in the config           |
| on the compute node                                | ``authorized_keys``                             |                                                                                                                       |
+----------------------------------------------------+-------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| **could not determine your default Slurm account** | No detectable default account                   | Pass the account when generating: ``vscode_job.sh -A <account> ...``                                                  |
+----------------------------------------------------+-------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| Connects but drops after X hours                   | The job's time limit ended                      | Regenerate with a longer time: ``vscode_job.sh -t HH:MM:SS ...``                                                      |
+----------------------------------------------------+-------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``vscode_job.sh: command not found``               | ``/apps/helpers`` not on your ``PATH``          | Run it by full path: ``/apps/helpers/vscode_job.sh ...``                                                              |
|                                                    | in this shell                                   |                                                                                                                       |
+----------------------------------------------------+-------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+

|
|

**Quick diagnosis:** run the same thing VS Code does, but with full output, in your
computer's terminal:

.. code-block:: bash

   ssh -v skipjack-compute echo OK

The output shows exactly where it fails (tunnel? authentication? allocation?).


|
|

----


Windows
#######

The "enter the OTP once" trick relies on the OpenSSH ``ControlMaster`` feature, which is
**not supported by native Windows OpenSSH**. Two options:

- **Recommended:** use **WSL** (Windows Subsystem for Linux) and follow this guide exactly
  as on Linux, from the WSL terminal. Install the **WSL** extension in VS Code.
- **Without WSL:** it works, but the OTP will be requested on every new SSH connection
  (including the one VS Code opens). In that case, remove the
  ``ControlMaster``/``ControlPersist``/``ControlPath`` lines from the base block and be ready to
  type password + OTP when VS Code prompts (enable ``Remote.SSH: Show Login Terminal`` in
  settings so you can type it).


|
|

----


Appendix — How it works under the hood
######################################

The ``ProxyCommand`` for a compute host does three things when VS Code connects:

1. **ssh skipjack** — reuses the already-authenticated master session, so no OTP is
   needed. It lands on the login node.
2. **salloc ...** — asks Slurm for a compute node. The allocation stays alive as long as
   the connection is open.
3. **exec 3<>/dev/tcp/<node>/22** — opens a raw TCP socket from the login node
   to the allocated node's SSH port. Skipjack has no ``netcat``, so this uses the bash-native
   ``/dev/tcp`` device. VS Code's outer SSH then completes an end-to-end handshake to the
   compute node over that stream, authenticating with your key.

A few environment details the script/config handles for you:

- A non-interactive SSH does not load the Slurm environment, so the script prepends the
  Slurm ``bin`` directory to ``PATH``.
- The login node requires an OTP on every connection, so ``ControlMaster`` keeps a single
  authenticated session that every later connection reuses.
- The VS Code default connect timeout (15 s) is too short to wait for the Slurm queue, so
  it is raised to 180 s.

Full sequence of one connection:

.. mermaid::

   sequenceDiagram
       participant VS as VS Code (your PC)
       participant M as Master session (SSH)
       participant L as Login node
       participant S as Slurm
       participant C as Compute node

       Note over M,L: you ran "ssh skipjack" (password+OTP) and left it open
       VS->>L: ProxyCommand: ssh skipjack (reuses the master, no OTP)
       L->>S: salloc --account=... --partition=med ...
       S-->>L: job allocated on a node (e.g. csr048)
       L->>C: opens /dev/tcp to the node's port 22
       VS->>C: end-to-end SSH handshake (authenticates with your key)
       VS->>C: installs and starts the VS Code Server
       Note over VS,C: you work on the compute node
       VS-->>S: on disconnect, salloc exits and the job is released

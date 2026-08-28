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

You open VS Code, select a host such as ``skipjack-compute``, and VS Code automatically:

- requests a job from Slurm;
- opens an SSH connection to the allocated compute node through a Skipjack login node;
- runs the VS Code Server on the compute node.

When you close VS Code, **the job is released automatically**. You do not have to run
``salloc`` manually, look up the allocated node, or configure port forwarding.


|

How it works
############

.. mermaid::

   flowchart LR
       A["Your computer<br/>(VS Code)"] -->|"1. Password + OTP<br/>(once)"| B["Login node<br/>login.arch.jhu.edu"]
       B -->|"2. salloc<br/>(allocate a node)"| C["Slurm"]
       C --> D["Compute node<br/>e.g. csr048"]
       B -.->|"3. TCP tunnel<br/>to port 22"| D
       A ==>|"4. Separate SSH key authentication"| D
       A ==>|"5. VS Code Server runs HERE"| D

There are **two separate SSH authentication steps**:

1. **Your computer to the login node.** You enter your password and OTP once when you
   open the SSH master session. Later connections reuse it through SSH ``ControlMaster``.
2. **Your computer to the compute node.** The outer SSH connection authenticates directly
   to the allocated node using ``~/.ssh/id_skipjack``. The master session does **not**
   authenticate this second connection.

Consequently, an open master session prevents another login-node password/OTP prompt, but
it cannot compensate for a missing or mismatched compute-node public key. The exact public
key corresponding to ``~/.ssh/id_skipjack`` must be present in the cluster's
``~/.ssh/authorized_keys`` file.


|

Prerequisites
#############

.. list-table::
   :header-rows: 1
   :widths: 28 72

   * - Item
     - Detail
   * - **A Skipjack account**
     - Username, password, and **OTP** (6-digit code) already set up and working.
   * - **Working login**
     - You can run ``ssh YOUR_USER@login.arch.jhu.edu`` and sign in with password + OTP.
   * - **VS Code installed**
     - On your computer — https://code.visualstudio.com
   * - **A terminal**
     - Native on macOS or Linux. **Windows** users should see the `Windows`_ section.


.. admonition:: Throughout this guide
   :class: hint

   Replace **YOUR_USER** with your Skipjack username (for example, ``arochab1``).
   Run commands marked "on your computer" on your own computer, not in a Skipjack shell.


|

----

Steps to Configure VS Code
##########################

Step 1 — Install the Remote-SSH extension
-----------------------------------------

In VS Code:

1. Open the **Extensions** panel (the blocks icon, or ``Cmd/Ctrl + Shift + X``).
2. Search for **Remote - SSH** (published by Microsoft).
3. Click **Install**.

This also installs **Remote Explorer**, which you will use to select the SSH host.


|

Step 2 — Create and register the SSH key
----------------------------------------

Inside the tunnel, VS Code authenticates directly to the compute node using a dedicated
SSH key. The public key installed on Skipjack must match the private key selected by the
``IdentityFile`` setting exactly.

In a terminal **on your computer**, create the key if it does not already exist. Press Enter
at the passphrase prompts to create a passwordless key for non-interactive VS Code
connections:

.. code-block:: bash

   ssh-keygen -t ed25519 -f ~/.ssh/id_skipjack -C "vscode-skipjack"

.. admonition:: Do not overwrite an existing private key
   :class: warning

   If ``~/.ssh/id_skipjack`` already exists, do not run ``ssh-keygen`` over it unless you
   intentionally want to replace it. Replacing the private key changes its fingerprint and
   invalidates any previously installed public key.

Rebuild the ``.pub`` file from the **actual private key**. This prevents a stale
``id_skipjack.pub`` file from being copied to the cluster:

.. code-block:: bash

   ssh-keygen -y -f ~/.ssh/id_skipjack > ~/.ssh/id_skipjack.pub

Copy the public key to Skipjack:

.. code-block:: bash

   ssh-copy-id -f -i ~/.ssh/id_skipjack.pub YOUR_USER@login.arch.jhu.edu

The ``-f`` option ensures that the exact key is copied even if ``ssh-copy-id`` cannot reliably
test the key against the login service. The command asks for your password and OTP. If
``ssh-copy-id`` is unavailable, install the key manually using the public key derived from
the private key:

.. code-block:: bash

   ssh-keygen -y -f ~/.ssh/id_skipjack | \
     ssh YOUR_USER@login.arch.jhu.edu \
     'umask 077; mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys'

.. admonition:: Why this works on compute nodes
   :class: hint

   Your ``$HOME`` is shared by the login and compute nodes. A correctly installed key in
   ``~/.ssh/authorized_keys`` is therefore available to the compute-node SSH server too.

|

Step 3 — Generate your launcher script on the cluster
-----------------------------------------------------

A helper called ``vscode_job.sh`` is available on every node. It is installed in
``/apps/helpers`` and is normally already on your ``PATH``. Run it once with the Slurm
resources you want. It writes ``~/vscode-jump.sh``, which VS Code uses to allocate a job
and open the tunnel. To change resources later, run the helper again.

1. Connect to the cluster: ``ssh YOUR_USER@login.arch.jhu.edu``
2. Run ``vscode_job.sh`` with any ``salloc`` flags you need. Examples:

.. code-block:: bash

   # CPU session (partition "med"): 8 hours, 8 cores
   vscode_job.sh -p med -t 08:00:00 --cpus-per-task=8

   # GPU session (partition "a100"): 2 hours, 12 cores, 1 GPU
   vscode_job.sh -p a100 -t 02:00:00 --cpus-per-gpu=12 --gres=gpu:1

The helper reports where it wrote the launcher and prints the exact ``ProxyCommand`` line
for the next step:

.. code-block:: text

   Generated: /home/YOUR_USER/vscode-jump.sh
     salloc args: -p med -t 08:00:00 --cpus-per-task=8 --account=... --comment=accept_cost --job-name=vscode

   Next: on your computer, point a ~/.ssh/config compute host at it:

       ProxyCommand ssh skipjack "~/vscode-jump.sh"

You do **not** need to pass ``--account`` or ``--comment``. The helper supplies your default
account and the required billing comment. To use another account, pass ``-A <account>``.

.. admonition:: Want more than one profile?
   :class: hint

   For example, create separate CPU and GPU launchers. Use ``--out`` to select a different
   filename, then configure another SSH host for that launcher:

   .. code-block:: bash

      vscode_job.sh --out ~/vscode-gpu.sh -p a100 -t 02:00:00 --gres=gpu:1

Run ``vscode_job.sh --help`` to see all options.


|

Step 4 — Configure ``~/.ssh/config`` on your computer
-----------------------------------------------------

On **your computer**, open ``~/.ssh/config`` and add these blocks. Replace **YOUR_USER**
with your username:

.. code-block:: none

   # ==== Skipjack: base connection (password + OTP are entered HERE, once) ====
   Host skipjack
       HostName login.arch.jhu.edu
       User YOUR_USER
       IdentityFile ~/.ssh/id_skipjack
       ControlMaster auto
       ControlPersist 8h
       ControlPath ~/.ssh/cm-%r@%h:%p

   # ==== Skipjack: allocated compute node via VS Code ====
   Host skipjack-compute
       User YOUR_USER
       IdentityFile ~/.ssh/id_skipjack
       StrictHostKeyChecking no
       UserKnownHostsFile /dev/null
       ProxyCommand ssh skipjack "~/vscode-jump.sh"

``ForwardAgent`` is intentionally omitted. The outer SSH client uses ``IdentityFile``
directly, so agent forwarding is not required for this workflow.

.. admonition:: Note
   :class: hint

   The partition, CPU, GPU, memory, and time settings live in ``~/vscode-jump.sh``, generated
   in `Step 3 — Generate your launcher script on the cluster`_. The ``ProxyCommand`` runs
   that script without additional arguments.

The 4 most common configuration mistakes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. **The username must match.** ``User`` must be the same in both blocks. If the
   ``skipjack`` block uses ``User jdoe``, ``skipjack-compute`` must also use ``jdoe``.
2. **The base alias must match.** The name used by ``ProxyCommand`` must exactly match the
   base block's ``Host``. If you rename ``Host skipjack`` to ``Host skj``, use
   ``ProxyCommand ssh skj "~/vscode-jump.sh"``.
3. **IdentityFile must identify the correct private key.** It must point to the key created
   and registered in Step 2.
4. **A master session does not authenticate the compute node.** It only covers the login
   hop. The compute-node public key must still be installed and accepted independently.


|

Step 5 — Increase the VS Code connection timeout
------------------------------------------------

Allocating a job may take from a few seconds to several minutes. The VS Code default timeout
can expire before the node is ready, causing ``Connection timed out during banner exchange``.
Raise the timeout to 5 minutes:

1. In VS Code, open ``Cmd/Ctrl + Shift + P`` and select
   **Preferences: Open User Settings (JSON)**.
2. Add this setting inside the ``{ }`` braces:

.. code-block:: json

   "remote.SSH.connectTimeout": 300

3. Save the file.


|

.. _step 6 — Open the master session:

Step 6 — Open the master session (enter the OTP once)
-----------------------------------------------------

In a terminal **on your computer**, run:

.. code-block:: bash

   ssh skipjack

Enter your password and OTP. Once you reach the cluster prompt, leave the session open while
you start VS Code.

.. admonition:: Important distinction
   :class: warning

   This master session authenticates only the connection to ``login.arch.jhu.edu``. The
   subsequent connection to ``skipjack-compute`` is a separate end-to-end SSH connection
   authenticated by ``~/.ssh/id_skipjack``. If the compute-node key is rejected, opening or
   reopening the master session will not fix it.

|

Step 7 — Connect from VS Code
-----------------------------

1. Open the **Remote Explorer** icon, or use ``Cmd/Ctrl + Shift + P`` and select
   **Remote-SSH: Connect to Host...**
2. Choose **skipjack-compute**.
3. If prompted for the remote platform, choose **Linux**.
4. Wait for the VS Code Server to install and start. The initial connection takes longer.

When the connection is ready, the bottom-left corner displays something similar to
**SSH: skipjack-compute**.

.. admonition:: Warning
   :class: warning

   Do not select ``skipjack`` in Remote-SSH. That host is the login node. Always select
   ``skipjack-compute`` or another compute profile created from it.


|

----

Common adjustments
##################

To change resources, re-run ``vscode_job.sh`` **on the cluster** with different flags. It
overwrites the selected launcher, and the change applies to the next connection. Your local
``~/.ssh/config`` does not need to change.


More CPUs
---------

.. code-block:: bash

   vscode_job.sh -p med -t 08:00:00 --cpus-per-task=30


Session length
--------------

``-t HH:MM:SS`` is the time limit. For example, ``-t 04:00:00`` requests four hours. When
the time limit expires, Slurm ends the job and VS Code disconnects.


GPU
---

GPU partitions on Skipjack include ``a100``, ``b200``, ``b300`` (8 GPUs per node), and
``h200`` (4 GPUs per node). Generate a GPU launcher:

.. code-block:: bash

   vscode_job.sh --out ~/vscode-gpu.sh -p a100 -t 02:00:00 --cpus-per-task=12 --gres=gpu:1

Then add a matching host on your computer:

.. code-block:: none

   Host skipjack-gpu
       User YOUR_USER
       IdentityFile ~/.ssh/id_skipjack
       StrictHostKeyChecking no
       UserKnownHostsFile /dev/null
       ProxyCommand ssh skipjack "~/vscode-gpu.sh"

.. admonition:: Warning
   :class: warning

   Your account must be allowed to use GPUs. If a job is rejected or remains pending with a
   reason mentioning ``gres/gpu`` (for example, ``AssocGrpGRES``), the selected Slurm account
   may have GPUs disabled (``gres/gpu=0``).


Choosing the Slurm account
^^^^^^^^^^^^^^^^^^^^^^^^^^

The helper uses your default Slurm account unless you provide another one:

.. code-block:: bash

   vscode_job.sh -A myaccount -p med -t 08:00:00

List the accounts available to your user with:

.. code-block:: bash

   sacctmgr -n -P show assoc user=$(id -un) format=Account,QOS


|

----

Ending the session
##################

- Closing the VS Code window, or selecting ``Cmd/Ctrl + Shift + P`` —
  **Remote: Close Remote Connection**, ends the SSH connection and releases the job.
- To check for remaining jobs, run this on the cluster:

  .. code-block:: bash

     sqme

  If a ``vscode`` job remains, cancel it with ``scancel -f <JOBID>``.
- The master connection can remain open and expires after the configured idle period. To
  close it immediately from your computer, run:

  .. code-block:: bash

     ssh -O exit skipjack


|

----

Troubleshooting
###############

.. list-table::
   :header-rows: 1
   :widths: 28 31 41

   * - Symptom
     - Likely cause
     - Fix
   * - Password or OTP prompt for ``YOUR_USER@login.arch.jhu.edu``
     - The master connection is not open, or the base alias/username is wrong.
     - Open ``ssh skipjack`` and leave it running; verify the ``Host skipjack`` and ``User``
       settings.
   * - Password prompt for ``YOUR_USER@skipjack-compute``
     - The public key used by VS Code is not correctly registered on Skipjack.
     - On your computer, rerun the two ``ssh-keygen -y`` and ``ssh-copy-id -f`` commands
       from Step 2, then reconnect.
   * - ``Permission denied (publickey,...)`` on the compute node
     - The compute-node public key is missing or does not match ``IdentityFile``.
     - Repeat Step 2 and confirm that ``IdentityFile`` is ``~/.ssh/id_skipjack``.
   * - Password prompt for the wrong username
     - ``User`` differs between blocks, or ``ProxyCommand`` points to another base alias.
     - Make the usernames match and use ``ProxyCommand ssh skipjack ...``.
   * - ``Connection timed out during banner exchange``
     - Allocation took longer than the VS Code timeout.
     - Set ``remote.SSH.connectTimeout`` to ``300``.
   * - ``could not determine your default Slurm account``
     - The helper could not detect a default account.
     - Regenerate with ``vscode_job.sh -A <account> ...``.
   * - Connection drops after a fixed number of hours
     - The Slurm time limit expired.
     - Regenerate the launcher with a longer ``-t HH:MM:SS`` value.
   * - ``vscode_job.sh: command not found``
     - ``/apps/helpers`` is absent from ``PATH`` in that shell.
     - Run ``/apps/helpers/vscode_job.sh ...``.

If these fixes do not resolve the problem, contact ARCH support with a screenshot or the
exact error message. Never send the contents of ``~/.ssh/id_skipjack``.


|

----

Windows
#######

The "enter the OTP once" method relies on OpenSSH ``ControlMaster``, which is not supported
by native Windows OpenSSH.

- **Recommended:** use **WSL** (Windows Subsystem for Linux), run all terminal commands from
  WSL, and install the VS Code **WSL** extension.
- **Without WSL:** remove ``ControlMaster``, ``ControlPersist``, and ``ControlPath`` from the
  base block. The proxy connection may request password + OTP each time. Enable
  **Remote.SSH: Show Login Terminal** so VS Code can display those prompts. Compute-node
  authentication still requires the registered ``id_skipjack`` public key.

If ``ssh-copy-id`` is unavailable, use the manual installation command from Step 2.


|

----

Appendix — How it works under the hood
######################################

The ``ProxyCommand`` for a compute host performs three transport steps:

1. **ssh skipjack** reuses the authenticated master connection to
   ``login.arch.jhu.edu``. This avoids another login-node password and OTP prompt.
2. **salloc ...** requests a compute node. The allocation stays alive while the proxied
   connection remains open.
3. **exec 3<>/dev/tcp/<node>/22** opens a raw TCP stream from the login node to the allocated
   node's SSH port. Skipjack does not provide ``netcat`` for this workflow, so the generated
   launcher uses Bash ``/dev/tcp``.

The local outer SSH client then performs a separate end-to-end handshake with the compute
node through that stream. It authenticates using ``~/.ssh/id_skipjack`` and starts the VS
Code Server there.

Additional details:

- A non-interactive SSH command does not load the usual Slurm environment, so the generated
  launcher prepends the Slurm ``bin`` directory to ``PATH``.
- ``ControlMaster`` shares the already-authenticated login-node connection. It does not
  forward or reuse authentication for the compute-node SSH server.
- The VS Code connection timeout is raised to **300 seconds** so the client can wait for the
  Slurm allocation.
- Agent forwarding is not required because the configured local ``IdentityFile`` signs the
  compute-node authentication directly.

Full sequence of one connection:

.. mermaid::

   sequenceDiagram
       participant VS as VS Code / local SSH client
       participant M as Master session
       participant L as login.arch.jhu.edu
       participant S as Slurm
       participant C as Compute node

       Note over M,L: User opens ssh skipjack and enters password + OTP
       VS->>M: ProxyCommand starts ssh skipjack
       M->>L: Reuse authenticated ControlMaster connection
       L->>S: salloc --account=... --partition=med ...
       S-->>L: Allocate a node (for example, csr048)
       L->>C: Open /dev/tcp/<node>/22
       VS->>C: End-to-end SSH handshake through the TCP stream
       VS->>C: Offer local id_skipjack public key
       C-->>VS: Accept matching authorized_keys entry
       VS->>C: Install and start VS Code Server
       Note over VS,C: User works on the allocated compute node
       VS-->>S: On disconnect, the launcher exits and Slurm releases the job

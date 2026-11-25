.. _cryosparc-tut tutorial:

CryoSPARC on Skipjack: tutorial
================================

.. contents::
   :local:
   :depth: 2

Tutorial version of the lab guide in ``README-user.md``, which is the text published at
https://docs.arch.jhu.edu/en/latest/3_Tutorials/specialized/Tutorial_CryoSPARC.html.

Each lab runs its own CryoSPARC on Skipjack, with its own license, users, database and project
directories. ARCH installs it and runs it, as the lab's CryoSPARC account; the lab works in its web
interface.

.. _cryosparc-tut-find-your-tutorial:

Find your tutorial
##################

+---------------------------+------------------------------------------------------------------+---------------------------------------------------------------------------+
| You are                   | You want to                                                      | Follow                                                                    |
+===========================+==================================================================+===========================================================================+
| The PI or the lab manager | get CryoSPARC for your lab on Skipjack                           | :ref:`Tutorial 1 <cryosparc-tut-tutorial-1-get-cryosparc-for-your-lab>`   |
+---------------------------+------------------------------------------------------------------+---------------------------------------------------------------------------+
| Anyone in the lab         | open CryoSPARC and run jobs                                      | :ref:`Tutorial 2 <cryosparc-tut-tutorial-2-open-cryosparc-and-run-a-job>` |
+---------------------------+------------------------------------------------------------------+---------------------------------------------------------------------------+
| The PI or the lab manager | manage logins, and ask ARCH to start, stop, back up or update it | :ref:`Tutorial 3 <cryosparc-tut-tutorial-3-manage-cryosparc>`             |
+---------------------------+------------------------------------------------------------------+---------------------------------------------------------------------------+
| The PI or the lab manager | bring projects from Rockfish                                     | :ref:`Tutorial 4 <cryosparc-tut-tutorial-4-move-from-rockfish>`           |
+---------------------------+------------------------------------------------------------------+---------------------------------------------------------------------------+

A lab coming from Rockfish does Tutorial 1 first, then Tutorial 4. Each tutorial is a list of steps to
follow in order. Settings, the lab's account and error messages are explained once, in the
:ref:`Reference <cryosparc-tut-reference>` at the end.



|

|

----


.. _cryosparc-tut-before-any-tutorial:

Before any tutorial
###################

**Names to replace** in the commands:

+------------------------+--------------------------------------------------------------------------------+
| In this guide          | Means                                                                          |
+========================+================================================================================+
| ``<pi>``               | the JHED of the PI whose lab this CryoSPARC belongs to                         |
+------------------------+--------------------------------------------------------------------------------+
| ``<you>``              | your own username                                                              |
+------------------------+--------------------------------------------------------------------------------+
| ``ext-<pi>-cryosparc`` | the lab's CryoSPARC account. CryoSPARC runs as it; nobody logs in with it, and |
|                        | nobody in the lab acts as it                                                   |
+------------------------+--------------------------------------------------------------------------------+
| ``<pi>_cryosparc``     | the lab's Slurm account, which pays for CryoSPARC's jobs                       |
+------------------------+--------------------------------------------------------------------------------+
| ``<host>``             | the node your lab's CryoSPARC master runs on: ``csr091`` for now               |
+------------------------+--------------------------------------------------------------------------------+
| ``<port>``             | the port your lab's CryoSPARC answers on. ARCH assigns it                      |
+------------------------+--------------------------------------------------------------------------------+

**Where to type.** On a Skipjack login node, unless the step names another place.

**Who runs what.** Nobody in the lab acts as ``ext-<pi>-cryosparc`` (no ``sudo``). The commands that run
as it (``cryosparc.sh`` ``start``, ``stop``, ``status``, ``backup``, ``update`` and the lab's settings) are ARCH's:
ask on a ticket. Everything these tutorials give you to do, you do as yourself: in ColdFront, in
CryoSPARC's web interface, or on a login node.

**Working for more than one PI.** An account can belong to several PIs' groups, and each lab has its
own CryoSPARC: its own account, host, port and logins. Use the host, port and login of the lab whose
project you work on. When you run ``config`` for a lab (Tutorial 1, step 5) and are in several PIs'
groups, name the lab: ``CS_LAB=<pi> /apps/helpers/cryosparc.sh config``. Without it you get
``you are in the groups of several labs``.



|

|

----


.. _cryosparc-tut-tutorial-1-get-cryosparc-for-your-lab:

Tutorial 1: Get CryoSPARC for your lab
######################################

Done once per lab. Steps 1 to 5 are yours; in step 6 ARCH installs it. Step 2 waits for ARCH.

.. _cryosparc-tut-step-1-get-a-license-id:

Step 1: Get a license ID
------------------------

*Who: the PI.*

Request a license from Structura at https://cryosparc.com/download (free for academic use). You
receive a license ID. Treat it as a password: never put it in a ticket or an e-mail.

**Coming from Rockfish?** Request a second license ID the same way, for Skipjack. CryoSPARC does not
allow one license ID on two running instances, and during the move both clusters run.

.. _cryosparc-tut-step-2-create-the-coldfront-project:

Step 2: Create the ColdFront project
------------------------------------

*Who: the PI, or the manager on the PI's behalf.*

1. In ColdFront: **Projects → Create Project**, with abbreviation ``cryosparc`` and an IO Number to pay
   for it.
2. Wait until ARCH activates the project.
3. On that project: **Request Resource Allocation** for the cluster.
4. Wait until ARCH approves it.

Result: the Slurm account ``<pi>_cryosparc``. Your CryoSPARC jobs are charged to it.

.. _cryosparc-tut-step-3-register-the-labs-cryosparc-account:

Step 3: Register the lab's CryoSPARC account
--------------------------------------------

*Who: the lab manager.*

1. Fill in the external-collaborator form at https://portal.arch.jhu.edu/user/jhu/register/:

   +-----------------------+-----------------------------------------------------------------------------+
   | Field                 | What to write                                                               |
   +=======================+=============================================================================+
   | Username              | ``ext-<pi>-cryosparc``                                                      |
   +-----------------------+-----------------------------------------------------------------------------+
   | First name, Last name | ``CryoSPARC``, your PI's last name                                          |
   +-----------------------+-----------------------------------------------------------------------------+
   | Email                 | a new mailbox **outside the JHU domains**, used only for this account (e.g. |
   |                       | ``<lab>.cryosparc@gmail.com``), kept by the PI or the manager               |
   +-----------------------+-----------------------------------------------------------------------------+
   | Password              | a strong one, kept by the manager. Nobody logs in with it                   |
   +-----------------------+-----------------------------------------------------------------------------+

2. Add the account to the ``cryosparc`` project and its allocation, like any member:
   **Project Detail → Add Users**. Until then the account stays inactive.

.. _cryosparc-tut-step-4-open-the-ticket:

Step 4: Open the ticket
-----------------------

*Who: the PI or the manager.*

Open a ticket on the `ARCH helpdesk <https://helpdesk.arch.jhu.edu/tickets/submit/>`__ or e-mail
``Arch@jh.edu`` (Schmidt Sciences labs:
`their helpdesk <https://helpdesk.schmidtsciences.jhu.edu/tickets/submit/>`__ or ``SSCI@jh.edu``). Choose
**"I need software installed, or a module is missing or broken"** and fill in:

+---------------------------+----------------------------------------------------------------------------------+
| Field                     | What to write                                                                    |
+===========================+==================================================================================+
| What do you need?         | A CryoSPARC master for my lab                                                    |
+---------------------------+----------------------------------------------------------------------------------+
| Software name and version | CryoSPARC, and the version or "latest" (``/apps/helpers/cryosparc.sh versions``  |
|                           | lists them)                                                                      |
+---------------------------+----------------------------------------------------------------------------------+
| Website or download link  | https://cryosparc.com                                                            |
+---------------------------+----------------------------------------------------------------------------------+
| License                   | academic license from Structura, held by the PI. **Never the license ID itself** |
+---------------------------+----------------------------------------------------------------------------------+
| What will you use it for? | your project, in a sentence                                                      |
+---------------------------+----------------------------------------------------------------------------------+
| Who will use it?          | the lab's CryoSPARC admin (the PI or the manager) with their e-mail, which       |
|                           | becomes the admin's login; the members' JHEDs                                    |
+---------------------------+----------------------------------------------------------------------------------+
| Special requirements      | the GPU partition you need (e.g. ``a100``); that ``ext-<pi>-cryosparc`` is       |
|                           | registered (step 3); whether you are moving from Rockfish                        |
+---------------------------+----------------------------------------------------------------------------------+

You can do step 5 now, without waiting for an answer.

.. _cryosparc-tut-step-5-type-your-license-id:

Step 5: Type your license ID
----------------------------

*Who: the PI or the manager, as yourself (no* ``sudo``\ *), on a login node.*

The license ID reaches ARCH through a settings file in your own home, never through the ticket:

.. code-block:: bash

   /apps/helpers/cryosparc.sh config

``config`` asks 37 settings, one per line, with the value it offers in brackets. Type the two below and
press **Enter** at every other line; ARCH types the rest of your lab's settings at install (step 6):

+-----------------+--------------------------------------------------------------------------------+
| Prompt          | Type                                                                           |
+=================+================================================================================+
| ``LICENSE_ID``  | your license ID (for a lab coming from Rockfish: the second one)               |
+-----------------+--------------------------------------------------------------------------------+
| ``MASTER_HOST`` | ``csr091``. The brackets show the login node you are on, which ``config`` does |
|                 | not accept: after three more tries it exits without saving                     |
+-----------------+--------------------------------------------------------------------------------+

This is the whole session. What you type is after the colon; a line that ends at the colon is Enter:

.. code-block:: text

   Enter keeps the value in [brackets]; - clears it.
   NAME [<pi>]:
   MODE [cluster]:
   VERSION [5.0.7]:
   LICENSE_ID []: <your license ID>
   DEST [/scratch/<affiliation>/<pi>/cryosparc]:
   DBPATH [/scratch/<affiliation>/<pi>/cryosparc/database]:
   SSDPATH [/scratch/<affiliation>/<pi>/cryosparc/cache]:
   PROJECT_DIRS [/scratch/<affiliation>/<pi>/cryosparc/projects]:
   PORT [25000]:
   MASTER_HOST [<the login node you are on>]: csr091
   MASTER_PARTITION [cryosparc]:
   MASTER_RESERVATION []:
   MASTER_QOS [cryosparc]:
   MASTER_CPUS [4]:
   MASTER_MEM [24G]:
   MASTER_TIME []:
   EMAIL [<you>@jhu.edu]:
   ADMIN_USER [admin]:
   FIRSTNAME [admin]:
   LASTNAME [<pi>]:
   SRC_DIR [/home/<affiliation>/<you>/.cryosparc/src]:
   BASE_SIF [/apps/software/cryosparc/cryosparc-base.sif]:
   STATE_DIR [/scratch/<affiliation>/<pi>/cryosparc/state]:
   OVERLAY_MODE [dir]:
   PARTITION [a100]:
   CPU_PARTITION [med]:
   ACCOUNT [<pi>_cryosparc]:
   ACCEPT_COST [no]:
   RESERVATION []:
   WALLTIME [72:00:00]:
   SLURM_MODE [bind]:
   SLURM_SUBMIT_HOST [<the login node you are on>]:
   LOGIN_HOST [login01.arch.jhu.edu]:
   APPTAINER_MODULE []:
   RUN_USER [<you>]:
   RUN_GROUP [<pi>]:
   TMP_DIR [/tmp/cryosparc-<pi>-<you>]:
   ==> Config saved: /home/<affiliation>/<you>/.cryosparc/<pi>.ini
   No CryoSPARC is installed for <pi> yet (...). ARCH sets the lab up (init), which writes
   /scratch/<affiliation>/<pi>/cryosparc/state/master.sbatch and starts the master the first time, as the account the lab runs under.

Schmidt Sciences labs see ``login01.schmidtsciences.jhu.edu`` at ``LOGIN_HOST``.

The file is ``~/.cryosparc/<pi>.ini`` in **your** home, mode 600: nobody else in the lab can read it.
ARCH takes only the license ID from it, so the values you left with Enter do not matter.

The last lines, ``Config saved`` and ``No CryoSPARC is installed for <pi> yet``, are expected. Check what
you typed:

.. code-block:: bash

   /apps/helpers/cryosparc.sh show | grep -E 'LICENSE_ID|MASTER_HOST'     # LICENSE_ID: its first 8 characters

.. _cryosparc-tut-step-6-tell-arch-and-wait-for-the-install:

Step 6: Tell ARCH and wait for the install
------------------------------------------

*Who: the PI or the manager. You run nothing in this step: only ARCH can install.*

1. Reply on the ticket of step 4. Do not open a new one. Write, without the license ID:

   .. code-block:: text

      The license ID is in ~/.cryosparc/<pi>.ini of my account, <you>, saved with config.
      Please install CryoSPARC <version>.

2. Wait for ARCH's answer on that ticket.
3. ARCH's answer brings your ``<host>``, your ``<port>``, the lab's directories (``DEST``, ``PROJECT_DIRS``)
   and, once, the password of your lab's first CryoSPARC admin. Its login is the e-mail you gave in
   the ticket.

ARCH reads the license ID from your file, types it and the rest of your lab's settings (port, host,
partitions, the admin's e-mail, ``ACCEPT_COST=yes``) into the lab account's settings, installs CryoSPARC
and starts the master.

.. _cryosparc-tut-step-7-check-it-and-change-the-password:

Step 7: Check it and change the password
----------------------------------------

*Who: the PI or the manager, after ARCH's answer.*

1. The master runs:

   .. code-block:: bash

      squeue -u ext-<pi>-cryosparc -n cryosparc-<pi>     # one line, state R, on <host>

2. Open CryoSPARC (:ref:`Tutorial 2 <cryosparc-tut-tutorial-2-open-cryosparc-and-run-a-job>`) and log in with the admin's
   e-mail and the password ARCH sent.
3. Change that password with a reset token
   (:ref:`A forgotten or first password <cryosparc-tut-a-forgotten-or-first-password>`).
4. Delete your copy of the settings: it holds the license ID, which ARCH now has.

   .. code-block:: bash

      rm ~/.cryosparc/<pi>.ini

Next: create your members' logins (:ref:`Add a lab member <cryosparc-tut-add-a-lab-member>`).



|

|

----


.. _cryosparc-tut-tutorial-2-open-cryosparc-and-run-a-job:

Tutorial 2: Open CryoSPARC and run a job
########################################

*Who: everyone in the lab.* You need your lab's ``<host>`` and ``<port>`` and your CryoSPARC login (an
e-mail and a password). Both come from your PI or lab manager. If you work for more than one PI, each
lab has its own host, port and login: use the ones of the lab whose project you are working on.

.. _cryosparc-tut-step-1-open-the-web-interface:

Step 1: Open the web interface
------------------------------

Choose one:

- **OnDemand** (nothing to install): at https://ood.arch.jhu.edu (Schmidt Sciences labs:
  https://ood.schmidtsciences.jhu.edu) go to **Interactive Apps → CryoSPARC**, pick your lab, click
  **Launch**, then **Launch CryoSPARC** on the session card. Firefox opens on your lab's CryoSPARC.
  Closing Firefox ends the session.
- **SSH tunnel**, from your workstation. Keep this command running and open
  ``http://localhost:<port>`` in your browser:

  .. code-block:: bash

     ssh -N -L <port>:<host>:<port> <you>@login01.arch.jhu.edu

  Schmidt Sciences labs use ``login01.schmidtsciences.jhu.edu``.

.. _cryosparc-tut-step-2-log-in:

Step 2: Log in
--------------

Use your CryoSPARC e-mail and password. This is not your JHED login. If you have none, ask your lab's
CryoSPARC admin (:ref:`Add a lab member <cryosparc-tut-add-a-lab-member>`); if you forgot it, reset it with a token
(:ref:`A forgotten or first password <cryosparc-tut-a-forgotten-or-first-password>`).

.. _cryosparc-tut-step-3-create-a-project-and-run-a-job:

Step 3: Create a project and run a job
--------------------------------------

1. Create new projects under your lab's project directory, by default
   ``/scratch/<affiliation>/<pi>/cryosparc/projects``. CryoSPARC sees only your lab's CryoSPARC
   directory and its project directories, so the raw data you import must be there too. Your PI or
   manager can tell you the exact paths (``DEST`` and ``PROJECT_DIRS``, in ARCH's install answer).
2. In the job builder, queue the job on the lane ``slurm-<partition>`` (for example ``slurm-a100``).
   Jobs that ask for GPUs go to that partition; CPU-only jobs go to a CPU partition on their own.

Jobs run in Slurm as the user ``ext-<pi>-cryosparc``, with the name ``cs_<project>_<job>``:

.. code-block:: bash

   squeue -u ext-<pi>-cryosparc

**The page does not open, or OnDemand says "nothing answers"?** The master is stopped
(``squeue -u ext-<pi>-cryosparc -n cryosparc-<pi>`` prints nothing). Your PI or manager asks ARCH to start
it (:ref:`Start, stop, check <cryosparc-tut-start-stop-check>`). Other errors:
:ref:`When something fails <cryosparc-tut-when-something-fails>`.



|

|

----


.. _cryosparc-tut-tutorial-3-manage-cryosparc:

Tutorial 3: Manage CryoSPARC
############################

*Who: the PI and the lab manager.* ARCH runs every command that acts as the lab's account: you ask on a
ticket (Tutorial 1, step 4, has the addresses), never with the license ID in it. What you do yourself
happens in CryoSPARC's web interface.

.. _cryosparc-tut-start-stop-check:

Start, stop, check
------------------

CryoSPARC's master runs as a Slurm job of the lab's account, on your lab's ``<host>``. It has no time
limit of its own and keeps running: after a node failure it comes back on the same host by itself, and
ARCH brings it back after a maintenance or when it reaches the time limit of the partition it runs on.

Check it, as yourself:

.. code-block:: bash

   squeue -u ext-<pi>-cryosparc -n cryosparc-<pi>      # state R: running on <host>; nothing: stopped

To stop it, restart it or start it again, open a ticket: ARCH runs ``cryosparc.sh stop``, ``restart`` or
``start`` as the lab's account. ``start`` ends when CryoSPARC answers at ``http://<host>:<port>``.

.. _cryosparc-tut-add-a-lab-member:

Add a lab member
----------------

In the web interface, logged in as a CryoSPARC admin of your lab: click your user name, then **Admin**,
**User Management**. Create a login for the member there: an e-mail, a username, a first and last
name, and a first password you give them. Make it an admin there too if that person should manage logins.
CryoSPARC's guide:
`user management <https://guide.cryosparc.com/setup-configuration-and-management/software-system-guides/tutorial-user-management>`__.

.. _cryosparc-tut-a-forgotten-or-first-password:

A forgotten or first password
-----------------------------

CryoSPARC never e-mails a reset link or token. The token goes through a CryoSPARC admin of your lab:

1. On the login page: **Reset Password → I need a reset token**, with the login's e-mail.
2. An admin, logged in, reads the token in **Admin → User Management** and passes it on. For an admin's
   own password, keep one window logged in and request the token from a private window.
3. On the login page: **Reset Password → I have a reset token**, with the e-mail, the token and the new
   password.

Change the admin password ARCH sent you at install this way. If no admin of your lab can log in any
more, ARCH resets one from the command line: open a ticket.

.. _cryosparc-tut-back-up-the-database:

Back up the database
--------------------

ARCH takes a backup as the lab's account, with the master running: ask on a ticket. It is a
``cryosparc_backup_<date>.archive`` file in ``<DEST>/backups``. The backup is the database only (users,
projects, jobs). Your project directories are your data and are not copied.

**Restoring a backup** replaces the whole database. Open a ticket with the path of the ``.archive`` file:
ARCH restores it with you.

.. _cryosparc-tut-update-cryosparc:

Update CryoSPARC
----------------

.. code-block:: bash

   /apps/helpers/cryosparc.sh versions     # versions available here, as yourself

To move your lab to a version, open a ticket: ARCH takes a backup, then runs ``update <version>`` as the
lab's account (it stops the master, switches version, starts it again). Updates go forward only: the
first start on a newer version migrates your database, and an older version will not start on it.

.. _cryosparc-tut-change-a-setting:

Change a setting
----------------

The lab's settings are ARCH's to change (``config``, as the lab's account). Open a ticket with the setting
and its new value, never the license ID. Every setting is described in :ref:`Settings <cryosparc-tut-settings>`. ARCH then
applies the change:

+--------------------------------------------------+---------------------------------------------------------------------+
| A change of                                      | ARCH runs                                                           |
+==================================================+=====================================================================+
| ``PROJECT_DIRS`` (a new project directory)       | ``restart``, then ``lane``                                          |
+--------------------------------------------------+---------------------------------------------------------------------+
| ``PARTITION``, ``CPU_PARTITION``, ``ACCOUNT``,   | ``lane``                                                            |
| ``ACCEPT_COST``, ``RESERVATION``, ``WALLTIME``   |                                                                     |
+--------------------------------------------------+---------------------------------------------------------------------+
| ``MASTER_CPUS``, ``MASTER_MEM``, ``MASTER_TIME`` | ``restart``                                                         |
+--------------------------------------------------+---------------------------------------------------------------------+
| ``LICENSE_ID`` (a new license)                   | you type it with ``config`` as yourself (:ref:`Tutorial 1, step 5   |
|                                                  | <cryosparc-tut-step-5-type-your-license-id>`); ARCH copies it, then |
|                                                  | ``restart``                                                         |
+--------------------------------------------------+---------------------------------------------------------------------+



|

|

----


.. _cryosparc-tut-tutorial-4-move-from-rockfish:

Tutorial 4: Move from Rockfish
##############################

*Who: the PI or the lab manager.* Rockfish is being retired, so each lab's CryoSPARC moves to Skipjack.

**Before you start**

- Your lab's CryoSPARC exists on Skipjack (:ref:`Tutorial 1 <cryosparc-tut-tutorial-1-get-cryosparc-for-your-lab>`) and
  ``squeue -u ext-<pi>-cryosparc -n cryosparc-<pi>`` shows it running.
- Its license ID is not the one Rockfish uses (Tutorial 1, step 1).
- You have two terminals open: one on Rockfish, one on Skipjack.
- On Rockfish, use only ``cryosparcm``. The ``cryosparc.sh`` found there is an old installer with the same
  name: do not run it. It asks for a license ID as if nothing were installed; your instance is fine.

**Choose a route**

+-----------------------+------------------------------------------------------------+--------------------------------------------------------------+
|                       | Route A: the lab, with its database                        | Route B: one project, without the database                   |
+=======================+============================================================+==============================================================+
| Brings                | your CryoSPARC users and passwords, and your projects with | one project. It gets a new number here; its job numbers stay |
|                       | their numbers                                              |                                                              |
+-----------------------+------------------------------------------------------------+--------------------------------------------------------------+
| The Skipjack database | **is replaced.** Use this route on a new Skipjack lab with | is not touched. Use this route when the lab already works    |
|                       | nothing to keep                                            | here                                                         |
+-----------------------+------------------------------------------------------------+--------------------------------------------------------------+
| Needs ARCH            | one ticket: the landing folders (step 7) and the database  | the landing folders, once per lab (step 7)                   |
|                       | (step 12)                                                  |                                                              |
+-----------------------+------------------------------------------------------------+--------------------------------------------------------------+
| On Rockfish           | you archive the projects                                   | you detach the project                                       |
+-----------------------+------------------------------------------------------------+--------------------------------------------------------------+

.. _cryosparc-tut-route-a-move-the-lab-with-its-database:

Route A: move the lab with its database
---------------------------------------

+----------+--------------------+------+-----------------------------------------------------------+
| Steps    | Where              | Who  | What                                                      |
+==========+====================+======+===========================================================+
| 1 to 5   | Rockfish           | you  | check the version, find the paths, archive, back up       |
+----------+--------------------+------+-----------------------------------------------------------+
| 6        | Skipjack           | you  | find your directory                                       |
+----------+--------------------+------+-----------------------------------------------------------+
| 7        | Skipjack           | ARCH | create the landing folders                                |
+----------+--------------------+------+-----------------------------------------------------------+
| 8        | Rockfish           | you  | copy the backup, the raw data and the project             |
+----------+--------------------+------+-----------------------------------------------------------+
| 9 to 11  | Skipjack           | you  | check the copy, give the group write access, re-point the |
|          |                    |      | links                                                     |
+----------+--------------------+------+-----------------------------------------------------------+
| 12       | Skipjack           | ARCH | restore the database                                      |
+----------+--------------------+------+-----------------------------------------------------------+
| 13 to 16 | Skipjack, Rockfish | you  | unarchive, check, run a test job, finish                  |
+----------+--------------------+------+-----------------------------------------------------------+

Nothing changes on Rockfish until step 4. Steps 2, 3, 4, 8, 9, 10, 11 and 13 are done once per project;
the others once per lab.

.. _cryosparc-tut-step-1-check-the-version-on-rockfish:

Step 1: Check the version on Rockfish
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Rockfish terminal.** Log in to Rockfish with the account that runs your lab's CryoSPARC there, then
go to the host of its master:

.. code-block:: bash

   ssh devcryo
   cryosparcm status | grep -i version

**Skipjack:** your lab runs the version ARCH installed (its answer in Tutorial 1, step 6).

The Rockfish version must be the same as the Skipjack one, or older. If Rockfish runs version 4, stop
here and open a ticket: that jump has not been tested.

.. _cryosparc-tut-step-2-find-the-projects-directory:

Step 2: Find the project's directory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Rockfish terminal:**

.. code-block:: bash

   cryosparcm icli

At the ``In [1]:`` prompt, paste this line and press Enter twice:

.. code-block:: python

   for p in api.projects.find(): print(p.uid, p.project_dir, "| archived" if p.archived else "", "| detached" if p.detached else "", "|", p.title)

Each line is a project: its number, its directory, its title.

.. code-block:: text

   P4 /data/<...>/projects/CS-my-project  | My project

Write down the number (``P4``) and the directory, type ``exit``, then:

.. code-block:: bash

   RF_P=<the project directory>
   du -sh $RF_P; ls -l $RF_P/project.json          # its size; project.json must exist

.. _cryosparc-tut-step-3-find-the-raw-data:

Step 3: Find the raw data
^^^^^^^^^^^^^^^^^^^^^^^^^

The project holds links to your raw data (movies, gain references). This prints where they point:

.. code-block:: bash

   find $RF_P -type l -printf '%l\n' | sed 's|/[^/]*$||' | sort | uniq -c | sort -rn | head

.. code-block:: text

        21 /vast/<...>/datasets/my_dataset

Each line is a number of links and the directory they point to: your raw data.

.. code-block:: bash

   RF_RAW=<that directory>
   du -sh $RF_RAW; ls $RF_RAW | wc -l              # size and number of files: note them for step 9
   find $RF_P -xtype l | wc -l                     # links already broken on Rockfish: must be 0

- Several lines under one common directory: use that common directory as ``RF_RAW``.
- Several unrelated directories: repeat the raw-data line of step 8 and step 11 for each.
- No line at all: the project has no links. Skip the raw data in step 8, and step 11.

.. _cryosparc-tut-step-4-archive-the-project-on-rockfish:

Step 4: Archive the project on Rockfish
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the **Rockfish web interface**:

1. Make sure no job of the project is running or queued.
2. Open the project, then **Actions → Archive Project**.

From now on, do not work on this project on Rockfish. The way back is **Unarchive** there.

Check in the Rockfish terminal. Both files exist, and the listing of step 2 now shows ``| archived``:

.. code-block:: bash

   ls -l $RF_P/cs.lock $RF_P/project.json

Moving several projects? Do steps 2 to 4 for each one before step 5.

.. _cryosparc-tut-step-5-back-up-the-rockfish-database:

Step 5: Back up the Rockfish database
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Rockfish terminal**, after every project you move is archived:

.. code-block:: bash

   RF_B=<a directory of yours on Rockfish>/cryosparc-backup; mkdir -p $RF_B
   cryosparcm database backup -o $RF_B
   chmod 640 $RF_B/cryosparc_*                     # these files hold password hashes
   RF_BK=$(ls -t $RF_B/cryosparc_backup_*.archive | head -1); echo $RF_BK

``echo`` prints the backup file, ``cryosparc_backup_<date>.archive``. A ``cryosparc_instance_config_<date>.tar``
next to it is not needed.

.. _cryosparc-tut-step-6-find-your-labs-directory-on-skipjack:

Step 6: Find your lab's directory on Skipjack
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Skipjack terminal.** ``DEST`` is in ARCH's install answer (Tutorial 1, step 6),
``/scratch/<affiliation>/<pi>/cryosparc`` by default:

.. code-block:: bash

   D=<the DEST path>
   squeue -u ext-<pi>-cryosparc -n cryosparc-<pi>     # the master runs: state R

If the master is not running, ask ARCH to start it (ticket).

.. _cryosparc-tut-step-7-ask-arch-for-the-landing-folders:

Step 7: Ask ARCH for the landing folders
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``DEST`` belongs to the lab's account, so your own account cannot write there. Once per lab, ARCH creates
three folders your group can write to, ``$D/backups``, ``$D/rawdata`` and ``$D/projects/rockfish`` (mode
2770). Ask on your ticket, or open one:

.. code-block:: text

   Please create the landing folders for the Rockfish move of the lab <pi>.

When ARCH answers, check that you can write there:

.. code-block:: bash

   ls -ld $D/backups $D/rawdata $D/projects/rockfish     # three lines that start with drwxrws---
   touch $D/rawdata/test && rm $D/rawdata/test && echo OK

.. _cryosparc-tut-step-8-copy-the-backup-the-raw-data-and-the-project:

Step 8: Copy the backup, the raw data and the project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Rockfish terminal**, with your own accounts. Start ``tmux`` first, so a dropped connection does not
stop the copy (``tmux attach -t move`` brings it back):

.. code-block:: bash

   tmux new -s move

   RF_P=<the project directory>                # step 2
   RF_RAW=<the raw data directory>             # step 3
   RF_BK=<the backup file>                     # step 5
   D=<the DEST path on Skipjack>               # step 6
   SJ=<you>@login01.arch.jhu.edu               # your own Skipjack account (Schmidt Sciences: login01.schmidtsciences.jhu.edu)

   ssh -fNM -S /tmp/sj-ctl $SJ                 # one connection to Skipjack: asks your password and code once
   R=(rsync -rlt --partial --info=progress2 -e "ssh -S /tmp/sj-ctl")     # the copy command, reused below

   "${R[@]}" $RF_BK   $SJ:$D/backups/
   "${R[@]}" $RF_RAW/ $SJ:$D/rawdata/$(basename $RF_RAW)/
   "${R[@]}" $RF_P/   $SJ:$D/projects/rockfish/$(basename $RF_P)/

   ssh -S /tmp/sj-ctl -O exit $SJ              # close the connection when everything is copied

- Keep the ``/`` at the end of the paths exactly as written.
- Interrupted? Run the same line again: it continues where it stopped.
- More projects: repeat the last two ``"${R[@]}"`` lines with each project's ``RF_RAW`` and ``RF_P``.
- In our test the copy ran at about 300 GB per hour. For several terabytes, ask ARCH about Globus for
  the raw data. Globus does not copy links, so the project's line above must still run afterwards.

.. _cryosparc-tut-step-9-check-what-arrived:

Step 9: Check what arrived
^^^^^^^^^^^^^^^^^^^^^^^^^^

**Skipjack terminal:**

.. code-block:: bash

   P=$D/projects/rockfish/<project folder>     # the same folder name as on Rockfish
   RAW=$D/rawdata/<raw data folder>            # the same folder name as on Rockfish
   ls -lh $D/backups                           # the backup file
   ls $RAW | wc -l; du -sh $RAW $P             # the same number of files and about the same sizes as in steps 2 and 3
   find $P -type l | wc -l                     # the links came along: the numbers of step 3, added up
   ls -l $P/cs.lock $P/project.json            # both exist
   BK=$D/backups/<the backup file name>

.. _cryosparc-tut-step-10-give-the-group-write-access:

Step 10: Give the group write access
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The files you copied belong to you. CryoSPARC runs as the lab's account and reaches them through your
PI's group:

.. code-block:: bash

   chmod -R g+rwX $RAW $P
   chmod g+r $BK

.. _cryosparc-tut-step-11-re-point-the-links-to-the-raw-data:

Step 11: Re-point the links to the raw data
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The links in the project still point at the Rockfish path. Run this with your own account.
The first command only shows what it would do:

.. code-block:: bash

   RF_RAW=<the raw data directory on Rockfish>     # exactly as step 3 printed it
   /apps/helpers/cryosparc.sh project-relink $P $RF_RAW $RAW

.. code-block:: text

   ==> /scratch/<...>/CS-my-project: 21 links, 21 of them point under /vast/<...>/my_dataset
   ==> Their new targets that exist now: 21 of 21. For example:
   ...
   ==> Nothing changed. To rewrite those 21 links: ...

In the second line both numbers must be equal: every link has its file on Skipjack. Then rewrite and
check:

.. code-block:: bash

   /apps/helpers/cryosparc.sh project-relink $P $RF_RAW $RAW --yes
   find $P -xtype l                                # broken links: must print nothing

Only the links inside the project change, never your data.

.. _cryosparc-tut-step-12-ask-arch-to-restore-the-database:

Step 12: Ask ARCH to restore the database
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Answer your ticket, or open a new one, with:

- your lab (``<pi>``) and "restore our Rockfish CryoSPARC database on Skipjack";
- the backup file: the path in ``$BK`` (``echo $BK``).

ARCH stops your master, moves the current Skipjack database aside, restores yours, starts the master
and replaces the Rockfish job lanes with the Skipjack one. **The restore replaces everything in the
Skipjack database:** the admin login created at install stops working, and you log in with your
Rockfish e-mails and passwords.

ARCH's answer says that the master runs again, with every process RUNNING and the license valid.

.. _cryosparc-tut-step-13-log-in-and-unarchive-the-project:

Step 13: Log in and unarchive the project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Open CryoSPARC (:ref:`Tutorial 2 <cryosparc-tut-tutorial-2-open-cryosparc-and-run-a-job>`) and log in with your
   Rockfish e-mail and password: the restore brought your Rockfish logins, and the admin login created
   at install no longer works. If your login is refused, reset it with a token from another admin of
   your lab (:ref:`A forgotten or first password <cryosparc-tut-a-forgotten-or-first-password>`); if no admin can log in,
   answer the ticket.
2. Open the project, then **Actions → Unarchive Project**, with its new path written out in full, the
   folder ``$P`` of step 9 (``echo $P``):
   ``/scratch/<affiliation>/<pi>/cryosparc/projects/rockfish/<project folder>``.

If the web interface refuses the path or the unarchive, answer the ticket with the project's number
(step 2) and that path: ARCH can unarchive it from the command line.

.. _cryosparc-tut-step-14-check-the-project:

Step 14: Check the project
^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Open the project: its jobs are there, with the same numbers.
2. Open a finished job and look at its inputs and outputs.

.. _cryosparc-tut-step-15-run-a-test-job:

Step 15: Run a test job
^^^^^^^^^^^^^^^^^^^^^^^

Run one small CPU job and one GPU job in the project, on the lane ``slurm-<partition>``. If that lane is
not offered in the job builder, ask ARCH on the ticket to run ``lane``, then reload the page.

.. _cryosparc-tut-step-16-finish-on-rockfish:

Step 16: Finish on Rockfish
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Stop using CryoSPARC on Rockfish for the projects you moved. Never unarchive there a project that now
  lives here: the two instances would write different copies of it.
- Keep the Rockfish copy (project folders, raw data, the backup) until you are satisfied with Skipjack.

.. _cryosparc-tut-route-b-move-one-project-without-the-database:

Route B: move one project without the database
----------------------------------------------

The project is detached on Rockfish and attached here. Your users must already exist on Skipjack
(:ref:`Add a lab member <cryosparc-tut-add-a-lab-member>`).

1. **Rockfish:** find the project's directory and its raw data (Route A, steps 1 to 3).
2. **Rockfish web interface:** the project's **Actions → Detach**. Wait until it finishes: the folder
   no longer has a lock file, so ``ls $RF_P/cs.lock`` answers ``No such file or directory``.
3. **Skipjack:** find your directory and have ARCH create the landing folders (Route A, steps 6 and 7).
4. **Rockfish:** copy the raw data and the project (Route A, step 8, without the backup line).
5. **Skipjack:** check the copy, give the group write access, re-point the links (Route A, steps 9 to
   11). Here ``cs.lock`` must not exist.
6. **Skipjack web interface:** **Projects → Attach Project**, with the project's folder (the one that
   holds ``project.json``, ``$P`` of step 9). Note the project's new number.
7. Check the project and run a test job (Route A, steps 14 and 15, with your Skipjack login).

.. _cryosparc-tut-what-to-expect-after-the-move:

What to expect after the move
-----------------------------

- **Project numbers.** Route A keeps them. Route B gives the project a new number (P3 on Rockfish can
  become P1 here); update notes and scripts that mention it. Job numbers (J1, J2, ...) stay in both.
- **Projects you did not archive** before the backup (Route A) are listed here too, but still point at
  Rockfish and do not open. Ask ARCH before touching them.
- **Deleted jobs stay hidden.** Jobs that were running when you stopped come back as not finished.
- **Results and logs are kept.** A job can run again once its inputs resolve here, which is what step 11
  does for the raw data.

.. _cryosparc-tut-if-something-fails-during-the-move:

If something fails during the move
----------------------------------

+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Message or symptom                                                              | Cause, fix                                                                       |
+=================================================================================+==================================================================================+
| On Rockfish, ``cryosparc.sh`` prints                                            | that is the old installer. Leave it with Ctrl-C and use ``cryosparcm``           |
| "Welcome to the CryoSparc Rockfish Installation Script" and asks for a license  |                                                                                  |
| ID                                                                              |                                                                                  |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``Permission denied`` when you create a folder under ``DEST``                   | expected with your own account: ARCH creates the landing folders (step 7)        |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``rsync`` asks for your password at every line                                  | the connection of step 8 is closed: run the ``ssh -fNM ...`` line again          |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``rsync``: ``Permission denied (13)`` on Skipjack                               | the landing folders are missing (step 7), or you are not in your PI's group      |
|                                                                                 | (``id`` lists your groups)                                                       |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``project-relink``: ``0 of them point under ...``                               | ``RF_RAW`` is not the path the links use. The command lists where the broken     |
|                                                                                 | links point: use that path                                                       |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``project-relink``: ``none of the N new targets exists``                        | ``RAW`` is wrong, or the raw data is not copied yet                              |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``project-relink``: ``could not rewrite ...``                                   | run it with the account that copied the project                                  |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| "Another CryoSPARC instance is running with the same license ID"                | Skipjack uses the license ID Rockfish is using: type the second one with         |
|                                                                                 | ``config`` as yourself (Tutorial 1, step 5) and ask ARCH to copy it and restart  |
|                                                                                 | the master                                                                       |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Unarchive or attach: path not found                                             | the folder is not under ``DEST`` or ``PROJECT_DIRS``: move it there, or ask ARCH |
|                                                                                 | to add its directory to ``PROJECT_DIRS`` (``config``, ``restart``, ``lane``)     |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Unarchive or attach: path rejected                                              | you gave the parent directory: give the project's folder, the one with           |
|                                                                                 | ``project.json``                                                                 |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Attach refused, lock found                                                      | the project is still attached on Rockfish: detach it there first                 |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| The file picker shows nothing (ARCH sees "400" in ``<DEST>/state/run/api.log``) | leading spaces in the path box: clear it and type the path again                 |
+---------------------------------------------------------------------------------+----------------------------------------------------------------------------------+

CryoSPARC's own guides:
`migrating an instance <https://guide.cryosparc.com/setup-configuration-and-management/software-system-guides/tutorial-migrating-your-cryosparc-instance>`__
and `data management <https://guide.cryosparc.com/setup-configuration-and-management/software-system-guides/guide-data-management-in-cryosparc-v4.0>`__
(archive, unarchive, detach, attach).



|

|

----


.. _cryosparc-tut-reference:

Reference
#########

.. _cryosparc-tut-the-labs-cryosparc-account:

The lab's CryoSPARC account
---------------------------

Each lab has one cluster account for CryoSPARC, ``ext-<pi>-cryosparc``. The master, its database and
every job CryoSPARC submits run as this account, not as a person.

+-------------------------+---------------------------------------------------------------------------------+
| Why                     | The cluster limits GPUs **per user** (16 at a time). On its own account, the    |
|                         | lab's CryoSPARC has those 16 to itself, and the PI's and the manager's own jobs |
|                         | never compete with it. The limit of the Slurm account ``<pi>_cryosparc`` (16    |
|                         | GPUs) still covers everything charged to it                                     |
+-------------------------+---------------------------------------------------------------------------------+
| Who creates it          | the lab manager, with the portal's registration form (Tutorial 1, step 3). ARCH |
|                         | then locks its login shell                                                      |
+-------------------------+---------------------------------------------------------------------------------+
| No login                | Its password exists only because the form requires one. Nobody logs in as the   |
|                         | account: it has no login shell, so no SSH and no Globus. Nobody in the lab acts |
|                         | as it either (no ``sudo``): ARCH runs the commands that do, on a ticket         |
+-------------------------+---------------------------------------------------------------------------------+
| Files                   | The lab's CryoSPARC directory (``DEST``: the database, the state, the default   |
|                         | ``projects/``) belongs to it, with the PI's group. Lab members can read results |
|                         | there; only the account writes                                                  |
+-------------------------+---------------------------------------------------------------------------------+
| Copying data in         | You copy with your own account into the landing folders ARCH creates, then give |
|                         | the group write access (Tutorial 4, steps 7 to 10)                              |
+-------------------------+---------------------------------------------------------------------------------+
| In Slurm and in billing | Every CryoSPARC job shows the user ``ext-<pi>-cryosparc`` and is charged to     |
|                         | ``<pi>_cryosparc``. Who queued a job is a CryoSPARC record: the job's page in   |
|                         | the web interface (Slurm's job name ``cs_<P>_<J>`` points to it)                |
+-------------------------+---------------------------------------------------------------------------------+

A lab installed before these accounts existed runs under the manager's or the PI's own account until
ARCH moves it. That person runs, as themselves, the ``cryosparc.sh`` commands these tutorials leave to
ARCH (``/apps/helpers/cryosparc.sh start``, ``stop``, ``status``, ``backup``, ``update``, ``config``, ``lane``, with
``CS_LAB=<pi>`` in front when in several PIs' groups), can start the master from OnDemand
(**Interactive Apps → CryoSPARC Master**), and copies data as that account.

.. _cryosparc-tut-settings:

Settings
--------

The settings live in ``~/.cryosparc/<pi>.ini`` in the lab account's home: ARCH prints them (``show``) and
edits them (``config``), on a ticket. The file holds your license ID: it is mode 600, and the license ID
never goes in a ticket. :ref:`Step 5 of Tutorial 1 <cryosparc-tut-step-5-type-your-license-id>` is how it reaches ARCH,
and lists every prompt of ``config`` with the value it offers.

+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| Setting                                                      | Value                                                                            |
+==============================================================+==================================================================================+
| ``DEST``, ``DBPATH``, ``SSDPATH``                            | the lab's CryoSPARC directory, its database and its cache, under your PI's       |
|                                                              | ``/scratch`` directory (``/scratch/<affiliation>/<pi>/cryosparc`` by default).   |
|                                                              | The other paths do not follow a new ``DEST``: type ``DBPATH``, ``SSDPATH``,      |
|                                                              | ``PROJECT_DIRS`` and ``STATE_DIR`` too                                           |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``PROJECT_DIRS``                                             | comma-separated directories where your projects and data live. CryoSPARC sees    |
|                                                              | ``DEST`` and these, nothing else of ``/scratch``. The default is ``projects/``   |
|                                                              | under ``DEST``; any other directory must exist before the master starts, and the |
|                                                              | lab's account must be able to write there through your PI's group                |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``LICENSE_ID``                                               | your lab's license                                                               |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``PORT``                                                     | the one ARCH assigned to your lab. CryoSPARC uses ``PORT`` to ``PORT+10``.       |
|                                                              | ``config`` offers ``25000`` to every new lab, and ARCH types yours at install:   |
|                                                              | it cannot change once the database exists                                        |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``MASTER_HOST``                                              | the node the master runs on: ``csr091`` for now. Never a login node              |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``MASTER_PARTITION``, ``MASTER_QOS``, ``MASTER_RESERVATION`` | how the master's job reaches that host, set by ARCH at install                   |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``MASTER_CPUS``, ``MASTER_MEM``, ``MASTER_TIME``             | the master job's size (``4``, ``24G``) and its time limit (blank: the            |
|                                                              | partition's)                                                                     |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``ACCOUNT``                                                  | the Slurm account that pays: ``<pi>_cryosparc``                                  |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``PARTITION``, ``CPU_PARTITION``                             | where GPU jobs run (e.g. ``a100``) and where CPU-only jobs run (``med``). GPU    |
|                                                              | partitions refuse a job that asks for no GPU                                     |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``RESERVATION``                                              | blank, unless ARCH gives your lab a reservation for its jobs                     |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``ACCEPT_COST``                                              | ``yes`` when ``ACCOUNT`` is a paid allocation: CryoSPARC's jobs then accept the  |
|                                                              | cluster's cost prompt, which a job submitted by CryoSPARC cannot answer          |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``WALLTIME``                                                 | the time limit of each CryoSPARC job (``72:00:00``)                              |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``EMAIL``, ``ADMIN_USER``                                    | the login of the CryoSPARC admin created at install: the real e-mail of the PI   |
|                                                              | or the manager, given in the ticket (Tutorial 1, step 4). It cannot change after |
|                                                              | the install                                                                      |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``RUN_GROUP``                                                | your PI's group, which owns the lab's files                                      |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``MODE``, ``SLURM_MODE``                                     | ``cluster``, ``bind``: leave them                                                |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+

``config`` does not ask ``PHASE``, ``CS_SIF`` and, once installed, ``VERSION``: they record what is installed
and change only with ``update``.

.. _cryosparc-tut-the-masters-slurm-job:

The master's Slurm job
----------------------

The master is a Slurm job named ``cryosparc-<pi>``, owned by the lab's account, on ``MASTER_HOST``, charged
to ``ACCOUNT``. Its file is ``<DEST>/state/master.sbatch``. ``cryosparc.sh`` writes that file from the lab's
settings, so a change goes through ``config`` (ARCH's): an edit by hand is lost.

+---------------------------------------------+------------------------------------------------------------------+
| In the file                                 | From the setting                                                 |
+=============================================+==================================================================+
| ``--job-name=cryosparc-<NAME>``             | ``NAME`` (your PI's JHED)                                        |
+---------------------------------------------+------------------------------------------------------------------+
| ``--partition``, ``--nodelist``             | ``MASTER_PARTITION``, ``MASTER_HOST``                            |
+---------------------------------------------+------------------------------------------------------------------+
| ``--account``, ``--qos``, ``--reservation`` | ``ACCOUNT``; ``MASTER_QOS`` and ``MASTER_RESERVATION``, when set |
+---------------------------------------------+------------------------------------------------------------------+
| ``--cpus-per-task``, ``--mem``, ``--time``  | ``MASTER_CPUS``, ``MASTER_MEM``; ``MASTER_TIME``, when set       |
+---------------------------------------------+------------------------------------------------------------------+
| ``--requeue``                               | always: after a node failure the job comes back on the same host |
+---------------------------------------------+------------------------------------------------------------------+
| ``--comment=accept_cost``                   | ``ACCEPT_COST=yes``                                              |
+---------------------------------------------+------------------------------------------------------------------+
| ``--output``                                | ``<DEST>/state/run/master-<job>.log``, the master job's log      |
+---------------------------------------------+------------------------------------------------------------------+

ARCH's ``cryosparc.sh start`` submits this file, as the lab's account.

.. _cryosparc-tut-jobs-and-the-lane:

Jobs and the lane
-----------------

CryoSPARC submits its jobs to Slurm through a lane named ``slurm-<partition>``, as the lab's account,
charged to ``ACCOUNT``, whichever CryoSPARC user queued them. The lane's two files are in
``<DEST>/lanes/<partition>/``. ``cryosparc.sh lane`` (ARCH's) writes them from the lab's settings and
reloads the lane, so a change goes through ``config`` and then ``lane``; an edit by hand is lost. ``/apps/software/cryosparc/examples/lane-a100/``
shows what a lane looks like.

.. _cryosparc-tut-commands:

Commands
--------

ARCH runs these as the lab's account (ask on a ticket):

+----------------------------------------------+------------------------------------------------------------------+
| Command                                      | What it does                                                     |
+==============================================+==================================================================+
| ``start``, ``stop``, ``restart``, ``status`` | the master's job                                                 |
+----------------------------------------------+------------------------------------------------------------------+
| ``show``, ``config``                         | print and edit the lab's settings                                |
+----------------------------------------------+------------------------------------------------------------------+
| ``lane``                                     | write the lane from the settings and reload it                   |
+----------------------------------------------+------------------------------------------------------------------+
| ``update X.Y.Z``                             | move to a version                                                |
+----------------------------------------------+------------------------------------------------------------------+
| ``backup [DIR]``, ``restore FILE``           | database backup, into ``<DEST>/backups`` or ``DIR``; restore one |
+----------------------------------------------+------------------------------------------------------------------+

You run these as yourself:

+-------------------------------------------------------------------+-----------------------------------------------------------------------------+
| Command                                                           | What it does                                                                |
+===================================================================+=============================================================================+
| ``squeue -u ext-<pi>-cryosparc``                                  | the master's job (``cryosparc-<pi>``) and CryoSPARC's jobs (``cs_<P>_<J>``) |
+-------------------------------------------------------------------+-----------------------------------------------------------------------------+
| ``/apps/helpers/cryosparc.sh config``                             | before the install: your license ID, in your own home (Tutorial 1, step 5)  |
+-------------------------------------------------------------------+-----------------------------------------------------------------------------+
| ``/apps/helpers/cryosparc.sh versions``, ``versions --remote``    | versions here, versions released                                            |
+-------------------------------------------------------------------+-----------------------------------------------------------------------------+
| ``/apps/helpers/cryosparc.sh project-relink DIR OLD NEW [--yes]`` | re-point a copied project's links                                           |
+-------------------------------------------------------------------+-----------------------------------------------------------------------------+
| ``/apps/helpers/cryosparc.sh help``                               | the list of commands                                                        |
+-------------------------------------------------------------------+-----------------------------------------------------------------------------+

.. _cryosparc-tut-when-something-fails:

When something fails
--------------------

+-------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Symptom                                                                       | Cause, fix                                                                       |
+===============================================================================+==================================================================================+
| ``No CryoSPARC is installed for <pi> yet`` at the end of ``config``           | expected: you saved your license ID in your own home (Tutorial 1, step 5)        |
+-------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``you are in the groups of several labs``                                     | ``config`` did not name the lab and you are in several PIs' groups:              |
|                                                                               | ``CS_LAB=<pi> /apps/helpers/cryosparc.sh config``                                |
+-------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``MASTER_HOST: give the lab's host ...; nothing was saved``                   | you pressed Enter at ``MASTER_HOST``: run ``config`` again and type ``csr091``   |
|                                                                               | there                                                                            |
+-------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| The master's job stays pending                                                | ``squeue -u ext-<pi>-cryosparc`` shows the reason. Its host is busy or down:     |
|                                                                               | open a ticket                                                                    |
+-------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``Account 'X' is not available for user ...`` when a job is submitted         | the lab's ``ACCOUNT`` is wrong: open a ticket (ARCH fixes it with ``config``,    |
|                                                                               | then ``lane``)                                                                   |
+-------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| A job fails at submit with ``[BILLING] ... Proceed? [y/N]`` and ``Cancelled`` | the cluster asks for a cost confirmation CryoSPARC cannot give: open a ticket    |
|                                                                               | (ARCH sets ``ACCEPT_COST=yes``, then ``lane``)                                   |
+-------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| OnDemand session shows "nothing answers" or a connection error                | the master is stopped (``squeue -u ext-<pi>-cryosparc -n cryosparc-<pi>`` prints |
|                                                                               | nothing): ask ARCH to start it, then reload the page in Firefox                  |
+-------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Your lab is not in the OnDemand list                                          | ARCH adds it: open a ticket                                                      |
+-------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| SSH tunnel: ``channel open failed: administratively prohibited``              | the login node refused the forward: use OnDemand, and tell ARCH the login host   |
|                                                                               | and port you used                                                                |
+-------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Where the logs are                                                            | the master job's log ``<DEST>/state/run/master-<job>.log`` and CryoSPARC's       |
|                                                                               | service logs in ``<DEST>/state/run/`` are readable only by the lab's account:    |
|                                                                               | ARCH reads them. Give the job's number and the error the web interface shows     |
+-------------------------------------------------------------------------------+----------------------------------------------------------------------------------+

Anything else: open a ticket with ARCH (Tutorial 1, step 4, has the addresses). Paste the command and
its output, never the license ID.

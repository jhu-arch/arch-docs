.. _cryosparc tutorial:

CryoSPARC on Skipjack: lab guide
================================

.. contents::
   :local:
   :depth: 2

Online version: https://docs.arch.jhu.edu/en/latest/3_Tutorials/specialized/Tutorial_CryoSPARC.html

Each lab runs its own CryoSPARC: its own account, your database, your license, your project
directories. What is shared is the software: one image per CryoSPARC version in
``/apps/software/cryosparc/``. Everything below is done with one command, ``/apps/helpers/cryosparc.sh``.

.. _cryosparc-quick-start:

Quick start
###########

``<pi>`` is your PI's JHED. The PI and the lab manager run the commands as the lab's CryoSPARC account
(``sudo -Hu ext-<pi>-cryosparc``); a lab installed under your own account runs them without that prefix.

**Getting your lab's master (once):**

1. **ColdFront:** Projects → Create Project, abbreviation ``cryosparc``, with an IO Number; then **Request
   Resource Allocation** on it. Wait for ARCH to approve it.

2. **The lab manager** registers ``ext-<pi>-cryosparc`` at https://portal.arch.jhu.edu/user/jhu/register/,
   with a new e-mail outside the JHU domains, then adds it to the ``cryosparc`` project and its allocation
   (Project Detail → Add Users).

3. **Ticket** on the `helpdesk <https://helpdesk.arch.jhu.edu/tickets/submit/>`__: "I need software installed,
   or a module is missing or broken", asking for a CryoSPARC master (details in
   :ref:`Before you start <cryosparc-before-you-start>`). Never put the license ID in it.

4. **License ID:** when ARCH gives you ``sudo``, type it at ``LICENSE_ID`` and say so in the ticket:

   .. code-block:: bash

      sudo -Hu ext-<pi>-cryosparc /apps/helpers/cryosparc.sh config

5. ARCH installs the master and sends you the port, the host and the admin password (once).

**Every day**, on a login node:

.. code-block:: bash

   sudo -Hu ext-<pi>-cryosparc /apps/helpers/cryosparc.sh start    # starts the master (a Slurm job)
   sudo -Hu ext-<pi>-cryosparc /apps/helpers/cryosparc.sh status
   sudo -Hu ext-<pi>-cryosparc /apps/helpers/cryosparc.sh stop

**Open it** (everyone in the lab):

- **OnDemand:** Interactive Apps → CryoSPARC, pick your lab, Launch, then **Launch CryoSPARC**.

- **Or an SSH tunnel**, from your workstation: ``ssh -N -L <port>:<host>:<port> <you>@login01.arch.jhu.edu``
  (Schmidt Sciences labs: ``login01.schmidtsciences.jhu.edu``), then open ``http://localhost:<port>``.

Log in with your CryoSPARC account (the lab's CryoSPARC admin creates them; see
:ref:`Lab members' accounts <cryosparc-lab-members-accounts>`). Run jobs on the lane ``slurm-<partition>``.

Moving from Rockfish: :ref:`Moving a lab from Rockfish <cryosparc-moving-a-lab-from-rockfish>`. Something fails:
:ref:`When something fails <cryosparc-when-something-fails>`.



|

|

----


.. _cryosparc-before-you-start:

Before you start
################

**ARCH creates your lab's master: you ask for it.** Nothing below works until ARCH has installed it
(see :ref:`One-time setup <cryosparc-one-time-setup-done-by-arch>`). To ask:

1. **Create a project in ColdFront first**, then request its allocation:

   1. Projects → Create Project, with **abbreviation** ``cryosparc`` (the PI creates it, or a manager on
      the PI's behalf), and an IO Number to pay for it. ARCH reviews and activates the project.

   2. On that project, **Request Resource Allocation** for the cluster. When ARCH approves it and a
      spending cap is set, Slurm gets the account ``<pi>_cryosparc`` (PI's username + the abbreviation).

   The master's job and your CryoSPARC jobs run under that account, so ARCH waits for the approval.

2. Open a ticket on the `ARCH helpdesk <https://helpdesk.arch.jhu.edu/tickets/submit/>`__, or e-mail
   ``Arch@jh.edu`` with the same content (Schmidt Sciences labs:
   `their helpdesk <https://helpdesk.schmidtsciences.jhu.edu/tickets/submit/>`__ or ``SSCI@jh.edu``). On the
   form, choose **"I need software installed, or a module is missing or broken"** under "What best
   describes your issue?" and fill in:

   +---------------------------+----------------------------------------------------------------------------------+
   | Field                     | What to write                                                                    |
   +===========================+==================================================================================+
   | What do you need?         | A CryoSPARC master for my lab                                                    |
   +---------------------------+----------------------------------------------------------------------------------+
   | Software name and version | CryoSPARC and the version (``/apps/helpers/cryosparc.sh versions`` lists the     |
   |                           | images), or "latest"                                                             |
   +---------------------------+----------------------------------------------------------------------------------+
   | Website or download link  | https://cryosparc.com                                                            |
   +---------------------------+----------------------------------------------------------------------------------+
   | License                   | academic license from Structura, held by your PI. **Never the license ID         |
   |                           | itself** (step 3)                                                                |
   +---------------------------+----------------------------------------------------------------------------------+
   | What will you use it for? | your project, in a sentence                                                      |
   +---------------------------+----------------------------------------------------------------------------------+
   | Who will use it?          | the PI, who runs the lab's CryoSPARC account (the PI, the lab manager or both:   |
   |                           | see :ref:`The lab's CryoSPARC account <cryosparc-the-labs-cryosparc-account>`),  |
   |                           | and the members (JHED IDs)                                                       |
   +---------------------------+----------------------------------------------------------------------------------+
   | Special requirements      | the GPU partition you need (e.g. ``a100``), where your projects and raw data     |
   |                           | live (they become ``PROJECT_DIRS``), and whether you are moving a lab from       |
   |                           | Rockfish (see                                                                    |
   |                           | :ref:`Moving a lab from Rockfish <cryosparc-moving-a-lab-from-rockfish>`)        |
   +---------------------------+----------------------------------------------------------------------------------+

   **The lab manager creates the lab's CryoSPARC account** (see
   :ref:`The lab's CryoSPARC account <cryosparc-the-labs-cryosparc-account>`) before the ticket, with the portal's
   external-collaborator form, https://portal.arch.jhu.edu/user/jhu/register/:

   +-----------------------+----------------------------------------------------------------------------------+
   | Field                 | What to write                                                                    |
   +=======================+==================================================================================+
   | Username              | ``ext-<pi>-cryosparc`` (your PI's JHED in place of ``<pi>``)                     |
   +-----------------------+----------------------------------------------------------------------------------+
   | First name, Last name | ``CryoSPARC``, your PI's last name                                               |
   +-----------------------+----------------------------------------------------------------------------------+
   | Email                 | a mailbox **outside the JHU domains**, new and for this account only (e.g.       |
   |                       | ``<lab>.cryosparc@gmail.com``), kept by the PI or the manager, never someone's   |
   |                       | own                                                                              |
   +-----------------------+----------------------------------------------------------------------------------+
   | Password              | a strong one, kept by the manager. Nobody logs in with it: the account is used   |
   |                       | only through ``sudo``                                                            |
   +-----------------------+----------------------------------------------------------------------------------+

   Then the PI or the manager adds it to the ``cryosparc`` project and its allocation (Project Detail →
   Add Users), like any member: until then the account stays inactive. In the ticket (still **"I need
   software installed, or a module is missing or broken"**), say that the account exists and who runs it:
   the PI, the manager or both.

3. Give ARCH the license ID through the settings file, not the ticket: once ARCH has given you ``sudo`` to
   the lab's account, run ``sudo -Hu ext-<pi>-cryosparc /apps/helpers/cryosparc.sh config`` and type it at
   ``LICENSE_ID`` (the file is mode 600). Say in the ticket that you did.

4. ARCH answers with your port and host, installs the master and sends you the admin password once.

You need:

- A CryoSPARC **license ID** for your lab (free for academic use, requested from Structura). CryoSPARC
  does not support one license ID on two running instances, so a lab moving from Rockfish needs a
  **second ID** for this cluster while its Rockfish master still runs (the rehearsal): request one more
  from Structura, like the first.

- Your PI's directory on ``/scratch`` for the install, the database and the SSD cache:
  ``/scratch/<affiliation>/<pi>/cryosparc`` by default. The lab is the PI's: a manager or member sets it
  up from their own account, as a member of the PI's group. If you are in several PIs' groups, name
  the lab each time: ``CS_LAB=<pi> /apps/helpers/cryosparc.sh ...``.

- Your lab's **Slurm account for CryoSPARC**, ``<pi>_cryosparc``: it comes from the ColdFront project
  with abbreviation ``cryosparc`` and its approved allocation (step 1 above). Jobs are charged to it.

- Your **port**, assigned by ARCH: CryoSPARC uses ``PORT`` to ``PORT+10``, one range per lab, below the
  kernel's ephemeral range (32768-60999, which CryoSPARC refuses). Ask ARCH if you do not have yours.

- The host ARCH gives your lab for the master, a node set aside for masters (through the ``cryosparc``
  reservation or partition). The master always runs there, as a Slurm job of the lab's CryoSPARC account (see :ref:`Every day <cryosparc-every-day>`), never on a
  login node.

.. _cryosparc-the-labs-cryosparc-account:

The lab's CryoSPARC account
---------------------------

Each lab has one cluster account for CryoSPARC, ``ext-<pi>-cryosparc``, created by the lab manager; ARCH
installs the lab's CryoSPARC under it. The master, its database and every job CryoSPARC submits run as this account, not as a person.

+-------------------------+----------------------------------------------------------------------------------+
| Why                     | The cluster limits GPUs **per user** (16 at a time, counted over all of that     |
|                         | user's jobs). On its own account the lab's CryoSPARC has those 16 to itself, so  |
|                         | the PI's and the manager's own jobs never compete with it. The limit of the      |
|                         | Slurm account ``<pi>_cryosparc`` (16 GPUs) still covers everything charged to    |
|                         | it, whoever submits                                                              |
+-------------------------+----------------------------------------------------------------------------------+
| Who creates it          | the lab manager, with the portal's registration form (see                        |
|                         | :ref:`Before you start <cryosparc-before-you-start>`); ARCH then locks its login |
|                         | shell and gives the PI and the manager ``sudo`` to it                            |
+-------------------------+----------------------------------------------------------------------------------+
| No login                | Its password exists only because the form requires one: the manager keeps it,    |
|                         | and nobody logs in as the account (it has no login shell, so no SSH session).    |
|                         | The PI and the manager run the commands of this guide as it:                     |
|                         | ``sudo -Hu ext-<pi>-cryosparc /apps/helpers/cryosparc.sh <command>`` (and        |
|                         | ``sudo -Hu ext-<pi>-cryosparc sbatch ...``)                                      |
+-------------------------+----------------------------------------------------------------------------------+
| Files                   | It is a member of the PI's group: the lab's CryoSPARC tree (``DEST``, the        |
|                         | database, the projects) belongs to it, with the PI's group                       |
+-------------------------+----------------------------------------------------------------------------------+
| CryoSPARC admin         | ``EMAIL`` in the settings is the real e-mail of the PI or the manager: it is the |
|                         | CryoSPARC admin's login, not the account's                                       |
+-------------------------+----------------------------------------------------------------------------------+
| In Slurm and in billing | every CryoSPARC job shows the user ``ext-<pi>-cryosparc`` and is charged to      |
|                         | ``<pi>_cryosparc``. Who queued a job is a CryoSPARC record: the job's page in    |
|                         | the web interface (Slurm's job name ``cs_<P>_<J>`` points to it)                 |
+-------------------------+----------------------------------------------------------------------------------+

Where this guide says "your account" or "the account the master runs as", it means this account, reached
with ``sudo -u``. A lab installed before these accounts existed runs under the manager's or PI's own
account until ARCH moves it.

What ARCH assigns per lab looks like this. Apart from the first row (ARCH's own test lab), the names and
accounts are **examples only**, scientists from history: they are not labs, users or Slurm accounts of
this cluster. The ports show the scheme (one hundred apart), not who has which. Your own values come from
ARCH (``show`` prints them).

+---------------------+-------------------+-----------------------------+----------+
| PI                  | Manager           | Slurm account (``ACCOUNT``) | ``PORT`` |
+=====================+===================+=============================+==========+
| Skipjack lab (ARCH) | R.S. Jacomini     | ``sjadmin``                 | 25000    |
+---------------------+-------------------+-----------------------------+----------+
| Ada Lovelace        | Charles Babbage   | ``alovela1_cryosparc``      | 25100    |
+---------------------+-------------------+-----------------------------+----------+
| Grace Hopper        | Howard Aiken      | ``ghopper1_cryosparc``      | 25200    |
+---------------------+-------------------+-----------------------------+----------+
| Rosalind Franklin   | Raymond Gosling   | ``rfrankl1_cryosparc``      | 25300    |
+---------------------+-------------------+-----------------------------+----------+
| Dorothy Hodgkin     | Max Perutz        | ``dhodgki1_cryosparc``      | 25400    |
+---------------------+-------------------+-----------------------------+----------+
| Barbara McClintock  | Harriet Creighton | ``bmcclin1_cryosparc``      | 25500    |
+---------------------+-------------------+-----------------------------+----------+
| Chien-Shiung Wu     | Luke Yuan         | ``cwu1_cryosparc``          | 25600    |
+---------------------+-------------------+-----------------------------+----------+
| Lise Meitner        | Otto Frisch       | ``lmeitne1_cryosparc``      | 25700    |
+---------------------+-------------------+-----------------------------+----------+
| Emmy Noether        | Hermann Weyl      | ``enoethe1_cryosparc``      | 25800    |
+---------------------+-------------------+-----------------------------+----------+
| Katherine Johnson   | Dorothy Vaughan   | ``kjohnso1_cryosparc``      | 25900    |
+---------------------+-------------------+-----------------------------+----------+
| Mary Anning         | Henry De la Beche | ``mannin1_cryosparc``       | 26000    |
+---------------------+-------------------+-----------------------------+----------+



|

|

----


.. _cryosparc-one-time-setup-done-by-arch:

One-time setup (done by ARCH)
#############################

ARCH creates your lab's master under the lab's CryoSPARC account: it fills the settings
(``~/.cryosparc/<pi>.ini`` in that account's home), installs the version you agreed on and starts it as a
Slurm job of that account on the assigned host. You receive the admin
password once; change it with ``passwd``. What ARCH needs from you: the license ID, the project
directories, and the CryoSPARC version (``/apps/helpers/cryosparc.sh versions`` lists them).
You can fill the settings yourself beforehand with ``config``. ARCH runs ``init`` (on a compute node, as your
account) before your first start; until then ``start``, ``status`` and ``open`` only say that no CryoSPARC is
installed for your lab yet.

Settings in that file (``/apps/helpers/cryosparc.sh show`` prints yours):

+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| Setting                                                      | Value                                                                            |
+==============================================================+==================================================================================+
| ``MODE``                                                     | ``cluster`` (jobs run through Slurm)                                             |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``DEST``, ``DBPATH``, ``SSDPATH``                            | under your PI's ``/scratch`` directory                                           |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``PROJECT_DIRS``                                             | comma-separated directories your projects and data live in, mounted as they are: |
|                                                              | CryoSPARC sees nothing else of ``/scratch``. ``init`` creates the default        |
|                                                              | ``projects/`` under ``DEST``; any other directory is yours and must exist        |
|                                                              | (``config`` warns, the master's job does not start without it)                   |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``RUN_GROUP``                                                | your PI's group: ``init`` gives the lab's directory to it, results readable by   |
|                                                              | the lab, the database and state only by the account the master runs as           |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``PORT``                                                     | the one ARCH assigned to your lab (below 32768)                                  |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``MASTER_HOST``                                              | the host the master runs on (its database keeps that name). ``config`` offers    |
|                                                              | the host it runs on: on a login node, replace it with your lab's host            |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``MASTER_PARTITION``, ``MASTER_QOS``, ``MASTER_RESERVATION`` | how the master's own job reaches your host: set by ARCH when it installs your    |
|                                                              | lab; leave them as they are                                                      |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``MASTER_CPUS``, ``MASTER_MEM``, ``MASTER_TIME``             | the master job's size (``4``, ``24G``) and time limit (blank: none, it runs      |
|                                                              | until you stop it)                                                               |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``LICENSE_ID``                                               | your lab's license                                                               |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``ACCOUNT``, ``PARTITION``, ``RESERVATION``                  | ``<pi>_cryosparc``; GPU partition (e.g. ``a100``); blank, unless ARCH gives your |
|                                                              | lab a reservation for its jobs (a job in a reservation runs only on its nodes,   |
|                                                              | so it must hold nodes of ``PARTITION``)                                          |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``CPU_PARTITION``                                            | ``med``: where CPU-only jobs (Import Movies, ...) run; GPU partitions refuse a   |
|                                                              | job that asks for no GPU. Blank: everything on ``PARTITION``                     |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``ACCEPT_COST``                                              | ``yes`` when ``ACCOUNT`` is a paid allocation: the lane's jobs carry             |
|                                                              | ``--comment=accept_cost``, because a submit from CryoSPARC cannot answer the     |
|                                                              | cluster's ``[y/N]`` cost prompt                                                  |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``SLURM_MODE``                                               | ``bind``                                                                         |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``EMAIL``, ``ADMIN_USER``                                    | the CryoSPARC admin login                                                        |
+--------------------------------------------------------------+----------------------------------------------------------------------------------+

The ``.ini`` holds your license ID: it is mode 600, keep it that way and do not paste it in tickets.
``config`` asks every setting except ``PHASE``, ``CS_SIF`` and (once installed) ``VERSION``: those record what
is installed and only ``init``, ``update`` and ``migrate`` set them.



|

|

----


.. _cryosparc-every-day:

Every day
#########

The master runs as a Slurm job of the lab's account, on your lab's host, charged to ``ACCOUNT``, until you
stop it. Only the account the lab is installed under starts and stops it (with the lab's CryoSPARC
account: the PI and the manager, through ``sudo -Hu ext-<pi>-cryosparc`` before each command below); lab
members only open it. The OnDemand **CryoSPARC Master** app runs as the person logged in, so it starts
only a lab installed under that person's own account. Start it any of these ways; all three submit the
same job:

- ``cryosparc.sh start`` on a login node: submits the job and waits up to 15 minutes for CryoSPARC
  to answer. A job still waiting in the queue after that stays queued (``status`` shows when it is up).

- **OnDemand:** **Interactive Apps > CryoSPARC Master**, pick your lab, **Launch**. The session card
  shows the address and how to open it.

- ``sbatch $DEST/state/master.sbatch`` on a login node.

.. code-block:: bash

   /apps/helpers/cryosparc.sh start          # submits the master's job, waits for CryoSPARC
   /apps/helpers/cryosparc.sh status         # the master's job and CryoSPARC's own status
   /apps/helpers/cryosparc.sh stop           # clean stop: CryoSPARC stops its database, then the job ends
   /apps/helpers/cryosparc.sh restart        # stop, then start
   /apps/helpers/cryosparc.sh open           # how to reach the web interface from your workstation
   /apps/helpers/cryosparc.sh passwd         # change the admin password

**Delete** on the OnDemand card stops it too
(Slurm signals the job and the master stops within Slurm's grace period); ``stop`` is the cleaner way.
Run these commands on a login node: ``status``, ``backup``, ``passwd`` and ``lane`` run themselves inside the
master's job, on its node. The job's log is ``$DEST/state/run/master-<job>.log`` (started from OnDemand:
the session's ``output.log``).

.. _cryosparc-the-masters-job-file:

The master's job file
---------------------

``$DEST/state/master.sbatch`` is the Slurm job that runs your master: ``sbatch`` takes it, and the
CryoSPARC Master app in OnDemand runs the same file with the same options. ``cryosparc.sh`` writes it
from your settings (``init``, ``config``, ``start``, ``lane``, and any command that tells you to ``sbatch`` it
while it does not exist yet), so a change goes through ``config``: an edit by hand is lost.

+---------------------------------------------+----------------------------------------------------------------------------------+
| In the file                                 | From the setting                                                                 |
+=============================================+==================================================================================+
| ``--job-name=cryosparc-<NAME>``             | ``NAME``; ``status`` and ``stop`` find the job by this name                      |
+---------------------------------------------+----------------------------------------------------------------------------------+
| ``--partition``, ``--nodelist``             | ``MASTER_PARTITION``, ``MASTER_HOST``                                            |
+---------------------------------------------+----------------------------------------------------------------------------------+
| ``--account``, ``--qos``, ``--reservation`` | ``ACCOUNT``; ``MASTER_QOS`` and ``MASTER_RESERVATION``, when set                 |
+---------------------------------------------+----------------------------------------------------------------------------------+
| ``--cpus-per-task``, ``--mem``, ``--time``  | ``MASTER_CPUS``, ``MASTER_MEM``; ``MASTER_TIME``, when set (otherwise no time    |
|                                             | limit)                                                                           |
+---------------------------------------------+----------------------------------------------------------------------------------+
| ``--requeue``                               | always: after a node failure the job comes back on the same host                 |
+---------------------------------------------+----------------------------------------------------------------------------------+
| ``--comment=accept_cost``                   | ``ACCEPT_COST=yes``                                                              |
+---------------------------------------------+----------------------------------------------------------------------------------+
| ``--output``                                | ``$DEST/state/run/master-<job>.log``                                             |
+---------------------------------------------+----------------------------------------------------------------------------------+

Its last line runs ``cryosparc.sh master-job``, which starts CryoSPARC and holds the job until you stop it.

The web interface listens on ``http://<host>:PORT``, inside the cluster only. Two ways in, both printed by
``open`` with your host and port filled in:

1. **SSH tunnel**, from your workstation: ``ssh -N -L PORT:<host>:PORT <user>@<login host>``, keep it
   running, then open ``http://localhost:PORT`` in your browser, with the login host ``open`` prints. If ssh
   answers ``channel open failed: administratively prohibited``, the login node refused the forward: use
   OnDemand, and tell ARCH the login host and port you used.

2. **OnDemand** (no ssh needed): **Interactive Apps > CryoSPARC**, pick your lab, **Launch**, then
   **Launch CryoSPARC** on the session card. Firefox opens on your lab's master (your usual OnDemand
   login, then your CryoSPARC login); closing Firefox ends the session.

Other lab members are added as CryoSPARC users inside the web interface, or from the command line below.



|

|

----


.. _cryosparc-lab-members-accounts:

Lab members' accounts
#####################

Inside the master's job, as the account that runs the master: from a login node, open a shell in that
job (on the master's node), then:

.. code-block:: bash

   A=ext-<pi>-cryosparc                                   # the lab's CryoSPARC account
   J=$(squeue -h -u $A -n cryosparc-<name> -o %i)         # the master's job
   sudo -Hu $A SLURM_JOB_ID=$J srun --jobid=$J --overlap --pty bash   # a shell inside it, as that account
   apptainer instance list                      # the master's instance: cryosparc-<name>
   I=instance://cryosparc-<name>
   C=/opt/cryosparc/cryosparc_master/bin/cryosparcm
   apptainer exec $I $C user create --email <email> --password '<password>' --username <user> \
       --firstname <first> --lastname <last>    # add --role admin for another CryoSPARC admin
   apptainer exec $I $C user resetpassword --email <email> --password '<new password>'
   apptainer exec $I $C user list               # accounts, with an Admin column
   apptainer exec $I $C user --help             # every user command

These are the CryoSPARC 5 commands; on 4.x they are ``cryosparcm createuser`` and ``cryosparcm resetpassword``
with the same options (no ``--role``). CryoSPARC never e-mails a reset link or token: **Reset password > I need
a reset token** on the login page creates a token that only the lab's CryoSPARC admin can see and pass on,
so ``user resetpassword`` is the quicker way.



|

|

----


.. _cryosparc-jobs:

Jobs
####

Jobs are submitted to Slurm by the lane ``init`` created (``$DEST/lanes/<partition>/``), charged to
``ACCOUNT``, as the account the master runs as, whichever CryoSPARC user queued them: jobs that ask for GPUs on ``PARTITION``, CPU-only jobs on ``CPU_PARTITION``
(and both in ``RESERVATION`` when set). In the job builder choose the lane named ``slurm-<partition>``.

``lane`` writes both lane files from your settings, so a change goes through ``config`` and then ``lane``;
an edit made by hand in ``$DEST/lanes/`` is lost the next time ``lane`` runs. If a job fails at submit with
a ``[BILLING] ... Proceed? [y/N]`` / ``Cancelled`` message, the cluster is asking for a cost confirmation
that a non-interactive submit cannot give: set ``ACCEPT_COST=yes`` with ``config``, then run ``lane``.
The lane in ``/apps/software/cryosparc/examples/lane-a100/`` is a reference for what ``lane`` writes.



|

|

----


.. _cryosparc-versions:

Versions
########

.. code-block:: bash

   /apps/helpers/cryosparc.sh versions          # images available, the one your lab runs
   /apps/helpers/cryosparc.sh versions --remote # also what CryoSPARC has released
   /apps/helpers/cryosparc.sh update 5.0.8      # move your lab to that version (stops the job, swaps, starts a new one)

Forward only: the first start on a newer version migrates your database, and an older version
will not start on a migrated database. Take a ``backup`` before an ``update``.
``update`` stops the master's job and submits a new one, on the same host and port; nothing else about
your lab changes across versions.



|

|

----


.. _cryosparc-backup-and-restore:

Backup and restore
##################

``backup`` and ``restore`` run as the account the master runs under: with the lab's CryoSPARC account, the
PI or the manager put ``sudo -Hu ext-<pi>-cryosparc`` before each command below (a lab installed under a
person's own account runs them as that account). ``restore`` must be that account because mongod writes
only a ``database/`` that belongs to it. Neither needs ARCH; during a move from Rockfish, ARCH runs the
``restore`` with you.

.. code-block:: bash

   /apps/helpers/cryosparc.sh backup            # database dump (.archive) into $DEST/backups, master running
   /apps/helpers/cryosparc.sh backup /scratch/.../somewhere   # any directory under DEST or a project dir
   /apps/helpers/cryosparc.sh stop
   /apps/helpers/cryosparc.sh restore /scratch/.../cryosparc_backup_....archive   # a short job on your lab's host
   /apps/helpers/cryosparc.sh start            # or OnDemand > CryoSPARC Master

The backup is the database only. Your project directories are your data and are not copied; a
backup matches them as they were when it was taken, so do not restore one older than your projects.



|

|

----


.. _cryosparc-moving-a-lab-from-rockfish:

Moving a lab from Rockfish
##########################

ARCH creates your lab here first (see :ref:`One-time setup <cryosparc-one-time-setup-done-by-arch>`) and plans the move
with you. Until the cut-over, Rockfish is only read: the rehearsal backup and the copies change nothing
there. At the cut-over you archive (or detach) your projects on Rockfish, which does change its database:
from then on the way back is to unarchive them there (or attach them again, with new project numbers).
Keep the Rockfish copy until you confirm the one here. The transfers need no sudo; commands of ``cryosparc.sh``
run as the lab's CryoSPARC account, with ``sudo -Hu ext-<pi>-cryosparc``.

.. _cryosparc-what-moves-and-how:

What moves, and how
-------------------

+--------------------------------------------------------------+--------------------------------------------------------------+----------------+
| What                                                         | How                                                          | Who            |
+==============================================================+==============================================================+================+
| CryoSPARC accounts, settings, and (when the rehearsal shows  | a database backup on Rockfish, restored here; your Rockfish  | ARCH, with you |
| it works) your projects as they are                          | login and password keep working                              |                |
+--------------------------------------------------------------+--------------------------------------------------------------+----------------+
| Project directories                                          | Globus, then one ``rsync`` pass for the links (below)        | you            |
+--------------------------------------------------------------+--------------------------------------------------------------+----------------+
| Raw data (movies, gain references)                           | Globus, to a directory under your ``PROJECT_DIRS``           | you            |
+--------------------------------------------------------------+--------------------------------------------------------------+----------------+

Files arrive owned by whoever transfers them, so your Rockfish user and group numbers do not matter.
The lab's CryoSPARC account has no login, so **you** (the PI or the manager) transfer as yourself, into
directories of your PI's group; then give the group write on what arrived, so the master can work there:

.. code-block:: bash

   chmod -R g+rwX <sj-path>/<project>        # as yourself: you own the copied files

A lab whose master still runs under a person's own account transfers as that account instead.

.. _cryosparc-rsync-or-globus:

rsync or Globus
---------------

+-----------------------------+--------------------------------------------------------+----------------------------------------------------+
|                             | rsync                                                  | Globus                                             |
+=============================+========================================================+====================================================+
| Links left by Import Movies | ✅ kept                                                | ❌ skipped: the ``imported/`` folders arrive empty |
+-----------------------------+--------------------------------------------------------+----------------------------------------------------+
| Speed on terabytes          | one stream, through a login node                       | many streams, through the transfer nodes           |
+-----------------------------+--------------------------------------------------------+----------------------------------------------------+
| Interrupted                 | rerun it (``--partial``); keep the session open (tmux) | resumes on its own                                 |
+-----------------------------+--------------------------------------------------------+----------------------------------------------------+
| Checked                     | size and date                                          | checksum of every file                             |
+-----------------------------+--------------------------------------------------------+----------------------------------------------------+

So: Globus for the raw data and the bulk of the projects (tick "preserve source file modification times"),
then, for each project, one pass that brings the links:

Run it **on Rockfish**, pushing to this cluster (the way we tested), as yourself:

.. code-block:: bash

   ssh -fNM -S /tmp/sj-ctl <you>@<sj-login>      # one connection to Skipjack, reused by every rsync
   rsync -rlt --partial --info=progress2 -e "ssh -S /tmp/sj-ctl" \
       <rf-path>/<project>/ <you>@<sj-login>:<sj-path>/<project>/
   ssh -S /tmp/sj-ctl -O exit <sj-login>         # when done

``<sj-login>`` is the login host ``open`` prints. ``-rlt`` keeps links and dates and leaves owner, group and
modes to this cluster. Each new connection asks for your password and code, and the login nodes limit how
many sessions you can open: that is why every ``rsync`` goes through the one connection.

.. _cryosparc-the-steps:

The steps
---------

1. **Decide where things go here.** The project folders and the raw data must sit under your lab's ``DEST``
   or a directory listed in ``PROJECT_DIRS`` (``sudo -Hu ext-<pi>-cryosparc /apps/helpers/cryosparc.sh show``):
   the master sees nothing else. The simplest is ``$DEST/projects/<project>`` for the projects and a folder
   such as ``$DEST/rawdata/`` for the raw data, both visible without any change. A directory elsewhere has to
   be added to ``PROJECT_DIRS`` with ``config``, then ``restart`` (the same way): the container's mounts are fixed
   when the master starts.

2. **First copy, while you keep working on Rockfish:** raw data and projects with Globus; ARCH restores a
   rehearsal backup of your database here. The master here runs with your second license ID (see
   :ref:`You need <cryosparc-before-you-start>`), never the one Rockfish is using.

3. **Check the rehearsal** with ARCH: log in with your Rockfish account, open a finished job and its inputs,
   run a small CPU job and one GPU job.

4. **Cut-over day:** on Rockfish, archive (or, if ARCH says so, detach) your projects and stop working
   there; ARCH takes the final backup.

5. **Last sync:** Globus again (only what changed) and the ``rsync`` pass above.

6. ARCH restores the final backup here; you unarchive (or attach, see
   :ref:`Moving one project <cryosparc-moving-one-project-detach-and-attach>`) each project with its new path and
   check one job again.

7. **Stop using Rockfish** for CryoSPARC; keep the Rockfish copy until you are happy with this one.

Do not run the same lab on both clusters for long: the two instances would write different copies of
the same projects. Each one needs its own license ID.

.. _cryosparc-moving-one-project-detach-and-attach:

Moving one project (detach and attach)
--------------------------------------

The route we have tested, one project at a time. The project gets a new number here; its job numbers stay.

1. **On Rockfish, detach the project:** in the web interface, the project's Actions menu → **Detach**.
   Wait until it finishes: the project folder no longer has a ``cs.lock``.

2. **See where things go here:** ``sudo -Hu ext-<pi>-cryosparc /apps/helpers/cryosparc.sh show`` prints
   ``DEST``; set it in your shell (``DEST=<that path>``) for the commands below. Projects go to
   ``$DEST/projects/``, raw data to a folder such as ``$DEST/rawdata/``.

3. **Copy the raw data** with Globus, keeping its folder layout under one directory
   (Rockfish ``<raw path>/...`` → ``$DEST/rawdata/...``).

4. **Copy the project folder:** Globus for the bulk, then the pass that brings the links, on Rockfish
   (with the connection of :ref:`rsync or Globus <cryosparc-rsync-or-globus>`; write the Skipjack ``DEST`` out in full):

   .. code-block:: bash

      rsync -rlt --partial --info=progress2 -e "ssh -S /tmp/sj-ctl" \
          <rf-path>/<project>/ <you>@<sj-login>:<DEST>/projects/<project>/

5. **Give the group write**, as yourself (skip this for a lab under your own account):

   .. code-block:: bash

      chmod -R g+rwX $DEST/projects/<project> $DEST/rawdata

6. **Re-point the links to the raw data**, as yourself. Read what the first command reports, then run it
   again with ``--yes``; at the end ``find`` prints nothing:

   .. code-block:: bash

      /apps/helpers/cryosparc.sh project-relink $DEST/projects/<project> <rockfish raw path> $DEST/rawdata
      /apps/helpers/cryosparc.sh project-relink $DEST/projects/<project> <rockfish raw path> $DEST/rawdata --yes
      find $DEST/projects/<project> -xtype l

7. **Attach here:** in the web interface, **Projects → Attach Project**, with the folder that holds
   ``project.json``. Note the new project number.

8. **Check it:** open a finished job and its inputs, then run one small CPU job and one GPU job.

.. _cryosparc-what-to-expect:

What to expect
--------------

- **Attached projects get a new number** (P3 on Rockfish can become P1 here); job numbers (J1, J2, ...)
  stay. Update notes or scripts that mention project numbers. Unarchived projects keep their number.

- **Deleted jobs stay hidden**, and jobs that were running when you stopped come back as not finished.

- Results and logs are kept, but a job whose inputs pointed at a Rockfish path cannot run again until those
  inputs resolve here. When the raw data's path changed, the links must be rewritten: ``find <project> -xtype l``
  lists the broken ones. Rewrite them for the whole project as yourself, without ``sudo`` (you
  copied it, so the links are yours; the lab's account also can, once the group has write):

  .. code-block:: bash

     /apps/helpers/cryosparc.sh project-relink <sj-path>/<project> <rockfish raw path> <skipjack raw path>         # shows what it would change
     /apps/helpers/cryosparc.sh project-relink <sj-path>/<project> <rockfish raw path> <skipjack raw path> --yes   # changes it

  The project path is the folder with ``project.json``; the Rockfish path is the one the links show
  (without ``--yes`` it lists where the broken links point). Only the project's links change, never your data.
  Copy the raw data with the same folder layout under one directory, so one old path covers every link.

.. _cryosparc-if-attach-or-unarchive-fails:

If attach or unarchive fails
----------------------------

+------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Message or symptom                                                     | Cause, fix                                                                       |
+========================================================================+==================================================================================+
| Attach refused, lock found                                             | the project is still attached on Rockfish: detach it there first                 |
+------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Path rejected                                                          | you gave the parent directory: give the project folder itself (the one with      |
|                                                                        | ``project.json``)                                                                |
+------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| The file picker shows nothing, or "400" in ``$DEST/state/run/api.log`` | leading spaces in the path box: clear it and retype the path                     |
+------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Path not found                                                         | the directory is not under ``PROJECT_DIRS``: add it with ``config``, then        |
|                                                                        | ``restart``                                                                      |
+------------------------------------------------------------------------+----------------------------------------------------------------------------------+

References: CryoSPARC's guides on
`migrating an instance <https://guide.cryosparc.com/setup-configuration-and-management/software-system-guides/tutorial-migrating-your-cryosparc-instance>`__
and `data management <https://guide.cryosparc.com/setup-configuration-and-management/software-system-guides/guide-data-management-in-cryosparc-v4.0>`__
(detach, attach, archive), and the CryoSPARC forum thread
`moving the whole database and data to a new cluster <https://discuss.cryosparc.com/t/moving-the-whole-database-and-data-to-a-new-cluster/25534/6>`__.



|

|

----


.. _cryosparc-when-something-fails:

When something fails
####################

+----------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Symptom                                                                          | Cause, fix                                                                       |
+==================================================================================+==================================================================================+
| ``Account 'X' is not available for user ...`` at submit                          | ``ACCOUNT`` is not a Slurm account you belong to: fix it with ``config``, then   |
|                                                                                  | ``lane``                                                                         |
+----------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``the master of <name> is not running``                                          | start it: ``cryosparc.sh start``, OnDemand > CryoSPARC Master, or                |
|                                                                                  | ``sbatch $DEST/state/master.sbatch``                                             |
+----------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``Invalid qos specification`` or                                                 | your account cannot use the ``cryosparc`` QOS, partition or reservation yet:     |
| ``Invalid account or account/partition combination`` when the master starts      | open a ticket                                                                    |
+----------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| The master's job stays pending                                                   | ``squeue -u ext-<pi>-cryosparc`` (or ``--me``, for a lab under your own account) |
|                                                                                  | shows the reason; its host is busy or down: open a ticket                        |
+----------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``ports in use within N-N+10`` in the master job's log                           | another lab uses that range: change ``PORT`` in ``config``                       |
+----------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| ``SLURM_MODE=bind needs the host Slurm client ...``                              | the host has no ``/apps/helpers/slurm-apptainer.sh``: tell ARCH                  |
+----------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| OnDemand session shows "nothing answers" or a connection error                   | the master is stopped: ``status``, then start it (above); reload the page in     |
|                                                                                  | Firefox                                                                          |
+----------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Your lab is not in the OnDemand list                                             | ARCH adds it: open a ticket                                                      |
+----------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| SSH tunnel: ``channel open failed: administratively prohibited``                 | the login node refused the forward: use OnDemand, and tell ARCH the login host   |
|                                                                                  | and port you used                                                                |
+----------------------------------------------------------------------------------+----------------------------------------------------------------------------------+
| Logs                                                                             | ``status``; the master job's log ``$DEST/state/run/master-<job>.log``;           |
|                                                                                  | CryoSPARC's service logs under ``$DEST/state/run/``                              |
+----------------------------------------------------------------------------------+----------------------------------------------------------------------------------+

Anything else: ``/apps/helpers/cryosparc.sh help``, or open a ticket with ARCH.

.. _cryosparc tutorial:

CryoSPARC on the Cluster
========================

.. contents::
   :local:
   :depth: 2

Each lab runs its own CryoSPARC: your account, your database, your license, your project
directories. What is shared is the software: one image per CryoSPARC version in
``/apps/software/cryosparc/``. Everything below is done with one command,
``/apps/helpers/cryosparc.sh``.


Before you start
################

- A CryoSPARC **license ID** for your lab (free for academic use, requested from Structura).
- A directory on ``/scratch`` for the install, the database and the SSD cache,
  e.g. ``/scratch/<affiliation>/<user>/cryosparc``.
- Your lab's **Slurm account for CryoSPARC**, ``<pi>_cryosparc``: a paid allocation of your project,
  requested in ColdFront like any other (project abbreviation ``cryosparc``). Jobs are charged to it.
- Your **port**, assigned by ARCH: CryoSPARC uses ``PORT`` to ``PORT+10``, one range per lab, below the
  kernel's ephemeral range (32768-60999, which CryoSPARC refuses). Ask ARCH if you do not have yours.
- The host ARCH gives your lab for the master: a node of the CryoSPARC reservation or a dedicated
  node (not a login node). The master runs where you run ``start``.

What ARCH assigns per lab looks like this (example names):

+--------------------------+------------------------+------------------------------------+----------+
| PI                       | Manager                | Slurm account (``ACCOUNT``)        | ``PORT`` |
+==========================+========================+====================================+==========+
| test lab (ARCH)          | R.S. Jacomini          | ``sjadmin``                        | 25000    |
+--------------------------+------------------------+------------------------------------+----------+
| Ada Lovelace             | Charles Babbage        | ``alovela1_cryosparc``             | 25100    |
+--------------------------+------------------------+------------------------------------+----------+
| Grace Hopper             | Howard Aiken           | ``ghopper1_cryosparc``             | 25200    |
+--------------------------+------------------------+------------------------------------+----------+
| Rosalind Franklin        | Raymond Gosling        | ``rfrankl1_cryosparc``             | 25300    |
+--------------------------+------------------------+------------------------------------+----------+
| Dorothy Hodgkin          | Max Perutz             | ``dhodgki1_cryosparc``             | 25400    |
+--------------------------+------------------------+------------------------------------+----------+
| Barbara McClintock       | Harriet Creighton      | ``bmcclin1_cryosparc``             | 25500    |
+--------------------------+------------------------+------------------------------------+----------+
| Chien-Shiung Wu          | Luke Yuan              | ``cwu1_cryosparc``                 | 25600    |
+--------------------------+------------------------+------------------------------------+----------+
| Lise Meitner             | Otto Frisch            | ``lmeitne1_cryosparc``             | 25700    |
+--------------------------+------------------------+------------------------------------+----------+
| Emmy Noether             | Hermann Weyl           | ``enoethe1_cryosparc``             | 25800    |
+--------------------------+------------------------+------------------------------------+----------+
| Katherine Johnson        | Dorothy Vaughan        | ``kjohnso1_cryosparc``             | 25900    |
+--------------------------+------------------------+------------------------------------+----------+
| Mary Anning              | Henry De la Beche      | ``mannin1_cryosparc``              | 26000    |
+--------------------------+------------------------+------------------------------------+----------+


|

|

----


One-time setup
##############

.. code-block:: bash

   /apps/helpers/cryosparc.sh config         # answers are kept in ~/.cryosparc/<group>.ini
   /apps/helpers/cryosparc.sh versions       # CryoSPARC versions available
   /apps/helpers/cryosparc.sh init 5.0.7     # installs your lab on that version, starts it,
                                              # prints the admin password ONCE (change it: passwd)

Settings that matter in ``config``:

+-----------------------------+---------------------------------------------------------------------------------------------------+
| Setting                     | Value                                                                                             |
+=============================+===================================================================================================+
| ``MODE``                    | ``cluster`` (jobs run through Slurm)                                                              |
+-----------------------------+---------------------------------------------------------------------------------------------------+
| ``DEST``, ``DBPATH``,       | under your ``/scratch`` directory                                                                 |
| ``SSDPATH``                 |                                                                                                   |
+-----------------------------+---------------------------------------------------------------------------------------------------+
| ``PROJECT_DIRS``            | comma-separated directories your projects live in (mounted as they are)                           |
+-----------------------------+---------------------------------------------------------------------------------------------------+
| ``PORT``                    | the one ARCH assigned to your lab (below 32768)                                                   |
+-----------------------------+---------------------------------------------------------------------------------------------------+
| ``LICENSE_ID``              | your lab's license                                                                                |
+-----------------------------+---------------------------------------------------------------------------------------------------+
| ``ACCOUNT``, ``PARTITION``, | ``<pi>_cryosparc``; GPU partition (e.g. ``a100``); the CryoSPARC reservation ARCH names (blank if |
| ``RESERVATION``             | none)                                                                                             |
+-----------------------------+---------------------------------------------------------------------------------------------------+
| ``SLURM_MODE``              | ``bind``                                                                                          |
+-----------------------------+---------------------------------------------------------------------------------------------------+
| ``EMAIL``, ``ADMIN_USER``   | the CryoSPARC admin login                                                                         |
+-----------------------------+---------------------------------------------------------------------------------------------------+

.. warning::

   The ``.ini`` holds your license ID: it is created mode 600, keep it that way and do not paste it in tickets.


|

|

----


Every day
#########

.. code-block:: bash

   /apps/helpers/cryosparc.sh start | stop | restart | status
   /apps/helpers/cryosparc.sh tunnel         # how to reach the web interface from your workstation
   /apps/helpers/cryosparc.sh passwd         # change the admin password

The web interface listens on ``http://<host>:PORT``; from outside the cluster use the SSH tunnel
``tunnel`` prints. Other lab members are added as CryoSPARC users inside the web interface.


|

|

----


Jobs
####

Jobs are submitted to Slurm by the lane ``init`` created (``$DEST/lanes/<partition>/``), on ``PARTITION``
(and ``RESERVATION`` when set), charged to ``ACCOUNT``, as your user. In the job builder choose the lane named ``slurm-<partition>``.

If a job fails at submit with a ``[BILLING] ... Proceed? [y/N]`` / ``Cancelled`` message, the cluster
is asking for a cost confirmation that a non-interactive submit cannot give: add the line
``#SBATCH --comment=accept_cost`` to ``$DEST/lanes/<partition>/cluster_script.sh`` and run
``/apps/helpers/cryosparc.sh lane`` to reload it.

A complete working lane, with CPU-only jobs sent to ``med`` and GPU jobs to ``a100``, is in
``/apps/software/cryosparc/examples/lane-a100/`` (see its README for the placeholders).


|

|

----


Versions
########

.. code-block:: bash

   /apps/helpers/cryosparc.sh versions          # images available, the one your lab runs
   /apps/helpers/cryosparc.sh versions --remote # also what CryoSPARC has released
   /apps/helpers/cryosparc.sh update 5.0.8      # move your lab to that version (stops, swaps, starts)

.. note::

   Forward only: the first start on a newer version migrates your database, and an older version
   will not start on a migrated database. Take a ``backup`` before an ``update``.

The master stops only for an ``update`` (or a maintenance you are told about) and comes back on the
same port; nothing else about your lab changes across versions.


|

|

----


Backup and restore
##################

.. code-block:: bash

   /apps/helpers/cryosparc.sh backup            # database dump (.archive) into $DEST/backups, master running
   /apps/helpers/cryosparc.sh backup /scratch/.../somewhere   # any directory under DEST or a project dir
   /apps/helpers/cryosparc.sh stop
   /apps/helpers/cryosparc.sh restore /scratch/.../cryosparc_backup_....archive
   /apps/helpers/cryosparc.sh start

.. note::

   The backup is the database only. Your project directories are your data and are not copied; a
   backup matches them as they were when it was taken, so do not restore one older than your projects.


|

|

----


When something fails
####################

+-----------------------------------------------------+------------------------------------------------------------------------------------------+
| Symptom                                             | Cause, fix                                                                               |
+=====================================================+==========================================================================================+
| ``Account 'X' is not available for user ...``       | ``ACCOUNT`` is not a Slurm account you belong to: fix it with ``config``, then ``lane``  |
| at submit                                           |                                                                                          |
+-----------------------------------------------------+------------------------------------------------------------------------------------------+
| ``ports in use within N-N+10`` at start             | another lab uses that range: change ``PORT`` in ``config``                               |
+-----------------------------------------------------+------------------------------------------------------------------------------------------+
| ``SLURM_MODE=bind needs the host Slurm client ...`` | the host has no ``/apps/helpers/slurm-apptainer.sh``: tell ARCH                          |
+-----------------------------------------------------+------------------------------------------------------------------------------------------+
| Web interface unreachable from your workstation     | run ``tunnel`` and use the SSH command it prints                                         |
+-----------------------------------------------------+------------------------------------------------------------------------------------------+
| Logs                                                | ``status``, and the service logs under ``$DEST/state/run/``                              |
+-----------------------------------------------------+------------------------------------------------------------------------------------------+

Anything else: ``/apps/helpers/cryosparc.sh help``, or open a ticket with ARCH.

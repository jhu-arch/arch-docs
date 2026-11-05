.. _rockfish migration:

Migrating from Rockfish
=======================

Rockfish is moving into Skipjack, ARCH's new cluster. Rockfish hardware is joining Skipjack in phases
between November and December 2026, so every Rockfish user needs a Skipjack account and needs to move
their data and software environment. This page collects the steps, the schedule and the links you need.

.. admonition:: Start now
   :class: tip

   Skipjack account creation is open. Before you move anything, take some time to review and clean up
   your data on Rockfish: the less you move, the easier the migration.

Quick Links
-----------

- `ARCH Portal (Skipjack accounts, projects and allocations) <https://portal.arch.jhu.edu/>`_
- :doc:`Skipjack User Guide <user-guide>`
- :doc:`Skipjack Quick Start <quickstart>`
- :doc:`Skipjack FAQ <migration-to-skipjack>`
- :doc:`Skipjack Partitions <2_Slurm/Partitions>` (including the planned partitions for Rockfish hardware)
- :doc:`Skipjack Storage <1_Resources/Storage>`
- `Globus <https://www.globus.org>`_
- `Email the helpdesk: arch@jhu.edu <mailto:arch@jhu.edu>`_
- `Office hours on Zoom <https://jh.zoom.us/j/94161100311>`_ (Monday to Friday, 10:00 AM to 3:00 PM)
- `Skipjack user survey <https://jh.qualtrics.com/jfe/form/SV_74ixLkPLYHjDUjk>`_

Migration Schedule
------------------

Rockfish hardware moves to Skipjack in phases. Nodes taken out of Rockfish in a phase are no longer
available on Rockfish from that date, so Rockfish has less capacity after each phase and queue waits there
may get longer. The hardware becomes available on Skipjack once it has been rebuilt and tested.

.. list-table::
   :header-rows: 1
   :widths: 14 18 68

   * - **Phase**
     - **Date**
     - **What moves**
   * - Phase 2
     - November 3, 2026
     - Skipjack account creation opens. The first group of 25% of nodes will move.
   * - Phase 3
     - November 17, 2026
     - The second group of 25% of nodes will move.
   * - Phase 4
     - December 1, 2026
     - The third group of 25% of nodes will move.
   * - Phase 5
     - December 15, 2026
     - The last group 25% of nodes will move.

Dates may shift; this page will be updated if they do. Rockfish hardware joins Skipjack as new
partitions, and their names and limits are not final yet. See
:doc:`Skipjack Partitions <2_Slurm/Partitions>` for the current plan.

What You Need to Do
-------------------

1. Create your Skipjack account
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Follow `Create or Activate an Account <user-guide.html#create-or-activate-an-account>`_ in the User Guide.
If you already have a Skipjack account, skip this step.

After your account is created, your PI needs to add you to a project **and** an allocation before you can
use the cluster. Rockfish accounts, projects and allocations do not carry over to Skipjack.

2. Storage
^^^^^^^^^^

Every user gets a default scratch allocation on Skipjack. Large storage allocations (more than 10 TB)
need a valid Internal Order (IO) or Cost Center (CC); PIs can follow
`Request Project Storage <user-guide.html#request-project-storage>`_ in the User Guide. See
:doc:`1_Resources/Storage` for the storage areas and their paths.

3. Plan and transfer your data with Globus
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Access to the Rockfish GPFS filesystems does not move to Skipjack, so plan to move your data once you have
access to Skipjack. `Data Transfer with Globus <user-guide.html#data-transfer-with-globus>`_ in the User
Guide walks through the transfer step by step.

.. important::

   - **Your Rockfish username must be your JHED ID** for Globus to work. If your Rockfish account was created
     without your JHED ID, see :ref:`Transferring Data from Rockfish? <id-not-match>` for next steps.
   - **File permissions only carry over if everyone who needs access already has a Skipjack account** when you
     transfer. Make sure everyone in your group has created their Skipjack account first.

For tips on preparing your data, see the :doc:`Skipjack FAQ <migration-to-skipjack>`.

4. Rebuild your software environment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As a best practice, rebuild your software environment whenever the underlying hardware or core software
libraries change. Expect to make small changes to your scripts, rebuild code from source, and recreate your
workflows (conda environments, npm packages, local ``.rc`` configurations and so on).

ARCH is moving the software stack over during the migration, starting with the most widely used software.
We cannot guarantee that the exact software or versions you use will be on Skipjack when you migrate. Email
the `helpdesk <mailto:arch@jhu.edu>`_ if you need help.

For PIs
-------

- `Request an upgrade to PI status <user-guide.html#request-account-upgrade-to-pi>`_.
- `Add your lab members to a project and allocation <user-guide.html#add-users-to-a-project-or-allocation>`_.
- PI accounts come with small default compute and storage allocations for trying out the system. These are
  likely not enough for computational work.
- For more compute and storage, first `create a project <user-guide.html#create-a-project>`_ with a valid
  IO/CC, then request resources for that project in the `ARCH Portal <https://portal.arch.jhu.edu/>`_.
  When you request your project, list the software your group needs so we can prepare it.

Getting Help
------------

- Send support requests to `arch@jhu.edu <mailto:arch@jhu.edu>`_.
- Join our open `office hours <https://jh.zoom.us/j/94161100311>`_, Monday to Friday, 10:00 AM to 3:00 PM.
- The :doc:`Skipjack User Guide <user-guide>` has more detail on every step.
- Tell us how Skipjack is working for you in the
  `user survey <https://jh.qualtrics.com/jfe/form/SV_74ixLkPLYHjDUjk>`_.

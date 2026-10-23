:orphan:

.. _skipjack faq dropdown:

Skipjack and ARCH Portal FAQ
============================

Answers to the questions people ask the ARCH helpdesk most often about the
Skipjack cluster and the ARCH portal. Sections and questions are ordered by
how often each topic comes up in helpdesk tickets (July to October 2026).

Full documentation: `docs.arch.jhu.edu <https://docs.arch.jhu.edu/en/latest/>`_.

**Coming from Rockfish?** Accounts, projects and data do not move by
themselves. See the relevant dropdowns below:
"Will my Rockfish account and project move to Skipjack?", "How do I move my
data from Rockfish?", "Do I need to rebuild my software for Skipjack?", and
"Does Skipjack cost anything?".

.. contents::
   :local:
   :depth: 2


Accounts, login and access
##########################

.. dropdown:: How do I get an account?

   Sign in to the ARCH portal at `portal.arch.jhu.edu <https://portal.arch.jhu.edu>`_:

   - **JHED users:** choose **JHED Login ID** and sign in with Johns Hopkins SSO.
   - **External collaborators:** choose **Register** to create a local account,
     with a username that starts with ``ext-``. JHED users must not register a
     local account.
   - **Schmidt Sciences users:** contact Schmidt Sciences first. Your portal is
     `portal.schmidtsciences.jhu.edu <https://portal.schmidtsciences.jhu.edu>`_.
   - **Students in a class:** your instructor requests your account; see
     "How do students get accounts for a class?" below.

   Everyone accepts the Terms of Service at first sign-in. An account alone does
   not give cluster access; see the next dropdown.

   Source: `User Guide: Create or activate an account <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#create-or-activate-an-account>`_

.. dropdown:: I have an account but I cannot log in or run jobs. Why?

   Cluster access needs a sponsor. Check, in order:

   #. Your PI, a project Manager or your course instructor added you to an active
      project **and** to one of its allocations. Being a member of the project
      alone gives no cluster access.
   #. You accepted the current Terms of Service on your **User Profile** in the
      portal.
   #. About 15 minutes have passed since that change; the portal updates the
      cluster on that cycle.

   Still blocked? Open a ticket with your username, your PI and the project name.

.. dropdown:: How do I log in with SSH?

   +------------------------+--------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
   | Account                | Command                                          | Second factor                                                                                                          |
   +========================+==================================================+========================================================================================================================+
   | JHED                   | ``ssh <username>@login.arch.jhu.edu``            | The terminal prints a link: approve the login in your browser with JHU SSO, then press Enter in the terminal           |
   +------------------------+--------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
   | External or class      | ``ssh <username>@login.arch.jhu.edu``            | Your password, then the 6-digit code from your authenticator app                                                       |
   +------------------------+--------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
   | Schmidt Sciences       | ``ssh <username>@login.schmidtsciences.jhu.edu`` | Your password, then the 6-digit code from your authenticator app                                                       |
   +------------------------+--------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+

   The first time you connect, type ``yes`` to accept the host key.

   Source: `Connect to the Skipjack cluster <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#connect-to-the-skipjack-cluster>`_

.. dropdown:: How do students get accounts for a class?

   The instructor (a PI) requests them in the portal under **Projects > My
   Classes > Class Request**, with the roster as ``Full Name,JHED-ID,external
   e-mail``. Use each student's external (non-JHU) e-mail address: the link to
   set the password goes there.

   Each student gets an account whose username starts with the course code, and
   signs in with that password and an authenticator code, not with JHED. **Class
   accounts and their files are deleted at the end of the course**, so students
   should copy what they need before the end date.

.. dropdown:: How do I reset my password?

   - **JHED:** at `my.jh.edu <https://my.jh.edu>`_. ARCH does not manage JHED
     passwords.
   - **External and Schmidt Sciences:** choose **Forgot Password** on the portal
     sign-in page, then **Send Reset Email**.
   - **Class accounts:** ask your instructor to resend the password link, or
     e-mail `arch@jh.edu <mailto:arch@jh.edu>`_.

   Source: `Reset password <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#reset-password>`_

.. dropdown:: Can I log in with an SSH key?

   Not to the login node: every login there goes through
   multi-factor authentication. The
   `VS Code guide <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/vscode.html>`_
   uses a key only for the connection from your computer to the compute node that
   runs your job, tunnelled through the login node.

.. dropdown:: How do external collaborators get access?

   They register a local account with **Register** on the portal sign-in page,
   choosing a username that starts with ``ext-``, and set up an authenticator app.
   Their PI then adds them to an allocation, as for any member.

.. dropdown:: How do I set up my authenticator app?

   JHED users skip this step: they use JHU SSO and Microsoft MFA. Everyone else,
   in the portal: user icon > **My Profile** > **Two-Factor Auth (2FA)** >
   **Set up 2FA** > **Set up Authenticator application**. Scan the QR code with
   Microsoft Authenticator, Google Authenticator or FreeOTP, type the 6-digit
   code and click **Submit** before it changes.

   Source: `Set up multi-factor authentication <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#setup-multi-factor-identification>`_

.. dropdown:: I lost my phone or my authenticator app. What do I do?

   - **JHED users:** your MFA is the Johns Hopkins Microsoft MFA; contact JHU IT
     to reset it.
   - **Everyone else:** open a ticket from another device
     (`arch@jh.edu <mailto:arch@jh.edu>`_, or
     `ssci@jh.edu <mailto:ssci@jh.edu>`_ for Schmidt Sciences). Staff reset your
     authenticator, and you set up a new one at your next portal sign-in.

.. dropdown:: How do I become a PI?

   In the portal, open **My Profile > Upgrade Account**, pick your department and
   click **Submit Upgrade Request**. Staff review the request. Once it is
   approved, you get a default project with a small compute allocation for testing
   and 1 TB of scratch storage. If your department is not listed, e-mail
   `arch@jh.edu <mailto:arch@jh.edu>`_.

   Source: `Request account upgrade to PI <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#request-account-upgrade-to-pi>`_

.. dropdown:: Can someone else manage my project for me?

   Yes. A PI can make a project member a Proxy Account Manager: on the project
   page, in the Users table, click the person icon, choose the **Manager** role
   and click **Update**. Managers can handle many project tasks for the PI, such
   as adding users. Only PIs can assign the role.

   Source: `Assign proxy account managers <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#assign-proxy-account-managers>`_

.. dropdown:: Will my Rockfish account and project move to Skipjack?

   No. Create a Skipjack account in the portal; PIs also create a new project.
   Members create their own accounts too, and the PI adds them. All DSAI members
   can move now; other groups are being onboarded in phases.

   Source: `Skipjack frequently asked questions <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/migration-to-skipjack.html>`_


Storage and data
################

.. dropdown:: Where should I keep my files?

   +--------------------+----------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------+
   | Location           | Path                                                                                                     | Use it for                                                                   |
   +====================+==========================================================================================================+==============================================================================+
   | Home               | ``~``                                                                                                    | Code, scripts and settings. It is the same on login and compute nodes.       |
   |                    |                                                                                                          | Avoid it for training data and large output.                                 |
   +--------------------+----------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------+
   | Scratch            | ``/scratch/jhu/<PI>`` (JHU) or ``/scratch/schmidt/<PI>`` (Schmidt Sciences);                             | Job input and output, training data. 1 TB per PI, shared by                  |
   |                    | members reach it through the link ``~/scratch_<PI>``                                                     | all of the PI's projects.                                                    |
   +--------------------+----------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------+
   | Project Storage    | ``/projects/<PI>``; members reach it through the link ``~/projects_<PI>``                                | Longer-lived project data, on storage the PI requests (one directory per PI).|
   +--------------------+----------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------+

.. dropdown:: My ``scratch_<PI>`` link is missing or broken. What do I do?

   The link is created when your PI adds you to an allocation. If it is missing
   or points nowhere, open a ticket with your username and your PI's name, and
   staff repair it. Until then, use the full scratch path above.

.. dropdown:: How do I get more storage?

   - **More scratch:** e-mail `arch@jh.edu <mailto:arch@jh.edu>`_ with a short
     justification.
   - **Project Storage:** on any project other than the default one, the PI opens
     the project page and, on the **Project Storage** card, chooses **Request
     Storage Change**. Give the total Project Storage and the Cache (its fast SSD
     share) in whole TB; a justification is required above the Cache limit. Staff
     review the request, and the storage is usually ready 1 to 3 business days
     after approval.

   Source: `Request project storage <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#request-project-storage>`_

.. dropdown:: How much storage do I have?

   In the portal, **Projects > My Storage** lists the Project Storage and Cache
   of each of your projects, any pending change, and the directory path. Scratch
   is 1 TB per PI unless it was raised.

.. dropdown:: How do I transfer data?

   Use Globus for large transfers:

   #. Go to `globus.org <https://www.globus.org>`_ and click **Log in**. JHED
      users choose **Johns Hopkins**; others choose their own organization's login.
   #. In **File Manager**, pick the source collection and the files.
   #. Split the view, search for **Skipjack** and pick your destination:

      +------------------------+------------------------------------------------------------+
      | Account                | Destination collections                                    |
      +========================+============================================================+
      | JHED                   | Skipjack JHU JHED Homes, Skipjack JHU JHED Scratch         |
      +------------------------+------------------------------------------------------------+
      | Schmidt Sciences       | Skipjack JHU Homes, Skipjack SSCI Scratch                  |
      +------------------------+------------------------------------------------------------+
      | External               | Skipjack JHU Homes, Skipjack JHU Scratch                   |
      +------------------------+------------------------------------------------------------+

   #. Allow access when Globus asks. Schmidt Sciences and external users enter
      their Skipjack username and password. Then start the transfer.

   Source: `Data transfer with Globus <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#data-transfer-with-globus>`_

.. dropdown:: How do I move my data from Rockfish?

   Use Globus as above, with **Rockfish dtn** as the source collection (either
   data transfer node works).

   - Your Rockfish username must exactly match your JHED ID. If it does not,
     create a Rockfish account that matches your JHED, ask your PI to add it to
     the project, and e-mail `arch@jh.edu <mailto:arch@jh.edu>`_ so staff can make
     your files available to it.
   - Clean up first: delete redundant or obsolete data, and move data you no
     longer use for active research to long-term storage.
   - Globus keeps file permissions only if the same users already have Skipjack
     accounts before the transfer.

   Source: `Rockfish users migrating their data <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#rockfish-users-migrating-their-data-to-skipjack>`_

.. dropdown:: How do I share files with my group?

   Use group permissions: ``groups`` lists your groups,
   ``chgrp <group> <file>`` gives a file to a group, and ``chmod g+r <file>``
   lets that group read it. See
   `Managing group permissions <https://docs.arch.jhu.edu/en/latest/2_Common_Tasks/Managing_Group_Permissions.html>`_.


Troubleshooting
###############

.. dropdown:: How do I get the software I need?

   Open a helpdesk ticket (see "How do I contact ARCH?" below) titled
   ``Software request: <name> <version>``. On the web form, choose **I need
   software installed, or a module is missing or broken** under "What best
   describes your issue?"; the form then asks for these details. By e-mail,
   include:

   - The software name and version (or "latest").
   - Its website or download link.
   - The license: free or open source, or commercial (who holds the license, and
     any license file or server).
   - What you will use it for, in a sentence or two.
   - Who will use it: just you, your group, or a class.
   - Special requirements, such as GPU or CUDA version, MPI or a specific
     compiler.
   - When you need it.

   You do not need to name a cluster: software requests are for Skipjack.

.. dropdown:: Do I need to rebuild my software for Skipjack?

   Usually yes. Recompile your code and recreate conda or Python environments on
   Skipjack instead of copying them from Rockfish.

.. dropdown:: I cannot connect to the login node. What should I check?

   - The host matches your account: ``login.arch.jhu.edu`` (JHED, external,
     class) or ``login.schmidtsciences.jhu.edu`` (Schmidt Sciences).
   - **JHED:** open the link the terminal prints, approve in the browser, then
     press Enter in the terminal.
   - **Other accounts:** type the current 6-digit code; it changes every 30
     seconds.
   - You have cluster access; see "I have an account but I cannot log in" above.
   - The `status page <https://status.arch.jhu.edu>`_ shows no maintenance.

.. dropdown:: My job ended with OUT\_OF\_MEMORY. What do I do?

   The job used more memory than it requested; its log shows
   ``slurmstepd: error: Detected 1 oom_kill event``. Raise ``--mem`` to about 20%
   above the job's peak memory, which ``seff <jobid>`` or ``jobstats <jobid>``
   shows.

   Each partition gives a fixed amount of memory per core, and that is also the
   maximum. Asking for more memory therefore adds cores: on ``med``,
   ``--cpus-per-task=1 --mem=40G`` gets 11 cores.

   Source: `CPU memory <https://docs.arch.jhu.edu/en/latest/2_Common_Tasks/Job_Efficiency/CPU_Memory.html#when-a-job-runs-out-of-memory>`_

.. dropdown:: My job is slow or my GPU sits idle. Why?

   - In Python, count usable cores with ``len(os.sched_getaffinity(0))``, not
     ``os.cpu_count()``.
   - Set ``export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK`` so threaded code uses
     the cores you requested.
   - A GPU under about 50% busy is usually waiting for data: read it from
     scratch, not home, and use more data-loading workers.
   - ``jobstats <jobid>`` shows the CPU, memory and GPU use of a finished job.

   Sources: `CPU utilization <https://docs.arch.jhu.edu/en/latest/2_Common_Tasks/Job_Efficiency/CPU_Utilization.html>`_,
   `GPU computing <https://docs.arch.jhu.edu/en/latest/2_Common_Tasks/Job_Efficiency/GPU_Computing.html>`_

.. dropdown:: VS Code does not connect. What do I check?

   +----------------------------------------------------+------------------------------------------------------------------------+
   | Symptom                                            | Fix                                                                    |
   +====================================================+========================================================================+
   | Asked for your password and code for the login node| The master session is not open: run ``ssh skipjack`` in a terminal     |
   |                                                    | first                                                                  |
   +----------------------------------------------------+------------------------------------------------------------------------+
   | Asked for a password for ``skipjack-compute``      | The key is not registered; reopening the master session does not fix   |
   |                                                    | it. Redo step 2 of the guide                                           |
   +----------------------------------------------------+------------------------------------------------------------------------+
   | ``Permission denied (publickey,...)``              | The compute-node key is missing or does not match: redo step 2 of the  |
   |                                                    | guide                                                                  |
   +----------------------------------------------------+------------------------------------------------------------------------+
   | ``Connection timed out during banner exchange``    | Set ``"remote.SSH.connectTimeout": 300`` in VS Code                    |
   +----------------------------------------------------+------------------------------------------------------------------------+
   | ``unix_listener: cannot bind to path``             | Run ``mkdir -p ~/.ssh/cm`` on your computer                            |
   +----------------------------------------------------+------------------------------------------------------------------------+
   | ``vscode_job.sh: command not found``               | Use the full path ``/apps/helpers/vscode_job.sh``                      |
   +----------------------------------------------------+------------------------------------------------------------------------+

   Source: `VS Code troubleshooting <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/vscode.html#troubleshooting>`_


Compute and jobs
################

.. dropdown:: Which partition should I use?

   +---------------------+------------------------------------------------------------------+--------------+
   | Partition           | What it is for                                                   | Time limit   |
   +=====================+==================================================================+==============+
   | ``interactive_cpu`` | Interactive CPU sessions                                         | 4 hours      |
   +---------------------+------------------------------------------------------------------+--------------+
   | ``interactive_gpu`` | Interactive GPU work on A100 slices (MIG), one slice per user    | 4 hours      |
   +---------------------+------------------------------------------------------------------+--------------+
   | ``agentic``         | Development while using agentic AI tools                         | 7 days       |
   +---------------------+------------------------------------------------------------------+--------------+
   | ``med``             | CPU batch jobs                                                   | 72 hours     |
   +---------------------+------------------------------------------------------------------+--------------+
   | ``l40s``, ``a100``, | GPU batch jobs on JHU accounts, by GPU model                     | 72 hours     |
   | ``h100``, ``h200``  |                                                                  |              |
   +---------------------+------------------------------------------------------------------+--------------+
   | ``b200``, ``b300``  | GPU batch jobs on Schmidt Sciences accounts                      | 72 hours     |
   +---------------------+------------------------------------------------------------------+--------------+
   | ``rtx6000``         | Groups that bought these nodes                                   | 72 hours     |
   +---------------------+------------------------------------------------------------------+--------------+

   Node counts, cores and memory per partition are on the
   `Partitions <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/2_Slurm/Partitions.html>`_
   page. Your account already sets the QoS, so most jobs never need ``--qos``.

.. dropdown:: How do I request a GPU?

   Add ``--gres=gpu:<count>``, for example ``#SBATCH --partition=a100`` and
   ``#SBATCH --gres=gpu:1``.

   - A job on a GPU partition without a GPU request is rejected, and so is a GPU
     request on a CPU partition.
   - One A100 slice for interactive work:
     ``--partition=interactive_gpu --gres=gpu:2g.20gb:1``.
   - On ``h100``, ``--prefer=h100_sxm`` or ``--prefer=h100_nvl`` asks for one of
     the two H100 models.
   - Each GPU comes with default cores and memory (for example 10 cores and 60 GB
     per A100).

   Source: `GPU computing <https://docs.arch.jhu.edu/en/latest/2_Common_Tasks/Job_Efficiency/GPU_Computing.html>`_

.. dropdown:: Which account should I submit my jobs with?

   Your PI's free default allocation uses the PI's username as its account; a paid
   project uses ``<PI>_<abbreviation>``, where the abbreviation is the project's
   short name. List the accounts you can use with ``interact -l`` or
   ``sacctmgr -n -P show assoc user=$(id -un) format=Account,QOS``, and pass one
   with ``--account=<account>`` (or ``-A <account>``).

.. dropdown:: How do I start an interactive session?

   ``interact`` always needs the account to use (``-a``):

   - ``interact -l`` lists the partitions and the accounts you can use.
   - ``interact -a <account> -p interactive_cpu -n 4 -t 2:00:00`` gives 4 cores
     for 2 hours.
   - ``interact -a <account> -p a100 -g 1`` gives one A100 GPU.

.. dropdown:: Why is my job pending?

   Run ``squeue -u $USER`` and read the reason column:

   +------------------------------+--------------------------------------------------------------------+------------------------------------------------------------------------------+
   | Reason                       | What it means                                                      | What to do                                                                   |
   +==============================+====================================================================+==============================================================================+
   | ``Priority`` or ``Resources``| Waiting its turn for free nodes                                    | Nothing; a shorter ``--time`` can start sooner                               |
   +------------------------------+--------------------------------------------------------------------+------------------------------------------------------------------------------+
   | Starts with ``AssocGrp`` and | The allocation used its budget or spending limit for this period   | It starts after the reset, or once the PI raises the spending limit (staff   |
   | ends in ``Minutes``          |                                                                    | raise a default allowance)                                                   |
   +------------------------------+--------------------------------------------------------------------+------------------------------------------------------------------------------+
   | ``AssocGrpGRES``             | The account's GPU limit is 0, or all its GPUs are in use           | Wait for its other jobs, or ask your PI                                      |
   +------------------------------+--------------------------------------------------------------------+------------------------------------------------------------------------------+
   | Starts with ``QOSMax`` and   | You or your account already use a limit of your QoS, such as GPUs  | It starts when your running jobs finish                                      |
   | ends in ``PerUser`` or       | at once                                                            |                                                                              |
   | ``PerAccount``               |                                                                    |                                                                              |
   +------------------------------+--------------------------------------------------------------------+------------------------------------------------------------------------------+
   | Starts with ``QOSMax`` and   | The job asks for more than its QoS allows                          | Cancel it and request less                                                   |
   | ends in ``PerJob``           |                                                                    |                                                                              |
   +------------------------------+--------------------------------------------------------------------+------------------------------------------------------------------------------+
   | ``ReqNodeNotAvail``          | Some nodes of the partition are down                               | Usually not why your job waits, unless maintenance is scheduled: a shorter   |
   |                              |                                                                    | ``--time`` lets it finish before then                                        |
   +------------------------------+--------------------------------------------------------------------+------------------------------------------------------------------------------+

.. dropdown:: My job was rejected with "Invalid account or account/partition combination". Why?

   Slurm prints this message for several causes. The common ones: you do not have
   cluster access on that account yet (see "Accounts, login and access" above),
   the PI has not set a spending limit on a new paid allocation yet, or the
   partition belongs to the other affiliation, for example a JHU account on
   ``b200``. ``interact -l`` shows the accounts you can use.

.. dropdown:: Can I run programs or VS Code on the login node?

   No. The login node is for editing scripts, submitting jobs and checking their
   output; running jobs on it is prohibited, and staff stop heavy processes there.
   Run your work in a job: ``interact`` for a shell, and the
   `VS Code guide <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/vscode.html>`_
   for VS Code, which starts a job with ``/apps/helpers/vscode_job.sh`` and
   connects to it.

.. dropdown:: I want to submit many jobs at once. Is there a limit?

   Yes: there are per-group and per-partition job limits. Write to
   `arch@jh.edu <mailto:arch@jh.edu>`_ before submitting a large number of jobs.

   Source: `Slurm on Skipjack <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/2_Slurm/Slurm.html>`_

.. dropdown:: How do I check my jobs and how efficient they were?

   - ``sqme`` shows your running and pending jobs.
   - ``sacct -X -S now-7days -o JobID,JobName%20,Partition,State,Elapsed,AllocCPUS,ReqMem``
     lists your jobs of the last 7 days.
   - ``seff <jobid>`` shows how much CPU and memory a finished job used, and
     ``jobstats <jobid>`` also shows GPU use, so you can request less next time.

   Source: `Job statistics <https://docs.arch.jhu.edu/en/latest/2_Common_Tasks/Job_Efficiency/Jobstats.html>`_


Allocations and billing
#######################

.. dropdown:: Does Skipjack cost anything?

   Not now. Compute on Skipjack is free for the time being. ARCH will not start
   billing without substantial prior notice, and nothing will ever be billed
   retroactively. The portal already uses the paid workflow below (projects, IO
   numbers, spending limits), so it is in place before billing starts.

   Source: `Skipjack frequently asked questions <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/migration-to-skipjack.html>`_

.. dropdown:: What is the difference between a default allocation and a paid project?

   +---------------------------+---------------------------------------------------+------------------------------------------------------+
   |                           | Default allocation                                | Paid project                                         |
   +===========================+===================================================+======================================================+
   | Who gets it               | Every PI, automatically                           | A PI who creates a project and requests an allocation|
   +---------------------------+---------------------------------------------------+------------------------------------------------------+
   | Budget                    | A fixed allowance, the same for every PI          | No fixed ceiling; the PI sets a spending limit       |
   +---------------------------+---------------------------------------------------+------------------------------------------------------+
   | Who raises it             | ARCH staff, on request                            | The PI, at any time                                  |
   +---------------------------+---------------------------------------------------+------------------------------------------------------+
   | Ready to run              | Immediately                                       | After the PI sets a spending limit or chooses        |
   |                           |                                                   | **No cap**                                           |
   +---------------------------+---------------------------------------------------+------------------------------------------------------+

   Your allocation page in the portal shows the allowance and what is left.

.. dropdown:: How do I create a project and request an allocation?

   #. JHU PIs add a Cost Center first: in **Cost Centers**, choose **+ Add**,
      enter the number, choose its type (IO Number or Cost Center) and, if you
      like, a label.
   #. **Projects > My Projects > + Add a project**, with a description of at
      least 150 words. Staff review the project. The default project cannot host
      a paid allocation.
   #. On the approved project, choose **+ Request Resource Allocation**: pick the
      cluster, write a justification and choose the IO number that pays for it.
   #. Staff approve the allocation. Then the PI sets a spending limit, or chooses
      **No cap**, on the allocation page.

   Sources: `Add a cost center <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#add-a-cost-center>`_,
   `Create a project <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#create-a-project>`_,
   `Request a project compute allocation <https://docs.arch.jhu.edu/en/latest/1_Clusters/Skipjack/user-guide.html#request-a-project-compute-allocation>`_

.. dropdown:: My allocation was approved, but jobs are refused and the allocation page says "Spending limit not set". Why?

   A new paid allocation starts with its limit at 0, so nothing runs until the PI
   sets a spending limit or chooses **No cap** on the allocation page. Only the
   PI can change it; project members ask the PI.

.. dropdown:: How does the spending limit work?

   It caps what the allocation may spend in each usage period of the cluster; the
   allocation page shows the period and the next reset date. When the limit is
   reached, new jobs are accepted but wait, and they start on their own after the
   reset, so you do not need to resubmit. To start them sooner, the PI raises the
   limit.

.. dropdown:: What is an IO number (cost center)?

   The JHU internal order number that pays for a paid allocation. PIs add theirs
   under **Cost Centers** and choose one when they request an allocation. An IO
   number cannot be edited after it is created: if one is wrong, add the correct
   one and open a ticket to move the allocation to it.

.. dropdown:: How will I know what a job costs?

   Usage is counted in service units (SU), where 1 SU = $0.001, and each
   partition has its own SU rate per hour. Once billing starts, ``sbatch`` and
   ``srun`` print an estimate and ask you to confirm; a script that cannot answer
   can accept it up front with
   ``sbatch --export=ALL,ACCEPT_COST=1 job.sh``. ``sbalance`` shows what each of
   your accounts used this period and what is still available.

.. dropdown:: Why is "Available" larger than my limit minus what I used?

   The scheduler gives older usage less weight as the period goes on, so it may
   accept more than the plain difference. ``sbalance --detail`` shows the limit,
   the scheduler's count and the SU held by running jobs.

.. dropdown:: What is never billed?

   - Default (free) allocations.
   - Schmidt Sciences projects.
   - Jobs ended by a node failure (``NODE_FAIL``, ``BOOT_FAIL``).

   Jobs that fail, time out, run out of memory, are cancelled or are preempted
   are billed for the time they held the nodes.

.. dropdown:: Can I pause billing on an IO number?

   Yes, under **Cost Centers** in the portal. A paused IO is never charged, but
   it also **stops new jobs on every paid allocation it funds**; the free default
   allocation keeps working. Pausing opens a helpdesk ticket, and only ARCH staff
   can resume the IO: reply to that ticket when the funding is in place.

.. dropdown:: We want to buy our own nodes. How does that work?

   Purchased-node (condo) projects are set up and managed by ARCH staff, and their
   jobs run on the partition of those nodes (for example ``rtx6000``). Open a
   ticket describing the hardware you have in mind.


Getting help
############

.. dropdown:: How do I contact ARCH?

   - **JHU, external and class accounts:** `arch@jh.edu <mailto:arch@jh.edu>`_
   - **Schmidt Sciences:** `ssci@jh.edu <mailto:ssci@jh.edu>`_
   - **Web form:** `helpdesk.arch.jhu.edu/tickets/submit/ <https://helpdesk.arch.jhu.edu/tickets/submit/>`_
     (Schmidt Sciences:
     `helpdesk.schmidtsciences.jhu.edu/tickets/submit/ <https://helpdesk.schmidtsciences.jhu.edu/tickets/submit/>`_)

.. dropdown:: What should I put in a ticket?

   Your username, the account or allocation, the job IDs, the exact command you
   ran, the full error message or a screenshot, and what you already tried.

.. dropdown:: When will I get an answer?

   Support hours are Monday to Friday, 8:00 AM to 4:30 PM Eastern. A typical
   response comes within one business day, and critical cluster issues may be
   handled after hours. ARCH cannot fully support personal SSH, VPN or network
   problems, unsupported software, or debugging of your own code unrelated to the
   cluster.

   Source: `Service level expectations <https://docs.arch.jhu.edu/en/latest/4_Support/Service_Level_Expectations.html>`_

.. dropdown:: Is the cluster down?

   Check the `status page <https://status.arch.jhu.edu>`_ for outages and
   maintenance.

.. dropdown:: Is there training?

   Yes, mostly over Zoom: see
   `ARCH training and education <https://www.arch.jhu.edu/support/training-education/>`_.

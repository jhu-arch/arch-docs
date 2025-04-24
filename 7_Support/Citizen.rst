Good Citizenship & Terms of Use
###############################

Definitions
===========

- **User**: Any individual with access to the ARCH facility's computing resources.
- **Account**: A username (e.g., ``jdoe1``) providing access to Rockfish and related services.
- **Allocation**: A compute-time grant (in service units, or SUs) associated with a project. A single account may belong to multiple allocations.
- **Principal Investigator (PI)**: A user responsible for managing a project and associated allocations. PIs are typically JHU faculty.

Being a Good Citizen
==============================

ARCH clusters are used daily by hundreds of researchers. Login nodes serve as a shared entry point for all users to interact with the system, submit jobs, manage files, and compile code. It is essential that all users practice good cluster etiquette to avoid disrupting services for others.

DO NOT Run Jobs on the Login Nodes
************************************

Login nodes are **not** meant for compute-heavy work. Running applications, simulations, or data transfers directly on these nodes impacts all users and may result in account suspension.

All users are subject to **automatic CPU throttling** on login nodes. Even if a job runs, it will do so at **poor performance**, often misleading users about how their code behaves on compute nodes. 

Additionally, if a user’s task consumes **excessive memory**, the system may forcibly terminate the terminal session. Repeated abuse or disruptive use can lead to **account suspension or revocation**.

Use an interactive session (``interact``) or submit a batch job for anything resource-intensive.

For large file transfers, always use **Globus** instead of ``rsync`` or ``cp``.  
See the :doc:`file transfers page <../1_Clusters/Rockfish/2_Navigating/File_Transfers>` for guidance on how to use Globus for Rockfish.


Allowed on Login Nodes
************************

- Requesting interactive sessions (``interact``)
- Compiling code (e.g. ``make`` – but avoid high parallelism like ``make -j 20``)
- Checking job status (``sqme``, ``squeue``, ``scontrol show job``)
- Editing scripts, small file manipulations
- Submitting jobs (``sbatch script.sh``)
- Viewing output files (``less``, ``more``, ``cat``)



Accounts and Allocations
*************************

PIs create and manage projects via the **Coldfront Portal**. You can find more information about allocations by visiting: 
:doc:`allocations page for Rockfish: <../1_Clusters/Rockfish/1_Resources/Allocation>`.


Acceptance of Terms
************************

Use of ARCH resources implies acceptance of these Terms. Terms may be updated periodically, and continued access implies agreement. Any user violating the Terms may have their account suspended or revoked.

Security
************

- User accounts are for individual use only — no shared logins
- Do not share passwords or authentication tokens
- ARCH staff will **never** request your password
- Report any security flaws immediately without exploiting them

Usage Policy
************

- Use ARCH resources only for approved research tied to your allocations
- Ensure all software and data comply with licensing and legal requirements
- Run compute-heavy applications only on compute nodes, via Slurm
- Never bypass the Slurm resource manager to access compute nodes directly
- Comply with U.S. export control regulations and license obligations as required
- Data subject to restrictions such as HIPAA or PHI is not permitted on ARCH Systems. If your research involves an IRB and the data is de-identified, please reach out to `help@arch.jhu.edu <mailto:help@arch.jhu.edu>`__  for further guidance.



Publications
*************

Any publications using Rockfish resources must include an acknowledgment:

.. code-block:: text

   This work was carried out at the Advanced Research Computing at Hopkins (ARCH) 
   core facility (https://rockfish.jhu.edu), which is supported by the National 
   Science Foundation (NSF) grant number OAC1920103.

PIs are responsible for uploading associated publications to the Coldfront portals in accordance with proposal guidelines.
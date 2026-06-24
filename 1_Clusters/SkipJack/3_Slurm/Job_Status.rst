Viewing Job Status & Efficiency
################################

sqme
*****

**TODO**: Confirm if SkipJack uses `sqme` or replace with the appropriate command.

View all jobs for a user (custom wrapper for `squeue`):

.. code-block:: console

   $ sqme

**TODO**: Add SkipJack-specific example output.

Common Pending Reasons
**********************

When a job is in the **PENDING (PD)** state, Slurm includes a reason to help you understand why it has not started yet. You can view this using:

.. code-block:: console

   $ squeue -u $USER

**Reason Codes:**

- **None**: No assigned reason yet.
- **Priority**: Job is waiting due to other jobs with higher priority.
- **Dependency**: Job is waiting on another job to complete.
- **JobArrayTaskLimit**: An array job hit its concurrency limit.
- **MaxCpuPerAccount**: Your group exceeded allowed CPU resources.
- **AssocGrpCPUMinutesLimit**: Your group has exceeded allowed CPU core-minutes.
- **QOSMaxGRESPerUser**: Requested GPU resources exceed QoS allowance.
- **MaxGRESPerAccount/User**: Max GPU resources exceeded for the group or user.

For a full list of reason codes, see the official documentation:  
https://slurm.schedmd.com/job_reason_codes.html

scontrol show job
********************

View detailed job info:

.. code-block:: console

   $ scontrol show job <jobid>

**TODO**: Add SkipJack-specific example output.

sacct
*****

View historical job data:

.. code-block:: console

   $ sacct

seff
*****

View job efficiency:

.. code-block:: console

   $ seff <jobid>

reportseff
***************

Summary view of multiple efficiency stats:

.. code-block:: console

   $ reportseff <jobid>

**TODO**: Confirm these tools exist on SkipJack or adjust accordingly.

jobstats
**********

We use `jobstats, an open-source utility developed by Princeton University <https://github.com/PrincetonUniversity/jobstats>`__, to collect and visualize CPU, memory, and GPU utilization for Slurm jobs.

Visualize GPU, memory, and CPU usage:

.. code-block:: console

   $ jobstats <jobid>

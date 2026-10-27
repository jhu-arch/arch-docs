Checking Job Status
###################

squeue
******

Show your pending and running jobs:

.. code-block:: console

   squeue --me

Add ``-l`` for time limits, or ``--start`` for Slurm's estimate of when pending jobs will start.

Pending Reasons
***************

A pending (``PD``) job shows a reason in the last column. Common ones:

- **Priority**: other jobs have higher priority; see :doc:`Priority`.
- **Resources**: the job is next in line and waiting for nodes to free up.
- **Dependency**: the job is waiting on another job (``--dependency``).
- **JobArrayTaskLimit**: an array job hit its ``%`` concurrency limit.
- **QOSMax...** / **AssocGrp...** / **MaxGRES...**: your user, project or partition has reached a limit on CPUs,
  GPUs or jobs. The job starts when your other jobs finish.
- **ReqNodeNotAvail**: the nodes you need are reserved or down (for example during maintenance).

Full list: `Slurm job reason codes <https://slurm.schedmd.com/job_reason_codes.html>`__.

scontrol show job
*****************

Full details of one job, including what it was allocated:

.. code-block:: console

   scontrol show job <job_id>

sacct
*****

History of finished jobs:

.. code-block:: console

   sacct -X -S now-7days -o JobID,JobName%20,Partition,State,Elapsed,AllocCPUS,ReqMem

Job Efficiency
**************

After a job finishes, ``jobstats <job_id>`` shows how much of the requested CPU, memory and GPU it actually used.
``seff <job_id>`` gives a short CPU and memory summary. See :doc:`/2_Common_Tasks/Job_Efficiency/Jobstats`.

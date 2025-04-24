Viewing Job Status & Efficiency
################################

sqme
*****
View all jobs for a user (custom wrapper for `squeue`):

.. code-block:: console

   $ sqme
   USER   ACCOUNT      JOBID   PARTITION  NAME       NODES  CPUS  MIN_MEMORY  TIME_LIMIT  TIME     NODELIST  ST  REASON
   user   group_gpu    111111  a100       job1.sh    1      12    4000M       3-00:00:00  3:53:46  gpu14     R   None
   user   group_gpu    111112  a100       job2.sh    1      12    4000M       3-00:00:00  3:09:00  gpu13     R   None

**Common Pending Reasons**

When a job is in the **PENDING (PD)** state, Slurm includes a reason to help you understand why it hasn’t started yet. You can view this using:

.. code-block:: console

   $ sqme

Example output:

.. code-block:: none

   JOBID            PARTITION  NAME      USER     ST  TIME      NODES  CPUS  REASON
   500001           parallel   sim01     user01   PD  0:00         1     1    (MaxCpuPerAccount)
   500002           parallel   sim02     user01   PD  0:00         1     1    (MaxCpuPerAccount)
   500003           parallel   jobXYZ    user02   PD  0:00         1     1    (AssocGrpCPUMinutesLimit)
   500004_[1-5]     parallel   arrayjob  user03   PD  0:00         1     1    (AssocGrpCPUMinutesLimit)
   500009           parallel   depend    user05   PD  0:00         1     1    (Dependency)

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

   $ scontrol show job 1111111

   JobId=1111111 JobName=job_script.sh
      UserId=example_user GroupId=example_group
      Priority=20688 QOS=qos_gpu State=RUNNING Reason=None
      RunTime=03:55:39 TimeLimit=3-00:00:00
      Partition=a100 NodeList=gpu14 NumCPUs=12
      ReqTRES=cpu=1,mem=4000M,node=1,billing=12,gres/gpu=1
      AllocTRES=cpu=12,mem=48000M,node=1,billing=12,gres/gpu=1

sacct
*****

View historical job data:

.. code-block:: console

   $ sacct

   JobID      JobName    Partition  State     ExitCode
   111111     job1.sh    a100       TIMEOUT   0:0
   111111.0   python     a100       COMPLETED 0:0
   111112     job2.sh    a100       RUNNING   0:0

seff
*****

View job efficiency:

.. code-block:: console

   $ seff 111111

   Job ID: 111111
   CPU Utilized: 00:00:00
   CPU Efficiency: 0.00%
   Memory Utilized: 0.00 MB
   Memory Efficiency: 0.00%

reportseff
***************

Summary view of multiple efficiency stats:

.. code-block:: console

   $ reportseff 111111

   JobID   State      Elapsed  TimeEff   CPUEff   MemEff
   111111  RUNNING    03:57:40   5.5%      ---      ---

jobstats
**********
**Note:**  
We use `jobstats, an open-source utility developed by Princeton University <https://github.com/PrincetonUniversity/jobstats>`__, to collect and visualize CPU, memory, and GPU utilization for Slurm jobs. It provides an intuitive, at-a-glance summary of resource efficiency and is particularly helpful for GPU workflows.

Visualize GPU, memory, and CPU usage:

.. code-block:: console

   $ jobstats 1111111

   ================================================================================
                              Slurm Job Statistics
   ================================================================================
          Job ID: 1111111
       NetID/Account: example_user/example_group_gpu
            Job Name: job_script
               State: RUNNING
               Nodes: 1
           CPU Cores: 12
        GPU utilization: 93%
        GPU memory usage: 31%
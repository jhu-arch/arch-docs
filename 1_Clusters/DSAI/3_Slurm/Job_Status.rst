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

   JOBID    PARTITION  NAME                 USER     ST   TIME NODES REASON
   -------- ---------- -------------------- -------- -- ------- ----- -----------------------
   100001   a100       train                userA    PD   0:00     1 Dependency
   100002   a100       batch_job            userB    PD   0:00     1 Priority
   100003   a100       workflow_11          userC    PD   0:00     1 Resources
   100004   a100       analysis_22          userC    PD   0:00     1 Priority
   100005   l40s       preproc_01           userD    PD   0:00     1 Resources
   100006   l40s       model_fit            userD    PD   0:00     1 Priority
   100011   h100       training_run         userE    PD   0:00     1 QOSMaxGRESPerUser
   100012   h100       inference            userE    PD   0:00     1 QOSMaxGRESPerUser
   100015   h100       gpu_test             userF    PD   0:00     1 Dependency

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

   $ scontrol show job 100123
   JobId=100123 JobName=my_job
      UserId=userX(0000) GroupId=research(0000) MCS_label=N/A
      Priority=4000000000 Nice=0 Account=pi_group QOS=normal
      JobState=RUNNING Reason=None Dependency=(null)
      Requeue=1 Restarts=0 BatchFlag=0 Reboot=0 ExitCode=0:0
      RunTime=00:57:06 TimeLimit=3-00:00:00 TimeMin=N/A
      SubmitTime=2025-04-28T10:00:00 EligibleTime=2025-04-28T10:00:00
      AccrueTime=2025-04-28T10:00:00
      StartTime=2025-04-28T10:00:15 EndTime=2025-05-01T10:00:15 Deadline=N/A
      PreemptEligibleTime=2025-04-28T10:00:15 PreemptTime=None
      SuspendTime=None SecsPreSuspend=0 LastSchedEval=2025-04-28T10:00:15 Scheduler=Backfill
      Partition=gpuA100 AllocNode:Sid=login01:123456
      ReqNodeList=(null) ExcNodeList=nodeX
      NodeList=gpu001
      BatchHost=gpu001
      NumNodes=1 NumCPUs=12 NumTasks=1 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
      ReqTRES=cpu=1,mem=10G,node=1,billing=180,gres/gpu=1
      AllocTRES=cpu=12,mem=120G,node=1,billing=180,gres/gpu=1,gres/gpu:a100=1
      Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
      MinCPUsNode=1 MinMemoryCPU=10G MinTmpDiskNode=0
      Features=(null) DelayBoot=00:00:00
      OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
      Command=bash
      WorkDir=/scratch/pi_group/userX
      Power=
      CpusPerTres=gpu:12
      TresPerNode=gres:gpu:1

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
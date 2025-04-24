Available Partitions
####################

Slurm divides resources into **partitions**, sometimes called **queues**. Each partition targets specific hardware or workloads.

.. list-table::
   :header-rows: 1
   :widths: 20 15 15 15 15 30

   * - Partition
     - Max Time (hrs)
     - Cores per Node
     - Max Memory
     - GPUs
     - Use Case
   * - express
     - 8
     - 4
     - 8 GB
     - —
     - Short tests, debugging, interactive work (Jupyter, RStudio)
   * - shared
     - 36
     - 32
     - 4 GB/core
     - —
     - Small-scale workflows with shared node usage
   * - parallel
     - 72
     - 48
     - 192 GB
     - —
     - Dedicated nodes for large parallel jobs
   * - bigmem
     - 48
     - 48
     - 1.5 TB
     - —
     - Memory-intensive jobs with special allocation
   * - a100
     - 72
     - 48
     - 192 GB
     - 4× A100 (40 GB)
     - GPU workflows
   * - ica100
     - 72
     - 64
     - 256 GB
     - 4× A100 (80 GB)
     - GPU workflows
   * - mig_class
     - 24
     - 64
     - 256 GB
     - 12× MIGs (20 GB)
     - Classroom GPU usage
   * - l40s
     - 24
     - 64
     - 256 GB
     - 8× L40s (48 GB)
     - High-performance GPU workloads

Partition Descriptions
***********************

express
-------

Express is designed for short-running jobs, including tests, debugging, or interactive sessions (e.g., Jupyter notebooks, RStudio).

- **CPU Limit**: Up to 4 cores
- **Memory Limit**: Up to 8 GB per job
- **Node Sharing**: Yes (shared with other jobs)
- **Max Runtime**: 8 hours

shared
------

Shared is designed for a mixture of jobs, from single-core sequential jobs to small parallel jobs (less than 32 cores).

- **Memory**: 4 GB per core
- **Node Sharing**: Yes (shared with other jobs)
- **Best For**: Smaller scale workflows
- **Max Runtime**: 36 hours

parallel
--------

Parallel is designed **only** for jobs requiring **48 cores or more**.

- **Nodes**: Single or multiple (up to 75)
- **Node Sharing**: No (dedicated)
- **User Responsibility**: All cores must be utilized
- **Max Runtime**: 3 days

bigmem
------

Bigmem is designed for memory-intensive workflows.

- **Memory**: 1.5 TB per node
- **Requirements**:
  
  - Slurm allocation: ``<PI_NAME>_bigmem`` (e.g., ``jsmith123_bigmem``)
  - QoS: ``qos_bigmem``

- **Max Runtime**: 2 days

a100
----

A100 is for GPU-enabled workflows.

- **GPUs**: 4× NVIDIA A100 (40 GB each)
- **Requirements**:

  - Slurm allocation: ``<PI_NAME>_gpu`` (e.g., ``jsmith123_gpu``)
  - QoS: ``qos_gpu``

- **Max Runtime**: 3 days

ica100
------

ICA100 is for GPU-enabled workflows using upgraded A100 cards.

- **GPUs**: 4× NVIDIA A100 (80 GB each)
- **Requirements**:

  - Slurm allocation: ``<PI_NAME>_gpu`` (e.g., ``jsmith123_gpu``)
  - QoS: ``qos_gpu``

- **Max Runtime**: 3 days

mig_class
---------

Mig_class is intended for classroom GPU workflows.

- **GPUs**: 4× NVIDIA A100 (80 GB each), segmented into 12× 20 GB MIGs
- **Requirements**:

  - Slurm allocation: ``<class_name>-<PI_NAME>`` (e.g., ``cs601-jsmith123``)
  - QoS: ``mig_class``

- **Max Runtime**: 1 day

l40s
----

L40s is designed for GPU workflows using L40s GPUs.

- **GPUs**: 8× NVIDIA L40s (48 GB each)
- **Requirements**:

  - Slurm allocation: ``<PI_NAME>_gpu`` (e.g., ``jsmith123_gpu``)
  - QoS: ``qos_gpu``

- **Max Runtime**: 1 day

Viewing Partition Configuration
*******************************

You can view details about any partition with the `scontrol` command. This is helpful to check limits, available nodes, default memory settings, and which QoS values are allowed or denied.

- Use `scontrol show partition` without any arguments to see **all** partitions.
- To find which QoS values are allowed or blocked in a partition, look at `QoS=` and `DenyQos=`.

Example:

.. code-block:: console

   scontrol show partition=shared

Sample Output:

.. code-block:: console

   PartitionName=shared
      AllowGroups=ALL AllowAccounts=ALL DenyQos=qos_gpu,qos_bigmem
      AllocNodes=ALL Default=NO QoS=shared
      DefaultTime=01:00:00 DisableRootJobs=NO ExclusiveUser=NO GraceTime=0 Hidden=NO
      MaxNodes=1 MaxTime=1-12:00:00 MinNodes=1 LLN=NO MaxCPUsPerNode=128 MaxCPUsPerSocket=UNLIMITED
      Nodes=sr[07-47]
      PriorityJobFactor=1 PriorityTier=2 RootOnly=NO ReqResv=NO OverSubscribe=YES:4
      OverTimeLimit=NONE PreemptMode=OFF
      State=UP TotalCPUs=2624 TotalNodes=41 SelectTypeParameters=NONE
      JobDefaults=(null)
      DefMemPerCPU=4000 MaxMemPerCPU=4000
      TRES=cpu=2624,mem=10250G,node=41,billing=2624
      TRESBillingWeights=CPU=1.0,Mem=0.00025M

Key Fields to Note
*********************

- **MaxTime**: The maximum wall-clock time allowed for jobs in this partition.
- **DefMemPerCPU**: The default memory available per core (can be overridden with `--mem` or `--mem-per-cpu`).
- **Nodes**: The physical nodes available for this partition.
- **OverSubscribe**: Indicates if jobs can share nodes.
- **DenyQos**: QOS values that are explicitly blocked from this partition.
- **TRES**: Total Resources (CPUs, memory, nodes) assigned to this partition.

Helpful Tips
************

- You can view the current load on each partition with:

  .. code-block:: console

    [root@login03 ~]# sinfo -s
    PARTITION AVAIL  TIMELIMIT   NODES(A/I/O/T) NODELIST
    parallel*    up 3-00:00:00     687/24/9/720 c[001-720]
    v100         up 3-00:00:00          0/1/0/1 gpu01
    a100         up 3-00:00:00        15/2/0/17 gpu[02-18]
    ica100       up 3-00:00:00         8/2/0/10 icgpu[01-10]
    bigmem       up 2-00:00:00        16/9/0/25 bigmem[01-25]
    mig_class    up 1-00:00:00          3/0/0/3 gpuz[01-03]
    express      up    8:00:00          0/5/0/5 sr[01-05]
    shared       up 1-12:00:00       12/29/0/41 sr[07-47]
    l40s         up 1-00:00:00          1/2/1/4 l[01-04]
    emr          up 7-00:00:00        11/6/1/18 er[01-18]   

  This provides a summary view of each partition’s usage and availability.

- To see the list of available partitions and their state:

  .. code-block:: console

     sinfo -o "%P %.5D %.10t %.10l %.6c %.10m"

  This will output:
  
  - Partition name
  - Node count
  - State (idle/alloc/mix)
  - Max time
  - CPUs per node
  - Memory

Partition Best Practices
*************************

- Use `--partition=` to explicitly request a partition in your batch script.
- Avoid defaulting to GPU partitions unless required — this helps ensure fair usage.
- Read memory policies carefully (e.g., shared nodes have 4 GB/core).
- Always pair GPU partitions with the appropriate QOS and allocation account.
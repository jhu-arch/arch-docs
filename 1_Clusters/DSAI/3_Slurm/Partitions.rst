Available Partitions
####################

Slurm divides resources into **partitions**, sometimes called **queues**. Each partition targets specific hardware or workloads.

.. list-table:: **DSAI Partition Summary**
   :header-rows: 1
   :widths: 12 10 12 14 12 12 38

   * - **Partition**
     - **# Nodes**
     - **CPU cores / node**
     - **Memory / core (MB)**
     - **GPUs / node**
     - **Time limit (hh:mm:ss)**
     - **Key features**
   * - ``cpu``
     - 80
     - 108
     - 4 000
     - — (N/A)
     - 72:00:00
     - Intel Xeon Platinum 8480+ (56-core) dual-socket nodes
   * - ``l40s``
     - 8
     - 124
     - 6 000
     - 8 × NVIDIA L40S 48 GB
     - 72:00:00
     - AMD EPYC 9534 (64-core) + high-mem L40S GPUs
   * - ``a100``
     - 15
     - 92
     - 10 000
     - 8 × NVIDIA A100 80 GB
     - 72:00:00
     - AMD EPYC 7443 (24-core) + A100 GPUs
   * - ``h100``
     - 16
     - 120
     - 12 000
     - 4 × NVIDIA H100 80 GB
     - 72:00:00
     - AMD EPYC 9534 (64-core) + H100 GPUs
   * - ``nvl``
     - 16
     - 124
     - 12 000
     - 4 × NVIDIA H100-NVL 96 GB
     - 72:00:00
     - AMD EPYC 9534 (64-core) + H100-NVL GPUs

Partition Descriptions
------------------------

cpu
~~~

* **No GPUs** – ideal for CPU only jobs.

l40s
~~~~

* **8 × L40 S 48 GB** per node. 
* 16 CPU cores charged **per GPU**.  

a100
~~~~

* **8 × A100 80 GB** per node.
* 12 CPU cores charged **per GPU**.  

h100
~~~~

* **4 × H100 80 GB** per node.
* Connected via Mellanox NDR and may give good performance for parallel GPU jobs.
* 32 CPU cores charged **per GPU**.  

nvl
~~~

* **4 × H100-NVL 96 GB** per node.
* Connected via Mellanox NDR and may give good performance for parallel GPU jobs.
* 32 CPU cores charged **per GPU**.  

GPU core-billing ratios
-----------------------

.. list-table::
   :header-rows: 1
   :widths: 18 18

   * - **Partition**
     - **Billed CPU cores per GPU**
   * - ``l40s``
     - 16
   * - ``a100``
     - 12
   * - ``h100`` / ``nvl``
     - 32

Only request the GPUs you truly need—extra GPUs multiply your billed
core-hours and may increase queue time.

Viewing Partition Configuration
--------------------------------

You can view details about any partition with the `scontrol` command. This is helpful to check limits, available nodes, default memory settings, and which QoS values are allowed or denied.

- Use `scontrol show partition` without any arguments to see **all** partitions.
- To find which QoS values are allowed or blocked in a partition, look at `QoS=` and `DenyQos=`.

Example:

.. code-block:: console

   scontrol show partition=h100

Sample Output:

.. code-block:: console

   PartitionName=h100
      AllowGroups=ALL AllowAccounts=ALL AllowQos=ALL
      AllocNodes=ALL Default=NO QoS=N/A
      DefaultTime=NONE DisableRootJobs=NO ExclusiveUser=NO GraceTime=0 Hidden=NO
      MaxNodes=3 MaxTime=3-00:00:00 MinNodes=0 LLN=NO MaxCPUsPerNode=128 MaxCPUsPerSocket=UNLIMITED
      Nodes=h[01-16]
      PriorityJobFactor=1 PriorityTier=1 RootOnly=NO ReqResv=NO OverSubscribe=YES:4
      OverTimeLimit=NONE PreemptMode=REQUEUE
      State=UP TotalCPUs=2048 TotalNodes=16 SelectTypeParameters=NONE
      JobDefaults=DefCpuPerGPU=32
      DefMemPerCPU=12000 MaxMemPerCPU=12000
      TRES=cpu=1984,mem=24752000M,node=16,billing=24320,gres/gpu=64,gres/gpu:h100=64
      TRESBillingWeights=CPU=10,Mem=0.83G,GRES/gpu=380

Key Fields to Note
------------------

- **MaxTime**: The maximum wall-clock time allowed for jobs in this partition.
- **DefMemPerCPU**: The default memory available per core (can be overridden with `--mem` or `--mem-per-cpu`).
- **Nodes**: The physical nodes available for this partition.
- **OverSubscribe**: Indicates if jobs can share nodes.
- **DenyQos**: QOS values that are explicitly blocked from this partition.
- **TRES**: Total Resources (CPUs, memory, nodes) assigned to this partition.

Helpful Tips
-------------

- You can view the current load on each partition with:

  .. code-block:: console

    [root@dsailogin ~]$ sinfo -s
    PARTITION AVAIL  TIMELIMIT   NODES(A/I/O/T) NODELIST
    l40s*        up 3-00:00:00          7/1/0/8 l[01-08]
    a100         up 3-00:00:00        14/0/1/15 c[001-015]
    nvl          up 3-00:00:00        14/2/0/16 n[01-16]
    h100         up 3-00:00:00        16/0/0/16 h[01-16]
    cpu          up 3-00:00:00       2/62/16/80 cpu[001-080]
    Secondary    up 3-00:00:00          3/1/0/4 c015,h16,l08,n16  

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
-------------------------

- Use `\-\-partition=` to explicitly request a partition in your batch script.
- Avoid defaulting to GPU partitions unless required — this helps ensure fair usage.
- Read memory policies carefully (e.g., shared nodes have 4 GB/core).
- Always pair GPU partitions with the appropriate QOS and allocation account.
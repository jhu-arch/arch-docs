Available Partitions
####################

Slurm divides resources into **partitions**, sometimes called **queues**. Each partition targets specific hardware or workloads.

.. list-table:: **Skipjack Partition Summary**
   :header-rows: 1
   :widths: 12 10 12 14 12 12 38

   * - **Partition**
     - **# Nodes**
     - **CPU cores / node**
     - **Memory / core (MB)**
     - **GPUs / node**
     - **Time limit (hh:mm:ss)**
     - **Key features**
   * - ``interactive_cpu``
     - 3
     - 216 (hyperthreads)
     - 2 000
     - (N/A)
     - 4:00:00
     - Intel Xeon Platinum 8480+ (56-core) dual-socket nodes
   * - ``interactive_gpu``
     - 2
     - 88
     - 2 000
     - 24 × A100 MIG ``2g.20gb`` slices (20 GB each)
     - 4:00:00
     - AMD EPYC 7443 (24-core); 8 × A100 80 GB per node, each split into 3 MIG slices
   * - ``agentic``
     - 3
     - 216 (hyperthreads)
     - 2 000
     - (N/A)
     - 7-00:00:00
     - Intel Xeon Platinum 8480+ (56-core) dual-socket nodes
   * - ``med``
     - 74
     - 108
     - 4 000
     - (N/A)
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
     - 13
     - 88
     - 6 000
     - 8 × NVIDIA A100 80 GB
     - 72:00:00
     - AMD EPYC 7443 (24-core) + A100 GPUs
   * - ``h100``
     - 32
     - 124
     - 12 000
     - 4 × NVIDIA H100 SXM 80 GB or 4 × NVIDIA H100 NVL 94 GB
     - 72:00:00
     - AMD EPYC 9534 (64-core) with half H100 SXM GPUs and other half H100 NVL GPUs
   * - ``h200``
     - 6
     - 124
     - 12 000
     - 4 × NVIDIA H200 NVL 141 GB
     - 72:00:00
     - AMD EPYC 9555 (64-core) with H200 GPUs
   * - ``b200``
     - 16
     - 124
     - 12 000
     - 8 × NVIDIA B200 180 GB
     - 72:00:00
     - Intel Xeon Platinum 8592+ (64-core) with B200 GPUs
   * - ``b300``
     - 17
     - 124
     - 12 000
     - 8 × NVIDIA B300 288 GB
     - 72:00:00
     - Intel Xeon 6767P (64-core) with B300 GPUs
   * - ``rtx6000``
     - 3
     - 124
     - 8 000
     - 2 nodes with 8 x NVIDIA RTX PRO 6000 96GB
       1 node with 4 x NVIDIA RTX PRO 6000 96GB
     - 72:00:00
     - Intel(R) Xeon(R) 6767P (64-core) with NVIDIA RTX PRO 6000 Blackwell GPUs


Planned Partitions (Rockfish Migration)
---------------------------------------

.. admonition:: Not available yet
   :class: warning

   The partitions below will be added as Rockfish hardware moves into Skipjack. They cannot be used yet.
   Names, node counts and limits may change before they go live; this page will be updated as each one opens.

.. list-table:: **Planned partitions from Rockfish hardware**
   :header-rows: 1
   :widths: 14 10 12 14 18 32

   * - **Partition (planned)**
     - **# Nodes**
     - **CPU cores / node**
     - **Memory / core (MB)**
     - **GPUs / node**
     - **Rockfish equivalent**
   * - ``low``
     - 672
     - 44
     - 4 000
     - (N/A)
     - ``parallel`` (Intel Xeon Gold 6248R, 192 GB)
   * - ``med`` (added nodes)
     - 47
     - 60
     - 4 000
     - (N/A)
     - Rockfish Sapphire Rapids nodes (Intel Xeon Gold 6448Y, 256 GB); join the existing ``med`` partition
   * - ``high``
     - 25
     - 124
     - 4 000
     - (N/A)
     - Rockfish Emerald Rapids nodes (Intel Xeon Platinum 8592+, 512 GB)
   * - ``midmem``
     - 23
     - 44
     - 8 000
     - (N/A)
     - 384 GB memory nodes
   * - ``highmem``
     - 44
     - 44
     - 16 000
     - (N/A)
     - 768 GB memory nodes
   * - ``bigmem``
     - 7
     - 44
     - 34 000
     - (N/A)
     - ``bigmem`` (1.5 TB memory nodes)
   * - ``a100_40``
     - 18
     - 44
     - 4 000
     - 4 × NVIDIA A100 40 GB
     - ``a100``
   * - ``a100_80``
     - 10
     - 60
     - 4 000
     - 4 × NVIDIA A100 80 GB
     - ``ica100``
   * - L40S (name TBD)
     - 4
     - 60
     - 16 000
     - 8 × NVIDIA L40S 48 GB
     - ``l40s``

.. note::
   The Rockfish A100 and L40S nodes get their own partitions rather than joining Skipjack's ``a100`` and ``l40s``
   partitions, because they have fewer CPU cores and less memory per GPU. Default CPU and memory per GPU on these
   partitions will differ from what you had on Rockfish; check your job scripts when they open.

Partition Descriptions
------------------------

interactive_cpu
~~~~~~~~~~~~~~~

* **No GPUs** – ideal for CPU only jobs.

interactive_gpu
~~~~~~~~~~~~~~~

* **8 × NVIDIA A100 80 GB** per node, split into 24 MIG slices of 20 GB each - ideal for short GPU jobs and development.
* Request one slice with ``--partition=interactive_gpu --gres=gpu:2g.20gb:1``.

agentic
~~~~~~~

* **No GPUs** – ideal for development while using agentic AI tools.

med
~~~

* **No GPUs** – general CPU partition for batch jobs.

l40s
~~~~

* **8 × L40S 48 GB** per node.   

a100
~~~~

* **8 × A100 80 GB** per node.

h100
~~~~

* **4 × H100 SXM 80 GB** per node for gh101-gh116.
* **4 × H100 NVL 94 GB** per node for gh117-gh132.

For jobs where there is a preference for SXM or NVL, use the following slurm option: ``--prefer=h100_sxm`` or ``--prefer=h100_nvl`` respectively.

For jobs where there is a requirement for SXM or NVL, use the following slurm option: ``--constraint=h100_sxm`` or ``--constraint=h100_nvl`` respectively.

h200
~~~~

* **4 × NVIDIA H200 NVL 141 GB** per node.

b200
~~~~

* **8 × NVIDIA B200 180 GB** per node.

b300
~~~~

* **8 × NVIDIA B300 288 GB** per node.

rtx6000
~~~~~~~

* **8 x NVIDIA RTX PRO 6000 96GB** per node for gr101 and gr103.
* **4 x NVIDIA RTX PRO 6000 96GB** for gr102.

GPU core-billing ratios
-----------------------
Current values are placeholders.

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
      AllowGroups=ALL AllowAccounts=jhu DenyQos=jsalt_2026
      AllocNodes=ALL Default=NO QoS=N/A
      DefaultTime=NONE DisableRootJobs=NO ExclusiveUser=NO ExclusiveTopo=NO GraceTime=0 Hidden=NO
      MaxNodes=UNLIMITED MaxTime=3-00:00:00 MinNodes=0 LLN=NO MaxCPUsPerNode=124 MaxCPUsPerSocket=UNLIMITED
      NodeSets=h100
      Nodes=gh[101-132]
      PriorityJobFactor=1 PriorityTier=1 RootOnly=NO ReqResv=NO OverSubscribe=YES:4
      OverTimeLimit=NONE PreemptMode=REQUEUE
      State=UP TotalCPUs=4096 TotalNodes=32 SelectTypeParameters=NONE
      JobDefaults=DefCpuPerGPU=30
      DefMemPerCPU=12000 MaxMemPerCPU=12000
      TRES=cpu=3968,mem=49504000M,node=32,billing=4027,gres/gpu=128
      TRESBillingWeights=CPU=1,Mem=0.0833G,GRES/gpu=2

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

    $ sinfo -s

    PARTITION       AVAIL  TIMELIMIT   NODES(A/I/O/T) NODELIST
    interactive_cpu    up    4:00:00          1/2/0/3 csr[048-050]
    interactive_gpu    up    4:00:00          1/1/0/2 ga[129-130]
    agentic            up 7-00:00:00          1/2/0/3 csr[051-053]
    med                up 3-00:00:00        68/0/6/74 csr[054-127]
    a100               up 3-00:00:00        13/0/0/13 ga[131-143]
    b200               up 3-00:00:00        12/4/0/16 gb[201-216]
    b300               up 3-00:00:00        1/16/0/17 gb[301-317]
    h100               up 3-00:00:00        31/1/0/32 gh[101-132]
    h200               up 3-00:00:00          5/1/0/6 gh[201-206]
    l40s               up 3-00:00:00          8/0/0/8 gl[105-112]
    rtx6000            up 3-00:00:00          3/0/0/3 gr[101-103]

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
- Read memory policies carefully (e.g. memory per core).
- Always pair GPU partitions with the appropriate QOS and allocation account.

Available Partitions
####################

Slurm divides resources into **partitions**, sometimes called **queues**. Each partition targets specific hardware or workloads.

.. list-table:: **SkipJack Partition Summary**
   :header-rows: 1
   :widths: 12 10 12 14 12 12 38

   * - **Partition**
     - **# Nodes**
     - **CPU cores / node**
     - **Memory / core (MB)**
     - **GPUs / node**
     - **Time limit (hh:mm:ss)**
     - **Key features**
   * - **TODO**: Add partition row(s) with specs

Partition Descriptions
------------------------

**TODO**: Add per-partition descriptions (name, use case, constraints).

GPU core-billing ratios
-----------------------

.. list-table::
   :header-rows: 1
   :widths: 18 18

   * - **Partition**
     - **Billed CPU cores per GPU**
   * - **TODO**: Add GPU billing ratio rows

Only request the GPUs you truly need-extra GPUs multiply your billed core-hours and may increase queue time.

Viewing Partition Configuration
---------------------------------

You can view details about any partition with the `scontrol` command. This is helpful to check limits, available nodes, default memory settings, and which QoS values are allowed or denied.

- Use `scontrol show partition` without any arguments to see **all** partitions.
- To find which QoS values are allowed or blocked in a partition, look at `QoS=` and `DenyQos=`.

Example:

.. code-block:: console

   scontrol show partition=TODO: Add example partition name

Sample Output:

.. code-block:: console

   **TODO**: Add sample scontrol output for SkipJack

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

    [TODO: Add hostname ~]$ sinfo -s
    PARTITION AVAIL  TIMELIMIT   NODES(A/I/O/T) NODELIST
    **TODO**: Add SkipJack partition listing

  This provides a summary view of each partition's usage and availability.

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

- Use `--partition=` to explicitly request a partition in your batch script.
- Avoid defaulting to GPU partitions unless required - this helps ensure fair usage.
- Read memory policies carefully (e.g., shared nodes have limited mem/core).
- Always pair GPU partitions with the appropriate QOS and allocation account.

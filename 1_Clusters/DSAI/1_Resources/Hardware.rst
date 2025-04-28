######################
DSAI Hardware Summary
######################

The DSAI cluster is a high-performance computing (HPC) system operated by ARCH at Johns Hopkins University. As of 2025, the DSAI Cluster consists of:

- **8,960 CPU cores** across **80 CPU nodes**
- **15 8-way nodes** with **NVIDIA A100 (80GB)** GPUs
- **32 4-way nodes** with **NVIDIA H100** GPUs
- **8 8-way nodes** with **NVIDIA L40S** GPUs
- **5 PB of WEKA storage** (backed by a parallel file system)

The following table summarizes the current node types available in the DSAI cluster:

.. list-table::
   :header-rows: 1
   :widths: 12 8 10 10 8 12 20

   * - Partition
     - # Nodes
     - CPU Cores / Node
     - Memory Per Core (MB)
     - GPUs Per Node
     - Time Limit
     - Features
   * - CPU
     - 80
     - 108
     - 4,000
     - N/A
     - 72:00:00
     - Intel Xeon Platinum 8480+ 56 Core
   * - l40s
     - 8
     - 124
     - 6,000
     - 8
     - 72:00:00
     - Nvidia L40S 48GB GPUs, AMD EPYC 9534 64 Core
   * - a100
     - 15
     - 92
     - 10,000
     - 8
     - 72:00:00
     - Nvidia A100 80GB GPUs, AMD EPYC 7443 24 Core
   * - h100
     - 16
     - 120
     - 12,000
     - 4
     - 72:00:00
     - Nvidia H100 80GB GPUs, AMD EPYC 9534 64 Core
   * - NVL
     - 16
     - 124
     - 12,000
     - 4
     - 72:00:00
     - Nvidia H100-NVL 96GB GPUs, AMD EPYC 9534 64 Core

Total system core count: **20,676 cores across 135 nodes**
Total system GPU count: **64 L40S, 120 A100, 64 H100, 64 H100-NVL GPUs**

.. note::
   Node specifications may change as new hardware is integrated into the cluster.
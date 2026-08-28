#########################
SkipJack Hardware Summary
#########################

The Skipjack cluster is a high-performance computing (HPC) system operated by ARCH at Johns Hopkins University. As of 2026, the Skipjack Cluster consists of:

- **8,960 CPU cores** across **80 CPU nodes**
- **15 8-way nodes** with **NVIDIA A100 (80GB)** GPUs
- **32 4-way nodes** with **NVIDIA H100** GPUs
- **6 4-way nodes** with **NVIDIA H200** GPUs
- **8 8-way nodes** with **NVIDIA L40** GPUs
- **16 8-way nodes** with **NVIDIA B200** GPUs
- **1 8-way nodes** with **NVIDIA B300** GPU
.. - **5 PB of WEKA storage** (backed by a parallel file system)

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
     - 112
     - 4,000
     - N/A
     - 72:00:00
     - Intel Xeon Platinum 8480+ 56 Core
   * - l40s
     - 8
     - 128
     - 6,000
     - 8
     - 72:00:00
     - Nvidia L40S 48GB GPUs, AMD EPYC 9534 64 Core
   * - a100
     - 15
     - 96
     - 10,000
     - 8
     - 72:00:00
     - Nvidia A100 80GB GPUs, AMD EPYC 7443 24 Core
   * - h100
     - 16
     - 128
     - 12,000
     - 4
     - 72:00:00
     - Nvidia H100 85GB GPUs, AMD EPYC 9534 64 Core
   * - h100-NVL
     - 16
     - 128
     - 12,000
     - 4
     - 72:00:00
     - Nvidia H100-NVL 100GB GPUs, AMD EPYC 9534 64 Core
   * - h200
     - 6
     - 128
     - 12,000
     - 4
     - 72:00:00
     - Nvidia H200 150GB GPUs, AMD EPYC 9555 64 Core
   * - b200
     - 16
     - 128
     - 16,000
     - 8
     - 72:00:00
     - Nvidia B200 190GB GPUs, INTEL(R) XEON(R) PLATINUM 8592+
   * - b300
     - 1
     - 128
     - 24,000
     - 8
     - 72:00:00
     - Nvidia B300 285GB GPUs, Intel(R) Xeon(R) 6767P

Total system core count: **18,464 cores across 158 nodes**
Total system GPU count: **64 L40S, 120 A100, 64 H100, 64 H100-NVL GPUs, 24 H200 GPUs, 128 B200 GPUs, 8 B300 GPUs**

.. note::
   Node specifications may change as new hardware is integrated into the cluster.

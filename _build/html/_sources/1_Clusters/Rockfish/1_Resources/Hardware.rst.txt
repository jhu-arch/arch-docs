Compute Node Summary
********************

The Rockfish cluster is a high-performance computing (HPC) system operated by ARCH at Johns Hopkins University. As of 2025, Rockfish consists of:

- **45,072 CPU cores** across **841 nodes**
- **Theoretical peak performance:** 3.3 PFLOPs  
- **Rmax:** 2.1 PFLOPs (measured)
- **Parallel file systems:** 3 IBM GPFS systems totaling ~13 PB of usable space
- **Network fabric:** Mellanox HDR100 (1:1.5 topology)
- **Top500 Ranking:** #443 as of November 2023

The following table summarizes the current node types available in the Rockfish cluster:

.. list-table::
   :header-rows: 1
   :widths: 15 12 25 12 20 20 12

   * - Type
     - Count
     - CPU
     - GPU
     - RAM
     - Storage
     - Total Cores
   * - Compute
     - 720
     - Intel Xeon Gold 6248R (Cascade Lake)
     - N/A
     - 192 GB DDR4 2933MHz
     - 1 TB NVMe SSD
     - 36,864
   * - Compute (Next-Gen)
     - 46
     - Intel Xeon Gold 6448Y (Sapphire Rapids)
     - N/A
     - 256 GB DDR5 4800MHz
     - 2 TB NVMe SSD
     - 2,944
   * - Large Memory
     - 25
     - Intel Xeon Gold 6248R (Cascade Lake)
     - N/A
     - 1.5 TB DDR4 2933MHz
     - 1 TB NVMe SSD
     - 1,200
   * - GPU (A100 40GB)
     - 18
     - Intel Xeon Gold 6248R (Cascade Lake)
     - 4 × NVIDIA A100 40GB
     - 192 GB DDR4 2933MHz
     - 1 TB NVMe SSD
     - 864
   * - GPU (A100 80GB)
     - 10
     - Intel Xeon Gold 6338 (Icy Lake)
     - 4 × NVIDIA A100 80GB
     - 256 GB DDR4 3200MHz
     - 1.6 TB NVMe SSD
     - 640
   * - GPU (L40S)
     - 4
     - Intel Xeon Gold 6338
     - 8 × NVIDIA L40S 48GB
     - 512 GB DDR4 3200MHz
     - 3.5 TB NVMe SSD
     - 256
   * - Fast Compute (Emerald Rapids)
     - 18
     - Intel Xeon Gold / Platinum 8592+
     - N/A
     - 512 GB TruDDR5 5600MHz
     - 1.8 TB NVMe SSD
     - 2,304

.. note::
   Node specifications may change as new hardware is integrated into the cluster.

Total system core count: **45,072 cores across 841 nodes**
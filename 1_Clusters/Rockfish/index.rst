Rockfish Cluster
=================

The Rockfish cluster is a high-performance computing (HPC) system operated by ARCH at Johns Hopkins University. As of 2025, Rockfish consists of:

- 45,072 CPU cores across 841 nodes
- 18 nodes with 4x NVIDIA A100 (40GB) GPUs
- 10 nodes with 4x NVIDIA A100 (80GB) GPUs
- 4 nodes with 8x NVIDIA L40S (48GB) GPUs
- Theoretical peak performance: 3.3 PFLOPs
- Rmax: 2.1 PFLOPs (measured)
- Parallel file systems: 3 IBM GPFS systems totaling ~13 PB of usable space
- Network fabric: Mellanox HDR100 (1:1.5 topology)
- Top500 Ranking: #443 as of November 2023

These are “shared resources”, therefore we expect all users to comply with policies on passwords, security guidelines, resource utilization and best practices, and privacy issues

If users have any questions about these policies, please send an email to `help@arch.jhu.edu <mailto:help@arch.jhu.edu>`__

.. toctree::
   :maxdepth: 1

   Quickstart
   1_Resources/index
   2_Navigating/index
   3_Slurm/index
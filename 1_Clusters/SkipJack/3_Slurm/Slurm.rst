SLURM Overview
###############

The SkipJack Cluster uses **SLURM** (Simple Linux Universal Resource Manager) to manage resource scheduling, job submission, and execution across the cluster.

SLURM is a widely adopted, open-source workload manager developed by `SchedMD <https://slurm.schedmd.com/>`__. It supports large-scale high-performance computing environments and is used by national labs, supercomputing centers, and universities worldwide.

Overview
********

SLURM allows users to:

- Submit batch jobs using `sbatch`
- Monitor job status with `squeue`, `sacct`, or `scontrol`
- Manage job arrays, resource requests, and job dependencies
- Allocate compute, memory, and GPU resources efficiently

All compute-intensive jobs must be submitted through SLURM. Running jobs directly on the login nodes is strictly prohibited. These nodes are shared among all users and are reserved for lightweight tasks like editing scripts, submitting jobs, and checking output files.

**TODO**: Add SkipJack-specific limits (job queue/running limits per group/partition).

Learn More
**********

To learn more about SLURM commands and features, refer to the official documentation:

`SLURM Official Documentation <https://slurm.schedmd.com/documentation.html>`__

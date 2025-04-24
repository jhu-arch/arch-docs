SLURM Overview
###############

Rockfish uses **SLURM** (Simple Linux Universal Resource Manager) to manage resource scheduling, job submission, and execution across the cluster.

SLURM is a widely adopted, open-source workload manager developed by `SchedMD <https://slurm.schedmd.com/>`__. It supports large-scale high-performance computing environments and is used by national labs, supercomputing centers, and universities worldwide.

Overview
********

SLURM allows users to:

- Submit batch jobs using `sbatch`
- Run interactive sessions using `interact`
- Monitor job status with `squeue`, `sacct`, or `scontrol`
- Manage job arrays, resource requests, and job dependencies
- Allocate compute, memory, and GPU resources efficiently

All compute-intensive jobs must be submitted through SLURM. Running jobs directly on the login nodes is strictly prohibited. These nodes are shared among all users and are reserved for lightweight tasks like editing scripts, submitting jobs, and checking output files.

Rockfish places limits on the number of jobs queued and running on a per group (allocation) and partition basis. Please note that submitting a large number of jobs (especially very short ones) can impact the overall  scheduler response for all users. If you are anticipating submitting a lot of jobs, please contact `help@rockfish.jhu.edu <mailto:help@rockfish.jhu.edu>`__ before submission. We can work to check if there are bundling options (job arrays or gnu parallel) that make your workflow more efficient and reduce the impact on the scheduler.

Interactive Sessions
********************

If your workflow requires interacting with a job as it runs (e.g., debugging, live monitoring, or launching GUI applications like RStudio or Jupyter), you must request an interactive session using the `interact` command:

.. code-block:: bash

   interact -p shared -n 4 -t 02:00:00

This submits a job to the scheduler that, once scheduled, grants you interactive terminal access to a compute node.

Learn More
**********

To learn more about SLURM commands and features, refer to the official documentation:

`SLURM Official Documentation <https://slurm.schedmd.com/documentation.html>`__
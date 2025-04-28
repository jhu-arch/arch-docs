Workflows
=========

Modern research often requires building complex, multi-step workflows to manage analysis pipelines, parallel jobs, and reproducibility.

This section provides structured guides for:

- **Job Dependencies** — Control job order and concurrency using SLURM dependencies
- **Parallel Jobs** — Submit multicore, multinode, or hybrid MPI+OpenMP jobs
- **Snakemake** — Create reproducible, scalable workflows with automatic dependency resolution
- **Reproducibility Framework (RF)** — Organize projects to make every analysis step traceable, repeatable, and version-controlled

Whether you need to manage hundreds of independent jobs, build structured pipelines, or ensure the reproducibility of your computational work, these tutorials walk you through the full lifecycle on ARCH Systems.

Questions? Contact `help@arch.jhu.edu <mailto:help@arch.jhu.edu>`__ for assistance.

.. toctree::
   :maxdepth: 1

   Tutorial_JobDependencies
   Tutorial_Parallel
   Tutorial_Snakemake
   Tutorial_Reproducibility_Framework
   
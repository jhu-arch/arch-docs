Managing Software Using Lmod
############################

Overview
********

Rockfish uses **Lmod** (Lua-based environment modules) to manage a wide variety of scientific software packages. Lmod allows users to dynamically modify their environment (e.g., `PATH`, `LD_LIBRARY_PATH`) by loading or unloading software modules, and supports hierarchical environments based on compilers, MPI stacks, and more.

Current Lmod version: **8.7.24**

Common software categories include:

* **Compilers** — GCC, Intel, CUDA
* **MPI stacks** — OpenMPI, Intel-MPI
* **Bioinformatics tools** — BLAST, Trinity, Samtools, Trimmomatic
* **Numerical libraries** — MKL, OpenBLAS, FFTW, HDF5
* **Commercial software** — MATLAB, COMSOL, ABINIT, TotalView

Module Hierarchy on Rockfish
*****************************

Lmod on Rockfish uses a **hierarchical module system**, organized by compiler and MPI stacks. The module paths include:

.. code-block:: bash

   /data/apps/lmod/linux-rocky8-zen/Core
   /data/apps/lmod/linux-centos8-x86_64/alt/gcc/9.3.0/openmpi/3.1.6
   /data/apps/lmod/linux-rocky8-cascadelake/gcc/9.3.0
   /data/apps/lmod/linux-centos8-x86_64/Core
   ...

This structure ensures that only compatible software is visible once the appropriate compiler or MPI module is loaded.

Basic Lmod Commands
*******************

Explore Available Modules
=========================

To view all software available in the current environment:

.. code-block:: bash

   module avail
   ml avail  # shortcut for module avail

To search for a specific module name across the hierarchy:

.. code-block:: bash

   module spider gcc
   module spider openmpi

To get detailed info about a specific version:

.. code-block:: bash

   module spider gcc/13.1.0
   module spider openmpi/4.1.6

.. tip::

   Lmod supports **shell auto-completion** for most commands, including
   :command:`module spider`.  
   Type a partial name and hit <Tab> — e.g.

   ::

      module spider <Tab>

   — and Lmod will attempt to complete (or list) matching modules.

Load and Use a Module
=====================

Once you identify the module, load it into your session:

.. code-block:: bash

   module load gcc/9.3.0
   module load openmpi/3.1.6
   module load hdf5

Use the `ml` command for convenience:

.. code-block:: bash

   ml gcc/9.3.0 openmpi/3.1.6

Check, purge, or reset your environment
=======================================

.. code-block:: bash

   module list        # show everything currently loaded

   module purge       # unload *all* modules (good hygiene before new jobs)

   module reset       # unload everything **and** re-load the default
                      # modules defined in ~/.modulerc or site defaults

Inspect a Module
================

To see what a module does to your environment (e.g., variables it sets, dependencies it loads):

.. code-block:: bash

   module show openmpi/3.1.6

Using Module Collections
************************

You can save and restore custom module environments:

Save your current environment:

.. code-block:: bash

   module save my_default_env

Load it later:

.. code-block:: bash

   module restore my_default_env

Advanced Notes
**************

Using Module Paths
==================

In some advanced workflows (like EasyBuild or custom stacks), you may need to add a module path manually:

.. code-block:: bash

   module use /path/to/custom/modules

Software Stacks and Compatibility
=================================

Some applications are only available after loading a specific stack, such as:

.. code-block:: bash

   module load gfbf/2023b
   module load R/4.4.1-gfbf-2023b

These stacks are typically managed using `standard`, `tools`, or `gfbf` collections.

Avoiding Conflicts
==================

Some modules are incompatible together (e.g., Python or Anaconda + certain R environments). Always:

1. Run `module purge` before starting new jobs.
2. Avoid mixing software from different compiler/MPI stacks.
3. Follow module hints (warnings or dependencies) shown via `module spider`.
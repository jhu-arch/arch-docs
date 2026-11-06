.. _spack tutorial:

SpackOn
=======

.. contents::
   :local:
   :depth: 2

This guide is for ARCH users who want to install and use software in their
**own** Spack, without admin rights. It does not cover the shared install
tree, the build cache or deployments: those are in the
admin guide.

``spackon`` is installed at ``/apps/helpers/spackon`` and is already on your
``$PATH``. Do not copy it anywhere: it calls itself by the name ``spackon``.

.. code-block:: bash

   command -v spackon      # expect: /apps/helpers/spackon
   spackon -h              # short help
   spackon help-all        # full user help


1. What you can do
##################

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Need
     - How
   * - Use software ARCH already provides
     - ``module avail``, ``module load``. No Spack needed
   * - Build software of your own
     - personal Spack (``spackon -c``, once), then ``spackon -i`` builds it as a Slurm job
   * - Use what you built
     - Lmod modules generated under ``$HOME/modulefiles/lmod``

Personal builds never touch the shared tree under ``/apps/software/spack/``.
If you need a package made available to everyone, ask the ARCH software
team.


|

|

----


2. Use pre-installed software (no Spack needed)
###############################################

.. code-block:: bash

   module avail                          # everything available on this node type
   module load gcc/12.5.0                # a compiler
   module avail                          # now also shows what was built with it
   module load zlib/1.3.1
   module list
   module unload zlib/1.3.1

Shared module names are plain ``name/version``. The module tree is a
hierarchy: a package built with a given compiler only becomes visible after
that compiler is loaded. Intel and AMD nodes have separate trees, and you see
the one matching the node you are on.


|

|

----


3. Install your personal Spack (once)
#####################################

.. code-block:: bash

   spackon -c        # or: spackon --create

This:

- **asks where Spack should be installed** (once). Builds are large, so pick a
  directory under a scratch you can write to. ``spackon`` suggests one: your own
  scratch (``/scratch/<aff>/$USER/spack``) if you have one, which only PIs do;
  otherwise a directory under your PI's scratch
  (``/scratch/<aff>/<PI>/$USER/spack``); otherwise ``$HOME/spack`` (check your
  quota first). Press Enter to accept, or type another absolute path. The
  answer is saved in ``$HOME/.spackon/config`` and used by every later command;
- clones Spack into that directory;
- writes your Spack configuration to ``$HOME/.spack``;
- creates ``$HOME/modulefiles/lmod/spackon/all`` for your modulefiles.
  Modulefiles always stay in your home, whatever directory you chose;
- creates a default environment named ``locally``;
- opens the ``spackon`` subshell when it finishes.

``<aff>`` is ``jhu``, or ``schmidt`` for usernames starting with ``ssci``.

.. note::

   Members of the deploy group are asked *admin or personal* when they run a
   plain ``spackon``. Answer ``2`` (personal), or run ``spackon --personal``.


|

|

----


4. The Spack subshell
#####################

.. code-block:: bash

   spackon           # same as: spackon -a  or  spackon --activate

This opens a subshell with Spack loaded and your personal module path added.
The prompt shows ``( spackon )``. Every ``spack ...`` command in this guide is
typed there.

.. code-block:: bash

   exit              # back to your normal shell

.. note::

   ``spackon -up`` exists but runs in a child process, so it cannot load Spack
   into your *current* shell. Use the subshell, or source
   ``$SPACK_ROOT/share/spack/setup-env.sh`` yourself.


|

|

----


5. Environments, packages and compilers
#######################################

Use one environment per software stack.

.. code-block:: bash

   spack env list                        # what you have
   spack env create gcc-12_5_0           # create (Spack rejects dots in names)
   spack env activate gcc-12_5_0 -p      # activate and show the name in the prompt
   spack env deactivate
   spack env remove old_env

Compilers:

.. code-block:: bash

   spack compilers                       # what Spack knows about
   module unload gcc                     # unload any loaded gcc module first
   spack compiler find                   # register the compilers on $PATH

Add packages and resolve the build plan:

.. code-block:: bash

   spack info gcc                        # versions and variants
   spack add gcc@12.5.0+binutils %gcc@11.5.0
   spack find                            # what the environment contains
   spack concretize -f                   # resolve versions, dependencies, compilers

If concretization fails, read the message and adjust the version, compiler or
constraints before building.

When a spec names a compiler (``%gcc@12.5.0``), the ``spackon`` subshell pins the
active environment to that compiler for every package in it, so build
dependencies are not reused from another compiler. Check with
``spack config get packages``.


|

|

----


6. Build with a Slurm job
#########################

Never run large builds on a login node. ``spackon -i`` submits the install as a
Slurm job (8 cores and 4 hours by default, ``spack install -j 8``). The
environment must be concretized first.

.. code-block:: bash

   exit                                  # leave the subshell (optional, but tidy)
   spackon -i gcc-12_5_0 -p med -t 02:00:00 --account=<account> --comment=accept_cost

- ``-p`` is the partition and ``-t`` the time limit (minutes, or any Slurm
  format). On ARCH there is no default partition and the billing plugin
  rejects jobs without ``--comment=accept_cost``, so keep those two.
- Every other option is passed to ``sbatch`` untouched (``--account=``,
  ``--mem=``, ``--exclusive``, ...).
- Your accounts: ``sacctmgr -nP show assoc user=$USER format=account``.

Follow the job:

.. code-block:: bash

   sqme                                  # your jobs (ARCH alias); or: squeue -u $USER
   cat slurm-<jobid>.out                 # written in the directory you submitted from

When the job completes, ``spackon`` refreshes your modulefiles under
``$HOME/modulefiles/lmod``. If the job ends in ``TIMEOUT``, resubmit with a larger
``-t``. If it failed, the ``slurm-<jobid>.out`` file is the place to start.


|

|

----


7. Use what you built, as modules
#################################

.. code-block:: bash

   module load own/0.1                   # adds $HOME/modulefiles/lmod/spackon/all to MODULEPATH
   module load gcc/12.5.0
   gcc --version

Your modules follow the same hierarchy as the shared ones: load the compiler,
then the packages built with it.


|

|

----


8. Worked example: GCC 12.5.0, then zlib built with it
######################################################

Pass 1: build GCC 12.5.0 with the system GCC 11.5.0.

.. code-block:: bash

   spackon
   spack env create gcc-12_5_0
   spack env activate gcc-12_5_0 -p
   spack compilers                       # gcc@11.5.0 must be listed; else: module unload gcc; spack compiler find
   spack add gcc@12.5.0+binutils %gcc@11.5.0
   spack concretize -f
   exit
   spackon -i gcc-12_5_0 -p med -t 02:00:00 --account=<account> --comment=accept_cost

.. note::

   **Why** ``+binutils``? The system binutils (2.35.2) cannot assemble the
   AVX512-FP16 instructions GCC emits for the newer Intel nodes, so a
   ``~binutils`` build fails in stage1 libgcc. ``+binutils`` makes Spack build and
   use its own binutils.

Pass 2: build zlib with the new compiler.

.. code-block:: bash

   spackon
   spack env create zlib-1_3_1
   spack env activate zlib-1_3_1 -p
   module unload gcc
   module load own/0.1
   module load gcc/12.5.0
   spack compiler find                   # registers gcc@12.5.0
   spack add zlib@1.3.1 %gcc@12.5.0
   spack concretize -f
   exit
   spackon -i zlib-1_3_1 -p med -t 02:00:00 --account=<account> --comment=accept_cost

Use it:

.. code-block:: bash

   module load own/0.1
   module load gcc/12.5.0
   module load zlib/1.3.1


|

|

----


9. Other commands
#################

.. code-block:: bash

   spackon -u                            # update Spack to the latest stable tag
   spackon -u dev                        # ... or to the develop branch
                                         # (the old tree is kept as spack.<mon><DD>.<YYYY>)
   spackon -r                            # remove your personal Spack (asks first)
   spackon -e <path>                     # move your environments to another path
   spackon -m a.yaml b.yaml              # merge YAML files (later files override earlier ones)
   spackon --keys list                   # GPG keys Spack trusts
   spackon --keys trust                  # trust the ARCH signing keys

Inside the subshell, Spack can also install from the ARCH build cache instead
of compiling, when a matching signed binary exists:

.. code-block:: bash

   spack buildcache list zlib
   spack install --use-buildcache prefer zlib@1.3.1


|

|

----


10. Troubleshooting
###################

.. list-table::
   :header-rows: 1
   :widths: 45 55

   * - Symptom
     - Cause and fix
   * - The job dies within minutes and the output says ``spack requires 'patch'``
     - the compute node image lacks GNU ``patch``. Not your mistake: report it to ARCH
   * - A GCC build fails in stage1 ``libgcc`` on a newer Intel node
     - add ``+binutils`` to the gcc spec (section 8)
   * - The job ends with ``TIMEOUT``
     - resubmit with a larger ``-t``
   * - ``sbatch`` refuses the job
     - add ``-p <partition>`` and ``--comment=accept_cost``; check your ``--account``
   * - My environments are gone
     - deploy-group members only: you opened the other store. The prompt says which, ``( spackon )`` or
       ``( spackon:admin )``. Use ``spackon --personal``
   * - ``spackon -up`` did nothing
     - it cannot change your current shell; use ``spackon`` (the subshell)
   * - ``module load zlib/1.3.1`` fails
     - load ``own/0.1`` and the compiler it was built with first

Where things live:

.. list-table::
   :header-rows: 1
   :widths: 45 55

   * - Path
     - Purpose
   * - the directory chosen at ``spackon -c``
     - your Spack and its packages (for example ``/scratch/<aff>/<PI>/$USER/spack``)
   * - ``$HOME/.spackon/config``
     - that choice, remembered
   * - ``$HOME/.spack/``
     - your Spack configuration
   * - ``$HOME/modulefiles/lmod/spackon/all``
     - your modulefiles (``module load own/0.1``)
   * - ``slurm-<jobid>.out``
     - the build log, in the directory you submitted from


|

|

----


11. Command reference
#####################

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Command
     - What it does
   * - ``spackon`` / ``spackon -a``
     - open the Spack subshell (default action)
   * - ``spackon -c``
     - install your personal Spack (once; asks where)
   * - ``spackon -i <env> [-p P] [-t T] [sbatch options]``
     - build the environment as a Slurm job
   * - ``spackon -u [dev]``
     - update Spack (latest stable tag, or develop)
   * - ``spackon -r``
     - remove your personal Spack (confirms first)
   * - ``spackon -e <path>``
     - move your environments to another path
   * - ``spackon -m <file>...``
     - merge YAML files
   * - ``spackon --keys list`` / ``spackon --keys trust``
     - list / trust GPG keys
   * - ``spackon --personal``
     - open your personal Spack without the admin/personal question
   * - ``spackon -h`` / ``spackon help-all``
     - short / full help

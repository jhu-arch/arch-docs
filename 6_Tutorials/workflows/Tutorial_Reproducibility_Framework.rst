Reproducibility Framework (RF)
##############################

Reproducibility is a core principle of good science.  
Seemingly small details—random-number seeds, software versions, or
inconsistent environments—can prevent others (or even *you* in six
months) from repeating an analysis.

The **Reproducibility Framework** (``rf``) provides a lightweight,
directory-based convention plus helper commands that help you

* organise multi-step analysis pipelines,
* separate *human* input from *machine* output,
* run every step with a single, argument-free *driver script*, and
* version both code *and* data.

The framework pairs naturally with containers (Docker / Singularity) and
with Git + Git-Annex for version control.

Why a dedicated framework?
--------------------------

Bioinformatic and data-science workflows typically chain many tools.
Exploration (trying alternative tools or parameters) is essential but
can quickly turn a project directory into an untraceable mess.  RF keeps
the exploration *structured* and *self-documenting* with three simple
rules:

1. **Directory = analysis step**  
   Dependencies appear naturally in the path.
2. **Two sub-dirs per step**  
   ``_h`` for *human* inputs (scripts, README, configs);  
   ``_m`` for *machine* outputs (results, logs).
3. **Driver script**  
   A *run* file inside ``_h`` executes the step **without arguments**.
   Re-running a step therefore always gives the same result.

A minimal example directory might look like:

.. code-block:: text

   project/
   ├── stepA
   │   ├── _h/          # scripts, README, configs
   │   │   └── run
   │   └── _m/          # program outputs
   └── stepB            # depends on stepA
       ├── _h/
       │   └── run
       └── _m/

Installing the framework
************************

Prerequisites
=============

* Python ≥ 3.6
* A recent Git installation (for ``_h`` trees)
* ``git-annex`` (for large files in ``_m``)
* The POSIX **tree** utility (needed by ``rf status``)

Step 1 – Install **rf**
=======================

.. code-block:: bash

   pip3 install --user git+https://github.com/ricardojacomini/rf.git
   rf --help
   rf run --help

Step 2 – Install the *tree* command (non-root)
==============================================

If *tree* is not available system-wide:

.. code-block:: bash

   curl -s https://raw.githubusercontent.com/ricardojacomini/rf/master/scripts/install_tree_non_root.sh | bash
   rf status         # verify installation
   rf status -p

Quick-start tutorials
*********************

Tutorial 1 – Your first RF project
==================================

.. code-block:: bash

   # 1) create a project with one analysis step
   mkdir -p tutorial/_h
   cd tutorial

   # 2) a minimal driver script
   echo "date > date.txt" > _h/run
   chmod +x _h/run

   # 3) initialise Git for the human tree
   git init .

   # 4) run the pipeline (one step for now)
   rf run .

   # 5) inspect results
   tree
   user@c001:~/tutorial$ tree
   .
   ├── _h
   │   └── run
   └── _m
       ├── date.txt
       ├── nohup.out
       └── SUCCESS

   2 directories, 4 files

   user@c001:~/tutorial$ cat _m/date.txt
   Mon Apr 28 13:52:50 EDT 2025
   

``rf`` created ``_m/date.txt`` and a ``SUCCESS`` stamp.  
`rf status` shows each step as **ready**, **running** or **done**.

Tutorial 2 – Running a step inside a container
===============================================

.. code-block:: bash

   cd tutorial
   mkdir -p bedtools/_h
   cd bedtools

Create *bedtools* driver ``_h/run``:

.. code-block:: bash

   #!/usr/bin/env bash
   set -euo pipefail
   bedtools genomecov -i ../_h/exons.bed -g ../_h/genome.txt -bg > out.tsv

Make it executable:

.. code-block:: bash

   chmod +x _h/run

Assume we already built ``../_h/ubuntu_bedtools.sif`` earlier.  
Run the step and bind its ``_m`` directory into the container:

.. code-block:: bash

   export IMG=../_h/ubuntu_bedtools.sif
   export BIND=$(realpath .)/_m               # mount point inside SIF
   rf run --container_image="$IMG" --volume="$BIND" .

``rf`` prints a time-stamped make-style plan, executes the driver inside
Singularity, and marks the step **done**.

Version control
===============

* **Human tree** (``_h``) – regular *Git* repository  
* **Machine tree** (``_m``) – *Git-Annex* keeps large outputs out of Git
* ``rf`` wraps common multi-step git / annex operations

For detailed version-control workflows see the original
`preprint <http://biorxiv.org/content/early/2015/12/09/033654>`__.

Reference
*********

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - **Command**
     - **Description**
   * - ``rf status``
     - Show each step as **ready**, **running**, **done** or **error**.
   * - ``rf run <dir>``
     - Execute the driver(s) beneath *dir*; container options optional.
   * - ``rf markdown``
     - Render an analysis tree as a Markdown report (nice for lab notes).

Tips & best practices
---------------------

* Keep driver scripts *argument-free*; pass parameters via config files
  stored in the same ``_h`` directory.
* Treat ``_m`` as **disposable**—delete and regenerate at any time.
* Commit early & often in ``_h``; use ``git annex sync`` for bulky
  results you really want to keep.
* Combine RF with Snakemake / Nextflow for workflow logic if desired—the
  directory structure still provides the *human-readable* scaffold.
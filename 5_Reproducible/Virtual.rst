.. _virtual-env:

Virtual Environment
###################

A virtual environment is used to isolating projects, interpreters like python, libraries and scripts, from those that are installed as part of your operating system.

There are ``Python`` and ``Anaconda`` installed on Rockfish cluster. The environments and packages that can be installed using ``pip`` and/or ``conda``. They differ in how dependency relationships within an environment are performed.

Python
******

.. image:: https://readthedocs.org/projects/python/badge/?version=latest
  :target: https://python.readthedocs.io/en/latest/?badge=latest
  :alt: The Python programming language

There are several python versions installed. Users can use ``module spider``. command to check the installed versions:

.. code-block:: console

  [userid@login03 ~]$ ml spider python
  -------------------------------------------------------------------------
    python:
  -------------------------------------------------------------------------
       Versions:
          python/3.7.9
          python/3.8.6
          python/3.9.0

Once you have a version of python loaded, you can use ``module avail`` command to check if any python packages are available to load.

.. code-block:: console

  [userid@login03 ~]$ module load python/3.8.6
  [userid@login03 ~]$ module avail

  *** RockFish Software ***
  Use "module spider <name>" to search all software.
  The available software depends on the compiler, MPI,
  Python, and R modules you have already loaded.
  https://lmod.readthedocs.io/en/latest/010_user.html

  ------------------------------ python (3.8) ------------------------------
     py-cython/0.29.21    py-pip/20.2               py-scipy/1.5.3
     py-joblib/0.14.0     py-pybind11/2.5.0         py-setuptools/50.1.0
     py-numpy/1.18.5      py-scikit-learn/0.23.2    py-threadpoolctl/2.0.0

To create a virtual environment, users can check the python version used and create a directory.

.. code-block:: console

  [userid@login03 ~]$ module list python

  Currently Loaded Modules Matching: python
   1) python/3.8.6
  [userid@login03 ~]$ mkdir python3.8
  [userid@login03 ~]$ cd python3.8/
  [userid@login03 python3.8]$

Once enter the directory, users can run the ``python3 -m venv`` command to create a virtual environment.

.. code-block:: console

  [userid@login03 python3.8]$ python3 -m venv math-packages
  [userid@login03 python3.8]$ ls math-packages/
  bin  include  lib  lib64  pyvenv.cfg

the environment will be created under the ``math-packages`` directory. You can use activate the environment by sourcing the ``activate`` script under the bin directory.

Once it is activated, the name of the environment ``math-packages`` will be displayed the prompt.

.. code-block:: console

  [userid@login03 python3.8]$ source math-packages/bin/activate
  (math-packages) [userid@login03 python3.8]$

Also, the python packages can be installed under this environment using the ``pip`` command.

.. code-block:: console

  (math-packages) [userid@login03 python3.8]$ pip install numpy
  Collecting numpy
    Downloading numpy-1.22.3-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (16.8 MB)
       |████████████████████████████████| 16.8 MB 85 kB/s
  Installing collected packages: numpy
  Successfully installed numpy-1.22.3

It multiple python packages with your specific versions can be installed.

pip
^^^

.. image:: https://img.shields.io/pypi/v/pip.svg
   :target: https://pypi.org/project/pip/

.. image:: https://readthedocs.org/projects/pip/badge/?version=latest
   :target: https://pip.pypa.io/en/latest


pip is a package manager. If more packages are needed, the ``pip`` command to install them.

.. warning::
   Users are not able to install packages in the python installed as part of your operating system.

Users can use the ``pip`` with ``--user`` option to install in the hidden directory ~/.local.

However, many packages can be installed. It is difficult to gathering all requirements in a global installation. Users has autonomy to create virtual environments, install packages and manage them. In this way, multiple environments can be created to avoid conflicts and ensure reproducibility.

How to install pip
""""""""""""""""""

Install pip for non-root users.

.. code-block:: console

  [userid@login03 ~]$ ml python/3.9.0
  [userid@login03 ~]$ curl -O https://bootstrap.pypa.io/get-pip.py
  [userid@login03 ~]$ python get-pip.py;  rm get-pip.py
  [userid@login03 ~]$ ml -python/3.9.0

Anaconda
********

.. image:: https://copr.fedorainfracloud.org/coprs/g/rhinstaller/Anaconda/package/anaconda/status_image/last_build.png
    :alt: Build status
    :target: https://copr.fedorainfracloud.org/coprs/g/rhinstaller/Anaconda/package/anaconda/

.. image:: https://readthedocs.org/projects/anaconda-installer/badge/?version=latest
    :alt: Documentation Status
    :target: https://anaconda-installer.readthedocs.io/en/latest/?badge=latest

.. image:: https://codecov.io/gh/rhinstaller/anaconda/branch/master/graph/badge.svg
    :alt: Coverage status
    :target: https://codecov.io/gh/rhinstaller/anaconda

.. image:: https://translate.fedoraproject.org/widgets/anaconda/-/master/svg-badge.svg
    :alt: Translation status
    :target: https://translate.fedoraproject.org/engage/anaconda/?utm_source=widget

There are many ananconda installed on the Rockfish cluster. Once loaded a anaconda, you can use conda command to create conda environments.

.. code-block:: console

  [userid@login03 conda]$ module load anaconda
  [userid@login03 conda]$ conda -V
  conda 4.8.3

Users are suggested to use conda environments for installing and running packages.

For example, to create an environment called ``my_tensorflow``, execute ``conda create --name my_tensorflow -y``. Also, for example, to create an environment called ``my_conda``, execute the command with ``-p`` option.

.. code-block:: console

  [userid@login03 ~]$ conda create -p conda/my_env
  Collecting package metadata (current_repodata.json): done
  Solving environment: done

  ==> WARNING: A newer version of conda exists. <==
    current version: 4.8.3
    latest version: 4.11.0

  Please update conda by running

      $ conda update -n base -c defaults conda

  ## Package Plan ##

    environment location: /home/userid/conda/my_env

  Proceed ([y]/n)? y

Conda
^^^^^

.. image:: https://github.com/conda/conda/actions/workflows/ci.yml/badge.svg
    :target: https://github.com/conda/conda/actions/workflows/ci.yml
    :alt: CI Tests (GitHub Actions)

.. image:: https://github.com/conda/conda/actions/workflows/ci-images.yml/badge.svg
    :target: https://github.com/conda/conda/actions/workflows/ci-images.yml
    :alt: CI Images (GitHub Actions)

.. image:: https://img.shields.io/codecov/c/github/conda/conda/master.svg?label=coverage
   :alt: Codecov Status
   :target: https://codecov.io/gh/conda/conda/branch/master

.. image:: https://img.shields.io/github/release/conda/conda.svg
   :alt: latest release version
   :target: https://github.com/conda/conda/releases

Conda is a tool to manager virtual environments, it allows to create, removing or packaging virtual environments, as well as package manager.

Users can now activate the environment by the conda activate command with the directory path:

.. code-block:: console

  [userid@login03 conda]$ cd conda
  [userid@login03 conda]$ conda activate ./my_env

Create the environment from the environment.yml
"""""""""""""""""""""""""""""""""""""""""""""""

Let's suppose you want to create a new environment, we can use the environment.yml file to create it.

.. code::

  name: machine-learning-env

  dependencies:
    - ipython=7.13
    - matplotlib=3.1
    - pandas=1.0
    - pip=20.0
    - python=3.6
    - scikit-learn=0.22

Using a prompt for the following steps:

1. Create the environment from the ``environment.yml`` file:

.. code::

  [userid@login03 ~]$ conda env create -f environment.yml

.. tip::
  The first line of the ``yml`` file sets the new environment's name.

  If you have created your environment, you can use the –file flag with the conda install command as:

  conda install --file requirements.txt

2. Activate the new environment: ``conda activate myenv``

3. Verify that the new environment was installed correctly:

.. code::

  [userid@login03 ~]$ conda env list

You can also use ``conda info --envs``.

You can control where a conda environment, providing a path to a target directory when creating the environment.

.. code::

  [userid@login03 ~]$ conda create --prefix ./envs jupyterlab=3.2 matplotlib=3.5 numpy=1.21

You then activate an environment created with a prefix using the same
command used to activate environments created by name:

.. code::

  [userid@login03 ~]$ conda activate ./envs

.. note::

  Specifying a path to a subdirectory of your project directory when
  creating an environment has the following benefits:

    * It makes it easy to tell if your project uses an isolated environment
      by including the environment as a subdirectory.
    * It makes your project more self-contained as everything, including
      the required software, is contained in a single project directory.

An additional benefit of creating your project’s environment inside a
subdirectory is that you can then use the same name for all your
environments. If you keep all of your environments in your ``envs``
folder, you’ll have to give each environment a different name.

.. code-block:: console

  [userid@login03 ~]$ salloc -p a100 -c 2 --gres=gpu:1 -t 120 -A <PI-userid>_gpu srun --pty bash
  [userid@gpu02 ~]$ mkdir -p ~/envs/tf_2.4.0
  [userid@gpu02 ~]$ cd ~/envs/
  [userid@gpu02 ~]$ ml anaconda cuda/11.1.0 cudnn
  [userid@gpu02 ~]$ cat > environment.yaml << EOF
                    dependencies:
                     - pip
                     - pip:
                     - tensorflow==2.4.0
                    EOF
  [userid@gpu02 ~]$ conda env create --prefix ~/envs/tf_2.4.0 --file environment.yaml
  [userid@gpu02 ~]$ conda activate ~/envs/tf_2.4.0

.. note:
  Charge job to specified account (<PI-userid>_gpu.


Conda-Pack
^^^^^^^^^^
`conda-pack`_ is a command line tool for creating relocatable conda environments. This is useful for deploying code in a consistent environment, potentially in a location where python/conda is not installed.

**Install via conda**

conda-pack is available from `Anaconda`_ as well as from conda-forge:

.. code-block:: console

  conda install conda-pack
  conda install -c conda-forge conda-pack

**Install via pip**

While conda-pack requires an existing conda install, it can also be installed from PyPI:

.. code-block:: console

  pip install conda-pack

**Install from source**

It can be installed from source.

.. code-block:: console

  pip install git+https://github.com/conda/conda-pack.git

**Usage**

conda-pack is primarily a commandline tool, see `docs`_ for full details.

On the source machine
"""""""""""""""""""""

.. code-block:: console

  # Pack environment my_env into my_env.tar.gz
  $ conda pack -n my_env

  # Pack environment my_env into out_name.tar.gz
  $ conda pack -n my_env -o out_name.tar.gz

  # Pack environment located at an explicit path into my_env.tar.gz
  $ conda pack -p /explicit/path/to/my_env

On the target machine
"""""""""""""""""""""

.. code-block:: console

  # Unpack environment into directory `my_env`
  $ mkdir -p my_env
  $ tar -xzf my_env.tar.gz -C my_env

  # Use python without activating or fixing the prefixes. Most python
  # libraries will work fine, but things that require prefix cleanups
  # will fail.
  $ ./my_env/bin/python

  # Activate the environment. This adds `my_env/bin` to your path
  $ source my_env/bin/activate

  # Run python from in the environment
  (my_env) $ python

  # Cleanup prefixes from in the active environment.
  # Note that this command can also be run without activating the environment
  # as long as some version of python is already installed on the machine.
  (my_env) $ conda-unpack

  # At this point the environment is exactly as if you installed it here
  # using conda directly. All scripts should work fine.
  (my_env) $ ipython --version

  # Deactivate the environment to remove it from your path
  (my_env) $ source my_env/bin/deactivate

Spack
******

.. image:: https://github.com/spack/spack/workflows/linux%20tests/badge.svg
    :target:  https://github.com/spack/spack/actions
    :alt: Unit Tests

.. image:: https://github.com/spack/spack/actions/workflows/bootstrap.yml/badge.svg
    :target:  https://github.com/spack/spack/actions/workflows/bootstrap.yml
    :alt: Bootstrapping

.. image:: https://github.com/spack/spack/workflows/macOS%20builds%20nightly/badge.svg?branch=develop
    :target:  https://github.com/spack/spack/actions?query=workflow%3A%22macOS+builds+nightly%22
    :alt: macOS Builds (nightly)

.. image:: https://codecov.io/gh/spack/spack/branch/develop/graph/badge.svg
    :target:  https://codecov.io/gh/spack/spack
    :alt: codecov

.. image:: https://github.com/spack/spack/actions/workflows/build-containers.yml/badge.svg
    :target:  https://github.com/spack/spack/actions/workflows/build-containers.yml
    :alt: Containers

.. image:: https://readthedocs.org/projects/spack/badge/?version=latest
    :target:  https://spack.readthedocs.io
    :alt: Read the Docs

.. image:: https://slack.spack.io/badge.svg
    :target:  https://slack.spack.io
    :alt: Slack

Spack is simple package management tool. It was designed for large supercomputing centers. It is non-destructive: installing a new version does not break existing installations, so many configurations can coexist on the same system.

Get spack from the `github repository
<https://github.com/spack/spack>`_ and install your first
package:

.. code-block:: console

   $ git clone -c feature.manyFiles=true https://github.com/spack/spack.git
   $ cd spack/bin
   $ ./spack install zlib

Documentation
^^^^^^^^^^^^^

[**Full documentation**](https://spack.readthedocs.io/) is available, or
run `spack help` or `spack help --all`.

For a cheat sheet on Spack syntax, run `spack help --spec`.

Tutorial
^^^^^^^^

We maintain a
[**hands-on tutorial**](https://spack.readthedocs.io/en/latest/tutorial.html).
It covers basic to advanced usage, packaging, developer features, and large HPC
deployments.  You can do all of the exercises on your own laptop using a
Docker container.

.. _conda-forge: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
.. _docs: https://conda.github.io/conda-pack/cli.html
.. _conda-forge2: https://conda-forge.org/
.. _conda-pack: https://conda.github.io/conda-pack/
.. _Anaconda: https://anaconda.org

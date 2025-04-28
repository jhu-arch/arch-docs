.. _singularity_container:

Singularity container
#####################

.. image:: https://readthedocs.org/projects/singularity-user-docs/badge/?version=latest
   :target: https://singularity-user-docs.readthedocs.io/en/latest/?badge=latest
   :alt: Documentation Status

This tutorials will allow you to run `Singularity`_ containers on computers where you do not have root (administrative) privileges, like the Rockfish cluster at ARCH.

A container allows you to put an application and all of its dependencies in a single package. Ensure portability and reproducibility of all dependency packages of an application.
Here are some examples of things you can do with containers:

* Package an analysis pipeline so that it runs on your computer, in the cloud, and in a High Performance Computing (HPC) environment to produce the same result.
* Publish a paper and include a link to a container with all of the data and software that you used so that others can easily reproduce your results.
* Install and run an application that requires a complicated stack of dependencies with a few keystrokes.
* Create a pipeline or complex workflow where each individual program is meant to run on a different operating system.

Building a Singularity Container Image from definitions file
************************************************************

Bootstrapping a `singularity container`_ allows using a file called ``definitions file`` which can reproduce container configurations on demand.

.. code-block:: console

  [userid@login01 ~]$ mkdir tutorial/container/_h -p
  [userid@login01 ~]$ cd tutorial/container/
  [userid@container ~]$ vi _h/ubuntu_bedtools.def

Let’s first create a container with Ubuntu 20.10 and the `bedtools`_ command (toolset). Below are the contents of how the definitions file should look like.

.. code-block:: console

  Bootstrap: docker
  From: ubuntu:20.10

  %post
      apt-get -y update
      apt-get -y install bedtools

  %environment
      export LC_ALL=C

Now let’s use this definition file as a starting point to build the ``ubuntu_bedtools.sif`` container. Note that the build command requires ``sudo`` privileges.

.. code-block:: console

  [userid@container ~]$ sudo singularity build _h/ubuntu_bedtools.sif _h/ubuntu_bedtools.def

Now let’s enter the new container and look around.

.. code-block:: console

  [userid@container ~]$ singularity shell ubuntu_bedtools.sif

  Singularity>
  Singularity> bedtools --version
  bedtools v2.29.2

Depending on the environment on your host system you may see your prompt change.
Let’s exit the container and re-enter as root.

.. code-block:: console

  Singularity> exit
  $ sudo singularity shell --writable ubuntu_bedtools.sif

Now as a root user inside the container. Note also the addition of the ``--writable`` option, it allows us to modify the container, and the changes will be saved into the container persisting across uses.

.. _fakeroot_option:
.. warning::
   The ``--fakeroot`` option provided in Singularity version 3.6.x (for use with the singularity ``build``, ``shell``, and ``exec`` commands) is not supported on Rockfish systems for security reasons.

How to build a Singularity Image from Docker Hub
************************************************

Singularity can also use containers directly from Docker images. You can ``shell``, ``import``, ``run``, and ``exec`` Docker images directly from the ``Docker Registry``. This feature was included because developers have been using Docker and scientists have already put many resources into creating Docker images.
Docker images, opening up access to a large number of existing container images available on Docker Hub and other registries.

.. code-block:: console

  [userid@container ~]$ mkdir ~/singularity
  [userid@container ~]$ cd ~/singularity/
  [userid@singularity ~]$ singularity pull docker://ubuntu:latest
  [userid@singularity ~]$ singularity shell ubuntu_latest.sif

However, you will not be able to change this image on Rockfish cluster, because there is no partition SIF writable, see :ref:`fakeroot option <fakeroot_option>`.

We will prepare an image using `Docker container`_, and make it available on `Docker Hub`_ and then an administrator will create a Singularity container to run it on Rockfish.

In order to build the application, we need to use a `Docker Desktop`_. Then, we will generate a Dockerfile to create `Nanopolish`_ application as an example. The Nanopolish is a software package for signal-level analysis of Oxford Nanopore sequencing data.

.. note::
  There are different ways to run Nanopolish: via conda, via installation source or container. This tutorial will cover how to install it using singularity, via docker hub repository.

**Nanopolish**

The Nanopolish package calculates an improved consensus sequence for a draft genome assembly, detect base modifications, call SNPs and indels with respect to a reference genome and more modules.

.. tip::
  To create this container, we used the latest Nanopolish version 0.13.3 and Ubuntu 21.04. Also, you can use different platform GNU/Linux: Ubuntu, ArchLinux, Debian, Centos, etc.

Non-root users
^^^^^^^^^^^^^^

The next steps were used to create it.

  1. Create a file named `Dockerfile`_
  2. Build an image from a Dockerfile ( `docker`_ `build`_ )
  3. Create a tag ``TARGET_IMAGE`` that refers to ``SOURCE_IMAGE`` ( docker `tag`_ )
  4. Run a command in a new container ( docker `run`_ )
  5. Start one or more stopped containers ( docker `start`_ )
  6. Exec (perform) a command into a running container (docker `exec`_)
  7. Create a new image from a container’s changes ( docker `commit`_ )
  8. Push an image or a repository to a registry ( docker `push`_ )

1. Create a file named Dockerfile
""""""""""""""""""""""""""""""""""

Docker builds images automatically by reading the instructions from a ``Dockerfile``.

.. note::
  Dockerfile is a text file that contains all commands, in order, needed to build a given image.

.. code-block:: console

  FROM --platform=linux/amd64 ubuntu:21.04

  MAINTAINER Ricardo S. Jacomini <rdesouz4@jhu.edu>

  RUN uname -a

  ENV TZ=America/New_York

  RUN apt-get update -qq

  RUN apt-get install -y tzdata

  RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

  RUN date

  RUN apt-get install -yq --no-install-suggests --no-install-recommends \

      ca-certificates gcc g++ make git wget bzip2 libbz2-dev \

      zlib1g-dev liblzma-dev libncurses5-dev libncursesw5-dev xz-utils \

      bwa bedtools \

      software-properties-common

  # **** Install HTSLIB ****

  RUN wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2

  RUN tar -vxjf htslib-1.9.tar.bz2

  WORKDIR htslib-1.9

  RUN ./configure --prefix=/usr/local

  RUN make

  RUN make install

  WORKDIR /

  RUN rm htslib* -Rf

  # **** Install BCFTools ****

  WORKDIR /

  RUN wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2

  RUN tar -vxjf bcftools-1.9.tar.bz2

  WORKDIR bcftools-1.9

  RUN ./configure --prefix=/usr/local

  RUN make

  RUN make install

  WORKDIR /

  RUN rm bcftools* -Rf

  # **** Install Canu ****

  WORKDIR /opt

  RUN git clone https://github.com/marbl/canu.git

  WORKDIR canu/src

  RUN make -j 4

  WORKDIR /

  # **** Set up environment variable ****

  ENV PATH="/opt/nanopolish:/opt/nanopolish/bin:/opt/canu/build/bin/:$PATH"

  ENV LD_LIBRARY_PATH="/opt/nanopolish/lib:$LD_LIBRARY_PATH"

  ENV C_INCLUDE_PATH ="/opt/nanopolish/include:$LD_LIBRARY_PATH">

  # **** Install Nanopolish ****

  WORKDIR /opt

  RUN git clone --recursive https://github.com/jts/nanopolish.git

  WORKDIR /opt/nanopolish

  RUN make all

  RUN make test

  RUN rm *.tar.*


2. Build an image from a Dockerfile
"""""""""""""""""""""""""""""""""""

  **Usage** : $ docker build [OPTIONS] PATH | URL | -

.. code-block:: console

  [userid@local ~]$  docker build - < Dockerfile


3. Create a tag target image that refers to source image
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  **Usage** : $ docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]

Tag an image referenced by ID.

.. code-block:: console

  [userid@local ~]$ docker image ls
  REPOSITORY                               TAG               IMAGE ID       CREATED          SIZE
  <none>                                   <none>            540135da7ceb   47 minutes ago   1.96GB

  [userid@local ~]$ docker tag 540135da7ceb archrockfish/nanopolish:0.13.3

  [userid@local ~]$ docker image ls
  REPOSITORY                               TAG               IMAGE ID       CREATED        SIZE
  archrockfish/nanopolish                  0.13.3            540135da7ceb   49 minutes ago   1.96GB

4. Run a command in a new container
"""""""""""""""""""""""""""""""""""""

  **Usage** : $ docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

Run it will create a container and start a Bash session to a specified image using IMAGE ID.

.. code-block:: console

  [userid@local ~]$ docker run -it 540135da7ceb bash
  root@421451a1f942:/opt/nanopolish#

  [userid@local ~]$ docker ps -all
  CONTAINER ID   IMAGE          COMMAND   CREATED          STATUS                     PORTS     NAMES
  421451a1f942   540135da7ceb   "bash"    22 seconds ago   Exited (0) 5 seconds ago             stupefied_johnson

or you can Run it will create a container named nanopolish using ``REPOSITORY``, if it was tagged. (``step 3``)

.. code-block:: console

  [userid@local ~]$ docker run --name nanopolish -it archrockfish/nanopolish:0.13.3 bash
  root@0c192de0b227:/#

  [userid@local ~]$ docker ps --all
  CONTAINER ID   IMAGE                            COMMAND   CREATED         STATUS          PORTS     NAMES
  0c192de0b227   archrockfish/nanopolish:0.13.3   "bash"    3 minutes ago   Up 44 seconds             nanopolish

5. Start one or more stopped containers
"""""""""""""""""""""""""""""""""""""""

  **Usage** : $ docker start [OPTIONS] CONTAINER [CONTAINER...]

.. code-block:: console

  [userid@local ~]$ docker start nanopolish
  nanopolish

  [userid@local ~]$ docker ps
  CONTAINER ID   IMAGE          COMMAND   CREATED          STATUS         PORTS     NAMES
  0c192de0b227   540135da7ceb   "bash"    46 seconds ago   Up 5 seconds             nanopolish

6. Exec (perform) a command into a running container
""""""""""""""""""""""""""""""""""""""""""""""""""""

  **Usage** : $ docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

First, start a container (``step 5``), or keep the container running (``step 4``) in the background, to run it with ```--detach`` (or ``-d``) argument.

.. note::
  You need to delete that first before you can re-create a container with the same name with.

.. code-block:: console

  [userid@local ~]$ docker stop nanopolish
  nanopolish

  [userid@local ~]$ docker rm nanopolish
  nanopolish
  or simply choose a different name for the new container.

  [userid@local ~]$ docker run --name nanopolish_local -dit archrockfish/nanopolish:0.13.3
  a3dcaa7760906861250329dca37b01f79caec10310e1bc37b7fdf6f341de5d27
  Then, execute an interactive bash shell on the new container.

  [userid@local ~]$ docker exec -it nanopolish_local bash
  root@a3dcaa776090:/opt/nanopolish#


7. Create a new image from a container’s changes
""""""""""""""""""""""""""""""""""""""""""""""""

  **Usage** : $ docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]

.. code-block:: console

  [userid@local ~]$ docker ps -all
  CONTAINER ID   IMAGE                            COMMAND   CREATED          STATUS                      PORTS     NAMES
  a3dcaa776090   archrockfish/nanopolish:0.13.3   "bash"    18 seconds ago   Exited (0) 14 seconds ago             nanopolish_local

  [userid@local ~]$  docker commit a3dcaa776090 archrockfish/nanopolish:0.13.3
  sha256:b379b32916535b146b1fce63a14fade2cdf60bbaacf36625732cec379e03dd96

  [userid@local ~]$ docker inspect -f "{{ .Config.Env }}" a3dcaa776090
  [PATH=/opt/nanopolish:/opt/nanopolish/bin:/opt/canu/build/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin TZ=America/New_York LD_LIBRARY_PATH=/opt/nanopolish/lib: C_INCLUDE_PATH==/opt/nanopolish/include:/opt/nanopolish/lib:]

  [userid@local ~]$ docker image ls
  REPOSITORY                               TAG               IMAGE ID       CREATED         SIZE
  archrockfish/nanopolish                  0.13.3            0375e5f8a31d   4 minutes ago   1.96GB

8. Push an image or a repository to a registry
""""""""""""""""""""""""""""""""""""""""""""""

  **Usage** : $ docker push [OPTIONS] NAME[:TAG]

.. code-block:: console

  [userid@local ~]$ docker push archrockfish/nanopolish:0.13.3
  The push refers to repository [docker.io/archrockfish/nanopolish]
  ee33934ad57b: Layer already exists
  ...
  ...
  ...

9. Pull an image from docker hub
""""""""""""""""""""""""""""""""

  **Usage** : $ singularity pull [pull options...] [output file] <URI>

The last step you will be able to create a singularity container on Rockfish cluster.

.. tip::
  Root users can use a ``build`` option, instead of ``pull`` command.

  $ sudo singularity build nanopolish.sif docker://archrockfish/nanopolish:0.13.3

.. code-block:: console

  [userid@login03 ~]$ interact -c 2 -t 120
  [userid@c011 ~]$ sudo singularity build nanopolish.sif docker://archrockfish/nanopolish:0.13.3

.. warning::
  You need to create a repository and assign who are the `contributors`_ with permission to upload an image to this repository, before tag an image referenced by ID (``step 3``).

.. _Docker Desktop: https://www.docker.com/products/docker-desktop/
.. _Nanopolish: https://github.com/jts/nanopolish
.. _Singularity: https://singularity-user-docs.readthedocs.io/en/latest/quick_start.html
.. _singularity container: https://singularity-tutorial.github.io/
.. _Docker container: https://docs.docker.com
.. _Docker Hub: https://hub.docker.com
.. _bedtools: https://bedtools.readthedocs.io/en/latest/
.. _Dockerfile: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
.. _docker: https://docs.docker.com/engine/reference/builder/
.. _Build: https://docs.docker.com/engine/reference/commandline/build/
.. _tag: https://docs.docker.com/engine/reference/commandline/tag/
.. _Run: https://docs.docker.com/engine/reference/commandline/run/
.. _Start: https://docs.docker.com/engine/reference/commandline/start/
.. _Exec: https://docs.docker.com/engine/reference/commandline/exec/
.. _commit: https://docs.docker.com/engine/reference/commandline/commit/
.. _Push: https://docs.docker.com/engine/reference/commandline/push/
.. _contributors: https://docs.docker.com/docker-hub/repos/

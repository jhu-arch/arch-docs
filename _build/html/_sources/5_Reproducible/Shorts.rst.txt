Short Tutorials
===============

They are straight to the point tutorials on Rockfish.

Python virtual environment
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: https://readthedocs.org/projects/python/badge/?version=latest
  :target: https://python.readthedocs.io/en/latest/?badge=latest
  :alt: The Python programming language

Here's an example of how to create a virtual Python environment using the built-in venv module in Python 3:

For more details, see. :ref:`Virtual Environment <virtual-env>`.

1. Connect to Rockfish terminal and navigate to the directory where you want to create the virtual environment.
2. Enter the following command to create a new virtual environment:

.. code-block:: console

  module load python/3.8.6
  python3 -m venv myenv

This will create a new virtual environment named myenv in the current directory.

3. Activate the virtual environment by running the appropriate command for your operating system:

.. code-block:: console

  source myenv/bin/activate

4. Once the virtual environment is activated, you can install any Python packages you need using pip. For example, to install the numpy package, simply run:

.. code-block:: console

  pip install numpy

5. When you're done working in the virtual environment, you can deactivate it by running the following command:

.. code-block:: console

  deactivate

That's it! You've now created a virtual Python environment and installed a package inside it.

Anaconda virtual environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

Here's an example of how to create a new Conda environment using the conda create command:

1. Connect to Rockfish terminal.
2. Enter the following command to create a new Conda environment named myenv:

.. code-block:: console

  module load anaconda
  conda create --name myenv

You can also specify which version of Python you want to use by including the version number after the environment name.
For example, to create a new environment named myenv with Python 3.9, you would enter:

.. code-block:: console

  conda create --name myenv python=3.9

3. Activate the new environment.

.. code-block:: console

  conda activate myenv

4. Once the environment is activated, you can install any Python packages you need using conda or pip. For example, to install the numpy package using conda, you would run:

.. code-block:: console

  conda install numpy

Alternatively, you can use pip to install packages:

.. code-block:: console

  pip install numpy

5. When you're done working in the environment, you can deactivate it by running the following command:

.. code-block:: console

  conda deactivate

That's it! You've now created a new Conda environment and installed a package inside it.

How to use python vend and conda env in slurm script
-----------------------------------------------------

To use a virtual environment created with either venv or conda in a Slurm script, you need to activate the environment before running your Python script.

Here's how to do that:

Using a virtual environment created with venv:

.. code-block:: console

    #!/bin/bash
    #SBATCH --job-name=myjob
    #SBATCH --output=myjob.out
    #SBATCH --error=myjob.err
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=1
    #SBATCH --time=1:00:00
    #SBATCH --partition=your_partition

    # Load any necessary modules or dependencies
    module load some_module

    # Activate the virtual environment
    source /path/to/venv/bin/activate

    # Run your Python script
    python myscript.py

    # Deactivate the virtual environment
    deactivate

Replace /path/to/venv with the path to your virtual environment directory, and myscript.py with the name of your Python script.

Using a virtual environment created with conda:

.. code-block:: console

    #!/bin/bash
    #SBATCH --job-name=myjob
    #SBATCH --output=myjob.out
    #SBATCH --error=myjob.err
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=1
    #SBATCH --time=1:00:00
    #SBATCH --partition=your_partition

    # Load any necessary modules or dependencies
    module load conda
    module load some_module

    # Activate the virtual environment
    conda activate /path/to/env

    # Run your Python script
    python myscript.py

    # Deactivate the virtual environment
    conda deactivate

Replace /path/to/env with the path to your virtual environment directory, and myscript.py with the name of your Python script.

Additionally, make sure to adjust the module load commands for any other modules or dependencies your Python script requires.

.. _conda-forge: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
.. _docs: https://conda.github.io/conda-pack/cli.html
.. _conda-forge2: https://conda-forge.org/
.. _conda-pack: https://conda.github.io/conda-pack/
.. _Anaconda: https://anaconda.org


How to load Rockfish R submodules into an R session or R-Studio environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This tutorial will guide you through the process of loading R submodules in an R session. These procedures also can be easily reproduced in various environments, such as R-Studio, R Script, or Slurm script.

In general, the ``module load`` command is used to load a specific software package or application into the current shell session. This command modifies the system's environment variables, such as ``PATH`` or ``LD_LIBRARY_PATH``, to make the software package available to the user.

.. note::
   `R`_ is an open-source programming language and software environment that is commonly used for statistical computing, data analysis, and visualization. By loading version ``4.0.2`` of ``R`` into the shell session, the user can run R scripts and commands, use R packages, and access other R-related functionality from within the terminal.

For instance, in this specific case, the ``module load`` command is being used to load version 4.0.2 of the R programming language into the current shell session on Rockfish.

Here is an example of how to load a submodule for ``R/4.0.2``:

1. First, you would need to log in to a system where R/4.0.2 is installed and load the R module.

.. code-block:: console

  [userid@local ~]$ module load r/4.0.2

2. Next, you would start an **R session** by typing **R** at the command line. This will open the R command line interface.

3. Once you are in the **R** command line interface, you can use the **library()** function to load the desired submodule. For example, if you wanted to load the **ggplot2** package, which is a popular package for data visualization in R, you would type the following command:

.. code-block:: console

  > library(ggplot2)

This command loads the ``ggplot2`` package into the R session, making its functions and data available for use.

4. After you have finished using the submodule, you can unload it from the R session using the **detach()** function, to remove the ``ggplot2`` package from the R session, freeing up memory and preventing conflicts with other packages.

.. code-block:: console

  > detach("package:ggplot2", unload=TRUE)

Overall, loading submodules in R/4.0.2 is a matter of using the **library()** function to load R packages within the R command line interface. The specific packages and submodules you load will depend on your specific needs and goals.

However, if the ``ggplot2`` package is not installed or not available in the system, you need install it using the **install.packages()** command..

.. code-block:: console

  > install.packages("ggplot2")

This procedures will store the package/library in the user's home directory (**R_LIBS_USER**), and it will be available for use in the R session

Another option is to source the ``lmod.R`` script. This provides additional functionality for managing Rockfish R submodules and loading them into the R session, which will be explained in the next section.

How to load R submodules available in the system in R session
--------------------------------------------------------------

The ``lmod.R`` script helps to load Rockfish R submodules available in the system into the R session.

.. note::
   This script is available in the /data/apps/helpers/ directory on Rockfish. It will change the **R_LIBS_USER** variable in R returning the paths where R looks for installed packages, the same way **module load** do in the terminal. When R searches for a package that has been loaded or installed, it will search in each of the directories listed by **.libPaths()** until it finds the package it is looking for.

Here is an example of how to use the ``lmod.R`` script to load a submodule for ``R/4.0.2``:

1. First, you would need to log into a system where R/4.0.2 is installed and load the R module using the module load command.

.. code-block:: console

  [userid@local ~]$ module load r/4.0.2

2. Next, you would start an `R`_ session by typing **R** at the command line. This will open the R command line interface.

3. Once you are in the **R** command line interface, you can use the **source()** function to load the ``lmod.R`` script. For example:

.. code-block:: console

  > source("/data/apps/helpers/lmod.R")

.. tip::
    You can also use the **source()** function to load the ``lmod.R`` script from a different directory. For example:

    > source("/data/apps/helpers/lmod.R")

     or

    > source(file.path(Sys.getenv("R_LIBS_USER"), "lmod.R"))
    
    The file.path function in base R offers a convenient way to define a file path, Sys.getenv("R_LIBS_USER") returns the path store into R_LIBS_USER variable, and R_LIBS_USER is an environment variable that defines the location of the user's personal R library directory.

4. After you have sourced the ``lmod.R`` script, you can use the **lmod()** function to load the desired submodule. For example, if you wanted to load the **ggplot2** package, which is a popular package for data visualization in R, you would type the following command:

.. code-block:: console

  > module("load", "r/4.0.2")
  > module("load", "r-ggplot2")

The first load command will load the R module making R submodules available to the next command, and the second load command will load the ``ggplot2`` package into the R session, making its functions and data available for use.

5. After you have finished using the submodule, you can unload it from the R session using the **lmod()** function. For example:

.. code-block:: console

  > module("unload", "r-ggplot2")

This command removes the ``ggplot2`` package from the R session, freeing up memory and preventing conflicts with other packages.

Overall, loading submodules in R/4.0.2 is a matter of using the **lmod.R** function to load R packages within the R command line interface. The specific packages and submodules you load will depend on your specific needs and goals.

However, if the ``ggplot2`` package is not installed, you need to install it using the **install.packages()** command. For example:

.. code-block:: console

  > install.packages("ggplot2")

This command will install the ``ggplot2`` package into the R session, making its functions and data available for use.

How to load tidyverse R submodule in R session
------------------------------------------------

.. code-block:: console

  [userid@local ~]$ module load r/4.0.2
  [userid@local ~]$ R

  > module("load", "r-tidyverse")
  > library(tidyverse)

How to load R submodules and install Rsamtools package in R session
---------------------------------------------------------------------

.. code-block:: console

  [userid@local ~]$ module load r/4.0.2
  [userid@local ~]$ R

.. warning::
    The **lmod.R** only works with **r/3.6.3** or **r/4.0.2**.

.. code-block:: console

  > source("/data/apps/helpers/lmod.R")
  > module("load", "r/4.0.2")

.. tip::
    Loading the r/4.0.2 will make R submodules available in the R session.
    **Note**: It won't work if you use a different R version loaded in the terminal. Change the version as needed.

.. code-block:: console

    > module("load","libjpeg")
    > module("load","libpng")
    > module("load","bzip2")
    > module("load","curl")

    > if (!require("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
    > BiocManager::install("Rsamtools",dependencies=TRUE, force=TRUE)

    > library(Rsamtools)


How to load and and list submodule in R session
------------------------------------------------

In this example we will load the **ggplot2** submodule and list all the submodules loaded in the R session, using another R version.

.. code-block:: console

  [userid@local ~]$ module load r/3.6.3
  [userid@local ~]$ R

  > module("load","r-ggplot2/3.2.0")
  > module("list")

  Currently Loaded Modules:
    1) gcc/9.3.0         10) r-lazyeval/0.2.2   19) r-magrittr/1.5      28) r-rcolorbrewer/1.1-2  37) r-ellipsis/0.3.0
    2) openmpi/3.1.6     11) r-mass/7.3-51.5    20) r-stringi/1.4.3     29) r-viridislite/0.3.0   38) r-zeallot/0.1.0
    3) slurm/19.05.7     12) r-lattice/0.20-38  21) r-stringr/1.4.0     30) r-scales/1.0.0        39) r-vctrs/0.2.0
    4) helpers/0.1.1     13) r-matrix/1.2-17    22) r-reshape2/1.4.3    31) r-assertthat/0.2.1    40) r-pillar/1.4.2
    5) git/2.28.0        14) r-nlme/3.1-141     23) r-rlang/0.4.6       32) r-crayon/1.3.4        41) r-pkgconfig/2.0.2
    6) standard/2020.10  15) r-mgcv/1.8-28      24) r-labeling/0.3      33) r-fansi/0.4.0         42) r-tibble/2.1.3
    7) r/3.6.3           16) r-rcpp/1.0.4.6     25) r-colorspace/1.4-1  34) r-cli/2.0.2           43) r-withr/2.2.0
    8) r-digest/0.6.25   17) r-plyr/1.8.4       26) r-munsell/0.5.0     35) r-utf8/1.1.4          44) r-ggplot2/3.2.0
    9) r-gtable/0.3.0    18) r-glue/1.4.1       27) r-r6/2.4.0          36) r-backports/1.1.4
  >

.. tip::
    Also, you can use the **module()** function to list all of the available modules in the current Lmod system.
    For example:

    > module("avail")

    > module("spider","r-")

    > module("list")

    This command lists all of the available modules in the current Lmod system. Running this command can be useful if you are not sure which module you need to load for a particular task.

.. _R: https://www.r-project.org/


How to create a Slurm script 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Slurm scripts are used to submit and manage jobs in a high-performance computing (HPC) environment that uses the Slurm workload manager. Slurm is a popular open-source resource management and job scheduling application used on many HPC clusters and supercomputers. 

A basic example of a Slurm script
---------------------------------

.. code-block:: console

  #!/bin/bash
  #SBATCH --job-name=my_job_name        # Job name
  #SBATCH --output=output.txt           # Standard output file
  #SBATCH --error=error.txt             # Standard error file
  #SBATCH --partition=partition_name    # Partition or queue name
  #SBATCH --nodes=1                     # Number of nodes
  #SBATCH --ntasks-per-node=1           # Number of tasks per node
  #SBATCH --cpus-per-task=1             # Number of CPU cores per task
  #SBATCH --time=1:00:00                # Maximum runtime (D-HH:MM:SS)
  #SBATCH --mail-type=END               # Send email at job completion
  #SBATCH --mail-user=your@email.com    # Email address for notifications

  # Load necessary modules (if needed)
  # module load module_name

  # Your job commands go here
  # For example:
  # python my_script.py

  # Optionally, you can include cleanup commands here (e.g., after the job finishes)
  # For example:
  # rm some_temp_file.txt

Here's an explanation of the key Slurm directives in the script:

* **#SBATCH** These lines are comments in a Slurm script and specify various options for the job.
* **--job-name** A name for your job.
* **--output** and **--error:** The paths to the standard output and error log files.
* **--partition:** The name of the Slurm partition or queue where the job should run.
* **--nodes:** The number of nodes needed for the job.
* **--ntasks-per-node:** The number of tasks per node or processes to run.
* **--cpus-per-task:** The number of CPU cores allocated to each task.
* **--time:** The maximum runtime for the job.
* **--mail-type** and **--mail-user:** Email notification settings.

.. note::
  Please avoid to use ``--ntasks`` on Rockfish also, no need to set ``--mem``. It will automatically set to the number of cores, 4GB per core.

After the ``#SBATCH`` directives, you can load any necessary modules or execute your job's commands. In the example, it's assumed that you will run a Python script named ``my_script.py``. You can replace this with your specific job commands.

To submit a Slurm job, you can save the script to a file (e.g., ``my_job.slurm``) and then use the ``sbatch`` command to submit the job:

.. code-block:: console

  [userid@local ~]$ sbatch my_job.slurm

.. note::
  The provided script is a Slurm job script written in Bash for submitting a job array to a Slurm cluster. Here's a breakdown of the script:

How to run a matlab job array
-----------------------------

.. code-block:: console

  #!/bin/bash -l
  #SBATCH --job-name=job-array2        # Job name
  #SBATCH --time=1:1:0                 # Maximum runtime (D-HH:MM:SS)
  #SBATCH --array=1-20                 # Defines a job array from task ID 1 to 20
  #SBATCH --ntasks-per-node=1          # Number of tasks (in this case, one task per array element)
  #SBATCH -p defq                      # Partition or queue name
  #SBATCH --reservation=Training       # Reservation name
  #SBATCH                              # This is an empty line to separate Slurm directives from the job commands

  # run your job

  echo "Start Job $SLURM_ARRAY_TASK_ID on $HOSTNAME"  # Display job start information

  sleep 10  # Sleep for 10 seconds

  export alpha=1  # Set an environment variable alpha to 1
  export beta=2   # Set an environment variable beta to 2

  module load matlab  # Load the Matlab module

  matlab -nodisplay -singleCompThread -r "myRand($SLURM_ARRAY_TASK_ID, $alpha, $beta), pause(20), exit"
  # Run a Matlab script with parameters: $SLURM_ARRAY_TASK_ID, $alpha, and $beta, and then exit

This script is designed to run a job array, where a job is executed 20 times with different values of ``$SLURM_ARRAY_TASK_ID``, which ranges from 1 to 20.

Here's what the script does:

  * The script specifies Slurm directives at the beginning of the file. These directives provide instructions to the Slurm scheduler for managing the job array, such as the job name, maximum runtime, array definition, number of tasks, partition, and reservation.
  * After the Slurm directives, the script contains actual job commands. It starts by echoing a message indicating the start of the job with the current task ID and the hostname where the job is running.
  * It then ``sleeps`` for 10 seconds using the sleep command.
  * Two environment variables, ``alpha`` and ``beta``, are exported with values 1 and 2, respectively.
  * The Matlab module is loaded with the ``module load`` command.
  * Finally, Matlab is invoked with the specified parameters using the ``-r`` flag. The ``myRand`` Matlab function is called with the current ``$SLURM_ARRAY_TASK_ID``, ``$alpha``, and ``$beta``. It also includes a pause(20) to pause execution for 20 seconds and then exits.

To submit this job array script to the Slurm scheduler, save it to a file (e.g., ``job_array_script.sh``) and then submit it using the ``sbatch`` command:

.. code-block:: console

  [userid@local ~]$ sbatch job_array_script.sh

.. note::
  The scheduler will take care of running the job array with the specified parameters.

How to run job array task with a step size
-------------------------------------------

When using **#SBATCH --array=1-100%10**, it defines a job array where the task IDs range from 1 to 100, and each job array element runs every 10 task IDs. This means that you will have a total of 10 job instances, each running a subset of the task IDs from 1 to 100. Here's an example script using this array configuration:

.. code-block:: console

  #!/bin/bash -l
  #SBATCH --job-name=job-array-example
  #SBATCH --time=1:0:0
  #SBATCH --array=1-100%10  # Job array from task ID 1 to 100, with a step size of 10
  #SBATCH --ntasks-per-node=1
  #SBATCH --partition=defq
  #SBATCH --mail-type=end
  #SBATCH --mail-user=userid@jhu.edu
  #SBATCH --reservation=Training

  ml intel/2022.2

  # Your executable or script goes here
  # Example: Running a Python script
  # python my_script.py $SLURM_ARRAY_TASK_ID

  # In this example, each job instance will execute the script with a different SLURM_ARRAY_TASK_ID.

In this script:

  * ``#SBATCH --array=1-100%10`` defines a job array with task IDs ranging from 1 to 100, where each job instance will run a subset of 10 consecutive task IDs. So, you'll have 10 job instances with ``SLURM_ARRAY_TASK_ID`` values like 1, 11, 21, ..., 91.
  * The ``ml intel/2022.2`` line loads the Intel compiler module, which can be used for compilation if your job requires it.
  * The actual job commands, such as running an executable or script, should be placed below the comments. In this example, I've left a placeholder comment indicating how you might run a Python script with the ``SLURM_ARRAY_TASK_ID``. You should replace it with the actual commands or scripts you want to execute for your job.

To submit this job array to the Slurm scheduler, save it to a file (e.g., ``job_array_example.sh``) and then submit it using the sbatch command:

.. code-block:: console

  [userid@local ~]$ sbatch job_array_example.sh

.. note::
  The scheduler will create 10 job instances, each running a subset of task IDs according to the specified array configuration.

How to run an MPI (Message Passing Interface) program
-----------------------------------------------------

To perform a Slurm script for running an MPI (Message Passing Interface) program on a high-performance computing (HPC) Rockfish Cluster. 

Here's a breakdown of the script:

.. code-block:: console

  #!/bin/bash -l
  #SBATCH --job-name=mpi-job          # Job name
  #SBATCH --time=10:00:00             # Maximum runtime (1 hour)
  #SBATCH --nodes=1                   # Number of nodes requested
  #SBATCH --ntasks-per-node=4         # Number of MPI tasks per node
  #SBATCH --partition=defq            # Partition or queue name
  #SBATCH --mail-type=end             # Email notification type (end of job)
  #SBATCH --mail-user=userid@jhu.edu  # Email address for notifications
  #SBATCH --reservation=Training      # Reservation name

  ml intel/2022.2  # Load the Intel compiler module with version 2022.2

  # compile
  mpiicc -o hello-mpi.x hello-mpi.c  # Compile the MPI program from source code

  mpirun -np 4 ./hello-mpi.x > my-mpi.log  # Run the MPI program with 4 MPI processes, redirecting output to a log file

Here's what the script does:

1. It specifies various Slurm directives at the beginning of the script. These directives provide instructions to the Slurm scheduler for managing the MPI job:

* **--job-name** Specifies a name for the job.
* **--time** Sets the maximum runtime for the job to 1 hour.
* **--nodes** Requests 1 compute node for the job.
* **--ntasks-per-node** Specifies that there will be 4 MPI tasks per node.
* **--partition** Specifies the Slurm partition or queue where the job should run (in this case, ``defq``).
* **--mail-type** Requests email notifications at the end of the job.
* **--mail-user** Specifies the email address where notifications will be sent.
* **--reservation** Associates the job with a reservation named "Training."

2. The script loads the Intel compiler module with version 2022.2 using the ``ml`` command. This is done to ensure that the correct compiler environment is set up for compilation.
3. It compiles the MPI program named ``hello-mpi.c`` using the ``mpiicc`` compiler and generates an executable named "hello-mpi.x."
4. Finally, it runs the MPI program using the mpirun command with 4 MPI processes. The standard output of the program is redirected to a log file named ``my-mpi.log``.

To submit this MPI job to the Slurm scheduler, save it to a file (e.g., ``mpi_job_script.sh``) and then submit it using the sbatch command:

.. code-block:: console

  [userid@local ~]$ sbatch mpi_job_script.sh

.. note::
  The scheduler will allocate resources and run the MPI program with the specified parameters.

How to run a mixed MPI/OpenMP program
-------------------------------------

To submit a Slurm job script for running a mixed MPI/OpenMP program on a high-performance computing (HPC) cluster. This script combines both message-passing parallelism (MPI) and shared-memory parallelism (OpenMP). Here's a breakdown of the script:

.. code-block:: console

  #!/bin/bash -l
  #SBATCH --job-name=omp-job          # Job name
  #SBATCH --time=1:0:0                # Maximum runtime (1 hour)
  #SBATCH --nodes=2                   # Number of nodes requested
  #SBATCH --ntasks-per-node=1         # Number of MPI tasks per node
  #SBATCH --cpus-per-task=4           # Number of CPU cores per task
  #SBATCH --partition=defq            # Partition or queue name
  #SBATCH --mail-type=end             # Email notification type (end of job)
  #SBATCH --mail-user=$USER@jhu.edu   # Email address for notifications (using the user's environment variable)
  #SBATCH --reservation=Training      # Reservation name

  ml intel/2022.2  # Load the Intel compiler module with version 2022.2

  # Compile the code using Intel and mix MPI/OpenMP
  echo "mpiicc -qopenmp -o hello-mix.x hello-world-mix.c"

  # How to compile
  # mpiicc -qopenmp -o hello-mix.x hello-world-mix.c

  # Run the code
  mpirun -np 2 ./hello-mix.x  # Run the mixed MPI/OpenMP program with 2 MPI processes

Here's what the script does:

1. The script specifies various Slurm directives at the beginning of the script. These directives provide instructions to the Slurm scheduler for managing the mixed MPI/OpenMP job:

* **--job-name** Specifies a name for the job.
* **--time** Sets the maximum runtime for the job to 1 hour.
* **--nodes** Requests 2 compute nodes for the job.
* **--ntasks-per-node** Specifies that there will be 1 MPI task per node.
* **--cpus-per-task** Specifies that each MPI task will use 4 CPU cores.
* **--partition** Specifies the Slurm partition or queue where the job should run (in this case, "defq").
* **--mail-type** Requests email notifications at the end of the job.
* **--mail-user** Uses the ``$USER`` environment variable to specify the email address where notifications will be sent. This assumes that the user's email is in the format ``username@jhu.edu``.
* **--reservation** Associates the job with a reservation named ``Training``.

2. The script loads the Intel compiler module with version 2022.2 using the ``ml`` command. This is done to ensure that the correct compiler environment is set up for compilation.
3. It echoes the compilation command that will be used (``mpiicc -qopenmp -o hello-mix.x hello-world-mix.c``). This is commented out because it's not actually compiling the code in the script, but you can uncomment it and run it outside the script.
4. Finally, it runs the mixed MPI/OpenMP program using the ``mpirun`` command with 2 MPI processes. The program is expected to use OpenMP for shared-memory parallelism.

To submit this mixed MPI/OpenMP job to the Slurm scheduler, save it to a file (e.g., ``mpi_omp_job_script.sh``) and then submit it using the sbatch command:


.. code-block:: console

  [userid@local ~]$ sbatch mpi_omp_job_script.sh

.. note::
  The scheduler will allocate resources and run the mixed MPI/OpenMP program with the specified parameters.
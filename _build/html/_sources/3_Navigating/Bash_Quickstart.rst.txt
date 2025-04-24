Bash Quick Start
################

This page introduces core Bash configuration practices to help Rockfish users customize their environment effectively. You'll learn how to manage startup files, use aliases, extend your `PATH`, and improve your shell productivity with built-in tools.

Understanding Bash Startup Files
********************************

When you connect to Rockfish, your shell session is initialized based on whether it's a **login** or **interactive** shell:

- **Login shells** (like SSH): Bash looks for and loads the first of these files: `~/.bash_profile`, `~/.bash_login`, or `~/.profile`.
- **Interactive non-login shells** (like opening a terminal or launching `bash`): Bash loads `~/.bashrc`.

To ensure consistent behavior across environments, your `.bash_profile` should source `.bashrc`. This is already set by default for Rockfish users:

.. code-block:: bash

   if [ -f ~/.bashrc ]; then
       source ~/.bashrc
   fi

Because `.bashrc` is sourced in every interactive shell, place all your personal configurations there — aliases, environment variables, `$PATH`, and module loads.


Protecting Your $PATH
**********************

When adding directories to your `PATH`, avoid doing so repeatedly in nested shells by using a guard variable:

.. code-block:: bash

   if [ -z "$ROCKFISH_ENV" ]; then
       export ROCKFISH_ENV=1
       export PATH="$HOME/bin:$PATH"
   fi

This ensures your custom paths are added only once per session.

Aliases: Quick Commands
************************

**Aliases** are shorthand for longer commands, helping you work more efficiently. For example:

.. code-block:: bash

   alias ll='ls -lFh'
   alias usage='quotas.py'
   alias la='ls -a'
   alias gpustat='nvidia-smi'

To make these available every time you log in, define them in your `~/.bashrc`.

Helpful Customizations
**********************

Other useful customizations — like loading modules or setting environment variables — should also go in `~/.bashrc`. For example:

.. code-block:: bash
   
   module load intel/2020.2
   module load gcc/11.2.0

   export EDITOR=vim
   export PROJECT_SCRIPTS=$HOME/projects/scripts
   
Example `.bashrc` Template
***************************

.. code-block:: bash

   # Source system-wide defaults
   if [ -f /etc/bashrc ]; then
       . /etc/bashrc
   fi

   # Prevent re-initializing environment on every subshell
   if [ -z "$ROCKFISH_ENV" ]; then
       export ROCKFISH_ENV=1

       # Extend PATH for custom scripts
       export PATH="$HOME/bin:$PATH"

       # Load frequently used modules
       module load module_xyz

       # Set environment variables
       export EDITOR=vim
       export PROJECT_SCRIPTS=$HOME/projects/scripts

       # Define helpful aliases
       alias ll='ls -lFh'
       alias la='ls -a'
       alias gpustat='nvidia-smi'
       alias usage='quotas.py'
   fi

Useful Bash Tricks for HPC Users
================================

History Expansion and Reuse
---------------------------

- **Repeat the last command:**

  .. code-block:: bash

     !!


- **Search your command history:**

  .. code-block:: bash

     history | grep slurm

Timing and Logging
------------------

- **Measure how long a command takes:**

  .. code-block:: bash

     time ./my_script.sh


- **Redirect standard output and error to a single file:**

  .. code-block:: bash

     ./script.sh > script.out 2>&1

- **Append to an existing output log:**

  .. code-block:: bash

     ./script.sh >> script.out 2>&1

Navigation and Shortcuts
------------------------

- **Make a directory and immediately `cd` into it:**

  .. code-block:: bash

     mkdir -p ~/project/output && cd $_

- **Use brace expansion to make multiple folders:**

  .. code-block:: bash

     mkdir scratch/{day1,day2,day3}

- **Create a quick backup of a file:**

  .. code-block:: bash

     cp script.sh{,.bak}

Monitoring and Usage
--------------------

- **Check your running processes:**

  .. code-block:: bash

     top -u $USER

- **Watch GPU usage in real time:**

  .. code-block:: bash

     watch -n 2 nvidia-smi

- **Show job efficiency stats (Slurm):**

  .. code-block:: bash

     seff <jobid>
     reportseff <jobid>
     jobstats <jobid>

File Inspection
---------------

- **Preview the top or bottom of a file:**

  .. code-block:: bash

     head -n 20 logfile.txt
     tail -n 20 logfile.txt

- **Follow a growing log file in real time:**

  .. code-block:: bash

     tail -f logfile.txt


Testing Your Configuration
**************************

To apply changes without logging out:

- Use `source ~/.bashrc` in an active terminal
- Open a second terminal to test changes independently

Copy Default Bash Files
************************

If you don’t have a `.bashrc` or `.profile`, you can copy the cluster defaults from:

.. code-block:: bash

   cp /etc/skel/.bashrc ~/.bashrc
   cp /etc/skel/.profile ~/.profile

Customize these as needed with your preferred modules, aliases, and paths.

Troubleshooting
***************

**Q: Why isn’t my `.profile` being read?**  
Bash loads the first available of the following: `.bash_profile`, `.bash_login`, or `.profile`. Use only one, and ensure it sources `.bashrc`.

**Q: Why is my `$PATH` getting longer and longer?**  
You're likely appending to it every time `.bashrc` is sourced. Use a guard variable like `ROCKFISH_ENV` to prevent that.

Further Resources
******************

- `Bash Reference Manual <https://www.gnu.org/software/bash/manual/>`_
- `TLDP Bash Guide <https://tldp.org/LDP/Bash-Beginners-Guide/html/>`_
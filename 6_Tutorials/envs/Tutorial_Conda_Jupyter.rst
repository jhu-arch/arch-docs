Link Conda to Jupyter
#####################

This guide explains how to link your **Conda environment** — whether it's Python or R — to **JupyterLab** on Rockfish.

Connect to Rockfish
*******************

Open a terminal and connect:

.. code-block:: bash

   ssh YourUserID@login.rockfish.jhu.edu

Start an Interactive Session (Compute Node)
*******************************************

.. code-block:: bash

   interact -p shared -n 4 -t 02:00:00

Load Anaconda and Activate Your Environment
*******************************************

.. code-block:: bash

   module load anaconda3/2024.02-1
   conda activate my_env

Replace ``my_env`` with the name of your Conda environment.

Install and Register the Jupyter Kernel
***************************************

For Python
==========

.. code-block:: bash

   # Install ipykernel (if not installed)
   pip install ipykernel

   # Register kernel
   ipython kernel install --user --name=my_env --display-name "Python - my_env"

For R
=====

.. code-block:: bash

   R

Inside the R prompt:

.. code-block:: r

   # Install the IRkernel package (if not installed)
   install.packages("IRkernel")

   # Register the kernel
   IRkernel::installspec(name = "my_env", displayname = "R - my_env")

   # Exit R
   q()

.. note::

   💡 **Explanation:**  
   - ``--name`` / ``name``: Internal identifier used by Jupyter (no spaces or dots).  
   - ``--display-name`` / ``displayname``: Friendly name that appears in the JupyterLab interface.

Confirm Kernel Registration
***************************

.. code-block:: bash

   jupyter kernelspec list

You should see your environment listed (e.g., ``my_env``).

Deactivate the Environment
**************************

.. code-block:: bash

   conda deactivate

Exit the Compute Node
*********************

.. code-block:: bash

   exit

You're All Set!
***************

The next time you launch **JupyterLab** on Rockfish, your kernel(s) will be available as options:

- ➡️ **Python - my_env**
- ➡️ **R - my_env**

Just select the one you need and start coding!
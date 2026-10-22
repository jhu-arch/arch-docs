:orphan:

Open OnDemand
=============

Open OnDemand (`OOD <https://www.openondemand.org/>`_) is an NSF-funded open-source HPC portal. It is a way for all our users to
access the Rockfish cluster HPC resources via a web interface. It is a web-portal that provides a
shell, file browser, and graphical interface for applications such as Matlab, ParaView,
Jupyter and RStudio Server, etc.

.. contents::
   :local:
   :depth: 2



.. dropdown:: Accessing the Open OnDemand Portal

   To access the Open OnDemand portal interface:
   
   #. Navigate to the Skipjack portal at https://portal.arch.jhu.edu.
   
   #. Select the OOD (Open OnDemand) icon in the bottom left.
   
      .. image:: images/ood-from-portal-icon.png
   
      .. note::
   
         You may need to re-authenticate.
   
   #. Arrive at the Open OnDemand landing page.
   
      .. image:: images/ood-portal-landing.png

.. dropdown:: Available Open OnDemand Applications

   Open OnDemand has several applications available:
   
   
   ============== ========================================================================
   Application    Description
   ============== ========================================================================
   Jupyter        Web-based interactive computing environment for code and data.
   MATLAB         High-performance numerical computing and data visualization environment.
   RStudio        Integrated development environment for the R programming language.
   Total View     Advanced parallel debugger for high-performance computing.
   VSCode Server  Enables remote development inside Visual Studio Code.
   ============== ========================================================================
   
   
   Open OnDemand also provides other desktop features
   
   ===================== ========================================================================
   Feature               Description
   ===================== ========================================================================
   Active Jobs           Monitor and manage running Slurm cluster jobs.
   Desktop               Interactive graphical desktop session inside a web browser.
   Job Composer          Create, edit, and submit cluster job scripts.
   Job Stats             Visualize performance metrics for active or completed jobs.
   Module Browser        Search and manage loaded environment modules.
   Project Manager       Organize files and workflows into dedicated project directories.
   Skipjack Shell Access Open a command-line terminal session on Skipjack nodes.
   System Status         View current cluster node availability and load.
   ===================== ========================================================================
   

   Interactive Apps can be accessed from the drop-down menu.
   
   .. image:: images/ood-interactive-apps-dropdown.png
   
   
   |
   
   Additionally, the grid icon displays all available apps and features.
   
   
   - Click the grid icon in the navigation bar.
   
     .. image:: images/ood-all-apps-icon.png
   
   - A table will all available apps and features is displayed.
   
     .. image:: images/ood-all-apps-page.png
   


.. dropdown:: Launching an Interactive Session

   Launching an Interactive Session creates a job in the Slurm job scheduler on the Skipjack cluster.
   Therefore, the same parameters for launching jobs from the cluster need to be selected in the
   portal.
   
   .. image:: images/ood-jupyter-job-setup.png
   
   
   Specify each option, and click **Launch** at the bottom.
   
   This will submit a job for your
   interactive session to the queue. When the status of your session changes to **Running**
   click **Launch Desktop** to start the desktop interface.

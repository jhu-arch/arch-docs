
Skipjack Quick Start
====================

.. contents::
   :local:
   :depth: 2


----

Account Setup & SSH Connection
##############################


.. dropdown:: 1. Identify Your User Category

   Your onboarding path depends on whether you have a **Johns Hopkins Enterprise Directory (JHED) ID**.

   - **JHU users (with JHED ID):** Log in to the
     `ARCH Portal <https://portal.arch.jhu.edu>`_ using your JHED
     credentials and Hopkins Single Sign-On (SSO).
    
   - **External and class-use users (without JHED ID):** Log in to the
     `ARCH Portal <https://portal.arch.jhu.edu>`_ using the credentials
     assigned to your user tier.
    
   - **Schmidt Sciences users:** Contact Schmidt Sciences directly
     rather than using the standard self-service process.


.. dropdown:: 2. Set Up Two-Factor Authentication (2FA) [non-JHED users only]

   Users logging in with local credentials (non-JHED) must configure an OTP authenticator before connecting over SSH:

     #. Go to the ARCH Portal and select your user icon, then **My Profile**.
  
     #. Under **Two-Factor Auth (2FA)**, click **Set up 2FA**, then
        **Set up Authenticator application**.
  
     #. Scan the QR code using Google Authenticator, Microsoft
        Authenticator, or FreeOTP.
  
     #. Enter the six-digit confirmation code to complete setup.

 

.. dropdown:: 3. Gain Cluster Access

   Creating or logging into an account registers you in the ARCH system,
   but does not automatically grant cluster access.

   - **Users:** Your PI, manager, or course instructor must add you to
     an active project allocation.

   - **PIs:** After creating your account, log in to the ARCH Portal
     and submit an account elevation request under
     **My Profile → PI Status → Upgrade Account**.



.. dropdown:: 4. Connect to Skipjack via SSH

   #. Open a terminal. macOS and Linux include terminal applications;
      Windows users can use OpenSSH or PuTTY.

   #. Connect using the appropriate login host.

      - **JHED ID and external users:**

        .. code-block:: bash

           ssh <your-username>@login.arch.jhu.edu

      - **Schmidt Sciences users:**

        .. code-block:: bash

           ssh <your-username>@login.schmidtsciences.jhu.edu

   #. On the first connection, type ``yes`` if prompted to trust the host.

   #. Enter your cluster password and, when prompted, the six-digit
      OTP code if required.

|
|

----

PI Quickstart — Project & Resource Setup on Skipjack
####################################################

All PI setup tasks below begin by logging in to the
`Skipjack Portal <https://portal.arch.jhu.edu/>`_ using your PI credentials.



.. dropdown:: 1. Create a Cost Center

   Before requesting funding allocations or billable cluster services,
   register your billing account.

     **1.** In the navigation sidebar, go to **Billing → Cost Centers**.
  
     **2.** Click **Add Cost Center** or **New Cost Center**.
  
     **3.** Enter the required JHU billing details, including the Internal Order or Cost Center number, approver, and departmental contact.
  
     **4.** Submit the request.


.. dropdown:: 2. Create a New Project
              
     **1.** In the sidebar, navigate to **Projects** -> click **Create Project**.
 
     **2.** Complete the project metadata fields:
 
       - **Title / Abbreviation:** A descriptive label and unique short name (used for Slurm account tags and filesystem groups).

       - **Primary IO Number / Cost Center:** Select a Cost Center entered in step #1 above.

       - **Affiliation / Department:** Research classification category.

       - **Description:** Summary of research scope and computational objectives (150+ words).
 
     **3.** Submit the request for provisioning.



.. dropdown:: 3. Add Users & Assign PI Proxy Managers

   Collaborators and students cannot run jobs or access shared project data until added:
   
     **1.** Open your project dashboard and scroll down to the **Users** field.
   
     **2.** Click **Add User** and search by **JHED ID** or **username**.
   
     **3.** **Assign Roles:**
   
       - **User:** Standard user access; can run Slurm jobs charged to the project account and access shared directories.
       - **Manager (PI Proxy):** Grants elevated administrative authority to a trusted lab member to approve
          member additions, and manage project resources on your behalf.


.. dropdown:: 4. Request Resource Allocations (Compute)

   Active allocations are required for members to submit Slurm batch jobs:
   
     **1.** Inside your project dashboard, scroll down to the **Allocations** section -> click **Request Resource Allocation**.

     **2.** Specify the requested quantity, brief justification, users and funding source.

     **3.** Submit the request for ARCH review and provisioning.


.. dropdown:: 5. Request Storage

   Provision dedicated high-performance project storage for shared datasets:
   
     **1.** Within your project dashboard, scroll down to the **Project Storage** section.

     **2.** Click **Request Storage Allocation**.

     **3.** Specify the target capacity in whole Terabytes (TB) for Project Storage (Total capacity) and Cache (Flash storage portion for frequently accessed data).

     **4.** Once approved, the dedicated group directory will be mounted and permissions linked to your project user group.

|
|

----

For detailed instructions, please see the :ref:`skipjack user guide`.

For help, please contact `arch@jh.edu <mailto:arch@jh.edu>`_.


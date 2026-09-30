Skipjack Quick Start
====================

Account Setup & SSH Connection
##############################

Your onboarding path depends on whether you have a **Johns Hopkins Enterprise Directory** (**JHED**) **ID**.

1. Identify Your User Category
------------------------------

   - JHU Users (with **JHED ID**): Log in to the `ARCH Portal <https://portal.arch.jhu.edu>`_ directly using your JHED Login ID
     credentials and Hopkins Single Sign-On (SSO).

   - External & Class-Use Users (without JHED ID): Log in via a Local Account on the `ARCH Portal <https://portal.arch.jhu.edu>`_
     using the credentials assigned to your user tier.

   - Note: Schmidt Sciences users do not use standard self-service and should contact Schmidt Sciences directly.


2. Set Up 2-Factor Authentication (2FA) [non-JHED users only]
-------------------------------------------------------------

   - Users logging in with local credentials (non-JHED) must configure an OTP authenticator before
     connecting over SSH:

     #. Go to the ARCH Portal --> click your user icon --> My Profile.

     #. Under Two-Factor Auth (2FA), click Set up 2FA, then Set up Authenticator application.

     #. Scan the QR barcode with Google Authenticator, Microsoft Authenticator, or FreeOTP, then enter the 6-digit confirmation code.


3. Gain Cluster Access
----------------------

   - Creating/logging into an account registers you in the ARCH system, but active cluster access
     requires that your Principal Investigator (PI), Manager, or Course Instructor add you to a
     project allocation.

   - PIs: After you have created your account, log in to Portal and submit an account elevation request
     (My Profile --> PI Status -> Select Upgrade Account).


4. How to SSH into Skipjack
---------------------------

  #. Open your terminal (macOS/Linux have built-in terminals; Windows users can use OpenSSH or PuTTY).

  #. Connect to the login node matching your user group:

     - **JHED ID** & External Users:

       .. code-block:: sh

          ssh <your-username>@login.arch.jhu.edu

     - Schmidt Sciences Users:

       .. code-block:: sh

          ssh <your-username>@login.schmidtsciences.jhu.edu

  #. First-time connection

     - Type ``yes`` at the host-ley prompt to trust the server.

  #. Authentication

     - Enter your **JHED ID**/Skipjack cluster password.

     - Enter the 6-digit code from your OTP authenticator app when prompted.

|
|

----


PI Quickstart  — Project & Resource Setup on Skipjack
#####################################################

All the actions below are initiated by first logging into  the `Skipjack Portal <https://portal.arch.jhu.edu/>`_ with your PI credentials.

1. Create a Cost Center
-----------------------

Before funding allocations or billable cluster services, register your billing account:

  #. In the navigation sidebar, go to **Billing** -> **Cost Centers**.

  #. Click **Add Cost Center** (or **New Cost Center**).

  #. Enter the required JHU billing details (Internal Order / Cost Center number, approver, and departmental contact)
     and submit.

2. Create a New Project
-----------------------

  #. In the sidebar, navigate to **Projects** -> click **Create Project**.

  #. Complete the project metadata fields:

     - **Title & Project Name/Code:** A descriptive label and unique short name (used for Slurm account tags and filesystem groups).
     - **Field of Science / Discipline:** Research classification category.
     - **Project Abstract:** Summary of research scope and computational objectives (150+ words).
     - **Associated Cost Center:** Select the Cost Center created in Step 1.

  #. Submit the request for provisioning.

3. Add Users & Assign PI Proxy Managers
---------------------------------------

Collaborators and students cannot run jobs or access shared project data until added:

  #. Open your project dashboard and scroll down to the **Users** field.

  #. Click **Add User** and search by **JHED ID** or **username**.

  #. **Assign Roles:**

     - **User:** Standard user access; can run Slurm jobs charged to the project account and access shared directories.
     - **Manager (PI Proxy):** Grants elevated administrative authority to a trusted lab member to approve
       member additions, and manage project resources on your behalf.

4 Request Resource Allocations (Compute)
-----------------------------------------

Active allocations are required for members to submit Slurm batch jobs:

  #. Inside your project, navigate to the **Allocations** tab -> click **Request Allocation**.
  #. Specify the requested quantity, and funding source.
  #. Submit the request for ARCH review and provisioning.

5. Request Storage
------------------

Provision dedicated high-performance project storage for shared datasets:

  #. Within your project dashboard, navigate to the **Storage** tab.
  #. Click **Request Storage Allocation**.
  #. Specify the target capacity in whole Terabytes (TB) for Project Storage (Total capacity) and Cache (Flash memory for frequently accessed data).
  #. Once approved, the dedicated group directory will be mounted and permissions linked to your project user group.


|
|

----


For detailed instructions, please see the :ref:`skipjack user guide`.

For help, please contact `arch@jh.edu <mailto:arch@jh.edu>`_.

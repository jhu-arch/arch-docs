Allocation and Account Management
#################################

Rockfish is accessible only to users and research groups with an approved allocation or user account.

Allocations and user accounts are managed through the `Coldfront Portal`_. All users—whether internal or external—must request access through this system.

.. note::
    All users should review the :doc:`Rockfish Citizen guidelines <../1_About_ARCH/RF_Citizen>` before requesting an allocation or account.

Requesting an Allocation
************************

Johns Hopkins Principal Investigators (PIs) may request projects and resource allocations using the `Coldfront Portal`_. Once an allocation is approved, users may request accounts. PIs or their designated proxies are responsible for adding users to the appropriate allocations once it is created.

A video walkthrough is available here: `Portal Navigation`_

Key features of the portal include:

- Requesting new projects and allocations (PIs)
- Managing users and adding them to allocations
- Uploading publications, grants, and ROI reports
- Assigning proxy account managers
- Monitoring usage across groups and allocations

.. warning::
   Allocations are reset quarterly under a "use it or lose it" model. Unused core-hours do not carry over.

Requesting User Accounts
************************

Non-PI users can request accounts through the Rockfish `Coldfront Portal`_. However, user accounts will only be activated after the user has been added to an existing project by a PI with an approved allocation on the Rockfish Cluster.

- All Johns Hopkins users **must use their JHED ID** (e.g., `jsmith123`) when requesting an account.  
  Failure to use your JHED ID may delay account approval and **will prevent access to Globus**, which requires JHED-based authentication.

User accounts can be requested at any time, and the portal also allows users to:

- Submit requests for user accounts
- Reset account passwords
- Monitor utilization and core-hour usage
- View current allocations and associated projects
- Add users (if PI or proxy)

.. note::
   By requesting an account on Rockfish, you are automatically subscribed to the **Rockfish Users mailing list**:  
   `rockfishusers@lists.jh.edu`.  
   This list is used to distribute **important cluster announcements, including scheduled maintenance, outages, and policy updates**.

   **Unsubscribing from this mailing list will result in account deactivation**, as it is the primary channel for operational communication.

Storage Allocations
*******************

Rockfish provides multiple file systems, each with different purposes and default quotas:

.. list-table:: Default Storage Quotas
   :widths: 25 20 35
   :header-rows: 1

   * - File System
     - Default Quota
     - Description
   * - /home/<userid>
     - 50 GB
     - Personal files and small software packages
   * - /data/<PI-userid>
     - 10 TB
     - Group-level storage for long-term project data
   * - /scratch4/<PI-userid>
     - 1 TB
     - Short-term scratch space for active jobs
   * - /scratch16/<PI-userid>
     - By request
     - Scratch space for large files

➡️ For more details on performance, usage policies, and file retention, see the `Filesystem Overview <Filesystems.html>`__.

Allocation Types
****************

Rockfish supports several types of allocations:

- **Standard Allocations:** Available to all JHU PIs.
- **MRI-Related Allocations:** Persist through Rockfish's lifespan (until end of 2026).
- **Dean's Condo Allocations:** Startup allocations provided by Dean's Offices for new faculty.
- **Condo Contributions:** PIs contributing hardware receive allocations proportional to contributed resources.

External and Collaborative Access
*********************************

ARCH supports interdisciplinary collaboration and allows Principal Investigators (PIs) to sponsor external users by issuing “ext-userid” accounts. These accounts are used to manage and identify non-JHU collaborators within the system.

- **External Collaborators:**  
  External users should submit account requests through the `Coldfront Portal`_, using a username **prepended with `ext-`** (e.g., `ext-jdoe`).  
  Please note that **external users will not have access to Globus** under any circumstances due to authentication restrictions.


.. _Coldfront Portal: https://coldfront.rockfish.jhu.edu/
.. _Portal Navigation: https://www.youtube.com/watch?v=L6zvLBK5Mss

Password Management
*******************

Resetting Your Rockfish Password
================================

If you forget your password or need to reset it, visit the `Coldfront Portal`_ and use the **Reset Password** option. You’ll need to enter the email address associated with your account. A secure link will be emailed to you to complete the reset process.

Password Requirements
=====================

Your Rockfish password must:

- Be at least eight characters long
- Contain characters from **at least three** of the following categories:
  - Lower-case letters
  - Upper-case letters
  - Digits
  - Special characters (excluding `'` and `"`)
- Be different from your **last three passwords**
- Remain private — your password must **never be shared**

.. note::
   Users are **strongly encouraged** to reset their password at least once per year.

.. _Coldfront Portal: https://coldfront.rockfish.jhu.edu/
.. _Portal Navigation: https://www.youtube.com/watch?v=L6zvLBK5Mss
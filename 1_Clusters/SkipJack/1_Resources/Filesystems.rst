######################
Filesystems on SkipJack
######################

SkipJack uses a combination of high-performance and research-tier file systems to support a wide range of workloads. Most storage is backed by **TODO**: Add filesystem backend type(s), with additional storage from **TODO**: Add any secondary storage providers for eligible researchers.

Storage on SkipJack is intended solely for research and educational purposes. Users are expected to manage their data responsibly, and storage quotas are enforced per group.

General Guidelines
******************

- **Data stored on ARCH-managed filesystems is not backed up by default.**
- Users are responsible for maintaining their own backups or purchasing backup services.
- Storage increases are granted on a case-by-case basis, based on need and system capacity.
- ARCH reserves the right to delete or move data as necessary to maintain system stability.
- Temporary storage for large projects is available - please contact ARCH staff.

.. important::
  **TODO**: Add any data policy specifics (e.g., HIPAA/PHI/CUI restrictions, IRB guidance)


Filesystems at a Glance
***********************

.. list-table:: 
   :header-rows: 1
   :widths: 18 15 12 12 15

   * - File System
     - System Type
     - Total Size
     - Default Quota
     - Backed Up?
   * - **TODO**: Add filesystem rows with path, type, size, quota, backup status


Local Scratch
=============

**TODO**: Describe local scratch/NVMe per node (if applicable) - mount point, size, use case, cleanup expectations.

/home/
=======

**TODO**: Describe /home filesystem - backend type, default quota, intended use

.. warning::
   `/home/` is **not intended for I/O** from jobs. Use the scratch filesystem instead.

**TODO**: Add additional filesystem sections (e.g., /scratch/, /data/) with descriptions.

Quota Reporting with ``quotas.py``
*********************************

**TODO**: Add description of quota tool if one exists for SkipJack, or remove this section.

Usage:

.. code-block:: console

   quotas.py

Example Output:

.. code-block:: bash

   **TODO**: Add example output showing quota/usage display


Fields:

- **FS**: Filesystem Path
- **Used**: Current usage for the filesystem
- **Quota**: Allocated quota for the user or group
- **Used %**: Percentage of usage relative to quota

####################
Filesystems on DSAI
####################

DSAI uses a combination of high-performance and research-tier file systems to support a wide range of workloads. Most storage is backed by IBM Spectrum Scale (GPFS), with additional storage from Krieger IT (VAST) for eligible researchers.

Storage on DSAI is intended solely for research and educational purposes. Users are expected to manage their data responsibly, and storage quotas are enforced per group.

General Guidelines
******************

- **Data stored on ARCH-managed filesystems is not backed up by default.**
- Users are responsible for maintaining their own backups or purchasing backup services.
- Storage increases are granted on a case-by-case basis, based on need and system capacity.
- ARCH reserves the right to delete or move data as necessary to maintain system stability.
- Temporary storage for large projects is available — please contact ARCH staff.

.. important::
  Data subject to restrictions - including but not limited to, HIPAA, PHI, or CUI is **not permitted** on DSAI.  
  If your research involves an IRB and the data is de-identified, please reach out to  
  `help@arch.jhu.edu <mailto:help@arch.jhu.edu>`__ for further guidance, prior to storing or processing any data.


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
   * - /home/
     - WEKA
     - 10 TB
     - 50 GB per user
     - Limited
   * - /scratch/
     - WEKA
     - 800 TB
     - 20 TB per group
     - No


Local Scratch
==============

Each compute node has a local 1+ TB NVMe hard drive mounted as “/tmp”. The latency to these  NVMe flash drives is orders of magnitude lower than for spinning disk  (GPFS), usually microseconds versus milliseconds. Users who read/write small files may want to use this space instead of the scratch file sets. It will provide better performance. Make sure you write files back to “scratch” or “data” before the job ends. Likewise, make sure you delete files and directories at the end of jobs.

/home/
=======

Each user receives 50 GB of storage in `/home/`, backed by WEKA.  
This area is intended for frequently used code, scripts, and configuration files.

.. warning::
   `/home/` is **not intended for I/O** from jobs. Use `/scratch/` instead.

/scratch/
=========

Each group receives 10TB of storage in `/scratch/`, backed by WEKA.

Quota Reporting with `quotas.py`
********************************

ARCH provides a command-line tool called `quotas.py` to help users monitor their disk usage across the `/home` and `/scratch` filesystems.

This tool runs automatically at login and displays the current usage for your home directory and your research group’s shared allocations. However, you can manually run it at any time to check your usage or monitor quotas for your research group.

Usage:
======

.. code-block:: console

   quotas.py

Example Output:
===============

.. code-block:: bash

  [user@dsailogin ~]$ quotas.py
  +---------------------------------------------------------------------+
  |          Usage for user as of Thu May  1 10:01:05 2025              |
  +---------------------------+-------------+-------------+-------------+
  |             FS            |     Used    |    Quota    |    Used %   |
  +---------------------------+-------------+-------------+-------------+
  |      /home/$user/          |   64.33 MB  |   50.00 GB  |    0.13%    |
  |     /scratch/$PI/          |   83.27 GB  |   10.00 TB  |      0%     |
  +---------------------------+-------------+-------------+-------------+

Fields:
=======

- **FS**: Filesystem Path
- **Used**: Current usage for the filesystem
- **Quota**: Allocated quota for the user or group
- **Used %**: Percentage of usage relative to quota
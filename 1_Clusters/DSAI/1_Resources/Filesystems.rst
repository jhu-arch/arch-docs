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
  Data subject to restrictions such as HIPAA or PHI is **not permitted** on DSAI.  
  If your research involves an IRB and the data is de-identified, please reach out to  
  `help@arch.jhu.edu <mailto:help@arch.jhu.edu>`__ for further guidance.


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
     - 1 TB per group
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

Each group receives 1TB of storage in `/scratch/`, backed by WEKA.

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

.. code-block:: text

  [root@login01 ~]# quotas.py
  +---------------------------------------------------------------------------------+
  |         Home Usage for user <your_username> as of Tue Apr 15 15:00:06 2025     |
  +---------------------+-------------------+-------------------+-------------------+
  |         Used        |       Quota       |      Percent      |       Files       |
  +---------------------+-------------------+-------------------+-------------------+
  |       XX.XX GB      |      50.00 GB     |      68.56%       |      XXX,XXX      |
  +---------------------+-------------------+-------------------+-------------------+

  +-----------------------------------------------------------------------------------------------+
  |         WEKA Usage for Group <group_name> as of Tue Apr 15 15:00:17 2025                      |
  +-------------+------------+-------------+----------+--------------+----------------+-----------+
  |      FS     |    Used    |    Quota    |  Used %  |    Files     |  Files Quota   |  Files %  |
  +-------------+------------+-------------+----------+--------------+----------------+-----------+
  |   scratch   |  XX.XX TB  |  10.00 TB   |  XX.XX%  |  X,XXX,XXX   |   40,960,000   |   XX.XX%  |
  +-------------+------------+-------------+----------+--------------+----------------+-----------+

Fields:
=======

- **Used**: Current usage for the filesystem
- **Quota**: Allocated quota for the user or group
- **Percent**: Percentage of usage relative to quota
- **Files**: Number of files currently stored
- **Files Quota**: Maximum allowed number of files
- **Files %**: Percent of file quota used

.. tip::
   File quotas are just as important as storage size. Exceeding your file quota may prevent new files from being written even if space remains.

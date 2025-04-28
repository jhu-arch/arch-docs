Filesystems on Rockfish
########################


Rockfish uses a combination of high-performance and research-tier file systems to support a wide range of workloads. Most storage is backed by IBM Spectrum Scale (GPFS), with additional storage from Krieger IT (VAST) for eligible researchers.

Storage on Rockfish is intended solely for research and educational purposes. Users are expected to manage their data responsibly, and storage quotas are enforced per group.

General Guidelines
******************

- **Data stored on ARCH-managed filesystems is not backed up by default.**
- Users are responsible for maintaining their own backups or purchasing backup services.
- Storage increases are granted on a case-by-case basis, based on need and system capacity.
- ARCH reserves the right to delete or move data as necessary to maintain system stability.
- Temporary storage for large projects is available — please contact ARCH staff.

.. important::
  Data subject to restrictions such as HIPAA or PHI is **not permitted** on Rockfish.  
  If your research involves an IRB and the data is de-identified, please reach out to  
  `help@rockfish.jhu.edu <mailto:help@rockfish.jhu.edu>`__ for further guidance.


Filesystems at a Glance
***********************

.. list-table:: 
   :header-rows: 1
   :widths: 18 15 12 12 15 15 10

   * - File System
     - System Type
     - Total Size
     - Block Size
     - Default Quota
     - Files per TB
     - Backed Up?
   * - /home/
     - NVMe SSD (ZFS)
     - 20 TB
     - 128 KB
     - 50 GB per user
     - N/A
     - Limited
   * - /scratch4/
     - IBM GPFS
     - 3.8 PB
     - 4 MB
     - 1 TB per group
     - 2M
     - No
   * - /scratch16/
     - IBM GPFS
     - 3.6 PB
     - 16 MB
     - By request
     - 1M
     - No
   * - /data/
     - IBM GPFS
     - 5.1 PB
     - 16 MB
     - 10 TB per group
     - 400K
     - No
   * - /vast/
     - VAST
     - N/A
     - 32 KB
     - By request
     - N/A
     - No


Local Scratch
==============

Each compute node has a local 1+ TB NVMe hard drive mounted as “/tmp”. The latency to these  NVMe flash drives is orders of magnitude lower than for spinning disk  (GPFS), usually microseconds versus milliseconds. Users who read/write small files may want to use this space instead of the scratch file sets. It will provide better performance. Make sure you write files back to “scratch” or “data” before the job ends. Likewise, make sure you delete files and directories at the end of jobs.

/home/
=======

Each user receives 50 GB of storage in `/home/`, backed by high-speed NVMe SSDs and ZFS.  
This area is intended for frequently used code, scripts, and configuration files.

.. warning::
   `/home/` is **not intended for I/O** from jobs. Use `/scratch` instead.

Limited file recovery may be possible, but is **not guaranteed**.

/scratch4/
==========

This default scratch space is optimized for high file-count and smaller file sizes using a 4 MB block size.

- 1 TB per group (default)
- Suitable for: **genomics, bioinformatics, mechanical engineering**
- Purged automatically after 30 days of inactivity (based on access time)
- Not backed up or recoverable

/scratch16/
===========

This scratch space is optimized for sequential I/O and streaming workloads.

- Available **by request** with justification
- 16 MB block size
- Suitable for: **physics, large-scale simulations, chemistry**
- Same 30-day purge policy applies
- Not backed up or recoverable

/data/
======

Groups are given 10 TB of allocation by default in `/data/`.

This area is ideal for storing high-value data generated during or after computation, including:

- Processed results
- Intermediate analysis
- Files you want to retain longer than 30 days

/data/ is **not backed up**, so users must implement their own preservation strategy.

/vast/
======

This all-flash storage is provided by **Krieger IT** for researchers who have purchased space.

- Mounted at `/vast/` on Rockfish
- Available to all JHU researchers
- Request form and pricing info:  

📄 `Request VAST Storage & View Pricing <https://jh.qualtrics.com/jfe/form/SV_4SJJTnPMp8dHKwm>`__

Quota Reporting with `quotas.py`
********************************

ARCH provides a command-line tool called `quotas.py` to help users monitor their disk usage across the `/home`, `/data`, `/scratch4`, `/scratch16`, and `/vast` filesystems.

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
  |         GPFS Usage for Group <group_name> as of Tue Apr 15 15:00:17 2025                      |
  +-------------+------------+-------------+----------+--------------+----------------+-----------+
  |      FS     |    Used    |    Quota    |  Used %  |    Files     |  Files Quota   |  Files %  |
  +-------------+------------+-------------+----------+--------------+----------------+-----------+
  |     data    |  XX.XX TB  |  10.00 TB   |  XX.XX%  |  X,XXX,XXX   |   40,960,000   |   XX.XX%  |
  |   scratch4  |  XX.XX TB  |  10.00 TB   |  XX.XX%  |  X,XXX,XXX   |   20,480,000   |   XX.XX%  |
  |  scratch16  |  XX.XX TB  |  10.00 TB   |  XX.XX%  |  X,XXX,XXX   |   10,240,000   |   XX.XX%  |
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

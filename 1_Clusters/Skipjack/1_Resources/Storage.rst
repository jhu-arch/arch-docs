.. _skipjack storage:

########################
Skipjack Storage
########################

Skipjack has three places to keep files: your **home** directory, your group's **scratch** space, and your
group's **Project Storage**. All three are available on the login nodes and on every compute node.

.. warning::

   Rockfish filesystems (including ``/data`` and ``/scratch4`` / ``/scratch16``) are **not** mounted on Skipjack.
   Copy the data you need with Globus; see :ref:`Data Transfer with Globus`.

.. list-table::
   :header-rows: 1
   :widths: 16 24 22 10 28

   * - **Storage**
     - **Path**
     - **Quota**
     - **Cost**
     - **Use it for**
   * - Home
     - ``/home/jhu/$USER``
       (Schmidt Sciences: ``/home/schmidt/$USER``)
     - 100 GB per user
     - Free
     - Scripts, source code, small configuration files
   * - Scratch
     - ``/scratch/jhu/$USER``
       (Schmidt Sciences: ``/scratch/schmidt/$USER``)
     - Shared per PI group: 1 TB by default, up to 10 TB on request
     - Free
     - Working data for jobs
   * - Project Storage
     - ``~/projects`` (link to your group's directory)
     - Requested by the PI, in whole TB
     - Paid
     - Data your group needs to keep long term

Home
****

Every user has a home directory with a **100 GB** quota. The home quota cannot be increased; put larger data in
scratch or Project Storage.

Your home directory also contains a ``projects`` link that takes you to your group's Project Storage directory.

Scratch
*******

Each PI receives scratch space with a **1 TB** quota when their account is upgraded to PI. The quota is shared by
everyone working under that PI, however many projects the PI has. Scratch can be increased to up to **10 TB at no
cost**: email `arch@jhu.edu <mailto:arch@jhu.edu>`__ with a brief justification.

Scratch is not purged, but it is meant for data your jobs are actively using. Keep data your group needs long
term in Project Storage.

Project Storage
***************

Project Storage is paid, long-term storage for a PI's group. A PI has one Project Storage directory, shared across
all of their projects; members reach it through ``~/projects``.

Project Storage runs on WEKA. It works like a hybrid drive: frequently used data is served from a fast SSD
**cache**, and less-used data is kept in object storage. The PI chooses both the total capacity and the cache size
when requesting it. See :ref:`Request Project Storage <request project storage>` in the user guide.

VAST (Rockfish users)
*********************

Rockfish groups with VAST space will have it moved to Skipjack, where it will be available at ``/vast/`` as on
Rockfish. **This is not available yet**; this page will be updated when it is.

Moving Data
***********

- **Globus** is the recommended way to move large amounts of data to or from Skipjack, including from Rockfish.
  Project Storage has no separate Globus endpoint: use the **Homes** endpoint for your login type and open the
  ``projects`` folder. See :ref:`Data Transfer with Globus`.
- For many small files, bundle them first (for example ``tar -czf mydata.tgz mydata/``); transfers of a few large
  files are much faster than many small ones.

What Data Is Allowed
********************

Data subject to restrictions, including but not limited to HIPAA, PHI or CUI, is **not permitted** on ARCH
systems. If your research involves an IRB and the data is de-identified, contact
`arch@jhu.edu <mailto:arch@jhu.edu>`__ before storing or processing any data.

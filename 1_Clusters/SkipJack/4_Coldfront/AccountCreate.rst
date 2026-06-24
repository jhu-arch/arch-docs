Creating a User Account
************************

.. _Coldfront Portal: TODO: Add SkipJack Coldfront URL

Non-PI users can request accounts through the SkipJack `Coldfront Portal`_. However, user accounts will only be activated after the user has been added to an existing project by a PI with an approved allocation on the SkipJack Cluster.

- All Johns Hopkins users **must use their JHED ID** (e.g., `jsmith123`) when requesting an account.  
  Failure to use your JHED ID may delay account approval and **will prevent access to Globus**, which requires JHED-based authentication.
- **TODO**: Add external/collaborator notes for SkipJack

User accounts can be requested at any time, and the portal also allows users to:

- Submit requests for user accounts
- Reset account passwords
- Monitor utilization and core-hour usage
- View current allocations and associated projects
- Add users (if PI or proxy)


.. note::
   By requesting an account on SkipJack, you are automatically subscribed to the **SkipJack Users mailing list**:  
   **TODO**: Add mailing list address.  
   This list is used to distribute **important cluster announcements, including scheduled maintenance, outages, and policy updates**.

   **Unsubscribing from this mailing list will result in account deactivation**, as it is the primary channel for operational communication.

.. note::
    All users should review the :doc:`Good Citizen guidelines <../../../4_Support/Citizen>` before requesting an allocation or account.

**External and Collaborative Access**

**TODO**: Add external/collaborator access policy for SkipJack (does it support ext- accounts?)

**Getting Started**

When you first navigate to the `Coldfront Portal`_, you'll be prompted to log in or create an account.  
Users should click **Request User Account**.

.. centered::
    |coldfront1|

You will then be asked to enter your JHED ID (as your username), email address, and a password. You **must use your JHED ID**. Using anything else will delay access and break services such as Globus.

**TODO**: Add cluster-specific image references for Coldfront screenshots (update paths/names).

After submitting your request, you should see a confirmation message. You can then log in to the `Coldfront Portal`_ with your new credentials.

At this stage, your account is created but **not yet active on SkipJack**. To gain access, you must be added to an existing project/allocation by your PI or a designated proxy. Once this has been done, your account will automatically be created on the SkipJack cluster.

.. |coldfront1| image:: TODO: Add path to Coldfront screenshot 1
   :alt: Coldfront login page
   :width: 70 %

.. |coldfront2| image:: TODO: Add path to Coldfront screenshot 2
   :alt: Coldfront create account form
   :width: 70 %

.. |coldfront3| image:: TODO: Add path to Coldfront screenshot 3
   :alt: Coldfront success message
   :width: 70 %

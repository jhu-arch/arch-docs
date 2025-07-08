Connecting to the JHU VPN
###########################

To access Open OnDemand or other internal Rockfish services from off campus, you must first connect to the **Johns Hopkins VPN** using the **Ivanti Pulse Secure** client.

This guide will walk you through the setup process.

.. note::
  You do **not** need the VPN if you are connected to the JHU campus network.

Step 1: Download Ivanti Pulse Secure
*************************************

1. Visit the `JHU VPN Resource Center <https://livejohnshopkins.sharepoint.com/sites/Office365Hub/SitePages/VPN-Resource-Center.aspx>`_.
2. Scroll to the **VPN Client Installs** section.
3. Download the **Ivanti Pulse Secure** client for your operating system.
4. Install the application.

Step 2: Configure the VPN
***************************

1. Open the **Pulse Secure** application.
2. Click the **+** button to add a new connection.
3. Use the following settings:
   
   - **Name**: JHU VPN (or any label you prefer)
   - **Server URL**: ``vpn.jh.edu`` *(Note: it's "jh", not "jhu")*
4. Click **Add**.
5. Select the new connection and click **Connect**.

Step 3: Authenticate
*********************

1. Enter your **JHED ID and password**.
2. When prompted, enter your **MFA code** from your authenticator app.
   - The code changes every minute.
   - If your code expires, refresh your app and try again.
3. Once authenticated, your VPN session will begin.

Step 4: Disconnect When Done
*****************************

When you're finished with your session:

1. Reopen the **Pulse Secure** app.
2. Select your active session and click **Disconnect**.

Troubleshooting
****************

- **Can’t connect?**
  - Double check the server is set to ``vpn.jh.edu``
  - Confirm your MFA code is current
  - Try clearing saved credentials if authentication fails repeatedly

- **Still having issues?**
  - Visit the `VPN Resource Center <https://livejohnshopkins.sharepoint.com/sites/Office365Hub/SitePages/VPN-Resource-Center.aspx>`_ for up-to-date support
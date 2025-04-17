## McAfee ePO and TLS Syslog Integration Guide

Recent enhancements to the McAfee (Trellix) ePolicy Orchestrator (ePO) now allow for secure message relaying using TLS-Syslog. This guide outlines the steps to configure both IBM QRadar and McAfee ePO for TLS-encrypted syslog event forwarding.

---

## QRadar Configuration

1. Log in to QRadar SIEM.
2. Navigate to **Admin** > **Log Source Manager**.
3. Click **Add Log Source** and configure the following parameters:

| Parameter                  | Value                                  |
|----------------------------|----------------------------------------|
| Name                       | (name) @ (IP Address)                  |
| Description                | (Describe the log source)              |
| Enabled                    | Yes                                    |
| Log Source Type            | McAfee ePolicy Orchestrator            |
| Protocol Type              | Syslog (undocumented)                  |
| Groups                     | (Assign relevant groups)               |
| Extension                  | (Leave blank unless needed)            |
| Target Event Collector     | (Local event collector)                |
| Disconnected Log Collector | (Leave blank unless needed)            |
| Credibility                | 5                                      |
| Internal                   | No                                     |
| Deployed                   | Yes                                    |
| Coalescing Events          | No                                     |
| Store Event Payloads       | Yes                                    |
| Log Source Identifier      | (IP Address)                           |

4. Deploy changes to apply the new log source.

> **Note:** Ensure your QRadar deployment has an active TLS listener on port 6514. Standard syslog protocol will work as long as this listener is enabled.

---

## McAfee ePolicy Orchestrator (Trellix) Configuration

1. Log in to the McAfee ePO console as an administrator.
2. Go to **Settings** > **Configuration** > **Registered Servers**.
3. Click **New Server** and enter the following:

   - **Server Type:** Syslog Server  
   - **Name:** (Choose a memorable name)  
   - **Notes:** (Optional)

   Syslog Server Setup

4. Complete the remaining fields:

   - **Server Name:** (QRadar server name or IP address)
   - **TCP Port Number:** 6514
   - **Enable Event Forwarding:** Checked
   - **Test Connection:** Click to verify connectivity before saving

   Syslog Server Fields

5. Save the configuration. Events should begin streaming to QRadar promptly.  
6. Verify event flow in QRadar by checking events associated with the new log source.

---

This setup ensures secure, reliable forwarding of McAfee ePO events to QRadar using TLS-encrypted syslog.

Sources

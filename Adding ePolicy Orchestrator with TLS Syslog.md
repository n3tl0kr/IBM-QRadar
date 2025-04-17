## McAfee ePO and TLS Syslog Integration

Recent upgrades to the McAfee (Trellix) ePolicy Orchestrator (ePO) system now allow secure, reliable event forwarding to QRadar using TLS-Syslog. Follow these steps to configure both QRadar and ePO for this integration.

---

## QRadar Configuration

1. **Log in** to your QRadar SIEM.
2. Navigate to **Admin** > **Log Source Manager**.
3. Select **Add Log Source** and configure with the following parameters:

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

4. **Deploy changes** to activate the new log source.

> **Note:** Ensure your QRadar deployment has an active TLS listener on port 6514. Standard syslog protocol will work as long as this listener is enabled.

---

## McAfee ePolicy Orchestrator (Trellix) Configuration

1. **Log in** to the McAfee ePO system as an administrator.
2. Navigate to **Settings > Configuration > Registered Servers**.
3. Click **New Server** and fill out the fields as shown below:
   - **Server Type:** Syslog Server
   - **Name:** (A memorable name for the connection)
   - **Notes:** (Optional)

   Registered Server Setup

4. Complete the remaining fields:
   - **Server Name:** (Use your QRadar server name or IP address)
   - **TCP Port Number:** 6514
   - **Enable event forwarding:** ✔️
   - **Test:** Click **Test Connection** before saving to ensure connectivity.

   Syslog Server Fields

5. **Save** your configuration. Events should begin streaming to QRadar shortly.
6. **Verify** in QRadar by checking for new events associated with the configured log source.

---

**You’re all set!**  
This configuration enables secure, TLS-encrypted syslog event forwarding from McAfee ePO to QRadar, ensuring both reliability and compliance.

If you need further customization or have more images to include, let me know!

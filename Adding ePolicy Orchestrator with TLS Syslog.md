# McAfee ePO and TLS Syslog
Due to new improvements with the McAfee/Trelix ePolicy Orchestrator system, we can now leverage TLS-Syslog to relay messages in a much more concrete fashion. 

## QRadar
1. Log in to the QRadar SIEM, navigate to the Admin menu and open the Log Source Manager app.  
2. Select Add Log Source and configure a new source with the following parameters.
3. Once completed, ensure to deploy changes.

|Parameter | Value |
| ----- | ----- | |
|Name | <name> @ <IP Address>|
|Description | Self explanatory|
|Enabled | Yes|
|Log Source Type | McAfee ePolicy Orchestrator|
|Protocol Type | TLS Syslog|
|Groups | <define groups> |
|Extension | |
|Target Event Collector | <Local event collector>|
|Disconnected Log Collector | |
|Credibility | 5|
|Internal | No|
|Deployed | Yes|
|Coalescing Events | No|
|Store Event Payloads | Yes|
|Log Source Identifier | <IP Address>|
|TLS Listen Port | 6514|
|Authentication Mode | TLS|
|Server Certificate Type | Generated Certificate|
|Max Payload Length | 4096|
|Maximum Connections | 50|
|TLS Protocols | TLS 1.2 and above|
|Use as a Gateway Log Source | No|
|Enable Multiline | Yes|
|Aggregation Method | Start/End Matching|
|Event Start Pattern | \< *(?<PRI>\d+) *\> *(?<VERSION>\d+)?|
|Event End Pattern | |
|Flatten Multiline Events Into Single Line | No|
|Event Formatter | None|

## McAfee ePolicy Orchestrator (Trellix)
1. Log in to the local McAfee ePO system as an administrator. 
2. Navigate to Settings > Configuration > Registered Servers
3. Select New Server, complete the fields shown below and choose Next
  Server Type: Syslog Server
  Name: A memorable name for the connection
  Notes: Any additional notes
![image](https://github.com/n3tl0kr/IBM-QRadar/assets/43141524/5c054563-541b-4264-9ae9-9bc2d9e94543)
4. Complete the remaining fields for the Syslog Server…
  Server Name: Use the server name or IP address
  TCP port number: 6514
  Enable event forwarding: [X]
  Test: (Select Test Connection prior to saving to ensure connectivity)
![image](https://github.com/n3tl0kr/IBM-QRadar/assets/43141524/63e064fc-8e97-479e-ad90-ce77f3f69962)
5. Once saved, events should start streaming to QRadar quickly. Verify by viewing events associated with the log source.

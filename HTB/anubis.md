Box info::
Linux
10.10.11.102

Enumeration:
nmap:
```
PORT      STATE SERVICE       VERSION
135/tcp   open  msrpc         Microsoft Windows RPC
443/tcp   open  ssl/http      Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
| tls-alpn:
|_  http/1.1
|_http-title: Not Found
| ssl-cert: Subject: commonName=www.windcorp.htb
| Subject Alternative Name: DNS:www.windcorp.htb
| Not valid before: 2021-05-24T19:44:56
|_Not valid after:  2031-05-24T19:54:56
|_ssl-date: 2022-01-14T17:57:28+00:00; +14m55s from scanner time.
445/tcp   open  microsoft-ds?
593/tcp   open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
49697/tcp open  msrpc         Microsoft Windows RPC
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 14m55s, deviation: 0s, median: 14m54s
| smb2-time:
|   date: 2022-01-14T17:56:51
|_  start_date: N/A
| smb2-security-mode:
|   3.1.1:
|_    Message signing enabled and required
```

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 250.08 seconds
rpcdump::rpcdump.py <ip> | grep -r "lsarpc\|samr\|atsvc\|winreg\|svcctl\|srvsvc\|epmapper" /opt/impacket/examples/rpcdumpanubis.txt ::
ncacn_np:\\EARTH[\PIPE\atsvc]

rpcclient: rpcclient.py -U "" -N <ip>
lsaquery::
Domain Name: WINDCORP                                                                                                
Domain Sid: S-1-5-21-3510634497-171945951-3071966075
rpcclient $> samlogon
Failed to open /var/lib/samba/private/secrets.tdb
Failed to fetch trust credentials for WORKGROUP to connect to netlogon: NT_STATUS_INTERNAL_ERROR
rpcclient $> dsroledominfo
Machine Role = [5]
Directory Service is running.
Domain is in native mode.
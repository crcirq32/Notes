Name: Devzat
IP: 10.10.11.118
OS: Linux

Enumeration::
nmap::
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 c2:5f:fb:de:32:ff:44:bf:08:f5:ca:49:d4:42:1a:06 (RSA)
|   256 bc:cd:e8:ee:0a:a9:15:76:52:bc:19:a4:a3:b2:ba:ff (ECDSA)
|_  256 62:ef:72:52:4f:19:53:8b:f2:9b:be:46:88:4b:c3:d0 (ED25519)
80/tcp   open  http    Apache httpd 2.4.41
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: devzat - where the devs at
8000/tcp open  ssh     (protocol 2.0)
| fingerprint-strings:
|   NULL:
|_    SSH-2.0-Go
| ssh-hostkey:
|_  3072 6a:ee:db:90:a6:10:30:9f:94:ff:bf:61:95:2a:20:63 (RSA)
1 service unrecognized despite returning data.
SF-Port8000-TCP:V=7.91%I=7%D=1/30%Time=61F72B44%P=x86_64-pc-linux-gnu%r(NU
SF:LL,C,"SSH-2\.0-Go\r\n");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

dirb::
/assets, /images, /javascript, /server-status

ffuf:: Nothing 

nikto:: 
+ Server may leak inodes via ETags, header found with file /, inode: 197f, size: 5c570e80059d3, mtime: gzip
+ Allowed HTTP Methods: HEAD, GET, POST, OPTIONS
+ OSVDB-3268: /images/: Directory indexing found.
+ OSVDB-3092: /LICENSE.txt: License file found may identicate 
  + Creative Commons Attribution 3.0 Unported

http:
UN: patrick@devzat.htb
`ssh -l [username] devzat.htb -p 8000 `
Font Awesome Free 5.9.0 by @fontawesome - https://fontawesome.com
html5up.net 
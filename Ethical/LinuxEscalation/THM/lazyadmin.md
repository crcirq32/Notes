PORT      STATE    SERVICE        VERSION
22/tcp    open     ssh            OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
80/tcp    open     http           Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
3022/tcp  filtered csregagent
4217/tcp  filtered vrml-multi-use
8208/tcp  filtered lm-webwatcher
12254/tcp filtered unknown
31156/tcp filtered unknown
31270/tcp filtered unknown
48273/tcp filtered unknown
52008/tcp filtered unknown
61975/tcp filtered unknown
MAC Address: 02:E6:B6:3D:0E:BB (Unknown)

https://www.cvedetails.com/vulnerability-list/vendor_id-45/product_id-66/version_id-471720/Apache-Http-Server-2.2.18.html

scan for CVE's

```
git clone https://github.com/scipag/vulscan scipag_vulscan
ln -s `pwd`/scipag_vulscan /usr/share/nmap/scripts/vulscan
nmap -sV --script=vulscan/vulscan.nse www.example.com
```

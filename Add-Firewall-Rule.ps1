# Need Administrator privilige
netsh advfirewall firewall add rule name="CAPI2 Event52 Demo" dir=out action=block remoteip=any profile=any enable=yes

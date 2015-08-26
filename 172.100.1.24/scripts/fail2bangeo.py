# Fail2BanGeo.py
import os
import re
f = open('/var/log/fail2ban.log', 'r')    
pattern = r".*?Ban\s*?((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$"
p = re.compile(pattern)
for i in f:
        m = p.match(i)
        if m:
                ip = m.group(1)
                file = os.popen('geoiplookup %s' % ip)
                print file.read()


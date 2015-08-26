#!/bin/bash
watch --color -n1 "iptables -nvL | egrep -v '^\s*0\s*0' | sed 's/\(DROP\|REJECT\)/\x1b[49;31m\1\x1b[0m/g' | sed 's/\(ACCEPT\)/\x1b[49;32m\1\x1b[0m/g'"

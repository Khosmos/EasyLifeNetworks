#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20151127
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv
IsFreeIPA() {
service ipa status > /etc/null 2>/etc/null
}


#!/usr/bin/python
import re, subprocess
def get_keychain_pass(server=None):
    command = "lpass show --password %s" % server
    output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
    return output.replace('\n', '').replace('\r', '')

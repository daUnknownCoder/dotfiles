#! /usr/bin/env python

import getpass
import sys

import pam

print(pam.authenticate(getpass.getuser(), sys.argv[1]))

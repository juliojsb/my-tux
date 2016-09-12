#!/usr/bin/env python
"""
Author        :Julio Sanz
Website       :www.elarraydejota.com
Email         :juliojosesb@gmail.com
Description   :Script to generate password hash compatible with /etc/shadow
               For example, if you need to manually change the password of a user in
               /etc/shadow, you will need to introduce the hash corresponding to that
               password. This script gives you directly the hash of a given password so
               you can then copy the hash in /etc/shadow
Dependencies  :None
Usage         :gen_shadow_hash.py [ md5 | sha256 | sha512 ]
Example       :gen_shadow_hash.py sha256
License       :GPLv3
"""

#
# IMPORTS
#

import sys, random, crypt, getpass

#
# VARIABLES
#

hash_algorithm=sys.argv[1]
alph_set = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
alph_subset = []

#
# FUNCTIONS
#

def hash_gen():
    password = getpass.getpass("Please enter the password to generate the hash:")

    for i in range(16):
        alph_subset.append(random.choice(alph_set))
    randomsalt = "".join(alph_subset)

    if hash_algorithm == "md5":
        hash_generated = crypt.crypt(password, '$1$%s$' % randomsalt)
        print ("MD5 hash generated -> "+hash_generated)
    elif hash_algorithm == "sha256":
        hash_generated = crypt.crypt(password, '$5$%s$' % randomsalt)
        print ("SHA256 hash generated -> "+hash_generated)
    elif hash_algorithm == "sha512":
        hash_generated = crypt.crypt(password, '$6$%s$' % randomsalt)
        print ("SHA512 hash generated -> "+hash_generated)
    else:
        print ("Not supported hash algorithm")

#
# MAIN
#

if __name__ == '__main__':
    hash_gen()

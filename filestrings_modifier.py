#!/usr/bin/env python2
"""
Author        :Julio Sanz
Website       :www.elarraydejota.com
Email         :juliojosesb@gmail.com
Description   :Script to replace, delete or add strings to a file
Dependencies  :None
Usage         :filestrings_modifier.py [file]
Example       :filestrings_modifier.py mytext.txt
               filestrings_modifier.py /home/mytext.txt
License       :GPLv3
"""

#
# IMPORTS
#

import sys, os

#
# FUNCTIONS
#

def replace_string():
    v_file = sys.argv[1]
    stringtosearch = raw_input("Please specify the text that is going to be replaced --> ")
    replacestring = raw_input("Please specify the text that will replace the word "+stringtosearch+" --> ")
    if os.path.isfile(v_file):
        with open(v_file, 'r') as f:
            data = f.read()
        newdata = data.replace(stringtosearch, replacestring)
        with open(v_file, 'w') as f:
            f.write(newdata)
    else:
        how_to_use()

def how_to_use():
    print "\nWrong usage. Please pass an existing filename (path if needed) as a parameter to the script"
    print "Usage -> filestrings_modifier.py [filename]"
    print "Examples: filestrings_modifier.py mytext.txt"
    print "          filestrings_modifier.py /home/mytext.txt"

# MAIN

if __name__ ==  '__main__':
    if len(sys.argv) == 2:
        replace_string()
    else:
        how_to_use()

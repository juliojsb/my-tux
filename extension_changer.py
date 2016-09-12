#!/usr/bin/env python2
"""
Author        :Julio Sanz
Website       :www.elarraydejota.com
Email         :juliojosesb@gmail.com
Description   :Python script to change filenames that have an extension (original_extension) to another
               one (final_extension) in a given folder (target_folder)
Dependencies  :This scrip has been written using Python 2.7.9
Usage         :./extension_changer.py [target_folder] [original_extension] [final_extension]
Example       :python extension_changer.py /home/jota/Documents .ext1 .ext2
               Would rename file1.ext1, file2.ext1 to file1.ext2 to file2.ext2 in /home/jota/Documents
License       :GPLv3
"""

#
# IMPORTS
#

import os,sys

#
# VARIABLES
#

target_folder = sys.argv[1]
original_extension = sys.argv[2]
final_extension = sys.argv[3]

#
# FUNCTIONS
#

def change_extension(folder,orig_ext,final_ext):
    print "Original files in folder "+folder+" with extension "+orig_ext
    for file in os.listdir(folder):
        if file.endswith(orig_ext):
            print(file)
        else: continue

    # Now change the extension
    for filename in os.listdir(folder):
        original_filename = os.path.join(folder,filename)
        if not os.path.isfile(original_filename): continue
        changed_filename = original_filename.replace(orig_ext, final_ext)
        os.rename(original_filename, changed_filename)

    print "Current files in folder "+folder+" with extension "+final_ext
    for file in os.listdir(folder):
        if file.endswith(final_ext):
            print(file)
        else: continue

    return 0

#
# MAIN
#

if __name__ == '__main__':
    if original_extension.startswith(".") and final_extension.startswith(".") and os.path.isdir(target_folder):
        change_extension(target_folder,original_extension,final_extension)
    else:
        print "Syntax error, please check that extensions begin with a dot and that the target folder exists"

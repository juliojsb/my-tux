#!/usr/bin/env python3
"""
Author        :Julio Sanz
Website       :www.elarraydejota.com
Email         :juliojosesb@gmail.com
Description   :Python script to decompress files that have been compressed
               the following supported formats: bz2,gzip,zip and xz
Dependencies  :This script has been written using Python 3.4.2
Usage         :./decompressor.py [/path/to/compressed_file]
Example       :./decompressor.py /home/jota/myfile.gz
License       :GPLv3
"""

#
# IMPORTS
#

import zipfile
import tarfile
import sys,os

#
# VARIABLES
#

curr_folder = os.getcwd()
file=sys.argv[1]

#
# FUNCTIONS
#

def decompress_file(file):
    if file.endswith('.zip'):
        zip_v = zipfile.ZipFile(file, 'r')
        zip_v.extractall(curr_folder)
        zip_v.close()
    elif file.endswith('.gz') or file.endswith('.gzip') or file.endswith('.bz2') or file.endswith('.xz'):
        tar = tarfile.open(file)
        tar.extractall(curr_folder)
        tar.close()
    else:
        print ("This script doesn't support compression format of "+file)
        sys.exit(1)

#
# MAIN
#

if __name__ == '__main__':
    decompress_file(file)

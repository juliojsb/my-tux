#!/usr/bin/env python
"""
Script        :file_sanitizer.py
Author        :Julio Sanz
Website       :www.elarraydejota.com
Email         :juliojosesb@gmail.com
Description   :Python script to compress and remove files older than X days
Usage         :file_sanitizer.py 
               Modify in the script the variables as needed
License       :GPLv3
"""

# =======================
# MODULES IMPORTS
# =======================

import time,os,gzip

# =======================
# VARIABLES
# =======================

# Location of files to compress/delete
folder = "/home/bob/sandbox/python/"
# Compress files older than specified
compress_older_days = 5
# Delete files older than specified
delete_older_days = 90
# Current time
now = time.time()

# =======================
# FUNCTIONS
# =======================

def sanitize_files():
    # Loop through all the folder
    for file in os.listdir(folder): 
        f = os.path.join(folder,file)
        if not f.endswith('.gz'):
            if os.stat(f).st_mtime < now - (60*60*24*compress_older_days) and os.path.isfile(f):
                print ("...Compressing file "+f)
                out_filename = f + ".gz"
                
                f_in = open(f, 'rb')
                s = f_in.read()
                f_in.close()

                f_out = gzip.GzipFile(out_filename, 'wb')
                f_out.write(s)
                f_out.close()

                # Remove original uncompressed file
                os.remove(f)     
                
        # We ensure that the file we are going to delete has been compressed before
        if f.endswith('.gz'):
            if os.stat(f).st_mtime < now - (60*60*24*delete_older_days) and os.path.isfile(f):
                print ("...Deleting old file "+f)
                os.remove(f)
            
# =======================
# MAIN
# =======================

if __name__ == '__main__':
    sanitize_files()
#!/usr/bin/env python2
"""
Script        :get_sites_http_status.py
Author        :Julio Sanz
Website       :www.elarraydejota.com
Email         :juliojosesb@gmail.com
Description   :Python script to check HTTP status of a list of sites defined in file
               (passed as an argument to the script)
               The file should be written with a website per line, example:
               www.google.com
               www.yahoo.com
               www.opendns.com
               ...

Dependencies  :This scrip has been written using Python 2.7.9
Usage         :python get_sites_http_status.py [sitelist]
License       :GPLv3
"""

# =======================
# MODULES IMPORTS
# =======================

import httplib,sys

# =======================
# VARIABLES
# =======================

# Location of sitelist file
sites = sys.argv[1]

# =======================
# FUNCTIONS
# =======================

def get_sites_status(sites_a):

    # Create list reading the file
    with open(sites_a, 'r') as f:
        sitelist = f.read().splitlines()

    # Loop through the list and check site by site. At the end, format the output with some decency
    print "{0:25} {1:15} {2:15}".format("Site", "Status", "Reason")
    print "-"*50
    for site in sitelist:
        conn = httplib.HTTPConnection(site)
        conn.request("HEAD", "/")
        response = conn.getresponse()
        #print "Site {0:25} Response Status {1:5} Reason {2:15}".format(p, str(response.status), str(response.reason))
        print "{0:25} {1:15} {2:15}".format(site, str(response.status), str(response.reason))

    return 0

def how_to_use():
    print "This script needs at least one parameter"
    print "Launch this way -> python get_sites_status.py [location_of_sitelist_file]"
    return 1

# =======================
# MAIN
# =======================

if __name__ == '__main__':
    get_sites_status(sites)

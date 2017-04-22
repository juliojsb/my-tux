My Tux
============

![awesome_tux](https://cloud.githubusercontent.com/assets/12804701/18446357/45c3db38-7922-11e6-8eca-20be41a28d98.png)

This is a repository of Bash and Python scripts that can be useful to sysadmins and end users of GNU/Linux systems.

#### Scripts

In every script you will find a first section of description, usage and examples. Here is a brief summary of each one:

* **check_partition_space.sh:** this script is intended to check the free space of a partition and send a notification email in case it surpasses a given threshold.

* **check_partition_space.py:** same as the one before, but written in Python for Python lovers! :)

* **clean_exim4.sh:** clean frozen messages, paniclogs... and start the MTA in a clean manner.

* **connect_vps_pub_auth.sh:** just a script to connect a remote server using public key auth. Because I don't like to remembder where things are...

* **dd_optimal_block_size_test.sh:** determine the optimal block size to write to a USB device.

* **debian_nvidia_drivers_installation.sh:** automate the install of the Nvidia privative driver in Debian.

* **decompressor.py:** easily decompress files with this Python script.

* **extension_changer.py:** change files extensions in a folder.

* **file_sanitizer.py:** compress and remove files older than X days.

* **filestrings_modifier.py:** modify text strings inside a file.

* **gen_shadow_hash.py:** generate /etc/shadow hashes based on a given password.

* **linux_security_checks.sh:** check your Linux system with ClamAV, Lynis, Chkrootkit... and send the report in an email.

* **ssh_paramiko_automate.py:** automate tasks in remote servers using paramiko.

All the scripts have been tested in Debian, the distribution that I use as my main operating system.

I will probably upload new scripts, so stay tuned!

#### License

All the code in this repository is licensed under GPLv3

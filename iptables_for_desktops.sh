#!/bin/bash
#
# Author        :Julio Sanz
# Website       :www.elarraydejota.com
# Email         :juliojosesb@gmail.com
# Description   :Script to create iptables rules focused on desktop environments.
#                By default it only accepts web navigation, dns lookups and ping. 
#                Comment out the rules you need.
# Dependencies  :iptables-persistent
# License       :GPLv3
#

# 
# VARIABLES
# 

# Enter LAN segment where you are in CIDR notation
lan_segment="192.168.1.0/24"
# DNS servers (OpenDNS servers by default, select yours)
dns_servers="208.67.222.222 208.67.220.220"

# 
# MAIN
# 

# IPv4 default rules
echo "> Cleaning current rules for IPv4"
iptables -F
iptables -Z
iptables -X
echo "> Applying default policies (DROP) for IPv4"
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# IPv6 default rules
echo "> Cleaning current rules for IPv6"
ip6tables -F
ip6tables -Z
ip6tables -X
echo "> Applying default policies (DROP) for IPv6"
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP

# Loopback communications
iptables -A INPUT -s 127.0.0.1 -i lo -j ACCEPT
iptables -A OUTPUT -d 127.0.0.1 -o lo -j ACCEPT

# Connections from/to LAN hosts
iptables -A OUTPUT -d "$lan_segment" -j ACCEPT
iptables -A INPUT -s "$lan_segment" -j ACCEPT

# DNS lookups
for dns_server in "$dns_servers"
do
    iptables -A OUTPUT -p udp -d "$dns_server" --sport 1024:65535 --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
done

# HTTP and HTTPS navigation/browsing
iptables -A OUTPUT -j ACCEPT -p tcp --sport 1024:65535 -m multiport --dports 80,443

# Allow output SMTP. For example, if you have an internal account that sends email to an external gmail account
#iptables -A OUTPUT -p tcp --dport 587 -j ACCEPT

# Steam client
#iptables -A OUTPUT -p udp --dport 27000:27030 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 27014:27050 -j ACCEPT
#iptables -A OUTPUT -p udp --dport 4380 -j ACCEPT

# Steam in Home streaming
#iptables -A INPUT -p udp -m multiport --dports 27031,27036 -j ACCEPT
#iptables -A INPUT -p tcp -m multiport --dports 27036,27037 -j ACCEPT

# Steamworks and voice chat
#iptables -A OUTPUT -p udp -m multiport --dports 3478,4379,4380 -j ACCEPT

# Connections to GitHub (maybe you have some repositories and interact via SSH)
# https://help.github.com/articles/what-ip-addresses-does-github-use-that-i-should-whitelist/
#iptables -A OUTPUT -p tcp -d 192.30.252.0/22 -m multiport --dport 22,80,443,9418 -j ACCEPT

# Connections to BitBucket (same as GitHub, normally intented to interact with repositories)
#iptables -A OUTPUT -p tcp -d 104.192.143.1 -m multiport --dport 22,80,443 -j ACCEPT
#iptables -A OUTPUT -p tcp -d 104.192.143.2 -m multiport --dport 22,80,443 -j ACCEPT
#iptables -A OUTPUT -p tcp -d 104.192.143.3 -m multiport --dport 22,80,443 -j ACCEPT
#iptables -A OUTPUT -p tcp -d 104.192.143.65 -m multiport --dport 22,80,443 -j ACCEPT
#iptables -A OUTPUT -p tcp -d 104.192.143.66 -m multiport --dport 22,80,443 -j ACCEPT
#iptables -A OUTPUT -p tcp -d 104.192.143.67 -m multiport --dport 22,80,443 -j ACCEPT

# Ping from inside to outside for testing and debugging purposes
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

# Allow incoming connections stablished before (and therefore, authorized by us through the firewall)
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Logging
iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -A OUTPUT -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
iptables -A LOGGING -j DROP

# Save iptables rules
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

# Show a summary of the rules applied
echo -e "_________________________________________________\n"
echo -e "------Current Iptables rules for IPv4"
echo -e "_________________________________________________\n"
iptables -nvL

echo -e "_________________________________________________\n"
echo -e "------Current Iptables rules for IPv6"
echo -e "_________________________________________________\n"
ip6tables -nvL

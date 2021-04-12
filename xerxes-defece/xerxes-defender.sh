iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# Flush all the previous rules
iptables -F
iptables -F -t mangle
iptables -F -t filter
iptables -F -t nat


# Drop invalid and non-syn packets that are in state new
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW ! --tcp-flags ALL SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate INVALID -j DROP

# PROTECTION FOR DOS ATTACKS

# Block any unusual amount of traffic on ports 80 and 443 
iptables -t mangle -A PREROUTING -p tcp --dport 80 --tcp-flags ALL SYN -m recent --update --hitcount 1 --seconds 1 -j DROP
iptables -t mangle -A PREROUTING -p tcp --dport 80 --tcp-flags ALL SYN -m recent --set

iptables -t mangle -A PREROUTING -p tcp --dport 443 --tcp-flags ALL SYN -m recent --update --hitcount 1 --seconds 1 -j DROP
iptables -t mangle -A PREROUTING -p tcp --dport 443 --tcp-flags ALL SYN -m recent --set

# Accept only if the the client is sending at most 10 packets to the server in a second
iptables -t mangle -A PREROUTING -p tcp --dport 443 -m limit --limit 10/s -j ACCEPT
iptables -t mangle -A PREROUTING -p tcp --dport 80 -m limit --limit 10/s -j ACCEPT

# Block any attempt to open more than 4 concurrent connections 
iptables -t filter -A INPUT -p tcp -m connlimit --connlimit-above 4 -j REJECT

# Allow legitimate traffic
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Accept rules for INPUT
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW --tcp-flags ALL SYN -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW --tcp-flags ALL SYN -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW --tcp-flags ALL SYN -j ACCEPT

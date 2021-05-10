# Xerxes Defender
XerXeS is an extremely efficient DoS tool, developed by the hacker The Jester (th3j35t3r) to automate DoS attacks. It provides the capacity to launch multiple independent attacks against several target sites without necessarily requiring a botnet.

It relies on the idea of opening multiple concurrent connections from one computer and sending as many traffic to the website as possible through those established connections. xerxes-defender doesn't allow more concurrent connections than 4 and it blocks the traffic if it's receiving more than 10 packets per second.

xerxes-defender will also flush all previous iptables rules and it doesn't offer decent rules for output chain. It's recommended to take a backup of your previous firewall configuration before you execute the script. Output rules can be added in the script as well.

# How to Use
$ chmod +x xerxes-defender.sh
$ ./xerxes-defender.sh

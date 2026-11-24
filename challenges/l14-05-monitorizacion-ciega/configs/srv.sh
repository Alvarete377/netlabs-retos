echo 'rocommunity netlabs-ro 10.0.0.10/32' > /etc/snmp/snmpd.conf.d/netlabs.conf
echo 'agentaddress udp:161' >> /etc/snmp/snmpd.conf.d/netlabs.conf
sed -i 's/^rocommunity /#rocommunity /; s/^rocommunity6 /#rocommunity6 /' /etc/snmp/snmpd.conf
systemctl restart snmpd 2>/dev/null || true

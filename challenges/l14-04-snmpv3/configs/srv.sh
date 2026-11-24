sed -i 's/^agentaddress .*/agentaddress udp:161/' /etc/snmp/snmpd.conf
sed -i 's/^rocommunity /#rocommunity /; s/^rocommunity6 /#rocommunity6 /' /etc/snmp/snmpd.conf
echo 'rocommunity netlabs-ro 10.0.0.10/32' > /etc/snmp/snmpd.conf.d/netlabs.conf
systemctl restart snmpd

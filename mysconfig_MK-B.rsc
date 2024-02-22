# jan/04/1970 02:06:29 by RouterOS 6.48.6
# software id = MHR9-40WD
#
# model = RB760iGS
# serial number = HDE08FV652F
/interface bridge
add admin-mac=18:FD:74:FA:D7:AF auto-mac=no comment=defconf name=bridge
/interface vlan
add interface=bridge name=vlan30 vlan-id=30
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip ipsec peer
add address=192.168.13.78/32 exchange-mode=ike2 name=MK-Sempere-A
/ip ipsec profile
set [ find default=yes ] dh-group=modp2048 enc-algorithm=aes-256 \
    hash-algorithm=sha256
/ip ipsec proposal
set [ find default=yes ] auth-algorithms=sha256 enc-algorithms=aes-256-cbc \
    pfs-group=modp2048
/ip pool
add name=dhcp-rack ranges=30.40.40.100-30.40.40.149
/ip dhcp-server
add address-pool=dhcp-rack disabled=no interface=vlan30 name=DHCP-RACK
/interface bridge port
add bridge=bridge comment=defconf interface=ether2
add bridge=bridge comment=defconf interface=ether3
add bridge=bridge comment=defconf interface=ether4
add bridge=bridge comment=defconf interface=ether5
add bridge=bridge comment=defconf interface=sfp1
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface bridge vlan
add bridge=bridge tagged=ether2 vlan-ids=30
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1 list=WAN
/ip address
add address=30.40.40.254/24 disabled=yes interface=ether2 network=30.40.40.0
add address=192.168.13.77/24 interface=ether1 network=192.168.13.0
add address=30.40.40.254/24 interface=vlan30 network=30.40.40.0
/ip dhcp-client
add comment=defconf interface=ether1
/ip dhcp-server lease
add address=30.40.40.11 mac-address=B6:B9:46:59:F6:8C server=DHCP-RACK
add address=30.40.40.12 client-id=\
    ff:ca:53:9:5a:0:2:0:0:ab:11:25:ec:7e:35:f1:11:31:60 mac-address=\
    9E:24:BA:C3:78:6F server=DHCP-RACK
add address=30.40.40.13 mac-address=B2:8B:14:5E:FC:EA server=DHCP-RACK
add address=30.40.40.14 client-id=\
    ff:ca:53:9:5a:0:2:0:0:ab:11:70:5d:62:af:cc:3f:db:77 mac-address=\
    7A:C5:CC:BC:8E:09 server=DHCP-RACK
add address=30.40.40.15 client-id=1:92:6:e:93:37:e4 mac-address=\
    92:06:0E:93:37:E4 server=DHCP-RACK
/ip dhcp-server network
add address=30.40.40.0/24 dns-server=30.40.40.11,30.40.40.14 domain=\
    domsempere.lan gateway=30.40.40.254 netmask=24
/ip dns
set allow-remote-requests=yes servers=192.168.13.254
/ip dns static
add address=192.168.88.1 comment=defconf name=router.lan
/ip firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input comment=\
    "defconf: accept to local loopback (for CAPsMAN)" dst-address=127.0.0.1
add action=accept chain=input comment="defconf: drop all not coming from LAN" \
    in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept in ipsec policy" \
    ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" \
    ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf: drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new disabled=yes in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none log=yes log-prefix=srcnat out-interface-list=WAN
/ip ipsec identity
add peer=MK-Sempere-A secret=Sempere4
/ip ipsec policy
set 0 disabled=yes
add disabled=yes dst-address=10.40.40.0/24 peer=MK-Sempere-A src-address=\
    30.40.40.0/24 tunnel=yes
/ip route
add distance=1 gateway=192.168.13.254
add distance=1 dst-address=10.40.40.0/24 gateway=192.168.13.78
add disabled=yes distance=1 dst-address=30.40.40.0/24 gateway=ether2
/system identity
set name=RouterOS
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN

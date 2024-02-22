# 2024-02-21 13:51:09 by RouterOS 7.13.4
# software id = 
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
/interface list
add name=WAN
add name=LAN
/ip ipsec peer
add address=192.168.13.77/32 exchange-mode=ike2 name=MK-Sempere-B
/ip ipsec profile
set [ find default=yes ] dh-group=modp2048 enc-algorithm=aes-256 \
    hash-algorithm=sha256
/ip ipsec proposal
set [ find default=yes ] auth-algorithms=sha256 enc-algorithms=aes-256-cbc \
    pfs-group=modp2048
/ip pool
add name=dhcp-lan ranges=10.40.40.10-10.40.40.99
add name=poolSempereVPN ranges=4.4.4.10-4.4.4.100
/ip dhcp-server
add address-pool=dhcp-lan interface=ether2 name=DHCP-VLAN10
/ppp profile
set *0 local-address=4.4.4.1 remote-address=poolSempereVPN
/ipv6 settings
set max-neighbor-entries=16384
/interface list member
add interface=ether1 list=WAN
add interface=ether2 list=LAN
/interface sstp-server server
set authentication=mschap2 certificate=certClient2Site-VPN-Sempere enabled=\
    yes
/ip address
add address=192.168.13.78/24 interface=ether1 network=192.168.13.0
add address=10.40.40.254/24 interface=ether2 network=10.40.40.0
/ip dhcp-client
add disabled=yes interface=ether1
/ip dhcp-server lease
add address=10.40.40.12 mac-address=08:00:27:91:50:6E server=DHCP-VLAN10
add address=10.40.40.14 mac-address=08:00:27:C9:80:89 server=DHCP-VLAN10
add address=10.40.40.13 mac-address=08:00:27:E7:9D:C0 server=DHCP-VLAN10
add address=10.40.40.15 mac-address=08:00:27:D9:7C:C5 server=DHCP-VLAN10
add address=10.40.40.51 client-id=1:8:0:27:5c:8a:1e mac-address=\
    08:00:27:5C:8A:1E server=DHCP-VLAN10
add address=10.40.40.41 client-id=\
    ff:af:81:8f:7d:0:2:0:0:ab:11:e6:68:9b:14:84:5d:dc:15 mac-address=\
    08:00:27:62:9A:48 server=DHCP-VLAN10
/ip dhcp-server network
add address=10.40.40.0/24 dns-server=10.40.40.254,30.40.40.11,30.40.40.14 \
    domain=domsempere.lan gateway=10.40.40.254
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,10.239.3.7
/ip firewall filter
add action=accept chain=forward disabled=yes
add action=accept chain=forward connection-state=\
    established,related,untracked
add action=fasttrack-connection chain=forward connection-state=\
    established,related hw-offload=yes
add action=accept chain=forward ipsec-policy=out,ipsec
add action=accept chain=forward ipsec-policy=in,ipsec
add action=accept chain=input in-interface-list=!LAN
add action=accept chain=input dst-address=127.0.0.1
add action=accept chain=input protocol=!icmp
add action=accept chain=input connection-state=established,related,untracked
add action=drop chain=input connection-state=invalid
/ip firewall nat
add action=masquerade chain=srcnat ipsec-policy=out,none log=yes \
    out-interface-list=WAN
/ip firewall service-port
set irc disabled=no
set rtsp disabled=no
/ip ipsec identity
add peer=MK-Sempere-B
/ip ipsec policy
set 0 disabled=yes
add disabled=yes dst-address=30.40.40.0/24 peer=MK-Sempere-B src-address=\
    10.40.40.0/24 tunnel=yes
/ip route
add disabled=no dst-address=30.40.40.0/24 gateway=192.168.13.77 \
    routing-table=main suppress-hw-offload=no
/ppp secret
add name=sergi
/system clock
set time-zone-name=Europe/Madrid
/system identity
set name=MK-Sempere-A
/system logging
add topics=firewall
/system note
set show-at-login=no


# remote over to HV1-NUG
Enter-PSSession -ComputerName HV1-NUG


# create a switch
New-VMSwitch -SwitchName vInternal -SwitchType Internal

# configure switch IP (gateway)
New-NetIPAddress -IPAddress 10.10.0.1 -PrefixLength 24 -InterfaceAlias "vEthernet (vInternal)"

# configure network address translation
New-NetNAT -Name "vNAT" -InternalIPInterfaceAddressPrefix 10.10.0.0/24

# add a virtual NIC
Add-VMNetworkAdapter -VMName CORE-NUG -SwitchName vInternal


# exit remote session
Exit-PSSession
# Proposal

Linux LiveCD that hosts 1 service:
  - Kea - DHCP

- Leverage kea since it has the ability to act on the DHCP lease.
  - Ensure dir indicator is clear: `latest/<arch>/<model>.img` or something like that
- Create an upgrade script
> https://openwrt.org/docs/guide-user/installation/sysupgrade.cli
```
expect-ssh@<host>: "cat /etc/scale_release" | grep <scale_ver> && exit 0 # no need to upgrade
scp openwrt-<ar71xx>-<scale_ver>-sysupgrade.bin root@<host>:/tmp
expect-ssh@<hosts>: "sysupgrade -v /tmp/firmware_image.bin"
# wait like autoflasher
serverspec
```
- except script to trigger to try to SSH into each AP that gets a lease on the network
  - Needs to be able to know img is current (check /etc/scale_release)
  - scp the img to the APs
  - Trigger upgrade to knew image
  - Wait til AP comes back
  - Run serverspec tests after upgrade script to ensure upgrade is successful

- Will need a way to know what version all APs are at
- Track the mac of the ap to ensure we know which on it is

## Pros
- Massflasher is simplier and less services than first proposal
- Decent control of what gets flashed
- Reuse immediately for in conference flashing (minus the kea autotrigger)
- Easier to calculate who was flashed and inventory that

## Cons
- Have to leverage admin ssh key or another key for flashing (could lock down in authorized_keys though
- Wont have kea as conference DHCP until 20x

## Stretch goal

Setup Kea to only upgrade a percentage of the leases for the APs on the subnet
Provide a control mechanisms to gradually update the APs by x percentage

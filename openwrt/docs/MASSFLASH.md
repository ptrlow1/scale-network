# Proposal

Linux LiveCD that hosts 3 service:
  - Kea - DHCP
  - dnsmasq - DNS
  - Webserver - Serve image via HTTP? (maybe over SSH)

- Leverage kea since it has the ability to act on the DHCP lease.
- Point the DNS server to the massflash
  - flash.scale.lan
- flash.scale.lan hosts a webserver with the image(s) we want the APs to upgrade to
  - Ensure dir indicator is clear: `latest/<arch>/<model>.img` or something like that
- Create an upgrade script
> https://openwrt.org/docs/guide-user/installation/sysupgrade.cli
```
DOWNLOAD_LINK="http://flash.scale.lan/latest/$arch/$model.img"; SHA256SUMS="http://flash.scale.lan/latest/$arch/$model.256shasum"
cd /tmp;wget $DOWNLOAD_LINK;wget $SHA256SUMS;sha256sum -c sha256sums 2>/dev/null|grep OK
sysupgrade -v /tmp/firmware_image.bin
```
- except script to trigger to try to SSH into each AP that gets a lease on the network
  - Needs to be able to know img is current (check /etc/scale_release)
  - scp the upgrade script to the APs (only temporary until we know all of them have this in future versions)
  - Trigger upgrade script
  - Run serverspec tests after upgrade script to ensure upgrade is successful

## Stretch goal

Setup DHCP option with a boolean flag for upgrading that leverage the upgrade script
Update udhcpc to handle new option 227? and launch the ability to upgrade all boxes
  - Jitter for upgrade being launched from udhcpc? Renewals might already be offset but just a thought
Will need a way to know what version all APs are at

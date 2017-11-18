# Home Assistant Configuration

My HA configuration

## Zwave Stick

In /etc/udev/rules.d/10-zwave-static.rules

```
ACTION=="add", ATTRS{idVendor}=="0658", ATTRS{idProduct}=="0200", SYMLINK+="zwave"
```

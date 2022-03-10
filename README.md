This is an extension for Drive Badger. It provides a so called hook script, that:

- scans given filesystem for `*.vmdk` files containing VMware virtual drive images
- mounts and exfiltrates found files (instead of just copying the whole images to the storage drive)

### Installing

Clone this repository as `/opt/drivebadger/hooks/hook-virtual` directory on your Drive Badger persistent partition.

When you install this hook, you should also install [`exclude-virtual`](https://github.com/drivebadger/exclude-virtual)
configuration repository - otherwise virtual drive images will be exfiltrated twice: mounted filesystem contents,
and images themselves. Note that `exclude-virtual` extension excludes also ISO images.

### More information

- [Drive Badger main repository](https://github.com/drivebadger/drivebadger)
- [Drive Badger wiki](https://github.com/drivebadger/drivebadger/wiki)
- [description, how hook repositories work](https://github.com/drivebadger/drivebadger/wiki/Hook-repositories)

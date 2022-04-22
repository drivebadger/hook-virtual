This is an extension for Drive Badger. It provides a so called hook script, that:

- scans given filesystem for virtual drive image files (`*.vmdk` for VMware, `*.vhd` and `*.vhdx` for Hyper-V)
- mounts and exfiltrates found files (instead of just copying the whole images to the storage drive)

### Installing

Clone this repository as `/opt/drivebadger/hooks/hook-virtual` directory on your Drive Badger persistent partition.

When you install this hook, you should also install [`exclude-virtual`](https://github.com/drivebadger/exclude-virtual)
configuration repository - it excludes additional files: ISO images and Hyper-V virtual machine state files.

Also, you should read [notes about fine tuning this hook](https://github.com/drivebadger/drivebadger/wiki/Exfiltrating-virtual-servers).


### More information

- [Drive Badger main repository](https://github.com/drivebadger/drivebadger)
- [Drive Badger wiki](https://github.com/drivebadger/drivebadger/wiki)
- [description, how hook repositories work](https://github.com/drivebadger/drivebadger/wiki/Hook-repositories)

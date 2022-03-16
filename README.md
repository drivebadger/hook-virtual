This is an extension for Drive Badger. It provides a so called hook script, that:

- scans given filesystem for virtual drive image files (`*.vmdk` for VMware, `*.vhd` and `*.vhdx` for Hyper-V)
- mounts and exfiltrates found files (instead of just copying the whole images to the storage drive)

### Installing

Clone this repository as `/opt/drivebadger/hooks/hook-virtual` directory on your Drive Badger persistent partition.

When you install this hook, you should also install [`exclude-virtual`](https://github.com/drivebadger/exclude-virtual)
configuration repository - otherwise virtual drive images will be exfiltrated twice: mounted filesystem contents,
and images themselves. Note that `exclude-virtual` extension excludes also ISO images.

### Limitations

#### Limitations related to Hyper-V:

- AVHD/AVHDX image checkpoints are not supported
- all changes contained in AVHD/AVHDX files (not yet merged into VHD/VHDX) will be skipped (and lost)
- ReFS filesystems are not supported
- Cluster Shared Volumes are not supported

#### Nested virtualization

Searching for VHD/VHDX/VMDK containers inside another VHD/VHDX/VMDK container is very, very slow, and therefore
disabled by default (which may lead to data loss, if victim uses nested VMware/Hyper-V virtualization - which
fortunately is very unusual, at least using VHD/VHDX/VMDK containers).

To avoid that, you need to create these 2 files (separately for VMware and Hyper-V):

- `/opt/drivebadger/config/.allow-nested-vhd`
- `/opt/drivebadger/config/.allow-nested-vhdx`
- `/opt/drivebadger/config/.allow-nested-vmdk`

#### Task spooler and Qemu: speed vs reliability

This extension uses `task-spooler` to queue exfiltration task for each VHD/VHDX/VMDK container.
By default, it runs only 1 task at a time (except when container needs to be copied as raw file).

To speed up the exfiltration process, you can set task spooler to execute 2 (or more) simultaneous
tasks, by executing `tsp -S 2` on console. However, exfiltration of VHD/VHDX/VMDK container relies
on Qemu, which is very susceptible to all sorts of problems with these containers, or filesystems
inside them. And error handling of Qemu running in multiple instances is very unreliable, so running
multiple tasks simultaneously can cause random rsync failures, and in the worst scenario can even
lock the whole exfiltration process.

Also, running more than 3 simultaneous tasks for Hyper-V, or more than 4 for VMware will almost
certainly cause data loss.


### More information

- [Drive Badger main repository](https://github.com/drivebadger/drivebadger)
- [Drive Badger wiki](https://github.com/drivebadger/drivebadger/wiki)
- [description, how hook repositories work](https://github.com/drivebadger/drivebadger/wiki/Hook-repositories)

## Mount a directory on RAM. 

Mount a directory completely on RAM. Everything will be wiped out on reboot.

```bash
mount -o size=<x>G -t tmpfs none <dir_name>
```

### Explanation

`size=<x>G`: Sets the directory size in RAM (replace <x> with GB, e.g., size=4G for a 4GB virtual directory).

`-t tmpfs`: Specifies tmpfs as the RAM-based filesystem.

`none`: Represents the virtual directory in RAM, not tied to any physical device.

`<dir_name>`: Path to the directory where you'll access the RAM directory.

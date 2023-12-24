## Some useful commands for enumerating *nix os

| Commands | Explanation |
|----------|--------|
| `uname -a` | Print all available system information |
| `uname -r` | Kernel release |
| `uname -n` | System hostname |
| `hostname` | As above |
| `uname -m` | Linux kernel architecture (32 or 64 bit) |
| `cat /proc/version` | Kernel information |
| `cat /etc/*-release` | Distribution information |
| `cat /etc/issue` | As above |
| `cat /proc/cpuinfo` | CPU information |
| `df -a` | File system information |

 **Users & Groups:**


| Commands | Explanation |
|----------|--------|
| `cat /etc/passwd` | List all users on the system |
| `cat /etc/group` | List all groups on the system |
| `cat /etc/shadow` | Show user hashes – Privileged command |
| ```grep -v -E "^#" /etc/passwd \| awk -F: '$3 == 0 { print $1}``` | List all super user accounts |
| `finger` | Users currently logged in |
| `pinky` | As above |
| `users` | As above |
| `who -a` | As above |
| `w` | Who is currently logged in and what they’re doing |
| `last` | Listing of last logged on users |
| `lastlog` | Information on when all users last logged in |
| `lastlog –u %username%` | Information on when the specified user last logged in |

 **User & Privilege Information:** 

| Commands | Explanation |
|----------|--------|
| `whoami` | Current username |
| `id` | Current user information |
| `cat /etc/sudoers` | Who’s allowed to do what as root – Privileged command |
| `sudo -l` | Can the current user perform anything as root |

 **Environmental Information:**

| Commands | Explanation |
|----------|--------|
| `env` | Display environmental variables |
| `set` | As above |
| `echo $PATH` | Path information |
| `history` | Displays command history of current user |
| `pwd` | Print working directory, i.e. ‘where am I’ |
| `cat /etc/profile` | Display default system variables |

 **Interesting Files:**

| Commands | Explanation |
|----------|--------|
| `find / -perm -4000 -type f 2>/dev/null` | Find SUID files |
| `find / -uid 0 -perm -4000 -type f 2>/dev/null` | Find SUID files owned by root |


 **Common Shell Escape Sequences:**

| Commands | Explanation |
|----------|--------|
| `:!bash` | vi, vim |
| `:set shell=/bin/bash :shell` | vi, vim |
| `!bash` | man, more, less |
| `find / -exec /usr/bin/awk 'BEGIN {system("/bin/bash")}' \;` | find |
| `awk 'BEGIN {system("/bin/bash")}'` | awk |
| `--interactive` | nmap |
| `perl -e 'exec "/bin/bash";'` | Perl |

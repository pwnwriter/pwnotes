### Installing NixOS on a Hetzner VPS

In this guide, I will explain how to install NixOS on a Hetzner VPS from a local machine using flakes and Nix itself.

#### Requirements
- A linux os with the latest systemd, I'm using `ubuntu24.04` 
- A machine with Nix already installed (I have written a blog post on this topic).
- Root privileges to run commands.

That's it!

We will use [`nixos-anywhere`][nixos-anywhere] and [`disko`][disko] to install Nix and create declarable partitions. First, we'll import them into our `flake`. The directory structure should look like this:

<img width="212" alt="Screenshot 2024-07-02 at 12 38 41" src="https://github.com/pwnwriter/pwnotes/assets/90331517/f5c53fd0-428c-4196-b30a-b65f6f6e1a72">

You'll want to change `wood` to something else, i'm just imagining the host name for myvps as `wolf`.

- `flake.nix`

```nix
  {
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, disko, ... }: {
    nixosConfigurations.wolf = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./configuration.nix
          ./disk-config.nix
        ];
      };
  };
}
```

We'll import our `configuration.nix` and `disk-config.nix` inside our flake. Add your public ssh keys in `authorized_keys` for accessing the server after installation. 

- `configuration.nix`

```nix
{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl # define your more packages here
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "You're public ssh key"
  ];

  system.stateVersion = "23.11";
}
````

Now regarding the disk, I'm using the default disk partitions required and recommended by `disko`, If you happen to change you can. This disk partions are for 
bios compatible gpt partition.

- `disk-config.nix`
```nix
# Example to create a bios compatible gpt partition
{ lib, ... }:
{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
```

Now, we'll have to run our flake to install nix on the vps.

```
 nix run github:nix-community/nixos-anywhere -- --flake .#wolf root@<server-ip>
```
<img width="1059" alt="Screenshot 2024-07-02 at 12 51 42" src="https://github.com/pwnwriter/pwnotes/assets/90331517/1189cb4f-8df2-4dc2-9ce4-9cdc9054af06">

##### It'll ask for password to install the base of nix. 

<img width="1130" alt="Screenshot 2024-07-02 at 12 55 31" src="https://github.com/pwnwriter/pwnotes/assets/90331517/d188d41e-56b8-4e41-901e-fcf23f9e7f26">

And now, you should be able to log-in into the vps using the `ssh keys` , regardless of the password being empty. 

<img width="1001" alt="Screenshot 2024-07-02 at 12 53 43" src="https://github.com/pwnwriter/pwnotes/assets/90331517/077585c3-65e2-4a6a-a3cc-b1a26ca32ff3">



<!---links---->
[disko]: https://github.com/nix-community/disko
[nixos-anywhere]: https://github.com/nix-community/nixos-anywhere

## How to Install Nix on any Linux VPS

Nix is a versatile package manager, programming language, and even a complete
Linux distribution. It stands out with its focus on reproducibility and
declarative configuration.

#### Download and Run the Installer

We'll be using determinate system's nix installer


```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- --install
```

<img width="1150" alt="Screenshot 2024-06-26 at 12 53 49" src="https://github.com/pwnwriter/pwnotes/assets/90331517/052d3936-e718-4dfd-9ecf-4d916c4388f7">


You should have nix installed by now.

`nix --version`

<img width="370" alt="Screenshot 2024-06-26 at 12 57 01" src="https://github.com/pwnwriter/pwnotes/assets/90331517/42c43f44-9032-41e6-80f9-d159f904d428">


#### Let's install a pkg `tmux`

`nix profile install nixpkgs#tmux`

<img width="429" alt="Screenshot 2024-06-26 at 12 58 46" src="https://github.com/pwnwriter/pwnotes/assets/90331517/f54cced6-7dd5-4df5-b898-2de5d8585bfe">

#### we can even install package for temp shell

```nix-shell -p git```

<img width="802" alt="Screenshot 2024-06-26 at 13 08 29" src="https://github.com/pwnwriter/pwnotes/assets/90331517/e79584f3-a945-4024-a362-3c7c0cce85bf">

<img width="778" alt="Screenshot 2024-06-26 at 13 08 37" src="https://github.com/pwnwriter/pwnotes/assets/90331517/59405340-ed5d-47a9-9ca9-5239b3546af8">

#### Installing Home Manager

Finally, we'll use Home Manager, a tool designed to manage the user environment (e.g., dotfiles) in a declarative way using Nix. We'll start by adding the minimal configuration needed to get Home Manager up and running.

First, create a dotfiles directory if you don't have one already (the name of the directory does not matter). Use git init (or your favorite GUI) to initialize a Git repository in the folder. Add the following two files:

`mkdir dotfiles; cd dotfiles; git init`

<img width="711" alt="Screenshot 2024-06-26 at 13 13 40" src="https://github.com/pwnwriter/pwnotes/assets/90331517/aea54276-965b-40b7-b353-80b30a380e37">

```nix
{
  description = "Your description here";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations = {
      <Yourname> = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./modules
          {
            home.username = "username";
            home.stateVersion = "23.11";
            home.homeDirectory = "/home/username";
          }
        ];
      };

    };
  };
}
```

Place the above file as `flake.nix`. 

Now the directory tree should look like this

<img width="433" alt="Screenshot 2024-06-26 at 13 18 31" src="https://github.com/pwnwriter/pwnotes/assets/90331517/88e8e502-82fe-4411-92be-603ecdb9d30e">


This flake initiales all the modules from `modules` directory.

For example to configure `git`, it goes something like this

```nix
{ pkgs, ... }:
let
  name = "username";
  email = "main";
in
{
  programs.git = {
    enable = true;
    userName = name;
    userEmail = email;
  };
}
```

Now we'll need to source it inside modules,

Like `lua`'s init.lua' we have `default.nix` in `nix`.

We'll now import out `git.nix` using `modules/default.nix` file and it goes something like this.

```nix
{ config, ... }:

let
  modules = [
    ./git.nix
  ];
in
{
  imports = modules;

  xdg.dataHome = "${config.home.homeDirectory}/.local/share";
  programs.home-manager.enable = true;
}
```


We can now build our config using following.

```bash
nix run github:nix-community/home-manager -- switch --flake .#your_name
```

<img width="756" alt="Screenshot 2024-06-26 at 13 24 51" src="https://github.com/pwnwriter/pwnotes/assets/90331517/65c2aaa3-865c-452a-af34-8094d9b1aee2">

It should generate your config like below. 

<img width="1157" alt="Screenshot 2024-06-26 at 13 26 58" src="https://github.com/pwnwriter/pwnotes/assets/90331517/9355a91e-f57d-47be-87b7-cdffa5d0be4f">


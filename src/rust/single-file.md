# Rust analyzer on single file

### Allow rust-analyzer to run on single file for completion

Create a `rust-project.json` in your `directory`

```json
{
    "sysroot_src": "/home/<pwn>/.local/share/rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/",
    "crates": [
        {
            "root_module": "main.rs",
            "edition": "2021",
            "deps": []
        }
    ]
}
```

Here, i manually defined `rustup` home. By default it's `~/.rustup`
```bash
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
```

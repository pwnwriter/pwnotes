## Links
- Package manager : [Cargo][cargo]
- Toolchain installer : [Rustup][rustup]
- Book : [Thebook][thebook]
- Linter: [Clippy]

### Allow rust-analyzer to run on single file for completion

Create a `rust-project.json` in your `directory`

```json
{
    "sysroot_src": "path/to/the/library",
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

### Define `crates` deps inside a single file.

```rust
//! ```cargo
//! [dependencies]
//! clap = { version = "4.2", features = ["derive"] }
//! ```

extern crate clap;

use clap::Parser;

#[derive(Parser, Debug)]
#[clap(version)]
struct Args {
    #[arg(short, long, default_value = "PwnWriter")]
    pub name: String,
}

fn main() {
    let args = Args::parse();
    println!("{}", args.name);
}
```

<!-- Links-->
[rustlang]: https://rustlang.org
[rustup]: https://rustup.rs
[cargo]: https://github.com/rust-lang/cargo
[thebook]: https://github.com/rust-lang/book
[Clippy]: https://github.com/rust-lang/clippy


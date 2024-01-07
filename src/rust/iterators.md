# Iterators

```rust
extern crate anyhow;

use anyhow::Result;

fn main() -> Result<()> {
    let ports = vec![1, 3, 4];

    let urls = vec![
        "https://github.com",
        "https://metislinux.org",
        "https://kisslinux.org",
    ];

    let urls_with_ports: Vec<String> = urls
        .iter()
        .zip(&ports)
        .map(|(url, &port)| format!("{}:{}", url, port))
        .collect();

    for url in urls_with_ports {
        println!("{}", url);
    }

    Ok(())
}
```

## Standard Input Using Cursor

Sometimes, you may not have access to `concatenate` a file and pipe it into your
code for testing. In such situations, you can utilize the `Cursor` module.

```rust
use std::io::{Cursor, BufRead, BufReader};

fn main() {
    let cursor = Cursor::new("Hey\npwned\n".to_string());
    let buffered_reader = BufReader::new(cursor);
    for line in buffered_reader.lines() {
        println!("{}", line.unwrap());
    }
}
```

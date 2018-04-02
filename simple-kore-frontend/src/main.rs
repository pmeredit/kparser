extern crate simple_kore_frontend;

#[cfg(not(test))]
fn main() {
    use std::env;

    let args: Vec<_> = env::args().collect();

    simple_kore_frontend::process_file(&args[1]);
}

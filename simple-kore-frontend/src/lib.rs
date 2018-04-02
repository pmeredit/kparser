extern crate lalrpop_util;
extern crate regex;

#[allow(unused_macros)]
pub mod ast;
pub mod parser;

pub fn process_file(file_name: &str) {
    use std::fs::File;
    use std::io::prelude::*;

    let mut f = File::open(&file_name).expect("File Not Found");
    let mut contents = String::new();
    f.read_to_string(&mut contents).expect("Could Not Read File");

    println!("{}", parser::TopExprParser::new().parse(&contents).unwrap());
}

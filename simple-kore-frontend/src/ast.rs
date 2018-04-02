use std::fmt;

#[derive(Debug)]
pub enum Expr {
    Int(i64),
    Float(f64),
    Str(String),
    Var(String),
    MetaVar(String),
    Quant(BinOpcode, String, String, Box<Expr>),
    Func(String, Vec<String>, Vec<Box<Expr>>),
    DualSortOp(Box<Expr>, DualSortOpcode, String, String, Box<Expr>),
    UnOp(UnOpcode, String, Box<Expr>),
    BinOp(Box<Expr>, BinOpcode, String, Box<Expr>),
}

impl fmt::Display for Expr {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        use ast::Expr::*;
        match *self {
            Int(ref i) => write!(f, "\\dv{{Int{{}}}}(\"{}\")", i),
            Float(ref n) => write!(f, "\\dv{{Real{{}}}}(\"{}\")", n),
            Str(ref s) => write!(f, "\\dv{{String{{}}}}(\"{}\")", s),
            Var(ref v) => write!(f, "\\dv{{Var{{}}}}(\"{}\")", v),
            MetaVar(ref v) => write!(f, "{}{{}}", v),
            Quant(ref op, ref s, ref v, ref exp) =>
                write!(f, "{}{{{}{{}}}}({}{{}}, {})", op, s, v, exp),
            Func(ref s, ref sl, ref el) => {
                let sls = sl
                    .into_iter()
                    .map(|x| format!("{}", x))
                    .fold("".to_string(), |acc, y| format!("{},{}", acc, y));
                let els = el
                    .into_iter()
                    .map(|x| format!("{}", x))
                    .fold("".to_string(), |acc, y| format!("{},\n{}", acc, y));
                write!(f, "{}{{{}}}({})\n", s, sls, els)
            },
            DualSortOp(ref le, ref o, ref s1, ref s2, ref re) => write!(f, "{}{{{}{{}},{}{{}}}}({},\n{})\n", o, s1, s2, le, re),
            UnOp(ref o, ref s, ref e) => write!(f, "{}{{{}{{}}}}({})\n", o, s, e),
            BinOp(ref le, ref o, ref s, ref re) => write!(f, "{}{{{}{{}}}}({},\n{})\n", o, s, le, re),
        }
    }
}

#[derive(Debug)]
pub enum DualSortOpcode {
    Equals,
    In,
}

impl fmt::Display for DualSortOpcode {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        use ast::DualSortOpcode::*;
        match *self {
            Equals => write!(f, "{}", "\\equals"),
            In => write!(f, "{}", "\\in"),
        }
    }
}

#[derive(Debug)]
pub enum UnOpcode {
    Not,
}

impl fmt::Display for UnOpcode {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            UnOpcode::Not => write!(f, "{}", "\\not"),
        }
    }
}

#[derive(Debug)]
pub enum BinOpcode {
    And,
    Or,
    Implies,
    Iff,
    ForAll,
    Exists,
    In,
}

impl fmt::Display for BinOpcode {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        use ast::BinOpcode::*;
        match *self {
            And     => write!(f, "{}", "\\and"),
            Or      => write!(f, "{}", "\\or"),
            Implies => write!(f, "{}", "\\implies"),
            Iff     => write!(f, "{}", "\\iff"),
            ForAll  => write!(f, "{}", "\\forall"),
            Exists  => write!(f, "{}", "\\exists"),
            In      => write!(f, "{}", "\\in"),
        }
    }
}


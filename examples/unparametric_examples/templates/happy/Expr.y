{
-- only list imports here
import Data.Char
}

%tokentype { Token }

%lexer { lexer } { TokenEOF }

%token
    ';'     { Sym ";"  }
    '<'     { Sym "<"  }
    '>'     { Sym ">"  }
    '>>'    { Sym ">>" }
    t       { AType $$ }
    v       { AVar $$  }
%%

Stmt : Type Exp ';' {}
     | Exp ';'      {}

Exp  : v            {}
     | Exp '>>' Exp {}
     | Exp '<' Exp  {}

Type : Type '<' Type '>' {}
     | t                 {}
{

data Token
    = TokenEOF
    | Sym String
    | AType {getString :: String}
    | AVar  {getString :: String}
    | ErrorTok
  deriving (Show, Eq, Ord)

lexer :: String -> [[Token]]
lexer s = filter (\x -> x /= []) $ lexerAux s ""

lexerAux :: String -> String -> [[Token]]
lexerAux [] buf = [promoteBuf buf]
lexerAux (' ':cs) buf = (promoteBuf buf) : (lexerAux cs " ")
lexerAux (';':cs) buf = (promoteBuf buf) : (lexerAux cs ";")
lexerAux ('<':cs) buf = (promoteBuf buf) : (promoteBuf "<") : (lexerAux cs "")
lexerAux ('>':cs) buf = (if buf == ">" then [Sym ">>", Sym ">"]
                                       else promoteBuf buf) : (lexerAux cs ">")
lexerAux (c:cs) buf   = lexerAux cs $ buf ++ [c]

promoteBuf :: String -> [Token]
promoteBuf " " = []
promoteBuf "<" = [Sym "<"]
promoteBuf ">" = [Sym ">"]
promoteBuf ";" = [Sym ";"]
promoteBuf  s  = [AType $ dropWhile isSpace s, AVar $ dropWhile isSpace s]

}

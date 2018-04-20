{
-- only list imports here
import Data.Char
}

%tokentype { Token }

%lexer { lexer } { TokenEOF }

%token
	"==" 	{ Sym "==" }
	"<" 	{ Sym "<" }
	">" 	{ Sym ">" }
	"if" 	{ Sym "if" }
	"then" 	{ Sym "then" }
	"else" 	{ Sym "else" }
	s 	    { AVar $$ }

%%
 Stmt : Exp {}
     | "if" Exp "then" Stmt {}
     | "if" Exp "then" Stmt "else" Stmt {}
 Exp : Exp "==" Exp  {}
     | Exp "<" Exp   {}
     | Exp ">" Exp   {}
     | s {}


{

data Token
	= TokenEOF
	| Sym String
	| AVar {getString :: String}
  deriving (Show,Eq, Ord)


lexer :: String -> [Token]
lexer [] = []
lexer (' ':cs) = lexer cs

lexer cs = let (s, rest) = findEnd cs in
       (if s == "==" then Sym "=="
  else if s == "<"  then Sym "<"
  else if s == ">"  then Sym ">"
  else if s == "if"  then Sym "if"
  else if s == "then"  then Sym "then"
  else if s == "else"  then Sym "else"
  else AVar s) : lexer rest

findEnd :: String -> (String, String)
findEnd cs = findEndAux cs ""

findEndAux :: String -> String -> (String, String)
findEndAux [] buf = (buf, [])
findEndAux (c:cs) buf = if c == ' ' then (buf, cs) else findEndAux cs (buf ++ [c])
}

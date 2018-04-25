{
-- only list imports here
import Data.Char
}

%tokentype { Token }

%lexer { lexer } { TokenEOF }

%token
	'*' 	{ Sym "*" }
	'+' 	{ Sym "+" }
	i 	   { AnInt $$ }
    s       { AVar $$ }
%%

E : E '+' E   {}
  | E '*' E   {}
  | s         {}
  | i         {}

{

data Token
	= TokenEOF
    | Sym String
	| AnInt {getInt :: Int}
	| AVar  {getString :: String}
  deriving (Show,Eq, Ord)

lexer :: String -> [Token]
lexer [] = []
lexer (' ':cs) = lexer cs

lexer cs = let (s, rest) = findEnd cs in
 (if s == "*" then Sym "*"
  else if s == "+"  then Sym "+"
  else if s == ">"  then Sym ">"
  else if isNumberS s then AnInt (read s)
  else AVar s) : lexer rest

findEnd :: String -> (String, String)
findEnd cs = findEndAux cs ""

findEndAux :: String -> String -> (String, String)
findEndAux [] buf = (buf, [])
findEndAux (c:cs) buf = if c == ' ' then (buf, cs) else findEndAux cs (buf ++ [c])

isNumberS :: String -> Bool
isNumberS s = if s == [] then False else isNumberSAux s
isNumberSAux :: String -> Bool
isNumberSAux [] = True
isNumberSAux (c:cs) = if isDigit c then isNumberSAux cs else False
}

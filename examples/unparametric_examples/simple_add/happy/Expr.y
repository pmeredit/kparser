{
-- only list imports here
import Data.Char
}

%tokentype { Token }

%lexer { lexer } { TokenEOF }

%token
	'+' 	{ Sym "+" }
	i 	   { AnInt $$ }
%%

E : E '+' E   {}
  | i         {}

{

data Token
	= TokenEOF
    | Sym String
	| AnInt {getInt :: Int}
  deriving (Show,Eq, Ord)

lexer :: String -> [Token]
lexer [] = []

lexer (c:cs) = if c == ' ' then lexer cs
               else let (s, rest) = findEnd (c:cs) in
			        if s == "" then lexer rest
					else 
                       (   if s == "*" then Sym "*"
                           else if s == "+"  then Sym "+"
                           else AnInt (read s)
                       ) : lexer rest

findEnd :: String -> (String, String)
findEnd [] = ("", "")
findEnd (c:cs) = findEndAux cs [c]

findEndAux :: String -> String -> (String, String)
findEndAux [] buf = (buf, [])
findEndAux (c:cs) buf = if c `elem` " +*" then (buf, c:cs) else findEndAux cs (buf ++ [c])
}

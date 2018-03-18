module TEST 
  syntax {S} Stmt ::= "if" Exp "then" S "else" S [symbol(ite)]
  syntax Stmt     ::= Exp 
  syntax Exp      ::= Exp "==" Exp [symbol(eq)]
  syntax Exp      ::= Var
  syntax Var      ::= r"[A-Za-z][A-Za-z0-9]*"

endmodule

input(Stmt): if {Var} x == y then s1 else s2
input(Stmt): if x == y then {Stmt} s1 else s2

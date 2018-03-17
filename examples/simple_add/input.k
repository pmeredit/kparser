module TEST 
 syntax Int ::= r"[0-9]+" [token] 
 syntax Exp ::= Exp "+" Exp [klabel(plus)] 
 syntax Exp ::= Int [klabel(inj)] 
endmodule 

input(Int): 1
input(Exp): 1
input(Exp): 1+2
input(Exp): 1+2+3

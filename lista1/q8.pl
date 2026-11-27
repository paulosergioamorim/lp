binario(0) :- !, write(0).
binario(X) :- R is X mod 2, Rest is X // 2, binario(Rest), write(R).

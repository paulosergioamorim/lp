num(0,nulo).
num(N,positivo) :- N>0, !.
num(N,negativo) :- N<0.

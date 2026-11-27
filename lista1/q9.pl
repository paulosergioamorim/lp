estrada(a,d,23).
estrada(a,b,25).
estrada(b,c,19).
estrada(c,d,14).
estrada(d,f,30).
estrada(c,f,28).
estrada(e,f,26).
estrada(b,e,32).

dist(X,X,0) :- !.
dist(X,Y,D) :- estrada(X,Y,D), !.
dist(X,Y,D) :- estrada(X,Z,Dx), estrada(Z,Y,Dy), D is Dx + Dy.

rota(X,X,[]) :- !.
rota(X,Y,[Y]) :- estrada(X,Y,_), !.
rota(X,Y,[Z|R]) :- estrada(X,Z,_), rota(Z,Y,R), !.

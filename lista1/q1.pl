mae(ana, eva).
mae(bia, ary).
mae(bia, clo).
mae(bia, rai).
mae(eva, noe).
mae(lia, gal).

pai(ary, gal).
pai(gil, ary).
pai(gil, clo).
pai(gil, rai).
pai(ivo, eva).
pai(rai, noe).

mulher(ana).
mulher(eva).
mulher(lia).
mulher(clo).
mulher(gal).
mulher(bia).

homem(ary).
homem(gil).
homem(ivo).
homem(rai).
homem(noe).

gerou(X,Y) :- mae(X,Y); pai(X,Y).

filho(X,Y) :- homem(X), gerou(Y,X).
filha(X,Y) :- mulher(X), gerou(X,Y).

irmao(X,Y) :- dif(X,Y), gerou(Z,X), gerou(Z,Y).

tio(X,Y) :- homem(X), irmao(X,Z), gerou(Z,Y).
tia(X,Y) :- mulher(X), irmao(X,Z), gerou(Z,Y).

primo(X,Y) :- gerou(Z,X), (tio(Z,Y); tia(Z,Y)).

avo(X,Y) :- homem(X), gerou(X,Z), gerou(Z,Y).
avo(X,Y) :- mulher(X), gerou(X,Z), gerou(Z,Y).

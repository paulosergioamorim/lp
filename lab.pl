% A
genitor(joana,joao).
genitor(joao,jose).
genitor(joao,maria).
genitor(jose,ana).
genitor(jose,paulo).
genitor(maria,pedro).

irmao(X,Y) :- genitor(Z,X),genitor(Z,Y),dif(X,Y).
primo(X,Y) :- genitor(Z,X),genitor(W,Y),irmao(Z,W).
neto(X,Y) :- genitor(Z,X),genitor(Y,Z).
descendente(X,Y) :- genitor(Y,X).
descendente(X,Y) :- genitor(Y,Z),descendente(X,Z).

% B
casados(carlos, maria).
casados(maria,carlos).
casados(pedro, julia).
casados(julia, pedro).
casados(antonio, mariana).
casados(mariana, antonio).

solteiro(X) :- \+ casados(_, X).
filho_unico(X) :- \+ irmao(_, X).

% C
pessoa(mia).
tipo_de_animal(cachorro).
tipo_de_animal(gato).
tipo_de_animal(tigre).
tipo_de_animal(X) :- tipo_peconhento(X).
tipo_peconhento(cobra).
tipo_peconhento(aranha).
tipo_peconhento(escorpiao).
gostaDe(X, Y) :- pessoa(X), tipo_de_animal(Y), condicao(Y).
condicao(Y) :- tipo_peconhento(Y), !, false.
condicao(_).
gostaDe2(X, Y) :- pessoa(X), tipo_de_animal(Y), tipo_peconhento(Y), !, false.

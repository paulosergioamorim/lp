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
casal(joana, antonio).
casal(joao, roberta).
casal(pedro, mariana).

% Para evitar a recursão infinita de definir fatos casados(a,b) e uma regra
% simétrica, separa-se os fatos das regras.

casados(X,Y) :- casal(X,Y) ; casal(Y,X).

% Sem pessoa(X), o prolog interpreta da seguinte forma: não existe X tal que
% casados(_, X)? Obviamente, existe tal X na base de dados, então quando a
% consulta é solteiro(X) (o usuário provavelmente quer consultar todos os
% solteiros), o resultado é false, pois existem casados. Ao colocar pessoa(X)
% antes da cláusula de negação, fixamos o valor de X = a, e então \+ casados(_,
% a) se comporta como a negação lógica.
solteiro(X) :- pessoa(X), \+ casados(_, X).
filho_unico(X) :- pessoa(X), \+ irmao(_, X).

% C
pessoa(mia).
pessoa(jose).
pessoa(joana).
pessoa(joao).
pessoa(maria).
pessoa(paulo).
pessoa(ana).
pessoa(pedro).
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

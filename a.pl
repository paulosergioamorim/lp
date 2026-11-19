genitor_(joana,joao).
genitor_(joao,jose).
genitor_(joao,maria).
genitor_(jose,ana).
genitor_(jose,paulo).
genitor_(maria,pedro).

irm_(X,Y) :- genitor_(Z,X),genitor_(Z,Y),dif(X,Y).
prim_(X,Y) :- genitor_(Z,X),genitor_(W,Y),irm_(Z,W).
net_(X,Y) :- genitor_(Z,X),genitor_(Y,Z).
descendente(X,Y) :- genitor_(Y,X).
descendente(X,Y) :- genitor_(Y,Z),descendente(X,Z).

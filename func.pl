head([X|_], X).
tail([_|Xs], Xs).
last([_|Xs], X) :- last(Xs, X), !.
last([X|[]], X).
init([X|Xs], [X|R]) :- init(Xs, R), !.
init([_|[]], []).

map(_,[],[]).
map(F,[X|Xs],[M|R]) :- call(F,X,M), map(F,Xs,R).

filter(_,[],[]).
filter(P,[X|Xs],R) :- (call(P,X) -> R = [X|Rest] ; R = Rest), filter(P,Xs,Rest).

% reduce
foldr(_,Z,[],Z).
foldr(F,Z,[X|Xs],R) :- foldr(F,Z,Xs,Aux), call(F,X,Aux,R).

foldl(_,Z,[],Z).
foldl(F,Z,[X|Xs],R) :- call(F,Z,X,Aux), foldl(F,Aux,Xs,R).

doubleIt(X, R) :- R is 2 * X.

odd(X) :- R is X mod 2, R == 1.
even(X) :- \+ odd(X).

sum(X,Y,R) :- R is X + Y.
sub(X,Y,R) :- R is X - Y.

min([X|[]], X) :- !.
min([X|Xs], X) :- min(Xs, M), X < M, !.
min([_|Xs], M) :- min(Xs, M).

selectionSort([], []).
selectionSort([Head|Tail], [Min|R]) :- min([Head|Tail],Min), selectchk(Min, [Head|Tail], Rest), selectionSort(Rest, R).

p(1).

max([X], X) :- !.
max([X|Xs], R) :- max(Xs, Aux), (X > Aux -> R = X ; R = Aux).

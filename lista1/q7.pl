produto(_, 0, 0) :- !.
produto(0, _, 0) :- !.
produto(X, Y, R) :- Pred is Y - 1, produto(X, Pred, Aux), R is X + Aux.

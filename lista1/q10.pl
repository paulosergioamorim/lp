ultimo([X], X) :- !.
ultimo([_|Xs], R) :- ultimo(Xs, R).

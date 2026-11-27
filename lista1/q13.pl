init([_], []) :- !.
init([X|Xs], [X|R]) :- init(Xs, R).

inv([], []) :- !.
inv(Xs, [L|R]) :- ultimo(Xs, L), init(Xs, Init), inv(Init, R).

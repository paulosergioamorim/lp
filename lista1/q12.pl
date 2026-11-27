anexa([], Ys, Ys).
anexa([X|Xs], Ys, [X|R]) :- anexa(Xs, Ys, R).

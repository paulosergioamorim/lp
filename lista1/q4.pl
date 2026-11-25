pessoa(ana,f,23,1.55,56.0).
pessoa(bia,f,19,1.71,61.3).
pessoa(ivo,m,22,1.80,70.5).
pessoa(lia,f,17,1.85,57.3).
pessoa(eva,f,28,1.75,68.7).
pessoa(ary,m,25,1.72,68.9).

mulher(X) :- pessoa(X, S, _, _, _), S == f.
homem(X) :- pessoa(X, S, _, _, _), S == m.

% mulher(X), pessoa(X, _, I, _, _), I > 20.
% pessoa(X, _, _, A, P), A >= 1.70, P < 65.
% homem(X), mulher(Y), pessoa(X, _, _, Ax, _), pessoa(Y, _, _, Ay, _), Ax > Ay.

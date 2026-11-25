% país(Nome, Área, População)
pais(brasil, 9, 130).
pais(china, 12, 1800).
pais(eua, 9, 230).
pais(india, 3, 450).

densidade(Pais, D) :- pais(Pais, A, P), D is P / A.

mais_populoso(X, Y) :- pais(X, _, P1), pais(Y, _, P2), P1 > P2.

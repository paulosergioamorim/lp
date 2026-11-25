filho(paulo, emilia).
filho(paulo, sergio).

feliz(X) :- filho(_, X).
casal(X,Y) :- dif(X,Y), filho(Z, X), filho(Z, Y).

:- dynamic pos/2.
pos(robo, garagem).
pos(tv, sala).

:- dynamic pego/1.

ande(X) :- pos(robo, X), !, fail.
ande(X) :- pos(robo, Y), format("anda de ~w até ~w\n", [Y, X]), retract(pos(robo, _)), asserta(pos(robo, X)).

pegue(robo) :- !, fail.
pegue(O) :- pego(O), !, fail.
pegue(O) :- pos(robo, X), pos(O, Y),
    (
        X == Y ->
            format("pega ~w\n", [O]), retract(pos(O, _)), asserta(pego(O)), asserta(pos(O, Z) :- pos(robo, Z))
            ; ande(Y), pegue(O) 
    ).

solte(O) :-
    pego(O),
    pos(robo, X),
    format("solta ~w\n", [O]),
    retract(pego(O)),
    retract(pos(O, Z) :- pos(robo, Z)), 
    asserta(pos(O, X)).


:- dynamic lampada/1.
lampada(apagada).

liga :- retract(lampada(_)), asserta(lampada(acessa)).
desliga :- retract(lampada(_)), asserta(lampada(apagada)).

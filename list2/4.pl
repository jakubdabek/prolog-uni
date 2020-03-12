% rule(X, Op, Y, Result) :- Result is the simplified value of expression (X `op` Y)
rule(X, +, Y, Y) :-
    number(X),
    X =:= 0, !.

rule(X, +, Y, X) :-
    number(Y),
    Y =:= 0, !.

rule(X, *, Y, Y) :-
    number(X),
    X =:= 1.

rule(X, *, Y, X) :-
    number(Y),
    Y =:= 1, !.

rule(X, *, _, 0) :-
    number(X),
    X =:= 0, !.

rule(_, *, Y, 0) :-
    number(Y),
    Y =:= 0, !.

rule(X, +, -X, 0) :- !.

rule(X, -, X, 0) :- !.

rule(X, /, X, 1) :- \+ (number(X), X =:= 0), !.

rule(X, Op, Y, Res) :- Res =.. [Op, X, Y].

% rule(Op, X, Result) :- Result is the simplified value of expression (`op` Y)
rule(-, X, Y) :-
    number(X),
    Y is -X, !.

rule(-, -X, X) :- !.

rule(+, X, X) :- !.

rule(Op, X, Res) :- Res =.. [Op, X].

% simplify(Term, Simplified) :- Simplified is Term simplified as much as rules allow
simplify(Term, Term) :- Term =.. [_], !.
simplify(Term, Simplified) :-
    Term =.. [Op, X],
    simplify(X, XS),
    rule(Op, XS, Simplified).
simplify(Term, Simplified) :-
    Term =.. [Op, X, Y],
    simplify(X, XS),
    simplify(Y, YS),
    rule(XS, Op, YS, Simplified).

% simplify(a*(b*c/c-b), 0). doesn't work
% simplify(a*(b*(c/c)-b), 0). does

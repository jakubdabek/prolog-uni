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

operands(+, normal, +, normal, normal).
operands(+, normal, -, normal, inverted).
operands(+, inverted, +, inverted, inverted).
operands(+, inverted, -, inverted, normal).

operands(*, normal, *, normal, normal).
operands(*, normal, /, normal, inverted).
operands(*, inverted, *, inverted, inverted).
operands(*, inverted, /, inverted, normal).

same_priority(Term, OpType, Terms-TermsRest) :-
    Term =.. [Mode, Expr],
    Expr =.. [Op, X, Y],
    operands(OpType, Mode, Op, LeftMode, RightMode),
    Left =.. [LeftMode, X],
    Right =.. [RightMode, Y],
    same_priority(Left, OpType, Terms-RightTerms),
    same_priority(Right, OpType, RightTerms-TermsRest), !.

same_priority(Term, OpType, Terms) :-
    Term =.. [Op, _, _],
    operands(OpType, normal, Op, _, _),
    same_priority(normal(Term), OpType, Terms-[]), !.

same_priority(Term, _, [Term|Terms]-Terms).


same_priority_2(X*Y, *, Terms) :-
    same_priority_2(mul(X*Y), *, Terms), !.
same_priority_2(X/Y, *, Terms) :-
    same_priority_2(div(X/Y), *, Terms), !.
same_priority_2(mul(X*Y), *, Terms) :-
    same_priority_2(mul(X), *, XTerms),
    same_priority_2(mul(Y), *, YTerms),
    append(XTerms, YTerms, Terms), !.
same_priority_2(mul(X/Y), *, Terms) :-
    same_priority_2(mul(X), *, XTerms),
    same_priority_2(div(Y), *, YTerms),
    append(XTerms, YTerms, Terms), !.
same_priority_2(div(X*Y), *, Terms) :-
    same_priority_2(div(X), *, XTerms),
    same_priority_2(div(Y), *, YTerms),
    append(XTerms, YTerms, Terms), !.
same_priority_2(div(X/Y), *, Terms) :-
    same_priority_2(div(X), *, XTerms),
    same_priority_2(mul(Y), *, YTerms),
    append(XTerms, YTerms, Terms), !.

same_priority_2(mul(X), *, [mul(X)]) :- !.
same_priority_2(div(X), *, [div(X)]) :- !.
same_priority_2(Term, _, [Term]).

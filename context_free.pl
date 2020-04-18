rule(abc, (s --> a, b, c)).
rule(abc, (a --> [a], a)).
rule(abc, (a --> [])).
rule(abc, (b --> [b], b)).
rule(abc, (b --> [])).
rule(abc, (c --> [c], c)).
rule(abc, (c --> [])).

s(As, Rest) :- a(As, Bs), b(Bs, Cs), c(Cs, Rest).
a(As, Xs) :- connect([a], As, As1), a(As1, Xs).
a(As, Xs) :- connect([], As, Xs).
b(Bs, Xs) :- connect([b], Bs, Bs1), b(Bs1, Xs).
b(Bs, Xs) :- connect([], Bs, Xs).
c(Cs, Xs) :- connect([c], Cs, Cs1), c(Cs1, Xs).
c(Cs, Xs) :- connect([], Cs, Xs).

s1 --> a1, b1, c1.
a1 --> [a], a1.
a1 --> [].
b1 --> [b], b1.
b1 --> [].
c1 --> [c], c1.
c1 --> [].

connect([], Xs, Xs).
connect([X|Xs], [X|Xs1], Xs2) :- connect(Xs, Xs1, Xs2).

simple_is_list([]).
simple_is_list([_|_]).

translate_rule(A --> B, (A1 :- B1)) :-
    A1 =.. [A, First, Rest],
    translate_body(B, First, Rest, B1).

translate_simple(A, First, First1, connect(A, First, First1)) :-
    simple_is_list(A),
    !.
translate_simple(A, First, First1, A1) :-
    A1 =.. [A, First, First1].

translate_body((A, Other), First, Rest, (A1, Body)) :-
    !,
    translate_simple(A, First, First1, A1),
    translate_body(Other, First1, Rest, Body).
translate_body(A, First, Rest, A1) :-
    translate_simple(A, First, Rest, A1).


translate_grammar(Name, Clauses) :-
    findall(Clause, (rule(Name, Rule), translate_rule(Rule, Clause)), Clauses).


foo([]) --> [].
foo([X|Xs]) --> [X], foo(Xs).

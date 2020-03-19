% fib(n, f) :- f is the nth Fibonacci number
fib(1, 0) :- !.
fib(2, 1) :- !.
fib(N, F) :-
    N > 2,
    N1 is N - 1,
    N2 is N - 2,
    fib(N1, F1),
    fib(N2, F2),
    F is F1 + F2, !.

fib_iter(1, 0) :- !.
fib_iter(2, 1) :- !.
fib_iter(N, F) :- N > 2, N2 is N - 2, fib_iter(0, 1, N2, F).
fib_iter(_, F2, N, F2) :- N is 0, !.
fib_iter(F1, F2, N, F) :-
    FNext is F1 + F2,
    N1 is N - 1,
    fib_iter(F2, FNext, N1, F), !.

lemma(Goal) :- Goal, save(Goal).
save(Goal) :- clause(Goal, !), !.
save(Goal) :- asserta((Goal :- !)).

:- dynamic fib_mem/2.
fib_mem(1, 0) :- !.
fib_mem(2, 1) :- !.
fib_mem(N, F) :-
    N > 2,
    N1 is N - 1,
    N2 is N - 2,
    lemma(fib_mem(N1, F1)),
    lemma(fib_mem(N2, F2)),
    F is F1 + F2, !, save(fib_mem(N, F)).

clear_fib_mem :- retractall(fib_mem(_, _)).
reset_fib_mem :-
    clear_fib_mem,
    assertz((fib_mem(1, 0) :- !)),
    assertz((fib_mem(2, 1) :- !)),
    assertz((
        fib_mem(N, F) :-
            N > 2,
            N1 is N - 1,
            N2 is N - 2,
            lemma(fib_mem(N1, F1)),
            lemma(fib_mem(N2, F2)),
            F is F1 + F2, !, save(fib_mem(N, F))
    )).

:- use_module(library(clpfd)).

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
            F is F1 + F2,
            !,
            save(fib_mem(N, F))
    )).

fib_mem(N, F) :-
    reset_fib_mem,
    fib_mem(N, F).


fib_clpfd(1, 0).
fib_clpfd(2, 1).
fib_clpfd(N, F) :- fib_clpfd(N, 0, 1, F).

fib_clpfd(N, F1, F2, F) :-
    F #>= F2,
    F3 #= F1 + F2,
    (
        N #= 3,
        F #= F3
    ;   N #> 3,
        N1 #= N - 1,
        fib_clpfd(N1, F2, F3, F)
    ).

% ?- F mod 13 #= 0, N #< 100, fib_clpfd(N, F), format('~d ~d~n', [N, F]), fail.

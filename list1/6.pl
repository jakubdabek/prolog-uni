primes(Lo, Hi, N) :-
    between(Lo, Hi, N),
    is_prime(N).

is_prime(2).
is_prime(X) :-
    X > 2,
    Max is eval(ceiling(sqrt(X)) + 1),
    forall(
        between(2, Max, Divisor),
        (
            Divisor < X,
            X mod Divisor =\= 0
        )
    ).

primes2(X, PS) :- X > 1, range(2, X, R), sieve2(X, R, PS).
 
sieve2(X, [H | T], [H | T]) :- H*H > X, !.
sieve2(X, [H | T], [H | S]) :-
    maplist(mult(H), [H | T], MS),
    remove2(MS, T, R),
    sieve2(X, R, S).

range(X, X, [X]) :- !.
range(X, Y, [X | R]) :-
    X < Y,
    X1 is X + 1,
    range(X1, Y, R).
 
mult(A, B, C) :- C is A*B.

remove2(_,       [],      []     ) :- !.
remove2([H | X], [H | Y], R      ) :- !, remove2(X, Y, R).
remove2(X,       [H | Y], [H | R]) :- remove2(X, Y, R).


primes3(X, PS) :- X > 1, range(2, X, R), sieve3(X, R, PS).
 
sieve3(X, [H | T], [H | T]) :- H * H > X, !.
sieve3(X, [H | T], [H | S]) :- mults(H, X, MS), remove3(MS, T, R), sieve3(X, R, S).
 
mults(H, Lim, MS) :- M is H * H, mults(H, M, Lim, MS).
mults(_, M, Lim, []) :- M > Lim, !.
mults(H, M, Lim, [M|MS]) :- M2 is M+H, mults(H, M2, Lim, MS).
 
remove3(_,       [],      []     ) :- !.
remove3([H | X], [H | Y], R      ) :- !, remove3(X, Y, R).
remove3([H | X], [G | Y], R      ) :- H < G, !, remove3(X, [G | Y], R).
remove3(X,       [H | Y], [H | R]) :- remove3(X, Y, R).
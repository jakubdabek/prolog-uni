% factorial(n, n!) :- n! is the factorial of n
factorial(0, 1) :- !.
factorial(X, Fact) :-
    X > 0,
    Pred is X - 1,
    factorial(Pred, PrevFact),
    Fact is PrevFact * X.

factorial2(N, F) :- factorial2(N, 1, F).
factorial2(0, Acc, Acc) :- !.
factorial2(N, Acc, F) :-
    Acc1 is N * Acc,
    N1 is N - 1,
    factorial2(N1, Acc1, F).

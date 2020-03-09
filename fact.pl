% factorial(n, n!) :- n! is the factorial of n
factorial(0, 1).
factorial(X, Fact) :-
    X > 0,
    Pred is X - 1,
    factorial(Pred, PrevFact),
    Fact is PrevFact * X.

% variance(List, Variance) :- Variance is the variance of values in List
variance([Elem|List], Variance) :-
    foldl(update, List, data(1, Elem, 0), data(N, _, M2)),
    Variance is M2 / N.

update(NewValue, data(Count, Mean, M2), data(Count1, Mean1, M2_1)) :-
    Count1 is Count + 1,
    Delta is NewValue - Mean,
    Mean1 is Mean + (Delta / Count1),
    Delta2 is NewValue - Mean1,
    M2_1 is M2 + Delta * Delta2.

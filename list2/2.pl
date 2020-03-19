% once(X, Xs) :- X occurs only once in list Xs
once(X, Xs) :-
    select(X, Xs, Ys),
    \+ member(X, Ys).

% twice(X, Xs) :- X occurs only twice in list Xs
twice(X, Xs) :-
    select(X, Xs, Ys),
    once(X, Ys).

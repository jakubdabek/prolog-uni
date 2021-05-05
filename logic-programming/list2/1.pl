% middle(Xs, X) :- X is in the middle of a (odd-length) list Xs
middle(Xs, X) :-
    append(Ys, [X|Zs], Xs),
    length(Ys, Ylen),
    length(Zs, Zlen),
    Ylen is Zlen, !.

middle2(Xs, X) :-
    append(Ys, [X|Zs], Xs),
    same_length(Ys, Zs), !.

% merge_stream(Xs, Ys, XYs) :- merge 2 sorted streams Xs and Ys into a sorted stream XYs
merge_stream(Xs, Ys, XYs) :-
    var(Xs),
    !,
    freeze(Xs, merge_stream(Xs, Ys, XYs)).
merge_stream(Xs, Ys, XYs) :-
    var(Ys),
    !,
    freeze(Ys, merge_stream(Xs, Ys, XYs)).
merge_stream([], Ys, Ys) :- !.
merge_stream(Xs, [], Xs) :- !.
merge_stream(Xs, Ys, XYs) :-
    choose_smallest(Xs, Ys, Xs1, Ys1, Z),
    XYs = [Z|XYs1],
    merge_stream(Xs1, Ys1, XYs1).

choose_smallest([X|Xs], [Y|Ys], [X|Xs], Ys, Y) :- X > Y, !.
choose_smallest([X|Xs], [Y|Ys], Xs, [Y|Ys], X) :- X =< Y, !.

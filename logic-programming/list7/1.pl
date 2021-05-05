% merge_stream(Xs, Ys, XYs) :- merge 2 sorted streams Xs and Ys into a sorted stream XYs
merge_stream(Xs, Ys, XYs) :-
    when((nonvar(Xs), nonvar(Ys)), merge_stream_nonvar(Xs, Ys, XYs)).

merge_stream_nonvar([], Ys, Ys) :- !.
merge_stream_nonvar(Xs, [], Xs) :- !.
merge_stream_nonvar([X|Xs], [Y|Ys], XYs) :-
    when(
        (ground(X), ground(Y)),
        (
            choose_smallest(X, Xs, Y, Ys, Xs1, Ys1, Z),
            XYs = [Z|XYs1],
            merge_stream(Xs1, Ys1, XYs1)
        )
    ).

choose_smallest(X, Xs, Y, Ys, Xs, [Y|Ys], X) :- X < Y, !.
choose_smallest(X, Xs, Y, Ys, [X|Xs], Ys, Y) :- X >= Y, !.

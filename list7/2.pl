:- ['./1.pl'].

% split_stream(XYs, Xs, Ys) :- Xs and Ys are streams containing elements from XYs
split_stream(XYs, Xs, Ys) :-
    split_stream(XYs, Xs, Ys, left).
    
split_stream(XYs, Xs, Ys, Dir) :-
    var(XYs),
    !,
    freeze(XYs, split_stream(XYs, Xs, Ys, Dir)).
split_stream([], [], [], _) :- !.
split_stream([X|XYs], [X|Xs], Ys, left) :-
    !,
    split_stream(XYs, Xs, Ys, right).
split_stream([Y|XYs], Xs, [Y|Ys], right) :-
    !,
    split_stream(XYs, Xs, Ys, left).

merge_sort_stream(Stream, Sorted) :-
    \+ ground(Stream),
    !,
    when(ground(Stream), merge_sort_stream(Stream, Sorted)).
merge_sort_stream([], []) :- !.
merge_sort_stream([X], [X]) :- !.
merge_sort_stream(Stream, Sorted) :-
    merge_stream(SortedXs, SortedYs, Sorted),
    merge_sort_stream(Xs, SortedXs),
    merge_sort_stream(Ys, SortedYs),
    split_stream(Stream, Xs, Ys).

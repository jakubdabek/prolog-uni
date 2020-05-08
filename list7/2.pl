:- ['./1.pl'].

% split_stream(XYs, Xs, Ys) :- Xs and Ys are streams containing elements from XYs
split_stream(XYs, Xs, Ys) :-
    freeze(XYs, split_stream_nonvar(XYs, Xs, Ys)).

split_stream_nonvar([], [], []) :- !.
split_stream_nonvar([X|XYs], [X|Xs], Ys) :-
    split_stream(XYs, Ys, Xs). % Xs and Ys inverted

% merge_sort_stream(Stream, Sorted) :- Sorted is Stream sorted
merge_sort_stream(Stream, Sorted) :-
    freeze(Stream, merge_sort_stream_nonvar(Stream, Sorted)).

merge_sort_stream_nonvar([], []) :- !.
merge_sort_stream_nonvar([S|Stream], Sorted) :-
    freeze(Stream, merge_sort_stream_nonvar2(S, Stream, Sorted)).

merge_sort_stream_nonvar2(S, [], [S]) :- !.
merge_sort_stream_nonvar2(S, Stream, Sorted) :-
    merge_stream(SortedXs, SortedYs, Sorted),
    merge_sort_stream(Xs, SortedXs),
    merge_sort_stream(Ys, SortedYs),
    split_stream([S|Stream], Xs, Ys).

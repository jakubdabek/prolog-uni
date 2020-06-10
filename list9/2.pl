:- use_module(library(clpfd)).

prepare(MaxWidth, MaxHeight, Size, X, Y, f(X, Size, Y, Size)) :-
    X + Size #=< MaxWidth,
    Y + Size #=< MaxHeight.

zip([], Ys, Ys) :- !.
zip(Xs, [], Xs) :- !.
zip([X|Xs], [Y|Ys], [X, Y|XYs]) :- zip(Xs, Ys, XYs).


label_squares_simple(Sizes, Width, Height, Coords) :-
    once(label_squares(Sizes, Width, Height, Coords, _, _)).

label_squares(Sizes, Width, Height, Coords, Rects, Options) :-
    (var(Options) -> Options = [max]; true),
    squares(Sizes, Width, Height, Coords, Rects),
    labeling(Options, Coords).

squares(Sizes, Width, Height, All, Rects) :-
    same_length(Xs, Sizes),
    same_length(Ys, Sizes),
    Xs ins 0..Width,
    Ys ins 0..Height,
    maplist(prepare(Width, Height), Sizes, Xs, Ys, Rects),
    disjoint2(Rects),
    zip(Xs, Ys, All).

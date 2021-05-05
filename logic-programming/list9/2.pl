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
    (var(Options) -> Options = [down, enum]; true),
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


squares_check_options :-
    member(Order, [leftmost, ff, ffc, min, max]),
    member(ValueOrder, [up, down]),
    member(Branching, [step, enum, bisect]),
    format('~w ~w ~w ', [Order, ValueOrder, Branching]),
    time(catch(
        call_with_time_limit(10, once(label_squares([1,1,1,1,2,2,2,2,3,3], 7, 6, _, _, [Order,ValueOrder,Branching]))),
        time_limit_exceeded,
        writeln('<time limit exceeded>')
    )),
    fail.

:- use_module(library(clpfd)).

label_tetravex(Name, Board, Options) :-
    (var(Options) -> Options = [ffc, down, enum]; true),
    tetravex(Name, Board),
    append(Board, Tiles),
    append(Tiles, All),
    labeling(Options, All).

tetravex(Name, Board) :-
    tiles(Name, Width, Height, Tiles),
    Length #= Width * Height,
    give_id(Length, Tiles, IdTiles),
    same_length(Solution, IdTiles),
    maplist(flip_length(5), Solution),
    maplist(cons, SolutionIds, _, Solution),
    SolutionIds ins 1..Length,
    all_distinct(SolutionIds),
    tuples_in(Solution, IdTiles),
    make_board(Width, Height, Solution, Board).

cons(X, Xs, [X|Xs]).

give_id(Length, Tiles, IdTiles) :-
    numlist(1, Length, Ids),
    maplist(cons, Ids, Tiles, IdTiles).

flip_length(Length, Xs) :- length(Xs, Length).

make_board(Width, Height, Solution, Board) :-
    fill_board(Width, Height, Solution, Board),
    maplist(row_constraints(horizontal), Board),
    transpose(Board, BoardT),
    maplist(row_constraints(vertical), BoardT).

fill_board(Width, Height, Solution, Board) :-
    length(Board, Height),
    maplist(flip_length(Width), Board),
    append(Board, Solution).

adjacent_constraints(horizontal, [_, _, E, _, _], [_, _, _, _, W]) :-
    E #= W.
adjacent_constraints(vertical, [_, _, _, S, _], [_, N, _, _, _]) :-
    N #= S.

row_constraints(_, [_]) :- !.
row_constraints(Mode, [X, Y|Xs]) :-
    adjacent_constraints(Mode, X, Y),
    row_constraints(Mode, [Y|Xs]).

print_board(Board) :-
    maplist(print_row, Board).

print_row(Row) :-
    maplist(print_top, Row), nl,
    maplist(print_middle, Row), nl,
    maplist(print_bottom, Row), nl.

print_top([_, N, _, _, _]) :-
    format('    ~d    ', [N]).

print_middle([Id, _, E, _, W]) :-
    format('~d  ~|~d~3+  ~d', [W, Id, E]).

print_bottom([_, _, _, S, _]) :-
    format('    ~d    ', [S]).

% tiles are in format [N, E, S, W]
tiles(t6a, 6, 6, Tiles) :-
    Tiles = [
        [0,6,2,4],[2,9,4,7],[2,3,2,0],[6,6,3,0],[1,8,2,0],[9,1,6,1],
        [5,0,0,6],[2,4,8,7],[3,6,4,2],[9,4,2,1],[4,3,9,1],[5,8,8,4],
        [8,0,4,9],[1,9,6,8],[3,9,8,1],[4,0,9,3],[2,7,3,3],[4,6,5,5],
        [4,1,9,0],[3,0,1,3],[4,5,4,3],[6,6,9,8],[1,7,5,7],[3,3,3,6],
        [5,3,0,9],[8,6,2,8],[7,4,6,9],[8,9,5,6],[2,1,5,6],[9,1,6,4],
        [9,4,4,9],[3,9,9,1],[6,3,8,6],[8,1,1,3],[9,8,5,9],[1,2,4,4]
    ].
tiles(t6b, 6, 6, Tiles) :-
    Tiles = [
        [1,6,5,7],[9,7,5,8],[2,2,5,4],[5,6,4,4],[6,1,2,3],[0,4,0,7],
        [4,3,8,9],[1,9,1,2],[6,3,4,1],[5,0,2,1],[2,0,1,7],[9,5,5,5],
        [9,6,8,8],[2,8,0,0],[2,4,8,6],[8,7,5,1],[3,3,9,6],[4,6,4,6],
        [2,1,7,9],[5,7,2,7],[7,7,0,4],[6,9,3,9],[4,5,2,6],[8,1,5,8],
        [0,1,9,4],[6,7,7,0],[3,9,5,9],[9,6,1,7],[5,9,3,3],[7,5,6,8],
        [1,8,6,6],[0,4,6,9],[5,1,2,0],[4,7,6,7],[5,9,3,4],[5,3,5,8]
    ].
tiles(t6c, 6, 6, Tiles) :-
    Tiles = [
        [9,6,3,9],[9,7,2,3],[7,5,9,8],[7,7,2,4],[6,6,4,3],[0,9,0,5],
        [9,6,2,7],[0,8,2,6],[0,4,8,1],[3,4,8,8],[7,3,5,7],[4,2,4,4],
        [1,6,1,5],[4,1,1,4],[3,0,0,0],[0,7,9,2],[0,1,9,4],[2,3,0,6],
        [1,6,3,1],[9,9,0,0],[2,8,3,7],[4,4,6,1],[8,7,4,0],[8,4,1,3],
        [2,0,4,3],[5,2,8,3],[1,6,0,2],[5,4,3,9],[3,7,6,2],[0,5,3,6],
        [1,5,9,0],[2,2,7,6],[6,3,7,2],[9,1,5,5],[4,2,4,2],[3,0,7,7]
    ].

tiles(test22, 2, 2, Tiles) :-
    Tiles = [
        [3, 2, 1, 4], [1, 2, 3, 4],
        [1, 3, 4, 2], [4, 1, 3, 2]
    ].

tiles(test32, 3, 2, Tiles) :-
    Tiles = [
        [3, 2, 1, 4], [1, 2, 3, 4], [2, 3, 4, 1],
        [1, 3, 4, 2], [4, 1, 3, 2], [4, 1, 2, 3]
    ].

tiles(test33, 3, 3, Tiles) :-
    Tiles = [
        [8,4,9,5],[0,6,1,4],[8,7,0,1],
        [5,1,8,4],[8,0,4,0],[4,2,9,7],
        [3,0,8,4],[9,6,0,6],[5,4,5,6]
    ].


tetravex_check_options :-
    member(Order, [leftmost, ff, ffc, min, max]),
    member(ValueOrder, [up, down]),
    member(Branching, [step, enum, bisect]),
    format('~w ~w ~w ', [Order, ValueOrder, Branching]),
    member(Name, [test22, test32, test33, t6a, t6b, t6c]),
    time(catch(
        call_with_time_limit(10, once(label_tetravex(Name, _, [Order,ValueOrder,Branching]))),
        time_limit_exceeded,
        writeln('<time limit exceeded>')
    )),
    fail.

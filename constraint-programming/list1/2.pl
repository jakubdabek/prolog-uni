:- use_module(library(clpfd)).

flip_length(Length, List) :- length(List, Length).

distances_from_middle(N, List) :-
    MiddleIndex is N // 2 + 1,
    numlist(1, N, Is),
    maplist(num_distance(MiddleIndex), Is, List).

num_distance(X, Y, Distance) :- Distance is abs(X - Y).

initial_board(Width, Height, Board) :-
    Width > 0, Height > 0,
    Width mod 2 #= 1, Height mod 2 #= 1,
    distances_from_middle(Height, MiddleRowDistances),
    distances_from_middle(Width, MiddleColumnDistances),
    maplist(initial_row(Width, MiddleColumnDistances), MiddleRowDistances, Board).

initial_row(Width, MiddleColumnDistances, MiddleRowDistance, Row) :-
    length(Row, Width),
    maplist(initial_value(MiddleRowDistance), MiddleColumnDistances, Row).

initial_value(0, 0, 1) :- !.
initial_value(0, 1, 1) :- !.
initial_value(1, 0, 1) :- !.
initial_value(_, _, 0).

board(1, Width, Height, Moves) :- board(Width, Height, Moves).
board(2, Width, Height, Moves) :- board2(Width, Height, Moves).

:- dynamic option_minimize/0.
option_minimize :- fail.

label_board(Type, Width, Height, Moves, Options) :-
    (var(Options) -> Options = []; true),
    board(Type, Width, Height, Moves),
    append(Moves, FlatMoves),
    (   option_minimize
    ->  sum(FlatMoves, #=, TotalMoves),
        Options1 = [min(TotalMoves)|Options]
    ;   Options1 = Options
    ),
    time(labeling(Options1, FlatMoves)).

board(Width, Height, Moves) :-
    initial_board(Width, Height, InitialValues),
    maplist(same_length, InitialValues, Moves),
    append(Moves, FlatMoves),
    FlatMoves ins 0..1, % any 2 repeated moves are idempotent
    maplist(maplist(clpfd_plus_mod), InitialValues, Moves, ValuesWithMoves),
    constrain_rows(Moves, ValuesWithMoves, IntermediateValues),
    transpose(Moves, MovesT),
    transpose(IntermediateValues, IntermediateValuesT),
    constrain_rows(MovesT, IntermediateValuesT, FinalValues),
    maplist(maplist(#=(1)), FinalValues).

% clpfd_plus_mod([A, B], Result) :- !, Result #= mod(A + B, 2).
% clpfd_plus_mod([A, B, C], Result) :- !, Result #= mod(A + B + C, 2).
% clpfd_plus_mod([A, B, C, D], Result) :- !, Result #= mod(A + B + C + D, 2).
% clpfd_plus_mod([A, B, C, D, E], Result) :- !, Result #= mod(A + B + C + D + E, 2).
% clpfd_plus_mod([A, B, C, D, E, F], Result) :- !, Result #= mod(A + B + C + D + E + F, 2).

clpfd_plus_mod(Xs, Result) :- sum(Xs, #=, Result0), Result = Result0 mod 2.
clpfd_plus_mod(X, Y, Result) :- Result #= mod(X + Y, 2).
clpfd_plus_mod(X, Y, Z, Result) :- Result #= mod(X + Y + Z, 2).

constrain_rows(Moves, Values, NewValues) :-
    maplist(constrain_row, Moves, Values, NewValues).

constrain_row([M,M1|Moves], [V|Values], [NV|NewValues]) :-
    clpfd_plus_mod(V, M1, NV),
    constrain_row_middle([M,M1|Moves], Values, NewValues).

constrain_row_middle([M1, _], [V], [NV]) :-
    !,
    clpfd_plus_mod(V, M1, NV).
constrain_row_middle([M1,M,M2|Moves], [V|Values], [NV|NewValues]) :-
    clpfd_plus_mod(V, M1, M2, NV),
    constrain_row_middle([M,M2|Moves], Values, NewValues).


cons(H, T, [H|T]).

board2(Width, Height, Moves) :-
    initial_board(Width, Height, InitialValues),
    maplist(same_length, InitialValues, Moves),
    append(Moves, FlatMoves),
    FlatMoves ins 0..1, % any 2 repeated moves are idempotent
    neighbourhood(Moves, Neighbourhoods),
    maplist(maplist(cons), InitialValues, Neighbourhoods, ValueParts),
    maplist(maplist(clpfd_plus_mod), ValueParts, Values),
    maplist(maplist(#=(1)), Values).

neighbourhood(Matrix, Neighbourhoods) :-
    maplist(same_length, Matrix, Neighbourhoods),
    maplist(row_neighbourhood, Matrix, Neighbourhoods, Diffs),
    transpose(Matrix, MatrixT),
    transpose(Diffs, DiffsT),
    maplist(row_neighbourhood, MatrixT, DiffsT, Ends),
    maplist(maplist(list_singleton), MatrixT, Ends).

list_singleton(X, [X]).

row_neighbourhood(Row, Neighbourhoods, Diffs) :-
    right_neighbourhood(Row, Neighbourhoods, Diffs0),
    left_neighbourhood(Row, Diffs0, Diffs).

left_neighbourhood(Row, Neighbourhoods, Diffs) :-
    reverse(Row, Row1),
    reverse(Neighbourhoods, Neighbourhoods1),
    same_length(Row, Diffs),
    reverse(Diffs, Diffs1),
    right_neighbourhood(Row1, Neighbourhoods1, Diffs1).

right_neighbourhood([_], D, D) :- !.
right_neighbourhood([_,R|Row], [[R|D]|Neighbourhoods], [D|Diffs]) :-
    right_neighbourhood([R|Row], Neighbourhoods, Diffs).

%  +--h(1)--+--h(2)--+--h(3)--+
%  |        |        |        |
% v(1)     v(4)     v(7)     v(10)
%  |        |        |        |
%  +--h(4)--+--h(5)--+--h(6)--+
%  |        |        |        |
% v(2)     v(5)     v(8)     v(11)
%  |        |        |        |
%  ............................

is_dir(left).
is_dir(right).
is_dir(up).
is_dir(down).

move(left, h(Pos), h(PosMoved)) :- !, PosMoved is Pos - 1.
move(left, v(Pos), v(PosMoved)) :- !, PosMoved is Pos - 3.

move(right, h(Pos), h(PosMoved)) :- !, PosMoved is Pos + 1.
move(right, v(Pos), v(PosMoved)) :- !, PosMoved is Pos + 3.

move(up, h(Pos), h(PosMoved)) :- !, PosMoved is Pos - 3.
move(up, v(Pos), v(PosMoved)) :- !, PosMoved is Pos - 1.

move(down, h(Pos), h(PosMoved)) :- !, PosMoved is Pos + 3.
move(down, v(Pos), v(PosMoved)) :- !, PosMoved is Pos + 1.

move(Dir, [], []) :- is_dir(Dir), !.
move(Dir, [Stick|Sticks], [StickMoved|SticksMoved]) :-
    is_dir(Dir), !,
    move(Dir, Stick, StickMoved),
    move(Dir, Sticks, SticksMoved).

move([], Stick, Stick).
move([Dir|Dirs], Stick, StickMoved) :-
    move(Dir, Stick, Stick1),
    move(Dirs, Stick1, StickMoved).

% fill_list(Len, Value, List)
fill_list(0, _, []).
fill_list(Len, Value, [Value|List]) :-
    Len > 0,
    Len1 is Len - 1,
    fill_list(Len1, Value, List).

big_squares(Squares) :-
    Squares = [
        [
            h(1), h(2), h(3),
            v(1), v(2), v(3),
            h(10), h(11), h(12),
            v(10), v(11), v(12)
        ]
    ], !.

medium_squares(Squares) :-
    TopLeft = [
        h(1), h(2),
        v(1), v(2),
        h(7), h(8),
        v(7), v(8)
    ],
    fill_list(3, TopLeft, List),
    maplist(move, [[right],[down],[right,down]], List, Moved),
    !,
    Squares = [TopLeft|Moved].

small_squares(Squares) :-
    TopLeft = [
        h(1),
        v(1),
        h(4),
        v(4)
    ],
    fill_list(8, TopLeft, List),
    Moves = [
        [right],
        [right, right],
        [down],
        [down, right],
        [down, right, right],
        [down, down],
        [down, down, right],
        [down, down, right, right]
    ],
    maplist(move, Moves, List, Moved),
    !,
    Squares = [TopLeft|Moved].

all_sticks(Sticks) :-
    findall(h(X), between(1, 12, X), Horizontal),
    findall(v(X), between(1, 12, X), Vertical),
    append(Horizontal, Vertical, Sticks1),
    predsort(compare_row, Sticks1, Sticks).


reverse_order(<, >).
reverse_order(>, <).
reverse_order(=, =).

compare_then(<, <, _) :- !.
compare_then(>, >, _) :- !.
compare_then(Ord, =, Ord) :- !.

compare_row(Ord, h(X), h(Y)) :- !, compare(Ord, X, Y).
compare_row(Ord, v(X), v(Y)) :-
    !,
    X1 is (X - 1) mod 3,
    Y1 is (Y - 1) mod 3,
    compare(Ord1, X1, Y1),
    compare(Ord2, X, Y),
    compare_then(Ord, Ord1, Ord2).
compare_row(Ord, h(X), v(Y)) :-
    !,
    X1 is ((X - 1) // 3) * 2,
    Y1 is ((Y - 1) mod 3) * 2 + 1,
    compare(Ord, X1, Y1).
compare_row(Ord, v(X), h(Y)) :-
    !,
    compare_row(Ord1, h(Y), v(X)),
    reverse_order(Ord1, Ord).


printer_grid(Grid) :-
    length(Grid, 7),
    prepare_grid(h, Grid).

next_type(h, v).
next_type(v, h).

grid_row_len(h, 7).
grid_row_len(v, 4).

prepare_grid(_, []) :- !.
prepare_grid(Type, [Row|Grid]) :-
    grid_row_len(Type, Len),
    length(Row, Len),
    next_type(Type, Type1),
    prepare_grid(Type1, Grid).

print_sticks(Sticks) :-
    all_sticks(All),
    predsort(compare_row, Sticks, Sorted),
    print_sticks_sorted(All, Sorted).

print_sticks_sorted(All, Sorted) :-
    printer_grid(Grid),
    print_sticks_h(All, Sorted, Grid),
    print_grid(Grid).

print_sticks_h([], [], _) :- !.
print_sticks_h(All, Sorted, [HRow|Grid]) :-
    !,
    print_sticks_h(All, Sorted, 3, HRow, All1, Sorted1),
    print_sticks_v(All1, Sorted1, [HRow|Grid]).
print_sticks_h(_, _, _) :- print("Should not be here").

print_sticks_h(All, Sorted, 0, _, All, Sorted) :- !.
print_sticks_h([Stick|All], [Stick|Sorted], N, ['+', '---', '+'|HRow], All1, Sorted1) :-
    !,
    succ(N1, N),
    print_sticks_h(All, Sorted, N1, ['+'|HRow], All1, Sorted1).
print_sticks_h([_|All], Sorted, N, [_,'   '|HRow], All1, Sorted1) :-
    % head([_|All]) \= head(Sorted)
    succ(N1, N),
    print_sticks_h(All, Sorted, N1, HRow, All1, Sorted1).

print_sticks_v([], [], _) :- !.
print_sticks_v(All, Sorted, [HRow1, VRow, HRow2|Grid]) :-
    !,
    print_sticks_v(All, Sorted, 4, HRow1, VRow, HRow2, All1, Sorted1),
    print_sticks_h(All1, Sorted1, [HRow2|Grid]).
print_sticks_v(_, _, _) :- print("Should not be here").

print_sticks_v(All, Sorted, 0, _, _, _, All, Sorted) :- !, print("Should not be here").
print_sticks_v([Stick|All], [Stick|Sorted], 1, ['+'], ['|'], ['+'], All, Sorted) :- !.
print_sticks_v(    [_|All],         Sorted, 1,   [_], [' '],   [_], All, Sorted) :- !.
print_sticks_v([Stick|All], [Stick|Sorted], N, ['+',_|HRow1], ['|'|VRow], ['+',_|HRow2], All1, Sorted1) :-
    !,
    succ(N1, N),
    print_sticks_v(All, Sorted, N1, HRow1, VRow, HRow2, All1, Sorted1).
print_sticks_v([_|All], Sorted, N, [_,_|HRow1], [' '|VRow], [_,_|HRow2], All1, Sorted1) :-
    % head([_|All]) \= head(Sorted)
    succ(N1, N),
    print_sticks_v(All, Sorted, N1, HRow1, VRow, HRow2, All1, Sorted1).

print_grid(Grid) :-
    % maplist(writeln, Grid),
    print_grid_h(Grid).

print_grid_h([]) :- !.
print_grid_h([HRow|Grid]) :-
    print_grid_h_row(HRow),
    print_grid_v(Grid).

print_grid_h_row([]) :- !, nl.
print_grid_h_row([X|HRow]) :-
    (   var(X)
    ->  write('+') % write(' ')
    ;   write(X)
    ),
    print_grid_h_row(HRow).

print_grid_v([]) :- !.
print_grid_v([VRow|Grid]) :-
    print_grid_v_row(VRow),
    print_grid_h(Grid).

print_grid_v_row([Last]) :- !, write(Last), nl.
print_grid_v_row([X|VRow]) :-
    write(X),
    write('   '),
    print_grid_v_row(VRow).


% combination(N, List, Combination) :- Combination of length N is a combination of List
combination(N, List, Combination) :- var(N), !, combination_var(N, List, Combination).
combination(N, List, Combination) :- nonvar(N), !, combination_nonvar(N, List, Combination).

combination_nonvar(0, [], []) :- !.
combination_nonvar(N, [H|T], [H|C]) :- succ(N1, N), combination_nonvar(N1, T, C).
combination_nonvar(N, [_|T],  C   ) :- combination_nonvar(N, T, C).

combination_var(0, [], []).
combination_var(N, [H|T], [H|C]) :- combination_var(N1, T, C), succ(N1, N).
combination_var(N, [_|T],  C   ) :- combination_var(N, T, C).

% combination_missing(N, List, Combination) :- Combination is a combination of List with N elements missing
combination_missing(N, List, Combination) :- var(N), !, combination_missing_var(N, List, Combination).
combination_missing(N, List, Combination) :- nonvar(N), !, combination_missing_nonvar(N, List, Combination).

combination_missing_nonvar(0, List, List) :- !.
combination_missing_nonvar(N, [H|T], [H|C]) :- combination_missing_nonvar(N, T, C).
combination_missing_nonvar(N, [_|T],  C   ) :- succ(N1, N), combination_missing_nonvar(N1, T, C).

combination_missing_var(0, List, List).
combination_missing_var(N, [H|T], [H|C]) :- combination_missing_var(N, T, C).
combination_missing_var(N, [_|T],  C   ) :- combination_missing_var(N1, T, C), succ(N1, N).

terms_to_list((Term, Terms), [Term|Terms1]) :- !, terms_to_list(Terms, Terms1).
terms_to_list(Term, [Term]).

square_terms(Terms, List) :-
    terms_to_list(Terms, List1),
    length(List, 3),
    (   member(big(NB), List1)
    ->  member(big(NB), List)
    ;   member(big(0), List)
    ),
    (   member(medium(NM), List1)
    ->  member(medium(NM), List)
    ;   member(medium(0), List)
    ),
    (   member(small(NS), List1)
    ->  member(small(NS), List)
    ;   member(small(0), List)
    ),
    !.


find_stick_combinations(N, Terms, Sticks) :-
    square_terms(Terms, TermList),
    all_sticks(All),
    !,
    combination_missing(N, All, Sticks),
    check_sticks(Sticks, TermList).


contains_square(Sticks, Square) :-
    length(Square, N),
    intersection(Sticks, Square, Intersection),
    length(Intersection, N).


check_term(big(N), N, Squares) :- big_squares(Squares).
check_term(medium(N), N, Squares) :- medium_squares(Squares).
check_term(small(N), N, Squares) :- small_squares(Squares).

check_sticks(_, []) :- !.
check_sticks(Sticks, [Term|TermList]) :-
    check_term(Term, N, Squares),
    findall(S, (member(S, Squares), contains_square(Sticks, S)), Contained),
    length(Contained, N),
    check_sticks(Sticks, TermList).


zapalki(N, Terms) :-
    find_stick_combinations(N, Terms, Sticks),
    writeln("Rozwiazanie"),
    print_sticks(Sticks).

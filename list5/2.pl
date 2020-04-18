same_length_index(Xs, Ys, Ns) :- same_length_index(Xs, Ys, Ns, 1).

same_length_index([], [], [], _) :- !.
same_length_index([_|Xs], [_|Ys], [N|Ns], N) :- succ(N, N1), same_length_index(Xs, Ys, Ns, N1).

construct_board(Queens, Board) :-
    same_length_index(Queens, Board1, Indexes),
    maplist(fill_row(Queens), Indexes, Board1),
    reverse(Board1, Board).

starting_color(N, dark) :- 1 =:= N mod 2, !.
starting_color(N, light) :- 0 =:= N mod 2, !.

switch_color(dark, light).
switch_color(light, dark).

fill_row(Queens, N, Row) :-
    starting_color(N, StartingColor),
    fill_row(Queens, N, Row, StartingColor).

fill_row([], _, [], _) :- !.
fill_row([N|Queens], N, [queen(Color)|Row], Color) :-
    !,
    switch_color(Color, Color1),
    fill_row(Queens, N, Row, Color1).
fill_row([_|Queens], N, [empty(Color)|Row], Color) :-
    !,
    switch_color(Color, Color1),
    fill_row(Queens, N, Row, Color1).


board(Queens) :-
    construct_board(Queens, Board),
    print_board(Board).

print_sep([]) :- write('+').
print_sep([_|Row]) :-
    write('+-----'),
    print_sep(Row).

count_row_height(N) :- between(1, 2, N).

print_field(empty(dark)) :- write(':::::').
print_field(queen(dark)) :- write(':###:').
print_field(empty(light)) :- write('     ').
print_field(queen(light)) :- write(' ### ').

print_row([]) :- write('|').
print_row([Field|Row]) :-
    write('|'),
    print_field(Field),
    print_row(Row).

is_nonempty([_|_]).
    
print_board([Row|Board]) :-
    print_sep(Row), nl,
    forall(count_row_height(_), (print_row(Row), nl)),
    (   is_nonempty(Board)
    ->  print_board(Board)
    ;   print_sep(Row), nl
    ).


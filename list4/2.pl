house(_HouseColor, _Nationality, _Pet, _Drink, _Cigarettes).
color(house(Color, _, _, _, _), Color).
nationality(house(_, Nationality, _, _, _), Nationality).
pet(house(_, _, Pet, _, _), Pet).
drinks(house(_, _, _, Drink, _), Drink).
smokes(house(_, _, _, _, Cigarettes), Cigarettes).

% adjacent(X, Y, Zs) :- X and Y are adjacent elements of list Zs
adjacent(X, Y, [X, Y|_]).
adjacent(X, Y, [_|Zs]) :- adjacent(X, Y, Zs).

id_or_swap(X, Y, X, Y).
id_or_swap(X, Y, Y, X).

first([H|_], H).
left_of(Houses, L, R) :- adjacent(L, R, Houses).
next_to(Houses, X, Y) :-
    left_of(Houses, X1, Y1),
    id_or_swap(X, Y, X1, Y1).

third([_,_,M|_], M).

einstein(Houses) :-
    Houses = [
        house(_, _, _, _, _),
        house(_, _, _, _, _),
        house(_, _, _, _, _),
        house(_, _, _, _, _),
        house(_, _, _, _, _)
    ],
    first(Houses, H1), nationality(H1, norwegian),
    member(H2, Houses), nationality(H2, english), color(H2, red),
    left_of(Houses, H3L, H3R), color(H3L, green), color(H3R, white),
    member(H4, Houses), nationality(H4, danish), drinks(H4, tea),
    next_to(Houses, H5X, H5Y), smokes(H5X, light), pet(H5Y, cat),
    member(H6, Houses), color(H6, yellow), smokes(H6, cigar),
    member(H7, Houses), nationality(H7, german), smokes(H7, pipe),
    third(Houses, H8), drinks(H8, milk),
    next_to(Houses, H9X, H9Y), smokes(H9X, light), drinks(H9Y, water),
    member(H10, Houses), smokes(H10, no_filter), pet(H10, bird),
    member(H11, Houses), nationality(H11, swedish), pet(H11, dog),
    next_to(Houses, H12X, H12Y), nationality(H12X, norwegian), color(H12Y, blue),
    next_to(Houses, H13X, H13Y), pet(H13X, horse), color(H13Y, yellow),
    member(H14, Houses), smokes(H14, mentol), drinks(H14, beer),
    member(H15, Houses), color(H15, green), drinks(H15, coffee).

rybki(Kto) :-
    einstein(Houses),
    member(H, Houses),
    pet(H, fish),
    nationality(H, Kto).

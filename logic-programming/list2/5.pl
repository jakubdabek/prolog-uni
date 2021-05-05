% lista(N, Xs) :- Xs is a list of numbers 1..N occuring twice,
% so that every 2 occurences of number I are interspersed
% with an even number of other numbers
lista(N, Xs) :-
    numlist(1, N, Is),
    lista(Is, [], [], Xs).

% lista(Unused, Even, Odd, Result)
lista([], [], [], []).
lista(Unused, Even, Odd, [E|Result]) :-
    select(E, Even, Even1),
    lista(Unused, Odd, Even1, Result).
lista([U|Unused], Even, Odd, [U|Result]) :-
    lista(Unused, [U|Odd], Even, Result).

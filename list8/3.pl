:- use_module(library(clpfd)).

segment(N, K, Xs) :-
    length(Xs, N),
    Xs ins 0..1,
    sum(Xs, #=, K),
    N1 is N - K - 1,
    numlist(0, N1, Offsets),
    maplist(bind_offset(Xs, K), Offsets).

nth_tail(0, Xs, Xs) :- !.
nth_tail(N, [_|Xs], Tail) :-
    N > 0,
    succ(N1, N),
    nth_tail(N1, Xs, Tail).

bind_offset(Xs, Length, Offset) :-
    nth_tail(Offset, Xs, [X|OffsetTail]),
    nth_tail(Length, [X|OffsetTail], Tail),
    maplist(bind_offset(X), Tail).

bind_offset(X, Y) :- X + Y #=< 1.

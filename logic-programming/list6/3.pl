ab(N) --> a(0, N), b(0, N).
abc(N) --> a(0, N), b(0, N), c(0, N).
abfib(N) --> a(0, N), {fib_iter(N, F)}, b(0, F).
abfib2(N) --> a2(N), b2fib(N).

a(Curr, N) --> `a`, {succ(Curr, Curr1)}, a(Curr1, N).
a(Curr, Curr) --> [].
b(Curr, N) --> `b`, {succ(Curr, Curr1)}, b(Curr1, N).
b(Curr, Curr) --> [].
c(Curr, N) --> `c`, {succ(Curr, Curr1)}, c(Curr1, N).
c(Curr, Curr) --> [].

a2(z) --> [].
a2(s(N)) --> `a`, a2(N).
b2fib(z) --> [].
b2fib(s(z)) --> `b`.
b2fib(s(s(N))) --> b2fib(N), b2fib(s(N)).

fib_iter(1, 0) :- !.
fib_iter(2, 1) :- !.
fib_iter(N, F) :- N > 2, N2 is N - 2, fib_iter(0, 1, N2, F).
fib_iter(_, F2, N, F2) :- N is 0, !.
fib_iter(F1, F2, N, F) :-
    FNext is F1 + F2,
    N1 is N - 1,
    fib_iter(F2, FNext, N1, F), !.

% check:
% N = 100, fib_iter(N, F), F1 is F + 5, findall(98, between(1, F1, _), B), findall(97, between(1, N, _), AB, B), time((phrase(abfib(N2), AB, R)))


% phrase(p(Xs), Ys, Zs) :- append(Xs, Zs, Ys)
p([]) --> [].
p([X|Xs]) --> [X], p(Xs).

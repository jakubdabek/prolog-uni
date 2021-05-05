% powerset of {x,y,z} is a poset
% le = inclusion

% reflexive
le(empty, empty).
le(x, x).
le(y, y).
le(z, z).
le(xy, xy).
le(xz, xz).
le(yz, yz).
le(xyz, xyz).

% direct relation
le(empty, x).
le(empty, y).
le(empty, z).
% le(xy, x).
le(x, xy).
le(y, xy).
le(x, xz).
le(z, xz).
le(y, yz).
le(z, yz).
le(xy, xyz).
le(yz, xyz).
le(xz, xyz).

% transitive
le(empty, xy).
le(empty, xz).
le(empty, yz).
le(empty, xyz).
le(x, xyz).
le(y, xyz).
le(z, xyz).

lt(X, Y) :-
    le(X, Y),
    X \= Y.

in_set(X) :- le(X, _); le(_, X).

maximal(X) :-
    in_set(X),
    \+ lt(X, _).

greatest(X) :-
    in_set(X),
    forall(in_set(Y), le(Y, X)).

minimal(X) :-
    in_set(X),
    \+ lt(_, X).

least(X) :-
    in_set(X),
    forall(in_set(Y), le(X, Y)).

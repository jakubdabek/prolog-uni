:- [4].

reflexive :- forall(in_set(X), le(X, X)).

transitive :-
    forall(
            (
                le(X, Y),
                le(Y, Z)
            ),
            le(X, Z)
        ).

weak_antisymmetric :-
    forall(
            (
                le(X, Y),
                le(Y, X)
            ),
            X = Y
        ).

partial_order :-
    reflexive,
    transitive,
    weak_antisymmetric.
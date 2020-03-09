male(terach).
male(abraham).
male(nachor).
male(isaac).
male(lot).

female(sarah).
female(milcah).
female(yiscah).

father(terach, abraham).
father(terach, nachor).
father(terach, haran).
father(abraham, isaac).
father(haran, lot).
father(haran, yiscah).

mother(sarah, isaac).

parent(Parent, Child) :-
    father(Parent, Child);
    mother(Parent, Child).

mother(Mother) :- mother(Mother, _).
father(Father) :- father(Father, _).
sister(Sister, Sibling) :-
    sibling(Sister, Sibling),
    female(Sister).
grandfather(Grandfather, Grandchild) :-
    father(Grandfather, Parent),
    parent(Parent, Grandchild).
sibling(Sibling1, Sibling2) :-
    parent(Parent, Sibling1),
    parent(Parent, Sibling2).

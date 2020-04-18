browse(Term) :- browse_node(Term, 1, []).

browse_node(Term, SiblingIndex, Stack) :-
    write(Term), nl,
    write('command: '),
    read(Command),
    !,
    execute(Command, Term, SiblingIndex, Stack).

execute(i, T, I, S) :- execute(in, T, I, S).
execute(o, T, I, S) :- execute(out, T, I, S).
execute(n, T, I, S) :- execute(next, T, I, S).
execute(p, T, I, S) :- execute(prev, T, I, S).

execute(in, Term, Index, Stack) :-
    atomic(Term),
    !,
    write('can\'t go into atom!'), nl,
    browse_node(Term, Index, Stack).
execute(in, Term, Index, Stack) :-
    !,
    arg(1, Term, Child),
    browse_node(Child, 1, [node(Term, Index)|Stack]).

execute(out, _, _, []) :- !.
execute(out, _, _, [node(Term, Index)|Stack]) :-
    !,
    browse_node(Term, Index, Stack).

execute(next, Term, Index, Stack) :-
    !,
    succ(Index, Index1),
    execute_sibling(Term, Index, Index1, Stack).

execute(prev, Term, Index, Stack) :-
    !,
    succ(Index1, Index),
    execute_sibling(Term, Index, Index1, Stack).


execute_sibling(Current, CurrentIndex, SiblingIndex, [node(Parent, Index)|Stack]) :-
    !,
    (   arg(SiblingIndex, Parent, Sibling) % fails if out of bounds
    ->  browse_node(Sibling, SiblingIndex, [node(Parent, Index)|Stack])
    ;   write('no more siblings!'), nl,
        browse_node(Current, CurrentIndex, [node(Parent, Index)|Stack])
    ).

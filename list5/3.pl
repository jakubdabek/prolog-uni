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
    !,
    arg(1, Term, Child),
    browse_node(Child, 1, [node(Term, Index)|Stack]).

execute(out, _, _, []) :- !.
execute(out, _, _, [node(Term, Index)|Stack]) :-
    !,
    browse_node(Term, Index, Stack).

execute(next, _, Index, Stack) :-
    !,
    succ(Index, Index1),
    execute_sibling(Stack, Index1).

execute(prev, _, Index, Stack) :-
    !,
    succ(Index1, Index),
    execute_sibling(Stack, Index1).


execute_sibling([node(Term, PrevIndex)|Stack], Index1) :-
    !,
    arg(Index1, Term, Next), % fails if out of bounds
    browse_node(Next, Index1, [node(Term, PrevIndex)|Stack]).

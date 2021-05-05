% rule(OpType, X, Y, Result) :- Result is the simplified value of expression (X `op` Y) where op depends on OpType and on operand modes
rule(OpType, operand(inversed, X), operand(inversed, Y), operand(ResultMode, Result)) :-
    rule_(OpType, operand(normal, X), operand(normal, Y), operand(ResultMode1, Result)),
    !,
    invert(ResultMode1, ResultMode).
rule(OpType, operand(inversed, X), operand(normal, Y), Result) :-
    rule_(OpType, operand(normal, Y), operand(inversed, X), Result), !.
rule(OpType, X, Y, Result) :-
    rule_(OpType, X, Y, Result), !.
rule(OpType, X, Y, Result) :-
    rule_(OpType, Y, X, Result), !.

rule_(OpType, X, Y, Result) :-
    execute(OpType, X, Y, Result), !.

rule_(+, operand(normal, X), operand(normal, Y), operand(normal, Y)) :-
    number(X),
    X =:= 0, !.

rule_(*, operand(normal, X), operand(normal, Y), operand(normal, Y)) :-
    number(X),
    X =:= 1, !.

rule_(*, operand(normal, X), operand(normal, _), operand(normal, 0)) :-
    number(X),
    X =:= 0, !.

rule_(*, operand(normal, X), operand(inversed, _), operand(normal, 0)) :-
    number(X),
    X =:= 0, !.

rule_(*, operand(normal, X), operand(inversed, X), operand(normal, 1)) :-
    \+ (number(X), X =:= 0),
    !.

rule_(+, operand(normal, X), operand(normal, -X), operand(normal, 0)) :- !.
rule_(+, operand(normal, X), operand(inversed, X), operand(normal, 0)) :- !.

% rule(X, Op, Y, Res) :- Res =.. [Op, X, Y].

% rule(Op, X, Result) :- Result is the simplified value of expression (`op` Y)
rule(-, X, Y) :-
    number(X),
    Y is -X, !.

rule(-, -X, X) :- !.

rule(+, X, X) :- !.

rule(Op, X, Res) :- Res =.. [Op, X].

% simplify(Term, Simplified) :- Simplified is Term simplified as much as rules allow
simplify(Term, Term) :- atomic(Term), !.
simplify(operand(Mode, Term), operand(Mode, Simplified)) :- !, simplify(Term, Simplified).
simplify(Term, Simplified) :-
    same_priority(Term, OpType, Terms),
    same_length(Terms, SimplifiedTerms),
    maplist(simplify, Terms, SimplifiedTerms),
    simplify_merge_same_priority(SimplifiedTerms, OpType, MergedTerms),
    merge_same_priority(MergedTerms, OpType, Simplified), !.

simplify(Term, Simplified) :-
    Term =.. [Op, X],
    simplify(X, XS),
    rule(Op, XS, Simplified).

simplify_merge_same_priority(Terms, OpType, Simplified) :-
    select(Term1, Terms, Terms1),
    select(Term2, Terms1, Terms2),
    (   rule(OpType, Term1, Term2, SimplifiedTerm)
    ->  simplify_merge_same_priority([SimplifiedTerm|Terms2], OpType, Simplified)
    ).

simplify_merge_same_priority(Terms, _, Terms).

tails(List, Tail, InitLength) :- tails(List, Tail, 0, InitLength).
tails([], [], N, N) :- !.
tails(List, List, N, N).
tails([_|List], Tail, N, InitLength) :- N1 is N + 1, tails(List, Tail, N1, InitLength).

select_from_tails(Elem, List, Tail, InitLength) :-
    tails(List, [Elem|Tail], InitLength).

append_init(_, 0, List, List) :- !.
append_init([Elem|List], N, List2, [Elem|ListList]) :- N1 is N - 1, append_init(List, N1, List2, ListList).

% select_pair_lazy(List, Elem1, Elem2) :- Elem1 and Elem2 are elements of List; the same pair won't appear twice
% ----------------
% while it was concieved to subsume 2 separate selects, it's not faster or more useful
select_pair_lazy(Elem1, Elem2, List, ListMissing) :-
    select_from_tails(Elem1, List, Tail1, InitLength1),
    select_from_tails(Elem2, Tail1, Tail2, InitLength2),
    freeze(ListMissing, (append_init(Tail1, InitLength2, Tail2, Tmp), append_init(List, InitLength1, Tmp, ListMissing))).
select_pair_lazy([_|List], Elem1, Elem2) :- select_pair_lazy(List, Elem1, Elem2).

% simplify(a*(b*c/c-b), 0). now does work
% simplify(a*(b*(c/c)-b), 0). does too

invert(normal, inversed).
invert(inversed, normal).

operands(+, normal, +, normal, normal).
operands(+, normal, -, normal, inversed).
operands(+, inversed, +, inversed, inversed).
operands(+, inversed, -, inversed, normal).

operands(*, normal, *, normal, normal).
operands(*, normal, /, normal, inversed).
operands(*, inversed, *, inversed, inversed).
operands(*, inversed, /, inversed, normal).

execute(OpType, operand(ModeX, X), operand(ModeY, Y), operand(ModeResult, Result)) :-
    number(X),
    number(Y),
    !,
    operands(OpType, ModeResult, Op, ModeX, ModeY),
    Expr =.. [Op, X, Y],
    Result is Expr.

cmp_same_priority(<, operand(normal, _), operand(inversed, _)) :- !.
cmp_same_priority(>, operand(inversed, _), operand(normal, _)) :- !.
cmp_same_priority(Order, operand(Mode, X), operand(Mode, Y)) :- 
    !,
    compare(RealOrder, X, Y),
    (   RealOrder == (=)
    ->  Order = (<)
    ;   Order = RealOrder
    ).

merge_same_priority(Terms, OpType, Term) :-
    predsort(cmp_same_priority, Terms, Sorted),
    Sorted = [operand(normal, First)|Rest],
    foldl(merge_same_priority_fold_step(OpType), Rest, First, Term).

merge_same_priority_fold_step(OpType, operand(Mode, Current), Acc, NewAcc) :-
    operands(OpType, normal, Op, normal, Mode),
    NewAcc =.. [Op, Acc, Current].

same_priority(Term, OpType, Terms) :-
    functor(Term, Op, 2),
    operands(OpType, normal, Op, _, _),
    same_priority_mode(normal, Term, OpType, Terms-[]), !.

same_priority_mode(Mode, Term, _, [operand(Mode, Term)|Terms]-Terms) :- atomic(Term), !.
same_priority_mode(Mode, Term, _, [operand(Mode, Term)|Terms]-Terms) :- functor(Term, _, 1), !.
same_priority_mode(Mode, Term, OpType, Terms-TermsRest) :-
    Term =.. [Op, Left, Right],
    operands(OpType, Mode, Op, LeftMode, RightMode),
    same_priority_mode(LeftMode, Left, OpType, Terms-RightTerms),
    same_priority_mode(RightMode, Right, OpType, RightTerms-TermsRest), !.

same_priority_mode(Mode, Term, _, [operand(Mode, Term)|Terms]-Terms) :- debug("here", [], []).

% time(same_priority(a*b*(c/d)/e/(f/(g*h/i)*j)*k, Op, Terms)).

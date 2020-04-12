:- dynamic do_split_/3.

% expression(Ns, Val, Expr) :- Expr is an expression consisting of
% numbers from Ns in order with arithmetic operators inbetween,
% whose value is Val
expression_unordered(Ns, Val, Expr) :-
    asserta((do_split_(A, B, C) :- !, split(A, B, C))),
    expression_(Ns, Current, Expr),
    Current is Val.
expression_unordered(_, _, _) :- retractall(do_split_(_,_,_)), !, fail.

expression_ordered(Ns, Val, Expr) :-
    asserta((do_split_(A, B, C) :- !, append(B, C, A))),
    expression_(Ns, Current, Expr),
    Current is Val.
expression_ordered(_, _, _) :- retractall(do_split_(_,_,_)), !, fail.

nonempty([_|_]).

expression_([], _, _, _) :- !, fail.
expression_([Current], Current, Current) :- !.
expression_(Ns, Current, Expr) :-
    do_split_(Ns, Xs, Ys),
    nonempty(Xs), nonempty(Ys),
    expression_(Xs, CurrentX, ExprX),
    expression_(Ys, CurrentY, ExprY),
    make_expr(CurrentX, CurrentY, ExprX, ExprY, Expr, Current).

make_expr(Val1, Val2, Expr1, Expr2, Expr, Val) :-
    arithmetic_op(Op),
    \+ (Op = (/), Val2 =:= 0),
    Expr =.. [Op, Expr1, Expr2],
    Tmp =.. [Op, Val1, Val2],
    Val is Tmp.

arithmetic_op(+).
arithmetic_op(-).
arithmetic_op(*).
arithmetic_op(/).


% split(XYs, Xs, Ys) :- XYs is split into 2 lists Xs and Ys
split([], [], []).
split([X|XYs], [X|Xs], Ys) :- split(XYs, Xs, Ys).
split([Y|XYs], Xs, [Y|Ys]) :- split(XYs, Xs, Ys).

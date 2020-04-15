expression_unordered(Ns, Val, Expr) :-
    expression(unordered, Ns, Val, Expr).

expression_ordered(Ns, Val, Expr) :-
    expression(ordered, Ns, Val, Expr).

nonempty([_|_]).

split_order(ordered, XYs, Xs, Ys) :- !, append(Xs, Ys, XYs).
split_order(unordered, XYs, Xs, Ys) :- !, split(XYs, Xs, Ys).

% expression(+Order, +Ns, +Val, -Expr) :- Expr is an expression consisting of
% numbers from Ns with arithmetic operators inbetween whose value is Val
% Order (ordered/unordered) determines whether the elements from Ns appear in order in Expr
expression(Order, Ns, Val, Expr) :-
    expression(Order, Ns, Expr),
    Val =:= Expr.

expression(_, [], _) :- !, fail.
expression(_, [Current], Current) :- !.
expression(Order, Ns, Expr) :-
    split_order(Order, Ns, Xs, Ys),
    nonempty(Xs), nonempty(Ys),
    expression(Order, Xs, ExprX),
    expression(Order, Ys, ExprY),
    make_expr(ExprX, ExprY, Expr).

make_expr(Expr1, Expr2, Expr1 + Expr2).
make_expr(Expr1, Expr2, Expr1 - Expr2).
make_expr(Expr1, Expr2, Expr1 * Expr2).
make_expr(Expr1, Expr2, Expr1 / Expr2) :- Expr2 =\= 0.


% split(XYs, Xs, Ys) :- XYs is split into 2 lists Xs and Ys
split([], [], []).
split([X|XYs], [X|Xs], Ys) :- split(XYs, Xs, Ys).
split([Y|XYs], Xs, [Y|Ys]) :- split(XYs, Xs, Ys).

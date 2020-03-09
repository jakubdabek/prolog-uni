% binary_tree(T) :- T is a binary tree
binary_tree(void).
binary_tree(tree(_Value, Left, Right)) :- binary_tree(Left), binary_tree(Right).

% subtree(S, T) :- S is a subtree of T
subtree(T, T).
subtree(S, tree(_, Left, Right)) :- subtree(S, Left); subtree(S, Right).

% is_ordered(T) :- tree T is ordered, i.e. all nodes on the left are smaller than the root, and all nodes on the right are greater
is_ordered(void).
is_ordered(T) :- is_ordered_minmax(T, _, _).

optional(none).
optional(some(_)).

optional_greater(_, none).
optional_greater(some(X), some(Y)) :- X > Y.

optional_less(_, none).
optional_less(some(X), some(Y)) :- X < Y.

optional_min(X, none, X).
optional_min(none, some(Y), some(Y)).
optional_min(some(X), some(Y), some(Min)) :- Min is min(X, Y).

optional_max(X, none, X).
optional_max(none, some(Y), some(Y)).
optional_max(some(X), some(Y), some(Max)) :- Max is max(X, Y).

is_ordered_minmax(void, none, none).
is_ordered_minmax(tree(Value, L, R), Min, Max) :-
    is_ordered_minmax(L, LMin, LMax),
    is_ordered_minmax(R, RMin, RMax),
    OptVal = some(Value),
    optional_greater(OptVal, LMax),
    optional_less(OptVal, RMin),
    optional_min(LMin, RMin, ChildMin),
    optional_min(ChildMin, OptVal, Min),
    optional_max(LMax, RMax, ChildMax),
    optional_max(ChildMax, OptVal, Max).

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


% maximum(Tree, Max) :- Max is the maximum value in Tree
maximum(tree(Value, void, void), Value) :- !.
maximum(tree(Value, void, Right), Max) :-
    !,
    maximum(Right, RMax),
    Max is max(Value, RMax).

maximum(tree(Value, Left, void), Max) :-
    !,
    maximum(Left, LMax),
    Max is max(Value, LMax).

maximum(tree(Value, Left, Right), Max) :-
    maximum(Left, LMax),
    maximum(Right, RMax),
    Max is max(max(LMax, RMax), Value).

% maximize(Tree, M) :- M is Tree with all nodes replaced with the maximum value of Tree
maximize(void, void) :- !.
maximize(Tree, MaxTree) :- maximize(Tree, MaxTree, MaxVal, MaxVar), MaxVar is MaxVal.
maximize(tree(Value, void, void), tree(MaxVar, void, void), Value, MaxVar) :- !.
maximize(tree(Value, void, Right), tree(MaxVar, void, MaxRight), MaxVal, MaxVar) :-
    !,
    maximize(Right, MaxRight, MaxValRight, MaxVar),
    MaxVal is max(Value, MaxValRight).
maximize(tree(Value, Left, void), tree(MaxVar, MaxLeft, void), MaxVal, MaxVar) :-
    !,
    maximize(Left, MaxLeft, MaxValLeft, MaxVar),
    MaxVal is max(Value, MaxValLeft).
maximize(tree(Value, Left, Right), tree(MaxVar, MaxLeft, MaxRight), MaxVal, MaxVar) :-
    maximize(Left, MaxLeft, MaxValLeft, MaxVar),
    maximize(Right, MaxRight, MaxValRight, MaxVar),
    MaxVal is max(max(MaxValLeft, MaxValRight), Value).

example_small_tree(X) :-
    X = tree(
        4,
        tree(
            5,
            void,
            tree(1, void, void)
        ),
        tree(10, void, void)
    ).

example_large_tree(X) :-
    X = tree(
        37,
        tree(
            24,
            tree(
                7,
                tree(
                    2,
                    void,
                    void
                ),
                void
            ),
            tree(
                32,
                void,
                void
            )
        ),
        tree(
            42,
            tree(
                42,
                tree(
                    40,
                    void,
                    void
                ),
                void
            ),
            tree(
                120,
                void,void
            )
        )
    ).

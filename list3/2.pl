% max_sum(List, MaxSum) :- MaxSum is the maximal sum of values of any slice of List (List[i:j])
max_sum(List, MaxSum) :-
    max_sum(List, 0, 0, MaxSum).

max_sum([], _, CurrentMax, CurrentMax).
max_sum([Elem|List], CurrentContiguousMax, CurrentMax, MaxSum) :-
    NewContiguousMax is max(CurrentContiguousMax + Elem, Elem),
    NewMax is max(NewContiguousMax, CurrentMax),
    max_sum(List, NewContiguousMax, NewMax, MaxSum).

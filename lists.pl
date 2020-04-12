% subsequence(Xs, Ys) :- Xs is a subsequence of Ys, i.e. Ys is Xs with any elements interspersed
subsequence([X|Xs], [X|Ys]) :- subsequence(Xs, Ys).
subsequence(Xs, [_|Ys]) :- subsequence(Xs, Ys).
subsequence([], Ys) :- is_list(Ys).


% adjacent(X, Y, Zs) :- X and Y are adjacent elements of list Zs
adjacent(X, Y, [X, Y|_]).
adjacent(X, Y, [_|Zs]) :- adjacent(X, Y, Zs).


% last(X, Ys) :- X is the last element of list Ys
last(X, [X]).
last(X, [_|Ys]) :- last(X, Ys).


% double(List, ListList) :- ListList is List with elements doubled, e.g. double([1,2,3], [1,1,2,2,3,3]).
double([X|Xs], [X,X|Ys]) :- double(Xs, Ys).
double([], []).


% my_delete(Xs, X, Ys) :- list Ys is the same as Xs, but without elements X
my_delete([X|Xs], X, Ys) :- my_delete(Xs, X, Ys).
my_delete([X|Xs], Z, [X|Ys]) :- X \= Z, my_delete(Xs, Z, Ys).
my_delete([], _, []).


% quicksort(Xs, Ys) :- Ys is Xs sorted with the quicksort algorithm
quicksort(Xs, _) :- nonground(Xs, _), !, fail.
quicksort([], []).
quicksort([X], [X]) :- !.
quicksort([X, Y], [X, Y]) :- X =< Y, !.
quicksort([X, Y], [Y, X]) :- X > Y, !.
quicksort([X|Xs], Ys) :-
    my_partition(Xs, X, Smaller, Larger),
    quicksort(Smaller, SmallerSorted),
    quicksort(Larger, LargerSorted),
    append(SmallerSorted, [X|LargerSorted], Ys).


% my_partition(Xs, Y, Smaller, Larger) :- Smaller contains elements from Xs smaller than Y, Larger contains elements larger
my_partition([], _, [], []) :- !.
my_partition([X|Xs], Y, [X|Smaller], Larger) :- X < Y, my_partition(Xs, Y, Smaller, Larger), !.
my_partition([X|Xs], Y, Smaller, [X|Larger]) :- my_partition(Xs, Y, Smaller, Larger), !.


% insertion_sort(Xs, Ys) :- Ys is Xs sorted with the insertion sort algorithm
insertion_sort([], []).
insertion_sort([X], [X]).
insertion_sort([X|Xs], Zs) :-
    insertion_sort(Xs, Ys),
    insert(X, Ys, Zs).


% insert(X, Ys, Zs) :- list Zs is Ys with X inserted in sorted order
insert(X, [], [X]).
insert(X, [Y|Ys], [Y|Zs]) :- X > Y, insert(X, Ys, Zs).
insert(X, [Y|Ys], [X,Y|Ys]) :- X =< Y.


% halves(Xs, Ys, Zs) :- Ys and Zs are 2 halves of list Xs
halves(Xs, Ys, Zs) :-
    append(Ys, Zs, Xs),
    length(Ys, N1),
    length(Zs, N2),
    N1 > 0,
    (
        N1 is N2;
        N1 is N2 - 1
    ).


% merge_sort(Xs, Ys) :- Ys is Xs sorted with the merge sort algorithm
merge_sort([], []).
merge_sort([X], [X]).
merge_sort(Xs, Ys) :-
    halves(Xs, Half1, Half2),
    merge_sort(Half1, Half1Sorted),
    merge_sort(Half2, Half2Sorted),
    merge(Half1Sorted, Half2Sorted, Ys).


% merge(Xs, Ys, XYs) :- merge 2 sorted lists (Xs and Ys) into a sorted list XYs
merge([], Ys, Ys).
merge(Xs, [], Xs).
merge([X|Xs], [Y|Ys], [Y|XYs]) :- X > Y, merge([X|Xs], Ys, XYs).
merge([X|Xs], [Y|Ys], [X|XYs]) :- X =< Y, merge(Xs, [Y|Ys], XYs).


% substitute(X, Y, Xs, Ys) :- list Ys is Xs with all occurrences of X replaced with Y
substitute(_, _, [], []).
substitute(X, Y, [X|Xs], [Y|Ys]) :- substitute(X, Y, Xs, Ys).
substitute(X, Y, [Z|Xs], [Z|Ys]) :- X \= Z, substitute(X, Y, Xs, Ys).


% unique(Xs, Ys) :- list Ys is Xs without duplicates
unique([], []).
unique([X|Xs], [X|Ys]) :-
    nonmember(X, Xs),
    unique(Xs, Ys).
unique([X|Xs], Ys) :-
    member(X, Xs),
    unique(Xs, Ys).
unique([X|Xs], [X|Ys]) :-
    member(X, Xs),
    delete(Xs, X, Zs),
    unique(Zs, Ys).


% nonmember(X, Xs) :- X is not a member of the list Xs
nonmember(X, [Y|Ys]) :- X \= Y, nonmember(X, Ys).
nonmember(_, []).

unique2(Xs, Ys) :- unique2(Xs, [], Ys).

unique2([], _, []).
unique2([X|Xs], Uniq, Ys) :-
    member(X, Uniq),
    unique2(Xs, Uniq, Ys).
unique2([X|Xs], Uniq, [X|Ys]) :-
    nonmember(X, Uniq),
    unique2(Xs, [X|Uniq], Ys).
unique2([X|Xs], Uniq, Ys) :-
    member(X, Xs),
    nonmember(X, Uniq),
    unique2(Xs, Uniq, Ys).


% intersect(Xs, Ys, Zs) :- Zs is a list of all elements that are both in Xs an Ys
intersect(Xs, Ys, Zs) :- findall(X, (member(X, Xs), memberchk(X, Ys)), Zs).


% myselect(X, Xs, Rest) :- select(X, Xs, Rest), nondet
myselect(X, [H|T], Rest) :- myselect_(H, T, X, Rest).

myselect_(H, T, H, T).
myselect_(H, [H2|T], X, [H|Rest]) :- myselect_(H2, T, X, Rest).

% myselect2(X, Xs, Rest) :- select(X, Xs, Rest), for some reason det on last element
% probably this implementation of prolog indexes clauses only on first argument
myselect2(X, [H|T], Rest) :- myselect2_(T, H, X, Rest).

myselect2_(T, H, H, T).
myselect2_([H2|T], H, X, [H|Rest]) :- myselect2_(T, H2, X, Rest).


% select_adjacent(X, Y, Xs, Rest) :- Xs with adjacent elements X and Y removes is Rest
select_adjacent(X, Y, [H1,H2|Xs], Rest) :- select_adjacent_(Xs, H1, H2, X, Y, Rest).

select_adjacent_(Xs, H1, H2, H1, H2, Xs).
select_adjacent_([H3|Xs], H1, H2, X, Y, [H1|Rest]) :- select_adjacent_(Xs, H2, H3, X, Y, Rest).

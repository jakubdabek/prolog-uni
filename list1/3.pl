/*
         |             |           | bottle | cookie 
         |             | cup       | plate  |
bicycle  |             | camera    |        |
pencil   | hourglass   | butterfly | fish   |

*/

left_of(bottle, cookie).
left_of(cup, plate).
left_of(bicycle, camera).
left_of(pencil, hourglass).
left_of(hourglass, butterfly).
left_of(butterfly, fish).

above(bycicle, pencil).
above(cup, camera).
above(camera, butterfly).
above(bottle, plate).
above(plate, fish).

right_of(Right, Left) :- left_of(Left, Right).
below(Below, Above) :- above(Above, Below).

left_of_rec(Left, Right) :- left_of(Left, Right). % base case
left_of_rec(Left, Right) :-
    left_of(Left, Middle),
    left_of_rec(Middle, Right).

same_row(Item, Item).
same_row(Item1, Item2) :-
    left_of_rec(Item1, Item2);
    left_of_rec(Item2, Item1).

above_rec(Above, Below) :- above(Above, Below). % base case
above_rec(Above, Below) :-
    above(Above, Middle),
    above_rec(Middle, Below).

row_below(Below, Above) :-
    same_row(Below, BelowColumnIntersection),
    above(AboveColumnIntersection, BelowColumnIntersection),
    same_row(AboveColumnIntersection, Above).

higher(Higher, Lower) :- row_below(Lower, Higher). % base case
higher(Higher, Lower) :-
    row_below(Other, Higher),
    higher(Other, Lower).

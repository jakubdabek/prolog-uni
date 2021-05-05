/*
4
3
2
1
*/

on(block4, block3).
on(block3, block2).
on(block2, block1).

above(Above, Below) :- on(Above, Below). % base case
above(Block1, Block2) :-
    on(Block1, Block3),
    above(Block3, Block2).

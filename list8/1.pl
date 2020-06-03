:- use_module(library(clpfd)).

regions(map1, Regions) :-
    Regions = [R1, R2, R3, R4, R5, R6, R7, R8, R9],
    R1 #\= R2, R1 #\= R4, R1 #\= R5, R1 #\= R6,
    R2 #\= R3, R2 #\= R4, R2 #\= R9,
    R3 #\= R4, R3 #\= R5, R3 #\= R9,
    R4 #\= R5,
    R5 #\= R6, R5 #\= R7, R5 #\= R9,
    R6 #\= R7, R6 #\= R8,
    R7 #\= R8, R7 #\= R9,
    R8 #\= R9.

coloring(Regions) :-
    numlist(1, 4, Nums), % map coloring theorem says that you need at most 4 colors
    member(Num, Nums),
    coloring(Regions, Num).
    
coloring(Regions, Num) :-
    Regions ins 1 .. Num,
    label(Regions).

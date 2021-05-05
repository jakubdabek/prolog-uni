:- use_module(library(clpfd)).

% stones(+Num, +TotalWeight, -Weights)
%   finds the weights of stones into which we can split a stone with weight TotalWeight,
%   so that we can measure any weight 1..TotalWeight with these stones.
stones(Num, TotalWeight, Weights, Indicators) :-
    length(Weights, Num),
    Weights ins 1..TotalWeight,
    chain(Weights, #=<),
    sum(Weights, #=, TotalWeight),
    numlist(1, TotalWeight, Measures),
    maplist(can_measure(Weights), Measures, Indicators).

mul_expr(A, B, C) :- C #= A * B.

can_measure(Weights, Target, Target-Indicators) :-
    same_length(Weights, Indicators),
    Indicators ins -1..1, % we can put the stones on either side of the scale
    % can't use scalar_product with unbound variables
    maplist(mul_expr, Weights, Indicators, Products),
    sum(Products, #=, Target).


% ?- stones(5, 45, W, I), label(W), maplist(arg(2), I, IVars), append(IVars, IAll), label(IAll).

:- use_module(library(clpfd)).

% knapsack(+Values, +Weights, +Capacity, -Solution)
% finds the optimal solution to the 0-1 knapsack problem
knapsack(Values, Weights, Capacity, Solution) :-
    same_length(Values, Weights),
    same_length(Values, Solution),
    Solution ins 0..1,
    scalar_product(Weights, Solution, #=<, Capacity),
    scalar_product(Values, Solution, #=, SolutionValue),
    once(labeling([max(SolutionValue)], Solution)).

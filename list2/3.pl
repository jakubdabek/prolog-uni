/*
    A
   > \
  /   \
 <     >
B------>C------>D

*/

arc(a, b).
arc(b, a).
arc(b, c).
arc(c, d).

% reachable(X, Y) :- Y is reachable from X according to edge relation arc(A, B)
reachable(X, Y) :- reachable_dfs(X, [X], Y).

reachable_dfs(X, _, X).
reachable_dfs(X, Visited, Y) :-
    arc(X, Z),
    \+ member(Z, Visited),
    reachable_dfs(Z, [Z|Visited], Y).

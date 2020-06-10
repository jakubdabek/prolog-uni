:- use_module(library(clpfd)).

tasks(Tasks) :-
    % each task is a list of [duration, resource1 usage, resource2 usage]
    Tasks = [
        [2, 1, 3],
        [3, 2, 1],
        [4, 2, 2],
        [3, 3, 2],
        [3, 1, 1],
        [3, 4, 2],
        [5, 2, 1]
    ].

resource_limits(5, 5).

prepare_task(ResourceId, [Duration|Resources], Start, End, task(Start, Duration, End, Usage, _Id)) :-
    nth1(ResourceId, Resources, Usage).

max_step(X, Max0, Max) :- Max #= max(Max0, X).
list_maximum([X|Xs], Max) :- foldl(max_step, Xs, X, Max).

% gives the same results and domains as the previous one
max_step2(X, Max, Max) :- Max #>= X.
list_maximum2(Xs, Max) :- foldl(max_step2, Xs, Max, Max).

label_schedule(MaxTime, Starts, StopTime) :-
    schedule(MaxTime, Starts, StopTime),
    labeling([min(StopTime), ff], [StopTime|Starts]).

schedule(MaxTime, Starts, StopTime) :-
    tasks(SimpleTasks),
    resource_limits(R1, R2),
    maplist(prepare_task(1), SimpleTasks, Starts, Ends, Tasks1),
    maplist(prepare_task(2), SimpleTasks, Starts, Ends, Tasks2),
    Starts ins 0..MaxTime,
    Ends ins 0..MaxTime,
    cumulative(Tasks1, [limit(R1)]),
    cumulative(Tasks2, [limit(R2)]),
    StopTime in 0..MaxTime,
    list_maximum(Ends, StopTime).
    
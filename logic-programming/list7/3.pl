philosophers(N, Philosophers, Forks, Options) :-
    philosophers(1, N, Fork0, Fork0, Philosophers, Forks, Options).

philosophers(N, N, Fork0, ForkN, [philosopher(N, Options, fork(1, Fork0), fork(N, ForkN))], [ForkN], Options) :- !.
philosophers(K, N, Fork0, ForkK, [philosopher(K, Options, fork(K, ForkK), fork(K1, ForkK1))|Philosophers], [ForkK|Forks], Options) :-
    K < N,
    succ(K, K1),
    philosophers(K1, N, Fork0, ForkK1, Philosophers, Forks, Options).

create_forks(Forks) :- maplist(mutex_create, Forks).
cleanup_forks(Forks) :- maplist(mutex_destroy, Forks).

run_philosophers(Philosophers) :-
    maplist(thread_create, Philosophers, Ids),
    maplist(thread_join, Ids, _).

philosophers_main(MaxRounds) :-
    setup_call_cleanup(
        (
            philosophers(5, Philosophers, Forks, [max_rounds(MaxRounds)]),
            create_forks(Forks)
        ),
        run_philosophers(Philosophers),
        cleanup_forks(Forks)
    ).

spaces(N, AtomSpaces) :-
    length(Spaces, N),
    maplist(=(' '), Spaces),
    atomic_list_concat(Spaces, AtomSpaces).
    
format_philosopher(Id, Format, Args) :-
    spaces(Id, Spaces),
    atomic_list_concat([Spaces, '[~w] ', Format], Format1),
    format(Format1, [Id|Args]).

pickup_forks(PhilosopherId, fork(IdL, MutexL), fork(IdR, MutexR)) :-
    format_philosopher(PhilosopherId, 'wants fork ~w~n', [IdL]),
    mutex_lock(MutexL),
    format_philosopher(PhilosopherId, 'picked up fork ~w~n', [IdL]),
    format_philosopher(PhilosopherId, 'wants fork ~w~n', [IdR]),
    mutex_lock(MutexR),
    format_philosopher(PhilosopherId, 'picked up fork ~w~n', [IdR]).

release_forks(PhilosopherId, fork(IdL, MutexL), fork(IdR, MutexR)) :-
    mutex_unlock(MutexL),
    format_philosopher(PhilosopherId, 'released fork ~w~n', [IdL]),
    mutex_unlock(MutexR),
    format_philosopher(PhilosopherId, 'released fork ~w~n', [IdR]).

think(PhilosopherId, MinTime, MaxTime) :-
    format_philosopher(PhilosopherId, 'is thinking~n', []),
    random(MinTime, MaxTime, Time),
    sleep(Time).

eat(PhilosopherId, MinTime, MaxTime) :-
    format_philosopher(PhilosopherId, 'is eating~n', []),
    random(MinTime, MaxTime, Time),
    sleep(Time).

philosopher(Id, Options, ForkL, ForkR) :-
    select_option(max_rounds(MaxRounds), Options, Options1, 100),
    option(max_time(MaxTime), Options1, 2),
    option(min_time(MinTime), Options1, 1),
    (   succ(MaxRounds1, MaxRounds)
    ->  think(Id, MinTime, MaxTime),
        pickup_forks(Id, ForkL, ForkR),
        eat(Id, MinTime, MaxTime),
        release_forks(Id, ForkL, ForkR),
        philosopher(Id, [max_rounds(MaxRounds1)|Options1], ForkL, ForkR)
    ;   true
    ).

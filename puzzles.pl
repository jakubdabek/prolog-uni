% queens(N, Qs) :- Qs is a list of row numbers for N queens on a NxN chess board, so that no two queens attack each other
queens(N, Qs) :-
    numlist(1, N, Ns),
    queens(Ns, [], Qs).

queens([], SafeQs, SafeQs) :- !.
queens(UnplacedQs, SafeQs, Qs) :-
    select(Q, UnplacedQs, UnplacedQs1),
    \+ attack(Q, SafeQs),
    queens(UnplacedQs1, [Q|SafeQs], Qs).

% attack(Q, Qs) :- Q attacks any of the queens from Qs; Q is on the left next to the leftmost queen from Qs
attack(Q, Qs) :- attack(Q, Qs, 1).
attack(Q1, [Q2|_], N) :- Q1 is Q2 + N.
attack(Q1, [Q2|_], N) :- Q1 is Q2 - N.
attack(Q1, [_|Qs], N) :- N1 is N + 1, attack(Q1, Qs, N1).


queens_fast(N, Qs) :- length(Qs, N), place_queens(N, Qs, _, _).

place_queens(0, _, _, _).
place_queens(I, Qs, Ups, [_D|Downs]) :-
    I > 0,
    I1 is I - 1,
    place_queens(I1, Qs, [_U|Ups], Downs),
    place_queen(I, Qs, Ups, Downs).

place_queen(Q, [Q|_Qs], [Q|_Ups], [Q|_Downs]).
place_queen(Q, [_|Qs], [_|Ups], [_D|Downs]) :-
    place_queen(Q, Qs, Ups, Downs).


solve_puzzle(puzzle(Facts, Queries, Solution), Solution) :-
    solve(Facts),
    solve(Queries).

solve([]).
solve([Goal|Gs]) :- Goal, solve(Gs).

test_puzzle(Name, Structure, Solution) :-
    structure(Name, Structure),
    facts(Name, Structure, Facts),
    queries(Name, Structure, Queries, Solution),
    solve_puzzle(puzzle(Facts, Queries, Solution), Solution).

% facts in the famous "Einstein's puzzle"
facts(
    einstein,
    People,
    [
        ( % The Englishman lives in the red house
            member(P1, People),
            nationality(P1, english),
            house_color(P1, red)
        ),
        ( % The Spaniard owns the dog
            member(P2, People),
            nationality(P2, spanish),
            owns_pet(P2, dog)
        ),
        ( % Coffee is drunk in the green house
            member(P3, People),
            drinks(P3, coffee),
            house_color(P3, green)
        ),
        ( % The Ukrainian drinks tea
            member(P4, People),
            nationality(P4, ukrainian),
            drinks(P4, tea)
        ),
        ( % The green house is immediately to the right of the ivory house
            select(P5_1, People, People5),
            member(P5_2, People5),
            house_color(P5_1, green),
            house_color(P5_2, ivory),
            house_position(P5_1, Pos5_1),
            house_position(P5_2, Pos5_2),
            right_of(Pos5_1, Pos5_2)
        ),
        ( % The Winston smoker owns snails
            member(P6, People),
            smokes(P6, winston),
            owns_pet(P6, snails)
        ),
        ( % Kools are smoked in the yellow house
            member(P7, People),
            smokes(P7, kools),
            house_color(P7, yellow)
        ),
        ( % Milk is drunk in the middle house
            member(P8, People),
            drinks(P8, milk),
            house_position(P8, right_of(right_of(leftmost)))
        ),
        ( % The Norwegian lives in the first house on the left
            member(P9, People),
            nationality(P9, norwegian),
            house_position(P9, leftmost)
        ),
        ( % The man who smokes Chesterfields lives in the house next to the man with the fox
            select(P10_1, People, People10),
            member(P10_2, People10),
            smokes(P10_1, chesterfields),
            owns_pet(P10_2, fox),
            house_position(P10_1, Pos5_1),
            house_position(P10_2, Pos5_2),
            next_to(Pos5_1, Pos5_2)
        ),
        ( % Kools are smoked in the house next to the house where the horse is kept
            select(P11_1, People, People11),
            member(P11_2, People11),
            smokes(P11_1, kools),
            owns_pet(P11_2, horse),
            house_position(P11_1, Pos5_1),
            house_position(P11_2, Pos5_2),
            next_to(Pos5_1, Pos5_2)
        ),
        ( % The Lucky Strike smoker drinks orange juice
            member(P12, People),
            smokes(P12, lucky_strikes),
            drinks(P12, orange_juice)
        ),
        ( % The Japanese smokes Parliaments
            member(P13, People),
            nationality(P13, japanese),
            smokes(P13, parliaments)
        ),
        ( % The Norwegian lives next to the blue house
            select(P14_1, People, People14),
            member(P14_2, People14),
            nationality(P14_1, norwegian),
            house_color(P14_2, blue),
            writeln(People),
            house_position(P14_1, Pos5_1),
            house_position(P14_2, Pos5_2),
            next_to(Pos5_1, Pos5_2)
        )
    ]
).

queries(
    einstein,
    People,
    [
        ( % Who owns the zebra?
            member(P1, People),
            nationality(P1, Nat1),
            owns_pet(P1, fox)
        )
        % ( % Who drinks water?
        %     member(P2, People),
        %     nationality(P2, Nat2),
        %     drinks(P2, water)
        % )
    ],
    [
        [Nat1, "owns the zebra"],
        [Nat2, "drinks water"]
    ]
).

house_position(Pos) :- house_position_(Pos, 5).
house_position_(leftmost, _).
house_position_(right_of(Pos), N) :- N > 0, N1 is N - 1, house_position_(Pos, N1).

person(_HousePosition, _HouseColor, _Nationality, _Pet, _Drink, _Cigarettes).
house_position(person(HousePosition, _, _, _, _, _), HousePosition).
house_color(person(_, HouseColor, _, _, _, _), HouseColor).
nationality(person(_, _, Nationality, _, _, _), Nationality).
owns_pet(person(_, _, _, Pet, _, _), Pet).
drinks(person(_, _, _, _, Drink, _), Drink).
smokes(person(_, _, _, _, _, Cigarettes), Cigarettes).

unique_person1(People, Property, Value, Person) :-
    select(Person, People, Rest),
    Goal =.. [Property, Person, Value],
    Goal,
    OtherGoal =.. [Property, OtherPerson, OtherValue],
    \+ (member(OtherPerson, Rest), OtherGoal, ground(OtherValue), OtherValue = Value).

unique_person(People, Properties, Values, Person) :-
    select(Person, People, Rest),
    Goal =.. [Properties, Person, Values],
    Goal,
    OtherGoal =.. [Properties, OtherPerson, OtherValues],
    \+ (member(OtherPerson, Rest), OtherGoal, ground(OtherValues), OtherValues = Values).

unique_person_test(People, Person) :-
    People = [
        person(leftmost, _, _, _, _, _),
        person(right_of(X), _, _, _, _, _),
        person(_, _, _, _, _, _),
        person(X, _, _, _, _, _)
    ],
    unique_person(People, house_position, right_of(right_of(leftmost)), Person).

structure(
    einstein,
    [
        person(_, _, _, _, _, _),
        person(_, _, _, _, _, _),
        person(_, _, _, _, _, _),
        person(_, _, _, _, _, _),
        person(_, _, _, _, _, _)
    ]
).

left_of(Pos, right_of(Pos)) :- house_position(Pos).
right_of(right_of(Pos), Pos) :- house_position(Pos).
next_to(Pos1, Pos2) :- left_of(Pos1, Pos2); right_of(Pos1, Pos2).

:- ['../list5/1.pl'].
:- ['./1.pl'].

execute_file(FileName) :-
    setup_call_cleanup(
        open(FileName, read, Stream),
        scanner(Stream, Tokens),
        close(Stream)
    ),
    phrase(program(Program), Tokens),
    execute(Program).

execute(Program) :- exec_program(Program, [], _).

exec_program([], Memory, Memory) :- !.
exec_program([Instruction|Program], Memory, Memory2) :-
    exec_instruction(Instruction, Memory, Memory1),
    exec_program(Program, Memory1, Memory2).

exec_instruction(assign(X, Expr), Memory, Memory1) :-
    eval_expr(Expr, Memory, Value),
    mem_set(X=Value, Memory, Memory1).
exec_instruction(read(X), Memory, Memory1) :-
    read(Input),
    mem_set(X=Input, Memory, Memory1).
exec_instruction(write(Expr), Memory, Memory) :-
    eval_expr(Expr, Memory, Value),
    write(Value), nl.
exec_instruction(if(Condition, Then), Memory, Memory1) :-
    (   check_true(Condition, Memory)
    ->  exec_program(Then, Memory, Memory1)
    ;   true
    ).
exec_instruction(if(Condition, Then, Else), Memory, Memory1) :-
    (   check_true(Condition, Memory)
    ->  exec_program(Then, Memory, Memory1)
    ;   exec_program(Else, Memory, Memory1)
    ).
exec_instruction(while(Condition, Do), Memory, Memory2) :-
    (   check_true(Condition, Memory)
    ->  exec_program(Do, Memory, Memory1),
        exec_instruction(while(Condition, Do), Memory1, Memory2)
    ;   Memory2 = Memory
    ).

eval_expr(int(X), _, X) :- !.
eval_expr(id(X), Memory, Value) :-
    !,
    mem_get(X, Memory, Value).
eval_expr(Expr, Memory, Value) :-
    Expr =.. [Op, Left, Right],
    !,
    eval_expr(Left, Memory, ValueLeft),
    eval_expr(Right, Memory, ValueRight),
    eval_op(Op, ValueLeft, ValueRight, Value).

eval_op(Op, X, Y, Val) :-
    !,
    Expr =.. [Op, X, Y],
    Val is Expr.

check_true((C1, C2), Memory) :-
    !,
    check_true(C1, Memory),
    check_true(C2, Memory).
check_true((C1; C2), Memory) :-
    !,
    (
        check_true(C1, Memory), !
    ;   check_true(C2, Memory)
    ).
check_true(Cond, Memory) :-
    Cond =.. [Op, Left, Right],
    eval_expr(Left, Memory, ValueLeft),
    eval_expr(Right, Memory, ValueRight),
    check_cond_op(Op, ValueLeft, ValueRight).

check_cond_op(Op, X, Y) :-
    !,
    Expr =.. [Op, X, Y],
    Expr.


mem_set(X=Val, [], [X=Val]) :- !.
mem_set(X=Val, [X=_|Memory], [X=Val|Memory]) :- !.
mem_set(X=Val, [M|Memory], [M|Memory1]) :- !, mem_set(X=Val, Memory, Memory1).

mem_get(X, [X=Val|_], Val) :- !.
mem_get(X, [_|Memory], Val) :- mem_get(X, Memory, Val).

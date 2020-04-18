parse(Tokens, Program) :-
    phrase(program(Program), Tokens).

program([Instruction|Program]) --> instruction(Instruction), !, program(Program).
program([]) --> [].

instruction(assign(X, Expression))  -->
    [id(X)], [sep(:=)], expression(Expression), [sep(;)].
instruction(read(X)) -->
    [key(read)], [id(X)], [sep(;)].
instruction(write(Expression)) -->
    [key(write)], expression(Expression), [sep(;)].
instruction(if(Condition, Then)) -->
    [key(if)], condition(Condition), [key(then)], program(Then), [key(fi)], [sep(;)].
instruction(if(Condition, Then, Else)) -->
    [key(if)], condition(Condition), [key(then)], program(Then), [key(else)], program(Else), [sep(;)].
instruction(while(Condition, Do)) -->
    [key(while)], condition(Condition), [key(do)], program(Do), [key(od)], [sep(;)].


expression(Addend + Expression) -->
    addend(Addend), [sep(+)], expression(Expression).
expression(Addend - Expression) -->
    addend(Addend), [sep(-)], expression(Expression).
expression(Addend) -->
    addend(Addend).


addend(Factor * Addend) -->
    factor(Factor), [sep(*)], addend(Addend).
addend(Factor / Addend) -->
    factor(Factor), [sep(/)], addend(Addend).
addend(Factor mod Addend) -->
    factor(Factor), [key(mod)], addend(Addend).
addend(Factor) --> factor(Factor).


factor(id(X)) -->
    [id(X)].
factor(int(X)) -->
    [int(X)].
factor(Expression) -->
    [sep('(')], expression(Expression), [sep(')')].


condition(Conjunction ; Condition) -->
    conjunction(Conjunction), [key(or)], condition(Condition).
condition(Conjunction) -->
    conjunction(Conjunction).


conjunction((Simple, Conjunction)) -->
    simple(Simple), [key(and)], conjunction(Conjunction).
conjunction(Simple) --> simple(Simple).


simple(Left =:= Right) -->
    expression(Left), [sep(=)], expression(Right).
simple(Left =\= Right) -->
    expression(Left), [sep(/=)], expression(Right).
simple(Left < Right) -->
    expression(Left), [sep(<)], expression(Right).
simple(Left > Right) -->
    expression(Left), [sep(>)], expression(Right).
simple(Left >= Right) -->
    expression(Left), [sep(>=)], expression(Right).
simple(Left =< Right) -->
    expression(Left), [sep(=<)], expression(Right).
simple(Condition) -->
    [sep('(')], condition(Condition), [sep(')')].

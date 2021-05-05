tokens([Token|Tokens]) --> token(Token), ignore, !, tokens(Tokens).
tokens([]) --> [].

ignore --> match_type_star(space, _), !.

token(Token) --> id(Token).
token(Token) --> key(Token).
token(Token) --> sep(Token).
token(Token) --> int(Token).

id(id(Id))    --> match_type_plus(upper, Codes), !, {atom_codes(Id, Codes)}.
key(key(Key)) --> match_type_plus(lower, Codes), !, {atom_codes(Key, Codes), is_keyword(Key)}.
sep(sep(Sep)) --> match_type_plus(punct, Codes), !, {atom_codes(Sep, Codes), is_separator(Sep)}.
int(int(Int)) --> match_type_plus(digit, Codes), !, {number_codes(Int, Codes)}.

all_keywords(Keywords) :-
    Keywords = [
        read,
        write,
        if,
        then,
        else,
        fi,
        while,
        do,
        od,
        and,
        or,
        mod
    ].

is_keyword(Key) :- all_keywords(Keywords), member(Key, Keywords).

all_separators(Separators) :-
    Separators = [
        ';',
        '+',
        '-',
        '*',
        '/',
        '(',
        ')',
        '<',
        '>',
        '=<',
        '>=',
        ':=',
        '=',
        '/='
    ].

is_separator(Sep) :- all_separators(Separators), !, member(Sep, Separators).

match_type(Type, Code) --> [Code], {code_type(Code, Type)}.
match_type_star(Type, [C|Codes]) --> match_type(Type, C), !, match_type_star(Type, Codes).
match_type_star(_, []) --> [].
match_type_plus(Type, [C|Codes]) --> match_type(Type, C), !, match_type_star(Type, Codes).

scanner(Stream, Tokens) :-
    phrase_from_stream(tokens(Tokens), Stream).

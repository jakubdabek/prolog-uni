txt = """
?- between(1, 12, N), writeln(N), time((lista(N, _), fail)).
1
% 18 inferences, 0.000 CPU in 0.001 seconds (0% CPU, Infinite Lips)
2
% 31 inferences, 0.000 CPU in 0.000 seconds (?% CPU, Infinite Lips)
3
% 78 inferences, 0.000 CPU in 0.000 seconds (?% CPU, Infinite Lips)
4
% 281 inferences, 0.000 CPU in 0.000 seconds (?% CPU, Infinite Lips)
5
% 1,355 inferences, 0.000 CPU in 0.000 seconds (?% CPU, Infinite Lips)
6
% 8,069 inferences, 0.000 CPU in 0.000 seconds (?% CPU, Infinite Lips)
7
% 56,516 inferences, 0.016 CPU in 0.004 seconds (391% CPU, 3617024 Lips)
8
% 453,163 inferences, 0.031 CPU in 0.033 seconds (95% CPU, 14501216 Lips)
9
% 4,088,361 inferences, 0.297 CPU in 0.301 seconds (99% CPU, 13771321 Lips)
10
% 40,974,839 inferences, 3.109 CPU in 3.179 seconds (98% CPU, 13177838 Lips)
11
% 451,618,970 inferences, 33.422 CPU in 34.325 seconds (97% CPU, 13512676 Lips)
12
% 5,428,949,729 inferences, 403.297 CPU in 413.507 seconds (98% CPU, 13461423 Lips)
false.
"""

for i, info in enumerate(txt[1::2], start=1):
    fact = factorial(i)
    inferences = int(''.join(info.split()[1].split(',')))
    print(f"{i:2} | {fact:12} | {inferences:12} | {(inferences/fact):4.2f}")

"""
 1 |            1 |           18 | 18.00
 2 |            2 |           31 | 15.50
 3 |            6 |           78 | 13.00
 4 |           24 |          281 | 11.71
 5 |          120 |         1355 | 11.29
 6 |          720 |         8069 | 11.21
 7 |         5040 |        56516 | 11.21
 8 |        40320 |       453163 | 11.24
 9 |       362880 |      4088361 | 11.27
10 |      3628800 |     40974839 | 11.29
11 |     39916800 |    451618970 | 11.31
12 |    479001600 |   5428949729 | 11.33
"""

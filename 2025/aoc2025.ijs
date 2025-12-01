NB. see https://adventofcode.com/2025/day/1

NB. 1.1
NB. ---
ex1 =: cutLF 0 : 0
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
)

f1 =: {{ +/ 0 = 100 | +/\ 50, (([: <: [: +: 'R'={.) * ".@}.) every y }}

day1 =: LF cut fread '~/u/advent_of_code/2025/day_1.txt'
f1 day1
NB. => 1165

NB. 1.2
f1b =: {{ +/\ 50, (([: <: [: +: 'R'={.) * ".@}.) every y }}
f1c =: ((1- [: +: >)*[) (-~&((<.@%)&100)) (1- [: +: >) * ]

+/ 2 f1c/\ f1b day1
NB. => 6496

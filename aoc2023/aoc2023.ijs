NB. see https://adventofcode.com/2023/day/1

NB. 1.1
NB. ---
ex1 =: LF cut 0 : 0
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
)

f1 =: [: +/ 10 1 * [: ".&> [: ({.,{:) (#~ e.&'0123456789')
+/ > f1 each LF cut fread '~/u/j/aoc/aoc2023/day_1.txt'
NB. => 54601

NB. 1.2:
ex1b =: LF cut 0 : 0
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
)

NB. I don't see an easy way to do this without a loop or rxrplc
load 'regex'
repl1 =: 3 : 0 
  for_ijk. 'one';'two';'three';'four';'five';'six';'seven';'eight';'nine' do.
    ijk =. >ijk
    y =. (ijk; ijk,((": >: ijk_index), ijk)) rxrplc y
  end.
  y
)

f1b =: [: +/ 10 1 * [: ".&> [: ({.,{:) [: (#~ e.&'0123456789') repl1
+/ > f1b each LF cut fread '~/u/j/aoc/aoc2023/day_1.txt'
NB. => 54078

NB. ----------------------------------------------------------------------

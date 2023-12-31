NB. see https://adventofcode.com/2023/day/1

NB. 1.1
NB. ---
ex1 =: LF cut 0 : 0
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
)
day1 =: LF cut fread '~/u/j/aoc/aoc2023/day_1.txt'

f1 =: [: +/ 10 1 * [: ".&> [: ({.,{:) (#~ e.&'0123456789')
+/ f1 &> day1
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
repl1 =: 3 : 0
  for_ijk. 'one';'two';'three';'four';'five';'six';'seven';'eight';'nine' do.
    ijk =. >ijk
    y =. y rplc ijk; ijk,((": >: ijk_index), ijk)
  end.
  y
)

f1b =: [: +/ 10 1 * [: ".&> [: ({.,{:) [: (#~ e.&'0123456789') repl1
+/ > f1b each day1
NB. => 54078

NB. ----------------------------------------------------------------------

NB. 2.1
NB. ---
ex2 =: LF cut 0 : 0
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
)
day2 =: LF cut fread '~/u/j/aoc/aoc2023/day_2.txt'

p2_red =: 12
p2_green =: 13
p2_blue =: 14

p2_game =: [: ".@> [: {: [: cut [: > {.
p2_ok =: [: *./ [: ([: (".@{. <: [: ". 'p2_'&,@{:) [: > cut)&> ',' cut ',' joinstring ';' cut [: > {:
+/ */"1 >([: (p2_game,p2_ok) ':'&cut) every day2
NB. => 2239

NB. 2.2:
p2_tr =: 3 : 0
  'ns c' =. cut y
  n =. ". ns
  if. c -: 'red' do. n, 0, 0
  elseif. c -: 'green' do. 0, n, 0
  else. 0, 0, n
  end.
)

+/ ([: */ [: >./ [: >./ [: {{p2_tr&>y}}&> [: ','&cut&.> ';'&cut) &> {:"1':'&cut &> day2
NB. => 83435

NB. ----------------------------------------------------------------------


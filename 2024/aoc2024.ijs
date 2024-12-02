NB. See https://adventofcode.com/2024

1!:44 '/Users/mathias/u/advent_of_code/2024'

NB. 1 - TODO

NB. ----------------------------------------------------------------------

NB. 2.1
NB. ---
ex2 =: LF cut 0 : 0
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
)

f2 =: [: *./ [: (([: 3&>: [: >./ |) , 1 = [: # [: ~. *) }. - }: 
day2 =: LF cut fread './2.txt'
+/ ([: f2a [: ". >) every day2
NB. => 534


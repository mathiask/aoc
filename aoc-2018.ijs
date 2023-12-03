NB. Advent of code 2018, day 25
NB. Finding constellations using transitive closures

]in25 =: do@(('-';'_')&stringreplace) every cutLF fread '/Users/mathias/u/j/2018day25.txt'
# ~. (+./ . *.)~^:_ ] 3 >: +/"1 | -"1/~ in25
NB. => 363

f =: [: #@~. [: (+./ . *.)~^:_ [: <:&3 [: +/"1@:| (-"1)/~

NB. 13 : '# ~. (+./ . *.)~^:_ ] 3 >: +/"1 | -"1/~ y'
NB.  # [: ~. [: +./ .*.~^:_ [: ] 3 >: [: +/"1 [: | -"1/~

NB. -------------------------------------------------------------------------

NB. Tutorial

]e3 =: do every cutLF noun define
 1, _1,  0,  1
 2,  0, _1,  0
 3,  2, _1,  0
 0,  0,  3,  1
 0,  0, _1, _1
 2,  3, _2,  0
_2,  2,  0,  0
 2, _2,  0, _1
 1, _1,  0, _1
 3,  2,  0,  2
)

e3
$e3
$ (-"1)/~ e3
{. (-"1)/~ e3
+/"1 | (-"1)/~ e3

<:&3 +/"1 | (-"1)/~ e3
]a =. <:&3 +/"1 | (-"1)/~ e3

a (+/ . *) a
a (+./ . *.) a
(+./ . *.)~ a
(+./ . *.)~^:2 a
(+./ . *.)~^:_ a

~. (+./ . *.)~^:_ a
# ~. (+./ . *.)~^:_ a

# ~. (+./ . *.)~^:_ <:&3 +/"1 | (-"1)/~ e3

NB. ======================================================================

NB. This translates to numpy as follows
NB. 
NB. >>> in25=np.loadtxt('/Users/mathias/u/j/2018day25.txt', delimiter=',', dtype='int64')
NB. >>> a3=np.array([1,-1,0,1,
NB. ...    2,0,-1,0,
NB. ...    3,2,-1,0,
NB. ...    0,0,3,1,
NB. ...    0,0,-1,-1,
NB. ...    2,3,-2,0,
NB. ...    -2,2,0,0,
NB. ...    2,-2,0,-1,
NB. ...    1,-1,0,-1,
NB. ...    3,2,0,2
NB. ...]).reshape(10,4)
NB.
NB. >>> def mpow2(m, n):
NB. ...    for i in range(n):
NB. ...        m *= m
NB. ...    return m
NB.
NB. >>> np.unique(mpow2(np.matrix(np.absolute(np.array([in25 - a for a in in25])).sum(axis=2) <= 3), 11), axis=0).shape[0]

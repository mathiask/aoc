NB. See https://adventofcode.com/2022

NB. 1.1
NB. ---
>./ > +/ @: (". every) each (<;._2 LF chopstring fread '/Users/mathias/u/advent_of_code/2022/aoc-2022-1.txt')
NB. => 72602

NB. ... or ...
>./ > +/ @: (". every) each (a: cut <;._2 fread '/Users/mathias/u/advent_of_code/2022/aoc-2022-1.txt')


NB. 1.2
NB. ---
+/ 3 {. \:~ > +/ @: (". every) each (<;._2 LF chopstring fread '/Users/mathias/u/advent_of_code/2022/aoc-2022-1.txt')
NB. => 207410

NB. ... or ...
+/ 3 {. \:~ > +/ @: (". every) each (a: cut <;._2 fread '/Users/mathias/u/advent_of_code/2022/aoc-2022-1.txt')

NB. ----------------------------------------------------------------------

NB. 2.1
NB. ---_
+/ > ([: +/ (('ABC' i. {.) ([: >: ] + (3 3 $ 3 6 0 0 3 6 6 0 3) {~ [: < ,) ('XYZ' i. {:))) each (;&;: each LF cut fread '/Users/mathias/u/advent_of_code/2022/aoc-2022-2.txt')
NB. => 13446

NB. 2.2
NB. ---_
+/;(('ABC' i. {.) ([: >: ]+((3 3 $ 3 6 0 0 3 6 6 0 3){~[) i. ])(3 * 'XYZ' i. {:)) each ;&;:each LF cut fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-2.txt'
NB. => 13509

NB. ----------------------------------------------------------------------

NB. 3.1: Let us try a different, less terse style...
NB. ------------------------------------------------

valP3 =: [: ((58&+)^:(<&0 & ])) 96 -~ a.&i.
sP3 =: valP3@{.@(-:&# ({. (e. # [) }.) ])

NB. the @{. is needed in case an item occurs more than once in a compartment

p3 =. LF cut fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-3.txt'
+/ sP3 every p3
NB. => 7742

NB. 3.2
NB. ---
sP3b =: valP3@{.@(0&{ (e.#[) 1&{ (e.#[) 2&{)
+/ sP3b"2 > _3 ]\ p3
NB. => 2276

NB. ----------------------------------------------------------------------

NB. 4.1
NB. ---
p4 =. LF cut fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-4.txt'
s4lcont =: (<: & (0&{)) *. (>: & (1&{))
s4cont =: s4lcont +. s4lcont~
s4 =: ((0 2)&{ s4cont (4 6)&{) @: ". @: > @ ;: @ >

NB. The two @:s are needed and cannot be replaced by @ or &

+/ s4 p4
NB. => 503

NB. 4.2
NB. ---
s4left_of =: 1&{@[ < 0&{@]
s4overlaps =: [: -. s4left_of +. s4left_of~
s4 =: ((0 2)&{ s4overlaps (4 6)&{) @: ". @: > @ ;: @ >
+/ s4b p4
NB. => 827

NB. ----------------------------------------------------------------------

NB. 5.1
NB. ---

NB. The CONCISE SOLUTION is in the block of six lines near the end.

NB. p5 =: <;._2 fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-5pre.txt'
p5 =: <;._2 fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-5.txt'
p5s =: }: {. (p5 ];._2~ a: = p5)
p5t =: {{ {."1 ;: |: (>: 4 * i. (>: }. $ y) % 4) {"1 y}} ,&> p5s

P5move =: 4 : '((}. > ({. x){y) ; (({. > ({. x){y)&, &.> (}. x){y)) x} y'
P5apply =: verb define
  :
  if. 1 > #x  do. y
  elseif. 1 > (<0 0){x do. (}. x) P5apply y
  else. ((<: (<0 0) { x) (< 0 0)} x) P5apply (<: }. {. x) P5move y
  end.
)

p5m =: ".&> (1 3 5)&{ @ ;: &> {. (p5 ];._1~ a: = p5)
{.&> p5m P5apply p5t
NB. => MQTPGLLDN

NB. 5.2
NB. ---
P5moveB =: 4 : '((({.x) }. > (1{x){y) ; ((({.x) {. > (1{x){y)&, &.> (2{x){y)) (}.x)} y'
P5applyB =: verb define
  :
  if. 1 > #x  do. y
  else. (}. x) P5applyB (0 _1 _1 + {. x) P5moveB y
  end.
)

{.&> p5m P5applyB p5t
NB. => LVZPSTTCZ

Note Inspiration from APL solution
  Looking at Jay Foad's solution at
  https://github.com/jayfoad/aoc2022apl/blob/main/p5.dyalog

      ⎕IO←1 ⋄ p q←{⍵⊆⍨×≢¨⍵}⊃⎕NGET'p5.txt'1
      p←~∘' '¨{⍵/⍨2=4|⍳≢⍵}↓⍉↑p ⋄ q←⍎¨¨'\d+'⎕S'&'¨q
      f←{(⍺⍺¨⌽⍺↑¨⍵),¨⍺↓¨⍵} ⋄ g←{(⊃⍺)0⍺⍺f@(1↓⍺)⊢⍵}
      ⊃¨⊃⌽g/(⌽q),⊂p ⍝ part 1
      ⊃¨⊃⊢g/(⌽q),⊂p ⍝ part 2

  we can try to express this in J:'
)

NB. ==================== CONCISE SOLUTION ====================
'p q' =. ];._1 a:,<;._2 fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-5.txt'
(p=.{{<@dlb"1 y#~1=4|i.#y}}|:p) ] q=.".&>(1 3 5){"1;:q
f =: {{ (u&.> |. x{.&.>y) ,&.> x}.&.>y }}
g =: adverb : '((0,~[:{.[) (u f) ] {~ [:}.[)`([:}.[)`]}'
{.&> >|.g&.>/ |.('';p);<"1 q   NB. 5a
{.&> > ]g&.>/ |.('';p);<"1 q   NB. 5b
NB. ==================== CONCISE SOLUTION ====================

Note Variant without adverb
   fb =: ([: |. {.&.>) ,&.> }.&.>
   gb =: ((0,~[:{.[) fb ] {~ [:}.[)`([:}.[)`]}
   {.&> >gb&.>/ |.('';p);<"1 q

   fa =: ([: |.&.> [: |. {.&.>) ,&.> }.&.>
   ga =: ((0,~[:{.[) fa ] {~ [:}.[)`([:}.[)`]}
   {.&> >ga&.>/ |.('';p);<"1 q
)

NB. ----------------------------------------------------------------------

NB. 6.1
4 + 1 i.~ [: (4=#@~."1) [: 3&}. _4&{.\
NB. 6.2
14 + 1 i.~ [: (14=#@~."1) [: 13&}. _14&{.\

NB. ----------------------------------------------------------------------

NB. 7.1
NB. ---
]p =. cut ;._2 fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-7pre.txt'

docd =: {{ if. x -: ,'/' do. ,<,'/' elseif. x -: '..' do. }. y else. ((([: (,&'/')`]@.('/' = [:{:]) ]) >{.y) ,x) ; y end. }}
f7 =: {{ if. ((,'$');'cd') -: 2{.x do. (>2{x) docd y else. y end. }}

(#~ 0&~:@>@{."1) (0&".&.>{."1 p) ,. (<a:) ]F:. (<@f7 >) p
+/ (#~ 100000&>:) (([: {."1 ]) +/@;/. [: {:"1 ]) ;([: < ([: > [:{:]) ,. [:{.])"1 (#~ 0&~:@>@{."1) (0&".&.>{."1 p) ,. (<a:) ]F:. (<@f7 >) p
NB. => 1555642

NB. 7.2
NB. ---
<./(#~ ] >: (30000000 - 70000000 - >./))(([: {."1 ]) +/@;/. [: {:"1 ]) ;([: < ([: > [:{:]) ,. [:{.])"1 (#~ 0&~:@>@{."1) (0&".&.>{."1 p) ,. (<a:) ]F:. (<@f7 >) p
NB. => 5974547

NB. ----------------------------------------------------------------------

NB. 8.1
NB. ---
froml =: (> _1 , [: }: [: >./\ ])"1
+/+/(froml+.(froml&.(|."1))+.(froml&.|:)+.(froml&.(|."1@:|:))) "."0;._2 fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-8.txt'
NB. => 1763

NB. 8.2
NB. ---
viewr  =: [: +/ [: (] +. [: }: 1,]) [: */\ {. > }.
viewsr =: (viewr@}.~"(1 0) [:i.#)"1
>./>./(viewsr * (viewsr&.(|."1)) * (viewsr&.|:) * (viewsr&.(|."1@:|:))) "."0;._2 fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-8.txt'
NB. => 671160


NB. ----------------------------------------------------------------------

NB. 9.1
NB. ---

]p9 =. cutLF fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-9.txt'
d9 =: (4 2 $ _1 0 1 0 0 _1 0 1) {~ 'LRUD' i. ;(".@}. $ ,@>@{.)"1 &.> p9
s9 =: (] + [:*-)^:(1 < [: >./ [:|-)
#~.>{:"1(0 0;0 0) ]F:.(([ + [:>@{.]) ([;s9) >@{:@]) d9
NB. => 6090

NB. 9.2
NB. ---
s9b =: (([ + [:{.]) ([, ]F:.(s9~)) [:}.])"(1 2)
# ~. 9&{"2 (10 2 $ 0) ]F:. s9b ] d9
NB. => 2566

NB. ----------------------------------------------------------------------

NB. 10.1
NB. ----
]p10 =. <;._2 fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-10.txt'
parse =: (2,".@>@}.@cut)`(1 0"_)@.('noop'&-:)
+/(18 + 40 * i.6) { (2&+@i.@# * >:@(+/\)) >,&.>/ <@({.((<:@[ $ 0:),{.@$){:)"1 parse&> p10
NB. => 12880

NB. 10.2
NB. ----
6 40 $ '.#' {~ (40 | i.240) (>: *. [ < 3 + ]) ] 0,}:(+/\)>,&.>/ <@({.((<:@[ $ 0:),{.@$){:)"1 parse&> p10

NB. ----------------------------------------------------------------------

NB. 11.1
NB. ----

NB. APL inspired solution, see below:

p11 =: > a: cut <;._2 fread '/Users/mathias/u/advent_of_code/2022/aoc-2022-11.txt'
atoi =: (a.{~48+i.10) ".@(e.~#]) ]
parse =: ([: atoi 0 pick ]); ([: ". ':' takeafter 1 pick ]); ('=' takeafter 2 pick ]); ([: atoi 3 pick ]); ([: atoi 4 pick ]); [: atoi 5 pick ]
]pp11 =: parse"1 p25

s11 =: verb define
  ms =. y
  for_i. i.#y do.
    m =. i { ms
    m =. (<(1 pick m) + # 2 pick m) 1}m
    items =. (<.@%&3)@".@((3 pick m) stringreplace~ 'old';[:":])"0 ] 2 pick m
    m =. a: 2} m
    ms =. m i} ms
    for_it. items do.
      j =. (((6 pick m),5 pick m) {~ 0 = [: }. (0, (4 pick m)) #: ]) it
      ms =. (< it ,~ >(< j,2) { ms) (< j,2)} ms
    end.
  end.
  ms
)

*/ 2 {. \:~ 1&pick"1 s11^:20 pp11
NB. => 100345

NB. 11.2
NB. ----

s11b =: verb define
  ms =. y
  d =. */ 4 pick"(0 1) pp11
  for_i. i.#y do.
    m =. i { ms
    m =. (<(1 pick m) + # 2 pick m) 1}m
    items =. (d&|)@".@((3 pick m) stringreplace~ 'old';[:":])"0 ] 2 pick m
    m =. a: 2} m
    ms =. m i} ms
    for_it. items do.
      j =. (((6 pick m),5 pick m) {~ 0 = [: }. (0, (4 pick m)) #: ]) it
      ms =. (< it ,~ >(< j,2) { ms) (< j,2)} ms
    end.
  end.
  ms
)

NB. Somehow, the numbers in the example did not match, but the final
NB. result below is correct:

*/ 2 {. \:~ 1&pick"1 s11b^:10000 pp11
NB. => 28537348205

Note Jay Foad's APL solution (https://github.com/jayfoad/aoc2022apl/blob/main/p11.dyalog)
  ⎕IO←0 ⋄ ⎕PP←17
  n←{⍎'0',⍵}¨¨¨'\d+'⎕S'&'¨¨p←(×≢¨p)⊆p←⊃⎕NGET'p11.txt'1
  m←n{k←1⌈⊃2⊃⍺ ⋄ e←2⊃⍵ ⋄ (1⊃⍺)((1+∨/'* o'⍷e)(k*'*'∊e)(k×'+'∊e))(3⊃⍺)(∊¯2↑⍺)0}¨p
  turn←{a b c d e←⍺⊃⍵ ⋄ e+←≢a←b ⍺⍺ a ⋄ t←0=c|a ⋄ (t/a)((~t)/a),⍨¨@(d,¨0)⊢(⊂⍬ b c d e)@⍺⊢⍵}
  round←{⊃⍺⍺ turn/(⌽⍳≢⍵),⊂⍵}
  f←{×/2↑{(⊂⍒⍵)⌷⍵}⊃∘⌽¨⍵}
  f {a b c←⍺ ⋄ ⌊3÷⍨a*⍨b×c+⍵}round⍣20⊢m ⍝ part 1
  y←⊃×/2⊃¨m ⋄ f {a b c←⍺ ⋄ y|a*⍨b×c+⍵}round⍣10000⊢m ⍝ part 2
'
)

NB. ========== Concise(r) solution ==========

NB. So, let us do this in J....
n11 =: '0123456789,'&(".@(e.~#]))&.> n011 =: > a: cut <;._2 fread '/Users/mathias/u/advent_of_code/2022/aoc-2022-11.txt'
f11 =: dyad define
  k =. >./1, 2 pick x
  e =. 2 pick y
  (1 pick x); ((>: +./'* o'E.e),(k^'*'e.e),k*'+'e.e); (3 pick x); ((4 pick x), 5 pick x); 0
)
]m11 =: n11 f11"1 n011

r11 =: dyad define
  'a b c' =. x
  <.3%~a^~b*c+y
)
turn =: dyad define
  'a b c d e' =. x { y
  e =. e + #a
  'be bm ba' =. b
  a =. b r11 a
  t =. 0=c|a
  x0 =. [:<],0:
  ((((x0 {:d){y),&.> <a#~-.t), (((x0 {.d){y),&.> <t#a),a:) ((x0 {:d), (x0 {.d), x0 x)} y
)
round =: {{ y ]F.. turn i.#y }}
chk11 =: [: */ 2{. [: \:~ 4&pick"1
chk11 round^:20 m11
NB. => 100345

NB. And now as an adverb to unify the solution with the one of part B:

turnA =: adverb define
  'a b c d e' =. x { y
  e =. e + #a
  'be bm ba' =. b
  a =. b u a
  t =. 0=c|a
  x0 =. [:<],0:
  ((((x0 {:d){y),&.> <a#~-.t), (((x0 {.d){y),&.> <t#a), (<e), a:) ((x0 {:d), (x0 {.d), (<x,4), x0 x)} y
)
roundA =: {{ y ]F.. (u turnA) i.#y }}

]d11 =: */ 2 pick"1 m11
r11b =: dyad define
  'a b c' =. x
  d11 | a^~b*c+y
)

chk11 (r11 roundA)^:20 m11	NB. part 1
NB. => 100345
chk11 (r11b roundA)^:10000 m11	NB. part 2
NB. => 28537348205

NB. ----------------------------------------------------------------------

NB. 12.1
NB. ----

NB. Starting from Jay Foad's APL solution:
NB.   e←⊃⍸'E'=p ⋄ f←{3⌈⌿0⍪⍵⍪0} ⋄ g←f⌈f⍤1
NB.   h←0∘{e⌷⍵:⍺ ⋄ (1+⍺)∇ n≤1+g n×⍵}
NB.   h 'S'=p ⍝ part 1
NB.   h 2=n ⍝ part 2

NB. a =: ...
NB. ]ns =:1 + 1 >. 26 <. ('S',a.{~97+i.26) i. s
NB. ]e =: ;I.&.>(+./"1; +./) 'E'= s

g =: {{ (3 >./\"1 ] 0,.y,.0) >. 3 >./\ 0,y,0}}
h =: dyad define
  if. (<e){y
  do.
	x
  else.
  	(>: x) h ns <: >: g ns*y
  end.
)
NB. Or h as a one-liner:
s12 =: {{ (((>:x) s12 ns <: [: >: [: g ns*])`(x"_) @. ((<e){y)) y }}

p12 =: >cutLF fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-12.txt'
]ns =:1 + 1 >. 26 <. ('S',a.{~97+i.26) i. p12
]e =: ;I.&.>(+./"1; +./) 'E'= p12
0 s12 'S'=p12
NB. => 497

NB. 12.2
NB. ----
0 s12 2=ns
NB. => 492

NB. ----------------------------------------------------------------------



NB. ----------------------------------------------------------------------

NB. 18.1
NB. ----

NB. Useful idiom:
]a =: ".&> LF cut 0 : 0
2 2 2
1 2 2
3 2 2
2 1 2
2 3 2
2 2 1
2 2 3
2 2 4
2 2 6
1 2 5
3 2 5
2 1 5
2 3 5
)

NB. This also works for this syntax:
]a =: ".&> LF cut 0 : 0
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
)

p18 =: ".&> LF cut fread'/Users/mathias/u/j/aoc/aoc2022/aoc-2022-18.txt'
((6 * #) - +/@,@(1 = [: +/"1 |@-"1/~)) p18
NB. => 4302

NB. 18.2
NB. ----

]p18x =: (<:@(<./) ,: >:@(>./)) p18
]p18cp =: ({. ([: < [ + i.@>:@-~)"0 {:) p18x
]p18a=:(>@{.@] (,/@(,"(0 1)/))([:>1{])(,/@(,"0/))[:>2{]) p18cp

]d=:(],-) (i.3) |."0 1 (3{.1)
f =: ,/"1@;@] ;~ (,/"1@;@] , >@{.@[) (] #~ -.@e.~) >@{:@[ ([#~e.) [: ,/ d +"1/~ [:>[:{.]

p18f =: > {: (p18;p18a) f^:(0 < #@>@{.@])^:_ p18x;0 3$a:
NB. unreachable cell: (p18a ([#~-.@e.) p18f) ([#~-.@e.) p18
((6 * #) - +/@,@(1 = [: +/"1 |@-"1/~)) (p18a ([#~-.@e.) p18f) ([#~-.@e.) p18
NB. => 1810
4302 - 1810
NB. => 2492

NB. ----------------------------------------------------------------------

NB. 20.1
NB. ----

]p20 =: ".&> cutLF fread'/Users/mathias/u/j/aoc/aoc2022/aoc-2022-20.txt'

NB. We have to be a bit careful because of duplicates in the input.
NB. So we disambiguate it by applying:
NB. (+ ([:i.#) % #)

s20 =: {{ ((<:#y)|(<.x)+y i. x) (([{.]),x,[}.]) (x~:y)#y}}
([: +/ ] {~ #@] | (1000*>:i.3) + ]i.0:) <. (]F..s20)~ (+ ([:i.#) % #) p20
NB. => 4267

NB. 20.2
NB. ----

n20 =: 811589153&([*[:<.]%[)
s20b =: {{ ((<:#y)| (n20 x)+y i. x) (([{.]),x,[}.]) (x~:y)#y}}
([: +/ ] {~ #@] | (1000*>:i.3) + ]i.0:) n20 (](]F..s20b)(] $~ 10 * [:#])) (+ [:i.#) 811589153 * p20
NB. => 6871725358451

NB. ----------------------------------------------------------------------

NB. 25.1
NB. ----

]p25 =: cutLF fread'/Users/mathias/u/advent_of_code/2022/aoc-2022-25.txt'
s25 =: 5 #. [: ". &> [: ('-';'_1';'=';'_2')&stringreplace&.> <"0
5 #.inv +/ s25 &> p25
NB. => 1 3 3 1 2 2 4 4 3 4 2 3 1 3 0 2 1 3 1 0
NB. Which converts to 2-=2==00-0==2=022=10

fix25 =: (([: >: ([:<:[){]) , (-&5)@{)`((<:@[),[)`]}
'=-012' {~ 2 + (] ]F.. fix25 I.@(2&<))^:_ ] 5 #.inv +/ s25 &> p25
NB. =>                2-=2==00-0==2=022=10

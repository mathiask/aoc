;; Representation of rules:
;; - Rules are a hash map from rule number to rule
;; - Each rule is either a character (numberp) or a list of lists
;;   - outer list is for the alternatives
;;   - inner list to list the rules that have to be followed

(require 's)

(defun day19-parse-rule (s)
  (string-match
   "\\([0-9]+\\): \\(\"\\(.\\)\"\\|\\([0-9]+\\( [0-9]+\\)*\\)\\( | \\([0-9]+\\( [0-9]+\\)*\\)\\)?\\)"
   s)
  (cons
   (string-to-number (match-string 1 s))
   (if (match-string 3 s)
       (seq-elt (match-string 3 s) 0)
     (append
      (list (mapcar #'string-to-number
                    (s-split " " (match-string 4 s))))
      (when (match-string 6 s)
        (list (mapcar #'string-to-number
                      (s-split " " (match-string 7 s)))))))))

(day19-parse-rule "0: 4 1 5")
(0 (4 1 5))
(day19-parse-rule "3: \"a\"")
(3 . 97)
(day19-parse-rule "42: 2 3 | 3 2")
(42 (2 3) (3 2))

(defun day19-eval (s ruleNo ruleHash)
  ;;(message "%s@%d" s ruleNo)
  (let ((rule (gethash ruleNo ruleHash)))
    (if (numberp rule)
        (when (and (> (length s) 0) (= rule (seq-elt s 0)))
          (list (substring s 1)))
      (mapcan
       (lambda (ar)
         (let ((ss (list s)))
           (dolist (rn ar)
             (setq ss
                   (mapcan
                    (lambda (s) (day19-eval s rn ruleHash))
                    ss)))
           ss))
       rule))))

(day19-eval
 "aaaabbb"
 0
 #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data (0 ((4 1 5)) 1 ((2 3) (3 2)) 2 ((4 4) (5 5)) 3 ((4 5) (5 4)) 4 97 5 98))
 )
("b")
("")

(defun day19 ()
  (save-excursion
   (goto-char 1)
   (re-search-forward "^;;;;; INPUT$")
   (forward-line)
   (let ((rules (make-hash-table)))
     (while (not (looking-at "^$"))
       (let ((r (day19-parse-rule (buffer-substring
                                   (line-beginning-position)
                                   (line-end-position)))))
         (puthash (car r) (cdr r) rules))
       (forward-line))
     (forward-line)
     (let ((cnt 0))
       (while (not (or (eobp) (looking-at "^;;;;;")))
         (when (member "" (day19-eval (buffer-substring
                                       (line-beginning-position)
                                       (line-end-position))
                                      0
                                      rules))
           (incf cnt))
         (forward-line))
       cnt))))

(day19)
289
12
3
139
2

;;;;; Test INPUT
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
;;;;; END

;;;;; Test INPUT 2
42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1
8: 42 | 42 8
11: 42 31 | 42 11 31

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
;;;;; END

;;;;; INPUT
94: 118 64 | 22 34
21: 16 64 | 49 34
70: 58 34 | 106 64
100: 58 64 | 56 34
24: 29 64 | 128 34
63: 107 64 | 106 34
10: 64 64 | 34 64
1: 40 34 | 58 64
119: 56 34 | 103 64
131: 56 64 | 9 34
34: "b"
65: 64 58 | 34 107
0: 8 11
68: 64 43 | 34 50
48: 107 64 | 96 34
38: 80 64 | 74 34
128: 73 64 | 19 34
6: 62 34 | 18 64
95: 111 34 | 61 64
74: 5 64 | 65 34
82: 91 64 | 79 34
37: 34 107 | 64 106
35: 122 34 | 23 64
106: 34 34 | 30 64
118: 9 34 | 114 64
4: 107 34 | 106 64
102: 96 64 | 107 34
31: 75 34 | 108 64
99: 34 10 | 64 114
90: 64 34 | 34 34
112: 64 10 | 34 3
15: 114 64 | 88 34
49: 32 34 | 120 64
83: 56 64 | 96 34
29: 34 78 | 64 131
84: 107 64 | 56 34
25: 40 64 | 107 34
33: 26 34 | 24 64
122: 114 34 | 103 64
69: 56 34 | 96 64
5: 103 34 | 9 64
17: 59 34 | 70 64
123: 40 64 | 90 34
114: 34 64
121: 114 34 | 3 64
32: 34 9 | 64 114
127: 4 64 | 84 34
125: 71 34 | 121 64
116: 64 1 | 34 118
105: 34 73 | 64 37
56: 64 34
110: 105 64 | 54 34
79: 64 9 | 34 107
42: 6 64 | 68 34
53: 2 64 | 17 34
61: 64 114 | 34 88
19: 103 34 | 40 64
9: 30 34 | 34 64
107: 34 64 | 64 30
115: 56 64 | 130 34
77: 56 34 | 9 64
46: 27 64 | 67 34
59: 88 34
22: 34 3 | 64 106
76: 69 34 | 28 64
129: 36 64 | 113 34
124: 44 64 | 39 34
103: 64 64
91: 34 40
67: 88 64 | 114 34
130: 34 64 | 64 34
12: 76 64 | 125 34
81: 64 96 | 34 106
13: 64 51 | 34 41
30: 64 | 34
20: 34 106 | 64 107
43: 89 34 | 129 64
71: 34 114 | 64 3
66: 48 64 | 81 34
3: 64 64 | 64 34
87: 64 52 | 34 14
96: 30 34 | 64 64
62: 38 34 | 12 64
88: 34 34
75: 126 34 | 85 64
55: 34 109 | 64 67
45: 56 64
104: 64 112 | 34 5
39: 64 77 | 34 100
86: 34 114 | 64 88
26: 64 47 | 34 94
101: 34 127 | 64 35
41: 81 34 | 83 64
40: 30 30
2: 115 64 | 71 34
64: "a"
108: 64 33 | 34 92
126: 64 7 | 34 13
117: 45 64 | 99 34
54: 15 34 | 63 64
51: 123 34 | 98 64
14: 34 88 | 64 56
98: 58 64 | 114 34
78: 34 9 | 64 10
7: 34 60 | 64 104
97: 46 64 | 82 34
57: 87 34 | 117 64
60: 34 120 | 64 4
58: 64 64 | 34 34
27: 64 40 | 34 56
89: 95 64 | 116 34
109: 34 90
44: 64 25 | 34 72
50: 64 124 | 34 101
47: 98 64 | 20 34
16: 34 70 | 64 69
85: 64 110 | 34 57
36: 119 34 | 91 64
28: 56 64 | 58 34
80: 91 64 | 72 34
111: 64 56 | 34 103
93: 66 64 | 55 34
92: 53 64 | 93 34
23: 64 3 | 34 40
52: 64 88 | 34 10
120: 96 64 | 114 34
73: 40 34
72: 34 106 | 64 88
18: 97 34 | 21 64
113: 102 34 | 86 64
8: 42 | 42 8
11: 42 31 | 42 11 31

aaabaabbabaaaabbaabaababbaaaabbb
bbabaaabbbbababbbaabbaba
baaaabbaaaaabbabbabaaaab
aabaaaaabaabaabbbababbba
abbbaababbaaaababaaabababbaaabababbbabbaaaaabbbabbaabbab
abbbbbbbbbaaababaaababaa
ababbbbbbbabbbabaaaaaaaaaaaabbbbbbaaabbaabbbabab
abaabbbababbaaababbbabab
aaaabababbaabaaaabaabbaa
bbaaaaabbbababbababbbbbaabbbabab
bbabaababbabbbaaabaaabba
bbaaabbabaaabbaabbbaaababaaababbbbaabaaababababb
bbbbaabbabaababababaabbbbbbbabbabbbaaabbaabaabbaabbbbbabababbbbbbabbbaab
aabbbbaaaabaaaaaaabbabaa
aaaabababababbabbabababb
babbabaababbbbabbbbababa
aabbbbbbaababbbbbabbbbbaababbaba
baaabbabaaaabaaaabbbabaa
bbaaaaabbbabbbaabababbba
abbaabbbbaabbabbaabbabaa
bbbbaaaabbababbaabbabbabbaabbabbbbbbababbabbbbbb
ababaabababaaabbaaaaaaaaaaaababa
abbaaaaaaaabbbbaabaabbaa
bbabababababababaaababbb
bbabbbaaababbbababbaabaaaaaaaabb
aaabbbbaaaaabaaabbbaaaabbaabaaabbbbabaaa
bbbabbaabbabbbabbbbabbba
abbbbbbaababbaaabaaaababaaaabaabbbbababaabbbaaaaabaaabbb
abbaaaabbbabababbaabaabbbaabbbaabbbbabaa
aaaabbbbabbaabaabbbabbababbaaaaabaaababb
bbaaaabbbbababbbbbbaabbababbbaaaaabbabbaabbabaaabbaababa
abaabaaaabbbbbbaababbbaaaabbabbbbbababaabbabaabbabababbabbbbaaba
bababbababbbaabbaabbbabb
aaabbababbaabaaabaabbaaa
babaaabbbaaaababbabbaaababbababb
babbaaaabbbabaaaabaabbbbaaabaabb
aabaaababaabaaaabaaaabbaaababbabaabababababbabbb
bababababababbbbbabbbbbb
baabbbaaaaabbbbaabbabbababbababa
abbbbbaaaaabbabbbababbbbbaaabbabbabaabbb
bbbabbbbaabbbababbabbaaabbbbaaabbbbbaaaa
ababbbabbbaaaaaaaaabbabbbababbabbaaabaababbbbabbaababbaabbbabaaaabbbabbb
aaabaababababababbbaabaa
ababbabbbabaabbabbaaaaabaaaabaabbaaabababbbbaabbbbaaababababbaaa
aaaabaabbbaaaaaabbaabbab
bbbaaaabaabbbababaaaaabb
aababbabbaabbaabbabbabba
aabbaaaaaabbbababbaaabbb
abaaaaabbaabaabbbaababbaababbbbbbbbbbbba
abbbbbaaaaabbbbbabbbbbaabbaaabaaaaaaaabb
bbabbbbaaaabbbbbaababbba
abbbaababaabababbbbbabbabaaababbbbbbbbaa
aaaaabbbaaabbabaabbabbabbbababababbbaaaaaaaaaababbbbaaba
abbbabbabaababaaabbbabababbaaaba
baaabbbbabbbbabbbbabbbbbaababaab
aaaaaaaaababbbabbaabbaabbbabbbbb
bbbaaabbbbbabbaaaaaabaaaaaaaabaa
bbababbbbaaaabbbabaabaaabbbaabababaaaaabbbaababbbaabbaaaaaaabaab
abbbaabbbbbbaaaaaabbabaa
aaabaabaaabbbbabaabbbabaaabaaabbbbbbbbbaaaabaaab
bbbbabaaaabaabababababbb
aabbbbabbbbabbaaababaabb
bbabbbaababaabbabbbaabbababbbbaa
abbabaababbbabaaaaaaabba
abaabbbabbbababbabbaababbbabaaaa
aababbbaabbaababbbbabaaabbbaabbbaababbaa
bbbaababaaabbbbaaabbbabababbabbbabaaaabb
abbbbbaaaaaaaaabaaabababbabbaaaabbbbbbbbabaaabba
ababbbaabbabaaababbbaaabaaabaabaabaabaab
bbabbaaaabbbabbabaaababa
babaaabbaabbaaaabbabbabb
abaaaabaababbbaabbbbbbbb
bbbaaaabababbaaabaaaaaba
aabbbaabbaaababbbbbbbaaaabbaaaba
bbaabaaaaababaaaaaaabbaabbaababbabbaabaabaaaaaaabaaababbababbaaaaaaababbbaabaaababbabbaa
babaaabbababbbabbaaaabbb
aaabbabaaabbbabaababbbba
bbaaaaaaaaaababaabbbaaaa
baabaaaabbababbaabbbbbbbabababaa
aaabbabbbabbabaaabaabbbaaaaababa
aabaaababbbbaaaaaaaabbaa
aaaaaaaababbbbaabbaabbbabaaabbaababbbabababbaaba
bbbaabbaaabbbbaaaababaaa
baabaaabaababbabaaaabaaa
bbbaabbabbabbaabaabbaabbabaabbbabbbabbaabbaabbbbbaaaabbb
abbaaaabbaaaabbabaababbb
bbbbbaaaabaababaaabaabaaaaaaabbbbbbaabbbaaabbbaa
babbbbbabbbababbaabbbbbbaaaabbbbbbaaabaa
aabaabaabaabbbaaaabbaaab
abbbabbabbbaaabbaaaaaaabbbbbbbbaaaabababaaababaababbbbbbbbaababa
baababbabbaaababbbbaaabbababbbab
bbaaaababbbbbaaaabaababaaababaaaababababbbbbbabbaaabbbabbaaaabbabbbbabab
bbbaaababbbbababaaababba
aabaaabbbaabbaabbbbbabbaaaaabaaaabaaabba
abbbbbaababbbaabbbbaabaa
bbbaabababaabaaabaabbaba
bbabbaabaaabbbabbbbbabaa
baabbaabbaaababbabbaaabb
aabbbbabaabbbaabbabaabbb
abbaabbbaabbbabaabaababbabbababa
bbabaaabbbbaaaabbabaabaaaabbaaaaaabaabaaaaabbaaa
abbabbbbbbaaaaaabaabbbab
baaabbaababbbabbabbbbaab
abaabababbbbaaabbaababaa
bbbaaaaaaaaabaabbaaaaaababbbabbabaabaabbaaabaaab
baaaaabbaabbabbbabbaaababaaabbabbbaaabbbbbabbabbbababaab
bbababaabbababbbaaabaaaa
abaaaabaaabbbbabaabbbabb
aaaabbbaabbbbabaabbabbbaaabbaaabbbbbbbab
bbaabababaaaaababbbbababaaaaaabbbabbbaababbaabaaaaababaaaaaabaab
ababaaabaaaabaababbbaabbabbaabaaaabbbbbbababbbaaababbbba
bbabbaabbbbbaaabbaababaa
aaaabbabbaabaaaaaabbaaab
bbbaaaaabbbbaaabaabbbaababbbbaaa
aabaabaabaaaaaabaaababaa
aaabbbbbaaaaabbbababbabbbaaababa
abbbaabbababbbaababaabaaababbbaaaabbbbbbbbbbbaabbbbbaabaaaababab
bbabbaabbaaaaaaaaaaaaaaaabaaabba
baaaaaaaababbbabaabbaaaaababbbabaabbbbbbabaaaaabbaaaabbbabbabbbaaabbaabbaabababb
bbbaababbaaabbaaabbabaab
bbaabbaabbbaaabbbabbbbaabaababbaabbabbbbbbabbbbbbbbbbbaaaabaabba
bbaaabbabbabbababaaaaaaaabbaaaabbbbbaaba
babbbbababbabbabbbbaaaaabbbabbabbbbbabbbbbabbbbbbabbabbb
abaababaaaaabaababaaabab
bbabbaaabbabbaababbabbaa
babbabbabbbbaaabbbabababababaaabaaabababbaabbaab
baabababbbbbaaabaaaaabbbabbbbbbabaaaaaba
ababbaaabaaabbaababbbbbb
bababaaabbbbaabbabbbbbbbaabbabba
bbababaabaaababbbaaaaaabaababbbaaaabbbaaabbaabba
bbbabbaaaabaaabbabaababbabbbbaab
bbabaabbbbbaaababbbabbaaaabbbbbbbabbbbbbabaaaaaabbbbbbabbbbabbbababaabaa
bbabbbbabaaabbaaaabbbbaabaabbaabbbbaabaa
ababbbaaaabaaabaaabbbaabaaaaaabaaaabbaaa
ababbbaabbabbbabbbaaabbabbbbbbaa
aabbababbabbabaaaaaababb
bababbaabaabababaabbbababaabbabbaabaabaaabababab
aababbbabbabbaabbaabbbbaaabaabaaaababbbaaaabbbbbbbbbbbaabbbbabbbbbbabbbabbbbbbba
bababbababaababbaababaab
babbbaaaabbaaaababbababb
abbabbbbabaabababaababbb
bbabbabaaabbababaabababb
babaabaaaababbbbaabaaababaaaabbaaaaaabab
abbabbababaabababaaaabbaabbbabbabbabbbbababbaaba
bbabaaabbaabbbabbbaaabaababaaaaa
abbbbabaabaababbababbabbabbaaaaabbbabbbb
baaabbbaaaabbbbaabaaaaabbbbaaabaabbabbbababbaaaa
aabbbbabbaabbbaaaabbaaaaabaabababbaaabaa
abbabaababaaabbaaabababbababbaab
aabbbaabbaaabbbbbbaaababababaaababbaaaaababaaaaabaabbbabbabbaabb
baabababbbabababbabaabbaaabaabbbabbbbaba
baabbbbabbaaabbaabaabbab
bbbaaaabbbbbabababaabbaa
abaababababbbaaababbbaba
bbaaaaabbababbabbbaaaaababaabbbabaababaaabbbbaab
bbabaabaaaabbbbbbabbbbababaaaaabaaababbaaabbbaaaabababaa
bbaaaaabbaababbaababbbaaaabababb
babaaabbbbbbaaaaaaabbabb
aababbbabbbababbbabbabaabaaabbaabaabbaba
baaabaababbbaaabaabbababaaaababaababbbbbaaaabaaababbabbb
bbbabbbbbbababbbbaabababbbabaaabababbaabbbaabbbb
bbbbabbaaaaabaababaaaabaaabababbabbaaabb
aaabbbbabaabbbaabbbaababaaaabaaaabbbbbbabbbabbbabbababbbabbabbbbaabbbaaa
aaabbbbaaaaaabbbabbaaaaabbbaabbb
aababbabaaabbbbbbababaaabaaaababbbaabaab
bbbabbabababbbbbbabbbbababaabaab
abbaabaabbaaaabbabbbbbbbaaaaabaabaabababbaababaa
bbbaabbaaaaabbabaaabbbabbabaaaaa
ababaaabbabaaabbabbbbbbbaaaababaabaaabbb
aabaaaabbbbabbbbbabaabaaabababbbabbbaaaabbaaabbababbaabbabaaabab
aabaaabbbabbbbbaaaaaabaaabbbbbbababaabbb
babbbbababbaaaabbabababb
aaabbabaaababbbabaabaaaaaabababaaabbaaab
babaaabababababbabbaabaaababbabaabaaaabaababababbabaaabbabbabbab
bbbbaaabaaabaabaababbbaabbaabaaaababaabbaaaabbba
baaabbbbbbabaababbbbbbab
abbaaaabbbabaabaaaababab
aaaabbabababbbbbaabbbabb
abaaaabaababaabaaaaaaaba
babbbaaabaaababaabababbaabaaaabb
aaabbabbaaaabaaabbbaaabbbabbbbbbabbabaab
aabaaaaabaaabaabaabbaaab
baabaabbababaabababbaaaa
abbabbbbababbbaabbabaaababbaaaabaabaabab
abbaabbbbabbbbbbabbabbbbbababbbabbbaabaaabbbbbabbbabaabbabbabaaa
baabbabbabaabaaabaababbb
bbabaaabbaabaabbbbbbbaaababababababaaaaa
bababbbbbbaabaaabaaaabbaaababbbbbbbabbbaaaabaabb
aabaaaaabbaaaaababbbabbb
bababbbbabbbaababababbababbaaabaabbaaaba
abbaaaaaabbaabaabaabaaababbaabbbbbaababb
bbbbabababaaabaaaaaaabbbaababaab
aabbbabbabbbbabaabbabbbbbbabbbbbbaabbbabbaaaabaaaabbaabaaaaaabbb
babaaabbababbababaaabbaaaaabbbaabbbbbbaa
ababaaabaaabbbabbbabbbababbbabab
aaabbbababbabbbbaabaabab
bababababbabbaabbbbbabbabbbabbbbaabbaaaa
abbbabbaaababbababbbbbaaaaababababbaaabb
ababaabaaaaabbbbbbbbabaa
bbbababbbababbaabbaaaabbaabaabbb
ababbaabababbababababbba
bbbbaabbbaababbabbaaabaa
aabaaaaaaaaaaaaaaaabbabaaaababba
aabbbbababaabbbababbabbb
bbbaaaabaaaaabbbbbabbbbabaaabbbbbbbaababbabaabbb
aababbbbbaabbbbbbbaabbbb
aababaaabbbbababbabbbabbbabbabbabbbbabaabbbabaaaaaaabbababbaabab
bbabbaaabbabbababbbabaaa
abbbbbbbbbaabaaaabaaabba
baaaababbbbabbabbbaabaaababaaaaabbbaabbb
babaabaabaaabbbababaaabbbbbaabaa
abaababbbabaabbaabbbbaab
aaabaabbbaaaabbaaaaaaabaaaaabababaabbaabaabbbabbababbbaa
abaaabaaaaabbbbabaabbbba
bbbaabbabababbbbbabababb
bbbbaaabbaaabbbbbbaabaaaabaaaaaa
bbababbbbbababbabbbabbabbaabbbaaaaaabbbbbbbabbababababba
abbaabbbbaaaaaaababbbbbaabaabbbbaaabaaab
aaabaababaabaaababbabbba
abbababababbbbbbbbbaabbaaabaabbbbbbbbbbbbaaabababbbbaababbbaaababaabaaaabbaababaababaaba
aaaabbbaaabbbbabbbabbaabbabbbbaabaabbababaabababaabbabbbabbabbaaaabbbaba
baabbaabbbbaaaabbbbaaaaaaaaabbabbaabbbbaabbaaababbbbaaba
bbaabbbabbaaaaabaabbbaabaabbbbbbabaabaaabbaaabaaabbbabbb
baaaaaabbabbabaabbbabbabbbbaaabaabbbbaaa
babbbbabaabaaabaabbbbbbbbbaabaab
bababbabbbaabbaabababbaabaaaabbaaaaabbaa
bbbbabbabaabaabbaabbbbababaababbababaaababaabaabbaababaa
bbabababbaaababbbabaabaa
ababbbabbaabbabbabbbbaab
aabbbbaabaabbabbabaabbaaaaaaabba
ababaaabaaaaababbbabaabb
bbaabbaaaabbbababbbbbabb
aabaaabbaabbabbbabababab
bbbaababbbabbababbbbbaababbbbbaabaaababa
abbbaaabbaaabbbaaaabbbaa
aabaaabbbaaaabbaabbbaabbaaaaababbabaaabbabbbbaabbaabbaab
baabaaaabbabaabaaaabbabbaabbababbabbbbbaaaababbaaaababbb
baabbabbbaaabbbaabbaabaabbaaaaaaaaaaaabaaabbbaaa
bbabbbbabbabbaababbbbbbbaabbbababbabaaaaaaabaaaa
aabaaababbbabbababbbbaba
abaababbaabaaabaabbbaaaa
babbbbbabbbbabbabbaabbabbbaaabaaabaabbbbabbbaabbbabaabbbbbabbaabaaaabbabbaabbabaabbbbaabbbabbaab
baabbaabaabaabaaabaabbbbaaaabaabbaababbbababaabbabbabbbb
aababbababbbbbaaaaaabababbbbbbaabbbbbbbb
aababababaaaaaabbbabaaaabbbabbabaaaaaaabbbbbbbaa
babaabbaaaaaabaabbbbaabbbbbbabbbbbbababa
aaabbbbabbabaabaababaabababaaabbabbbaabbaaabaaab
abbabbabbabbbbbaaaabaaab
abbbaaaabbaaaabbaabaaaabbabbaabbbabaababbbbbbbabaabbbabbababaaabbaabbbabbbbabbbbabbabababaaaabaa
abbbabaaaaabbabbabbabbbbbbabaaabbabbaabbababbabaaaaababaaaababbababababb
aabbbaaabbabbbbbabbaaababbaabbab
aaaabbbaaababaaabababaaaabbabbabaaaababbbbbbbabbbabaabbaabababbb
aabbbbaaaaabbabaaababbabaabbbbabbbabaaba
abbabbbbaababbbbabbbbaaa
aaabbabaaaabaababaabbbaababbabbb
aabaabaaabbbabbaababbaaabbbbabbb
bababbaaabaaabaaaaababbb
aabbbbaabbbaaaaabbaabbaabbabbbaaaabbabab
aabbabbbaabaaabaabbaababbbbbabaa
bbaabaaaaaabbbbbbbabbaababbaabbbbaaaaaaabbbaabbbbaaabababababbba
aaaaaaabbabbabbabbbbbaaaababbbbbaabbbbbababbbaaa
aababbbaabbbaaabbabaaaba
aabbbbbbaaababbabaaabbabbabbbbabbbbaaababbbababbabbbabbbabaababaaaababbabbbbabbbaaabbaab
bbbababbbaaabbababbabbbb
bbbbbababbbbaabaabaabbaababbbbbb
bbababbabbaaaaabbbaabbbababbabbb
abaaababaabbbbbaabbabbaaaabaabbbbbbbbbbabaabaaababbaabba
baabababbbbbbaababbaaaab
baaababbbabbbaaabbaaababaabaabba
bbabbaabababbbabababaabb
bbbbabbabaabbbbaabaabbbabaaabaababaaababbababbbababababb
bbabbbaaabbaabaaaababaababbbabababaabbaaabababbbaabbbabb
bbaabaaabaaabbaabbabbabb
baaabbbabbbbabbabaaaabbabbbbabbaaabbaaabbbbbbbabbabbbabaaabababaaabbaabb
baabbaabaaaabaabbaaababbbabababb
abbaababbbaaaabbbabbabbbabbababbbabbbbbbbbbabababbbbbbbbaaaababbbabbabaabbbbabaabbbbbaab
abbaababbabaabbabaababbabaababbbaabbbbabaabababaaaabbbaaaababaab
baaaabbaabbabbbbbabbaaaa
bbbabaabbbbbaabbbaaabbba
aaaabbbbaabaaabbbaaaaaba
bbbabbbbbbaaaaaabbbaababbaabaaaa
abbaaaaabbbababbbbaabaab
abbabbbbbabbbaababababab
baaabaaaaaabbabbbbbbbaabaababbbabababbbabbbbbbbaabbbbaababbbbabbbbbbabba
bbabababababbbbbabbaabababbaababbaabbabbbbbaabaabbbbabaabaaabaaa
ababbaabbbbbbbaaaaabbbaaabaaabab
bababbbbbbbabbaababaabbb
aaabaabaabbaabaaabbbbbbbabaaaababbaaaaba
aabbaaaaaaaabbbbabbbabaa
babbbbbabaaababbbbaaaaabbaaabaab
baabaaaababaabbaabbababb
bbbabbbbbabbbbbaaaaabbba
bbababaaaabbaaaaaaaabbaa
bbbaaabbbabbbabbaabbaabb
bbbaabbaaababbbabaaababa
aababbbbabbabbbbabaaaaabbbbaabbbaaaabbbaababaaaa
bbababbbbabbbbbaaabbbaaa
abbbabbaabbaaaaaabbbbbab
aaababbababaabbbbabbaabbabbbabbb
bbabbbaaaaabababaabbbbbabaabbaaaaabaabba
ababaabababababaaabbabba
babbbbbabaababbabaabaaba
abbbbbaabbababbaaababaaa
babaabbabbbababbbabababb
bbbaaabbbbaaaabaaabbabaabbbbbabbbbaabbababbaabba
ababbbabbbaabbbaabaabbbaaaabbbbbaababaab
abaaaaabaababbabababbaaaaabbbbbaaaababbaaaababbbbbaaabaabbbbaaba
baaaabbababababaabbbaababbbabbaabbbaaabaabaababbbbbabaabbbaabbab
aabbaaaaabbbbbaabaabbaba
ababbaaaaaabbbbbaababbabbbbabbaaaabaaaaaabaabaaaabbababa
bababbabbbbaababbaaaabbb
bbbbabbaaababbbabaababbb
bbbbababaaaabbaabbaabaabbbbaabbaabbbbbbabbbbbaaabbbaabba
aababababbbbbbaaaabaaabbbabbbaaaaaaababbabaabbbabbbabbaaaaaababaabbbaabaabbbabbbbbbbabbb
bbaabbaabbbbabbaaaaababaaaabbabaaaabbaabbaabaabaaabbaaab
aabbbaabbbbbaabbbbabbbaabbbaaababaabbbbb
bbabbbaabaaabbabbbbaaaababaabbab
bbbaaabbabbaabbbbabababaaababbbaabbbbaaa
bbababaaabaaaaabbbbaaabaaabbbaaababaaabaaabbaabababababaaabbbaaa
ababbbaaabbbaaabbabbaaba
baabbbbabaabbaabbaabbabbbbababaabbabbabbabaabbaa
aabbaaaababaaabbbabbabaabaaabbbbbaabbbabbbbbabbb
baababbaaabbaaaaabaaabaaaaaabbabbabbaaba
bbbaababbbbbbaaabbaabaaabbabaabaaababaaaaabbaaab
babaabbabbbaabbaaaababba
bbbaaaabaabbbbbbbbbbabaa
ababbbabbaabbaabaaabbbabaaababaa
abbbbbaabbbaaabaabaabbbaaaabbbababbbabbbbaabbaaaabbbbbab
bbbbaaaabbaaaabbaabbababbabbabba
baabababbabbbbababaabababbbababa
aaabbaaaaabbbbbabbaabbaaabaaaababbbababbbabaabbaaaaaaaba
baaaaaaaaabbaaaaaaabaaab
bababbbbaaaabbabbababbbbbbabaaababbbbaaa
babbbbbababbbbaaabbbbbbbaaabbababbbabaaa
baaababaaabbbaabbbbaaabbbbabbabaaababaaaaabbbbbb
abbbbbaabbabbabababbabbb
ababbbabbbabbaabbaabbaaa
aaaabaaaaaaabbababaabbab
bbbbbaabbaaabbbbaaabaababaaabbbabbaaaaababbaaaaababaabab
abbabbbbbababaaabaabbbaaabbbbbab
abbaaaababababaabaaaababaabbaabbabbabaabaabbaabbbaaaabbaaaabaaaa
baaababbaaaabaabbaaaabbababaabbbbabbaaaa
aaabaabaabaabbaaababbaababbabbbaabbbbbaaabaaaaabbbbababa
abbbbaaaaaaabbaaabababaaaabaabaabaabbaaaabaaaabaabaabbabbbaabaab
bbabbbaaaabaaabbbababbabbbaabaab
babababaaaabaabaaabaabab
baaabaabbbaaabbabbaabbbabaabbabbbbbaabbabbbbabaa
ababaaabbbababbabbbabbabbbbbbbbababababb
ababbabbbbaaabaaaaababaa
baaaababaabbbbbbaaababaa
abbaaaababaabababbabaabaabbabaaa
babbabababbaaabaaaaababaababaaabbaaaabbaababbbaaaabbbbaaaabaabbaaaababab
babaaabbbaaaaaabaabbaaab
abbaaaabaaaabaaabaabaaba
bbabbbabbaaaababababbbbabbaaaaabaabababaabbaaabaaababaaabbbbbbaa
baaabaabbbbbbaaabaaabbabaaabbbbabbaabababbbbaaba
abbbaabbabaabababbbbabaa
bbabbbaabbabbaabbabaaaaa
bbaaaaababbbaaabbbbbaabbabababbb
aaaaabbbaabaaaaaabbaaaba
bbaaaaaaaaabbabbbaaababa
abaabaabababbababbaabbbbababaaaa
bbbaabbabbabbaabaabaaabbbabaaaab
bbabbaabbabbabbabbbaaabbbbbaabbaaabbbaab
abbaaabaaabaababbababaab
baaabbbabbabababbbbaabbabbbaabababbbbaba
abbabbbbaaabbabbababbbba
aabaabaabbabbbbababbaabb
aababbbabababbabababbaaa
abababbaaabbababaabababaababaabbaabaaabbbbaaabbbabababbaabbaaaaa
baaaabbabaaabbabbbaaabbaaaaababaabaababbabaabaab
baabbaaaabbaababaabbaabbbaabaaaabaaaabaabababbbaabbbbbbaaababbbaaabbbaababbaaaaaabababab
baaabbaaaaabbbabababaaababbbbbab
abaabbbababaabaabaaaababbbaaaaabbabaaaabbabaaaabbaababaabaaaabbb
ababbaaababaabaaaabaabbb
aaaabaabababaaaaaaabbabbaaababbbababaabbbaaaabaaaaaabbaaabababbbaaaabbaa
abaabbabbabbbaabbbbbbbbbabaabbbbabbaabbaabababaa
aababbabbbabaababababaababbaabbabbaaabaababbabbb
aaabaababbbabaabababaaabbbbbababbababbbababaaabbbaababbabbbababbaaaababb
aaabaabaabbaabbbbbbbbaabaaaaaababbbababa
baabbabbbbaaaaababaabaab
baaaaaabbaaabaabbababbaaababbbbbaabbabbbbabbbabb
ababbbbbbaaaaaabbbabbaabbbbababa
bbbabababbbabbabbbabbabababbbabaababbaaabbaababbbbabbaab
abbaaaaaaabbbaabaaaaabbbbbbbbbbaaabbabaa
babbbaaaaabaaabbbbabbaab
bbabbababaababbabbbabaab
aabbaaaabaabbabbbbabaabb
abbbabbabaabaaabaaaaabba
babbbabbbaabbabbabbabaaa
abbbbbbabaaababbababbaba
aaaabbaababbababbbbbabbbbbbbabababaabbbabbaaabaaaaaaabba
babaabaabbaaababaabbbbbbbbaabaaaababbaaaabaaaaaaabbabaaa
bbbbaabbaabaaabbbababaaa
baabababaaabbabbabaaaabaaaaabaaabaaaaabb
aaaabababaababbabaaaabbb
abaababbbbaabbaaaaabbbbabbbabbbaabbababb
bbabbaabaaaababaaabaaababbabbaabaaaaaaabbaababbbbbbbbbba
abaaaaabaaaabbbbababaaaa
bbbaaaababbbaaababbbbaaa
abaabaaaaabbabaaababaaaaaabababa

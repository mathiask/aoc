(setq p1t (list
           9
           2
           6
           3
           1
           ))

(setq p2t (list
           5
           8
           4
           7
           10
           ))

(defun day22 (deck1 deck2)
  (while (and deck1 deck2)
    (let ((c1 (car deck1))
          (c2 (car deck2)))
      (setq deck1 (cdr deck1)
            deck2 (cdr deck2))
      (if (> c1 c2)
          (setq deck1 (append deck1 (list c1 c2)))
        (setq deck2 (append deck2 (list c2 c1))))))
  (let* ((deck (or deck1 deck2))
         (n (length deck))
         (s 0))
    (seq-do-indexed
     (lambda (x i) (setq s (+ s (* (- n i) x))))
     deck)
    s))

(day22 p1t p2t)
306
(3 2 10 6 8 5 9 4 7 1)

(setq p1 (list
          27
          29
          30
          44
          50
          5
          33
          47
          34
          38
          36
          4
          2
          18
          24
          16
          32
          21
          17
          9
          3
          22
          41
          31
          23))
(27 29 30 44 50 5 33 47 34 38 36 4 ...)

(setq p2 (list
          25
          1
          15
          46
          6
          13
          20
          12
          10
          14
          19
          37
          40
          26
          43
          11
          48
          45
          49
          28
          35
          7
          42
          39
          8))
(25 1 15 46 6 13 20 12 10 14 19 37 ...)

(day22 p1 p2)
32162

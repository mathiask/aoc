(defun day13 (n s)
  (let ((r (sort
          (mapcar
           (lambda (xs)
             (let ((x (string-to-number xs)))
               (cons (- x (% n x)) x)))
           (seq-filter
            (lambda (r) (not (string= "x" r)))
            (split-string s ",")))
          (lambda (x y) (< (car x) (car y))))))
    (list r (* (caar r) (cdar r)))))

(day13 939 "7,13,x,x,59,x,31,19")
(((5 . 59) (6 . 7) (10 . 13) (11 . 19) (22 . 31)) 295)
((5 . 59) (6 . 7) (10 . 13) (11 . 19) (22 . 31))
((6 . 7) (10 . 13) (5 . 59) (22 . 31) (11 . 19))

(6 10 5 22 11)
(1 3 54 9 8)
("7" "13" "59" "31" "19")
("7" "13" "x" "x" "59" "x" "31" "19")

(day13 1000066 "13,x,x,41,x,x,x,37,x,x,x,x,x,659,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,19,x,x,x,23,x,x,x,x,x,29,x,409,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,17")
(((6 . 41) (7 . 37) (10 . 17) (11 . 13) (18 . 19) (20 . 23) (28 . 29) (296 . 659) (348 . 409)) 246)

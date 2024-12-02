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

(* 7 13 59 31 19)
3162341

(defun day13a (s)
  (let* ((l0 (mapcar
              (lambda (xs)
                (if (string= "x" xs) 1 (string-to-number xs)))
              (split-string s ",")))
        (tx 0)
        (dt (car l0))
        (l (cdr l0))
        (x 1))
    (while l
      (let ((y (car l)))
        (while (not (= 0 (% (+ tx x) y)))
          (setq tx (+ tx dt)))
        (setq dt (* dt y)
              x (1+ x)
              l (cdr l))))
    tx))

(day13a "2,3")
2
(day13a "2,3,5")
8

(day13a "7,13,x,x,59,x,31,19")
1068781

(day13a "13,x,x,41,x,x,x,37,x,x,x,x,x,659,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,19,x,x,x,23,x,x,x,x,x,29,x,409,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,17")
939490236001473



;; 0: 2 3 5
;; 1: - - -
;; 2: 2 - -
;; 3: - 3 -
;; 4: 2 - -
;; 5: - - 5
;; 6: 2 3 -
;; 7: - - -
;; 8: 2 - - <= t=8
;; 9: - 3 -
;;10: 2 - 5

(% -2 5)
-2

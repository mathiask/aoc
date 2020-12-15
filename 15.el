(defun day15 (numbers end)
  (let ((h (make-hash-table :size 10000)))
    (dolist (x (cdr numbers))
      (puthash x 't h))
    (while (< (length numbers) end)
      (let* ((x (car numbers))
            (l (cdr numbers))
            (i 1)
            (nx (if (not (gethash x h))
                    0
                  (while (and l (not (= x (car l))))
                    (incf i)
                    (setq l (cdr l)))
                  i
                  )))
        (setq numbers (cons nx numbers))
        (puthash x 't h))))
  (car numbers))

(day15 '(6 3 0) 10)
(0 4 0 1 3 3 0 6 3 0)
(day15 '(6 3 0) 2020)
436
(436 58 9 4 0 352 38 5 0 727 63 11 ...)
(day15 '(2 3 1) 2020)
1
(1 4 4 0 202 9 4 0 972 56 5 0 ...)
(day15 '(3 1 2) 2020)
10
(10 6 0 261 24 25 9 4 0 701 31 6 ...)
(day15 '(3 2 1) 2020)
27
(27 4 0 262 12 5 0 757 46 65 8 0 ...)
(day15 '(1 3 2) 2020)
78
(78 30 4 17 5 0 225 17 34 6 0 1056 ...)
(day15 '(1 2 3) 2020)
438
(438 39 5 0 598 241 11 7 0 234 68 83 ...)
(day15 '(2 1 3) 2020)
1836
(1836 61 219 20 1 4 4 0 993 79 4 0 ...)

(day15 '(0 1 13 15 3 6) 2020)
(700 300 19 17 5 0 690 81 6 7 0 1541 ...)

;; --

(day15 '(6 3 0) 300000)
(day15 '(6 3 0) 30000000) ;; too slow, as expected
(day15 '(2 3 1) 30000000)
(day15 '(3 1 2) 30000000)
(day15 '(3 2 1) 30000000)
(day15 '(1 3 2) 30000000)
(day15 '(1 2 3) 30000000)
(day15 '(2 1 3) 30000000)

(defun day17-read-initial-state ()
  (save-excursion
   (goto-char 1)
   (re-search-forward "^;;;;; INPUT$")
   (forward-line)
   (let ((h (make-hash-table :test 'equal))
         (x 0)
         (y 0))
     (while (not (or (eobp) (looking-at "^;;;;;")))
       (while (not (eolp))
         (puthash (list x y 0 0)
                  (if (eq ?# (char-after)) 1 0)
                  h)
         (forward-char)
         (incf x))
       (forward-line)
       (incf y)
       (setq x 0))
     (cons y h))))

(day17-read-initial-state)
(3 . #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data ((0 0 0) 0 (1 0 0) 1 (2 0 0) 0 (0 1 0) 0 (1 1 0) 0 (2 1 0) 1 (0 2 0) 1 (1 2 0) 1 (2 2 0) 1 ...)))

(defun day17 (iterations)
  (let* ((nh (day17-read-initial-state))
         (n (car nh))
         (h (cdr nh))
         (xl 0)
         (xh (1- n))
         (yl 0)
         (yh (1- n))
         (zl 0)
         (zh 0)
         (wl 0)
         (wh 0))
    (dotimes (i iterations)
      (let ((h2 (make-hash-table :test 'equal)))
        (decf wl)
        (incf wh)
        (decf zl)
        (incf zh)
        (decf xl)
        (incf xh)
        (decf yl)
        (incf yh)
        (dolist (w (number-sequence wl wh))
          (dolist (z (number-sequence zl zh))
            (dolist (x (number-sequence xl xh))
              (dolist (y (number-sequence yl yh))
                (let ((cnt 0)
                      (cell (gethash (list x y z w) h 0)))
                  (dotimes (dw 3)
                    (dotimes (dz 3)
                      (dotimes (dx 3)
                        (dotimes (dy 3)
                          (unless (and (= 1 dw) (= 1 dz) (= 1 dx) (= 1 dy))
                            (setq cnt
                                  (+ cnt (gethash
                                          (list (+ x dx -1)
                                                (+ y dy -1)
                                                (+ z dz -1)
                                                (+ w dw -1))
                                          h
                                          0))))))))
                  (puthash (list x y z w)
                           (case cnt
                             ((0 1) 0)
                             (2 (if (> cell 0) 1 0))
                             (3 1)
                             (t 0))
                           h2))))))
        (setq h h2))
      ;; (goto-char (point-max))
      ;; (insert "\n-----------------------\n")
      ;; (dolist (z (number-sequence zl zh))
      ;;   (insert (format "\nz=%d\n" z))
      ;;   (dolist (y (number-sequence yl yh))
      ;;     (dolist (x (number-sequence xl xh))
      ;;       (insert (if (> (gethash (list x y z) h) 0) ?# ?.)))
      ;;     (newline)))
      )
    (let ((r 0))
      (maphash (lambda (k x) (setq r (+ r x))) h)
      r)))

(day17 6)
848



;;;;; Test INPUT
.#.
..#
###
;;;;; END

;;;;; INPUT
#......#
##.#..#.
#.#.###.
.##.....
.##.#...
##.#....
#####.#.
##.#.###
;;;;; END

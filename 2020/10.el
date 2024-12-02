(defun day10 ()
  (with-current-buffer "input"
    (goto-char 1)
    (let ((lines nil))
      (while (< (point) (point-max))
        (setq lines (cons (string-to-number (word-at-point)) lines))
        (forward-line))
      (setq lines (sort lines #'<=))
      (message "%s"
               (mapcar* (lambda (x y) (- y x))
                              (cons 0 lines)
                              (append lines (list (+ 3 (car (last lines)))))))
      (mapcar
       (lambda (x) (list (car x) (length (cdr x))))
       (seq-group-by #'identity
                     (mapcar* (lambda (x y) (- y x))
                              (cons 0 lines)
                              (append lines (list (+ 3 (car (last lines)))))))))))

(day10)

(defun runs (as)
  (let ((cnt 0)
        (last nil)
        (res nil))
    (mapc (lambda (y)
            (if (eq y last)
                (incf cnt)
              (when last
                (setq res (cons (list last cnt) res)))
              (setq last y
                    cnt 1)))
          as)
    (reverse (cons (list last cnt) res))))

(defun day10-confs (x)
  (if (> x 3) 7
    (apply #'* (make-list (1- x) 2))))


(apply #'*
       (mapcar #'day10-confs
               (mapcar #'cadr
                       (seq-filter (lambda (x) (eq 1 (car x)))
                                   (runs '(1 1 1 3 1 1 1 3 1 1 1 1 3 1 1 1 1 3 1 1 1 1 3 1 1 3 1 1 1 1 3 1 1 1 1 3 1 1 3 3 1 1 1 1 3 3 1 3 3 1 1 1 3 1 1 1 1 3 1 1 1 1 3 1 3 1 3 1 1 1 3 1 1 1 1 3 3 3 1 1 1 3 1 1 1 1 3 3 1 1 3 1 1 1 3 3 1 3 1 1 1 1 3 1 1 1 1 3))))))
453551299002368








;; ------------------
((1 76) (3 32))
(* 76 32)
2432

((1 22) (3 10))
((1 7) (3 5))

;; 01234
;; 0234
;; 0134
;; 0124
;; 034
;; 014
;; 024

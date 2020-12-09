(defun day3 ()
  (with-current-buffer "input"
    (let ((cnt 0)
          (max-y 323)
          (max-x 30)
          (dx 1))
      (goto-char 1)
      (while (< (line-number-at-pos) max-y)
        (let ((x (+ dx (- (point) (line-beginning-position)))))
          (forward-line)
          (forward-line) ; comment me out again for previoud dx values
          (forward-char (if (> x max-x) (1- (- x max-x)) x)))
        (message "%d:%d" (line-number-at-pos) (- (point) (line-beginning-position)))
        (when (eq 35 (char-after))
          (incf cnt)
          (message "tree: %d" cnt)))
      cnt)))

(day3)
29

64
53
50
148

(* 50 148 53 64 29)
727923200

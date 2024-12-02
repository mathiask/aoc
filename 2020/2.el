(defun day2 ()
  (with-current-buffer "input"
    (let ((cnt 0))
      (goto-char 1)
      (while (< (point) (point-max))
        (re-search-forward "\\([0-9]+\\)-\\([0-9]+\\) \\(.\\): \\(.*\\)")
        (let* ((min (string-to-number (match-string 1)))
               (max (string-to-number (match-string 2)))
               (c (match-string 3))
               (s (match-string 4))
               (length (length (seq-filter
                                (lambda (x) (eq (string-to-char c) x))
                                (string-to-list s)
                                ))))
          (when (and (<= min length) (<= length max))
            (incf cnt)))
        (forward-line))
      cnt)))

(day2)
655

(defun day2a ()
  (with-current-buffer "input"
    (let ((cnt 0))
      (goto-char 1)
      (while (< (point) (point-max))
        (re-search-forward "\\([0-9]+\\)-\\([0-9]+\\) \\(.\\): \\(.*\\)")
        (let* ((min (string-to-number (match-string 1)))
               (max (string-to-number (match-string 2)))
               (cs (match-string 3))
               (c (string-to-char cs))
               (s (match-string 4))
               (n 0))
          (when (eq c (seq-elt s (1- min))) (incf n))
          (when (eq c (seq-elt s (1- max))) (incf n))
          (when (eq 1 n) (incf cnt)))
        (forward-line))
      cnt)))
(day2a)
673
(defun code-to-number (s)
  (string-to-number
   (replace-regexp-in-string
    "."
    (lambda (s) (if (or (string-equal "B" s)
                   (string-equal "R" s))
               "1"
             "0"))
    s)
   2))

(defun day5 ()
  (with-current-buffer "input"
    (let ((passes nil))
      (goto-char 1)
      (while (< (point) (point-max))
        (setq passes
              (let ((p (point)))
                (cons
                 (list (code-to-number (buffer-substring p (+ 7 p)))
                       (code-to-number (buffer-substring (+ 7 p) (+ 10 p))))
                 passes)))
        (forward-line))
      (seq-max (mapcar (lambda (x) (+ (* 8 (car x)) (cadr x))) passes)))))

(day5)

;; 46 - 991 exist
(defun day5a ()
  (with-current-buffer "input"
    (let ((passes nil)
          (ts (make-hash-table :size 1000)))
      (dotimes (i 946)
        (puthash (+ i 46) t ts))
      (goto-char 1)
      (while (< (point) (point-max))
        (setq passes
              (let* ((p (point))
                     (r (code-to-number (buffer-substring p (+ 7 p))))
                     (c (code-to-number (buffer-substring (+ 7 p) (+ 10 p)))))
                (remhash (+ (* 8 r) c) ts)))
        (forward-line))
      (hash-table-keys ts))))

(day5a)
(534)

(defun day6 ()
  (with-current-buffer "input"
    (let ((cnt 0))
      (goto-char 1)
      (while (< (point) (point-max))
        (forward-line)
        (let ((as (make-hash-table :size 26))
              (go t))
          (while go
            (while (< (point) (line-end-position))
              (puthash (char-after) t as)
              (forward-char 1))
            (forward-line)
            (setq go (not (eq (point) (line-end-position)))))
          (setq cnt (+ cnt (hash-table-count as)))))
      cnt)))

(day6)
6735
11

(defun day6a ()
  (with-current-buffer "input"
    (let ((cnt 0))
      (goto-char 1)
      (while (< (point) (point-max))
        (forward-line)
        (let ((as (make-hash-table :size 26))
              (go t)
              (n 0))
          (while go
            (incf n)
            (while (< (point) (line-end-position))
              (let* ((c (char-after))
                     (x (gethash c as)))
                (puthash c (1+ (if x x 0)) as))
              (forward-char 1))
            (forward-line)
            (setq go (not (eq (point) (line-end-position)))))
          (mapc (lambda (q) (when (< (gethash q as) n) (remhash q as)))
                (hash-table-keys as))
          (setq cnt (+ cnt (hash-table-count as)))))
      cnt)))

(day6a)
3221

6

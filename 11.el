(defun day11-compute-next-cells (n)
  (with-current-buffer "input"
    (goto-char 2) ; pos 1 contains " " as must the entire column 0
    (let ((chg nil))
      (while (not (eobp))
        (case (char-after)
          (?L
           (set-text-properties
            (point) (1+ (point))
            (list 'cell
                  (if (> (day11-neighbors n) 0)
                      ?L
                    (setq chg t)
                    ?#)
                  )))
          (?#
           (set-text-properties
            (point) (1+ (point))
            (let ((n (day11-neighbors n)))
              (list 'cell
                    (if (< n 4)
                        ?#
                      (setq chg t)
                      ?L)
                    )))))
        (forward-char))
      chg)))

(defun day11-neighbors (n)
  (+
   (day11-neighbor -1 -1 n)
   (day11-neighbor  0 -1 n)
   (day11-neighbor  1 -1 n)
   (day11-neighbor -1  0 n)
   (day11-neighbor  1  0 n)
   (day11-neighbor -1  1 n)
   (day11-neighbor  0  1 n)
   (day11-neighbor  1  1 n)))

(defun day11-neighbor (dx dy n)
  (if (eq ?# (char-after (+ (point) dx (* dy n)))) 1 0))

(defun day11-update ()
  (with-current-buffer "input"
    (goto-char 2)
    (while (not (eobp))
      (let ((p (get-text-property (point) 'cell)))
        (when p
          (insert-char p)
          (delete-char 1)
          (forward-char -1)))
        (forward-char))))

(day11-compute-next-cells 96)

(day11-update)

(defun day11 (n)
  (buffer-disable-undo "input")
  (while (day11-compute-next-cells n)
    (day11-update))
  (with-current-buffer "input"
    (length (seq-filter (lambda (c) (eq ?# c)) (buffer-string)))))

(day11 96)
2249

37


;; ------------------------------------------------------------

(with-current-buffer "input"
  (length (seq-filter (lambda (c) (eq ?# c)) (buffer-string))))
37

(35 35 35 35 35 35 35 35 35 35 35 35 ...)


(with-current-buffer "input"
  (get-text-property (point) 'cell))
2
(with-current-buffer "input"
  (set-text-properties (point) (1+ (point)) '(mk 1 cell 2)))
t

(with-current-buffer "input"
  (text-properties-at (point)))
nil

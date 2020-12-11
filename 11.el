(defun day11-compute-next-cells (n nbhdfn th)
  (with-current-buffer "input"
    (goto-char 2) ; pos 1 contains " " as must the entire column 0
    (let ((chg nil))
      (while (not (eobp))
        (case (char-after)
          (?L
           (set-text-properties
            (point) (1+ (point))
            (list 'cell
                  (if (> (day11-neighbors n nbhdfn) 0)
                      ?L
                    (setq chg t)
                    ?#)
                  )))
          (?#
           (set-text-properties
            (point) (1+ (point))
            (let ((n (day11-neighbors n nbhdfn)))
              (list 'cell
                    (if (< n th)
                        ?#
                      (setq chg t)
                      ?L)
                    )))))
        (forward-char))
      chg)))

(defun day11-neighbors (n nbhdfn)
  (+
   (funcall nbhdfn -1 -1 n)
   (funcall nbhdfn  0 -1 n)
   (funcall nbhdfn  1 -1 n)
   (funcall nbhdfn -1  0 n)
   (funcall nbhdfn  1  0 n)
   (funcall nbhdfn -1  1 n)
   (funcall nbhdfn  0  1 n)
   (funcall nbhdfn  1  1 n)))

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

(defun day11 (n &optional nbhdfn th)
  (buffer-disable-undo "input")
  (while (day11-compute-next-cells n
                                   (or nbhdfn #'day11-neighbor)
                                   (or th 4))
    (day11-update))
  (with-current-buffer "input"
    (length (seq-filter (lambda (c) (eq ?# c)) (buffer-string)))))

(defun day11a-neighbor (dx dy n)
  (let ((tx dx)
        (ty dy))
    (while (eq ?. (char-after (+ (point) tx (* ty n))))
      (setq tx (+ tx dx))
      (setq ty (+ ty dy)))
    (if (eq ?# (char-after (+ (point) tx (* ty n)))) 1 0)))

(day11 12)
37
2249

(day11-compute-next-cells 12 #'day11a-neighbor 5)
(day11-update)

(day11 96 #'day11a-neighbor 5)
2023

26



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

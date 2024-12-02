(let ((l (list 14 12 68)))
  (seq-take (cons 28 l) (length l)))
(28 14 12)

(defun day9 (&optional n)
  (unless n (setq n 5))
  (with-current-buffer "input"
    (goto-char 1)
    (let ((l nil))
      (dotimes (i n)
        (setq l (cons (string-to-number (word-at-point)) l))
        (forward-line))
      (catch 'found
        (while (< (point) (point-max))
          (let ((sums (mapcan
                       (lambda (a) (mapcar
                               (lambda (b) (+ a b))
                               l))
                       l))
                (x (string-to-number (word-at-point))))
            (when (not (memq x sums))
              (throw 'found x))
            (setq l (seq-take (cons x l) (length l))))
          (forward-line))))))

(day9 25)
542529149

(defun day9a (tgt)
  (with-current-buffer "input"
    (goto-char 1)
    (let ((results nil)
          (partials nil))
      (while (< (point) (point-max))
        (let ((x (string-to-number (word-at-point))))
          (setq partials
                (seq-filter
                 (lambda (z) (<= (car z) tgt))
                 (cons (list x (list x))
                       (mapcar (lambda (y)
                                 (list (+ x (car y)) (cons x (cadr y))))
                               partials))))
          ;;(message "%s" partials)
          (setq results (append
                         (seq-filter (lambda (z) (= tgt (car z))) partials)
                         results)))
        (forward-line))
      (mapcar
       (lambda (z) (list (seq-min (cadr z)) (seq-max (cadr z)) z))
       results))))

(day9a 542529149)
((542529149 542529149 (542529149 (542529149))) (23189120 52489498 (542529149 (37477873 36964189 34243114 31909958 52489498 30908145 43826724 29914669 28682756 29676232 25684438 24779820 ...))))

(+ 23189120 52489498)
75678618


((127 (127)) (127 (40 47 25 15)))

(seq-concatenate 'list '(1 2) '(3 4 5))
(1 2 3 4 5)

(append '(1 2) '(3 4 5 99))
(1 2 3 4 5 99)

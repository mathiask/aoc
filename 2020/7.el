(defun day7-extract-adjacency ()
  (with-current-buffer "input"
    (let ((am nil))
      (goto-char 1)
      (while (< (point) (point-max))
        (re-search-forward "\\([^0-9]*\\) bags contain ")
        (let ((tgt (match-string 1))
              (srcs nil))
          (unless (re-search-forward "no other bags." (line-end-position) t)
            (while (< (point) (line-end-position))
              (re-search-forward "[0-9]+ \\([^,.]*\\) bags?[,.]")
              (setq srcs (cons (match-string 1) srcs))))
          (setq am (append (mapcar (lambda (x) (list x tgt)) srcs) am)))
        (forward-line))
      am)))

(day7-extract-adjacency)

(defun day7-find-containers (bag adj)
  (let ((containers nil)
        (front (list bag))
        (next nil)
        (go t)) ;; this could be done in a more clever way => see below
    (while go
      (mapc
       (lambda (f)
         (mapc
          (lambda (a)
            (when (string-equal f (car a))
              (setq next (cons (cadr a) next))))
          adj))
       front)
      (delete-dups next)
      (setq containers (append next containers))
      (setq front next)
      (setq go (not (eq nil next)))
      (setq next nil))
    (delete-dups containers)))

(length (day7-find-containers "shiny gold" (day7-extract-adjacency)))
148

(defun day7a-extract-adjacency ()
  (with-current-buffer "input"
    (let ((am nil))
      (goto-char 1)
      (while (< (point) (point-max))
        (re-search-forward "\\([^0-9]*\\) bags contain ")
        (let ((src (match-string 1))
              (tgts nil))
          (unless (re-search-forward "no other bags." (line-end-position) t)
            (while (< (point) (line-end-position))
              (re-search-forward "\\([0-9]+\\) \\([^,.]*\\) bags?[,.]")
              (setq tgts
                    (cons (cons (string-to-number (match-string 1)) (match-string 2))
                          tgts))))
          (setq am (append (mapcar (lambda (x) (list src (car x) (cdr x)))
                                   tgts)
                           am)))
        (forward-line))
      am)))

(day7a-extract-adjacency)

(("vibrant plum" 6 "dotted black") ("vibrant plum" 5 "faded blue") ("dark olive" 4 "dotted black") ("dark olive" 3 "faded blue") ("shiny gold" 2 "vibrant plum") ("shiny gold" 1 "dark olive") ("muted yellow" 9 "faded blue") ("muted yellow" 2 "shiny gold") ("bright white" 1 "shiny gold") ("dark orange" 4 "muted yellow") ("dark orange" 3 "bright white") ("light red" 2 "muted yellow") ...)

(defun day7a-count-contained (bag adj)
  (let ((cnt 0)
        (front (list (cons 1 bag)))
        (next nil))
    (while front
      (mapc (lambda (f) (mapc
                    (lambda (a)
                      (when (string-equal (cdr f) (car a))
                        (let ((n (* (car f) (cadr a))))
                          (setq next (cons (cons n (caddr a)) next))
                          (setq cnt (+ cnt n)))))
                    adj))
            front)
      (setq front next)
      (setq next nil))
    cnt))

(day7a-count-contained "shiny gold" (day7a-extract-adjacency))
24867

126

32

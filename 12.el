(defun day12-v+ (v1 v2)
  (cons (+ (car v1) (car v2)) (+ (cdr v1) (cdr v2))))

(day12-v+ '(1 . 2) '(3 . -4))
(4 . -2)

(defun day12-v* (n v)
  (cons (* n (car v)) (* n (cdr v))))

(day12-v* 3 '(1 . -2))
(3 . -6)

(defun day12 ()
  (with-current-buffer "input"
    (goto-char 1)
    (let ((d '(1 . 0))
          (p '(0 . 0)))
      (while (not (eobp))
        (let ((arg (buffer-substring (1+ (point)) (line-end-position))))
          (case (char-after)
            ((?F ?N ?E ?S ?W)
             (setq p (day12-v+
                      p
                      (day12-v*
                       (string-to-number arg)
                       (case (char-after)
                         (?F d)
                         (?N '(0 . 1))
                         (?E '(1 . 0))
                         (?S '(0  . -1))
                         (?W '(-1 . 0)))))))
            ((?L ?R)
             (setq d (if (string= "180" arg)
                         (day12-v* -1 d)
                       (day12-v*
                        (if (string= "270" arg) -1 1)
                        (cons (* (cdr d)
                                 (if (= ?L (char-after)) -1  1))
                              (* (car d)
                                 (if (= ?L (char-after))  1 -1)))))))))
        (message "%s (%s)" p d)
        (forward-line))
      (list p d (+ (abs (car p)) (abs (cdr p)))))))

(day12)
((-225 . -296) (0 . 1) 521)

((17 . -8) (0 . -1) 25)

(defun day12a ()
  (with-current-buffer "input"
    (goto-char 1)
    (let ((wp '(10 . 1))
          (p '(0 . 0)))
      (while (not (eobp))
        (let ((arg (buffer-substring (1+ (point)) (line-end-position))))
          (case (char-after)
            (?F
             (setq p (day12-v+
                      p
                      (day12-v* (string-to-number arg) wp))))
            ((?N ?E ?S ?W)
             (setq wp (day12-v+
                       wp
                       (day12-v*
                        (string-to-number arg)
                        (case (char-after)
                          (?N '(0 . 1))
                          (?E '(1 . 0))
                          (?S '(0  . -1))
                          (?W '(-1 . 0)))))))
            ((?L ?R)
             (setq wp (if (string= "180" arg)
                         (day12-v* -1 wp)
                       (day12-v*
                        (if (string= "270" arg) -1 1)
                        (cons (* (cdr wp)
                                 (if (= ?L (char-after)) -1  1))
                              (* (car wp)
                                 (if (= ?L (char-after))  1 -1)))))))))
        (message "%s (%s)" p wp)
        (forward-line))
      (list p wp (+ (abs (car p)) (abs (cdr p)))))))

(day12a)
((20290 . -2558) (52 . -31) 22848)

((214 . -72) (4 . -10) 286)

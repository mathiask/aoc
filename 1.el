(with-current-buffer "input"
  (setq data nil)
  (goto-char 1)
  (while (< (point) (point-max))
    (setq data (cons (thing-at-point 'number) data))
    (beginning-of-line 2)
    ))

(length data)
200
data
(1572 1564 1968 1493 1920 1928 1963 1848 1828 1168 1588 1733 ...)

(seq-filter
 (lambda (d) (eq 2020 (car d)))
 (mapcar
  (lambda (z) (list (+ (car z) (cadr z) (caddr z)) z))
  (mapcan (lambda (x) (mapcan (lambda (y)
                           (mapcar (lambda (w)
                                     (list x y w))
                                   data))
                         data))
          data)))
((2020 (1003 912 105)) (2020 (1003 105 912)) (2020 (912 1003 105)) (2020 (912 105 1003)) (2020 (105 1003 912)) (2020 (105 912 1003)))

(* 1003 912 105)
96047280

(* 788 1232)
970816

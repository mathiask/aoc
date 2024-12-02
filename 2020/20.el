(defun day20-from-binary-string (s)
  (string-to-number
   (apply #'string
          (seq-map (lambda (c) (if (= ?# c) ?1 ?0)) s))
   2))

(defun day20-from-binary-char (c)
  (if (= ?# c) 1 0))

(defun day20-flip (x)
  (let ((y 0))
    (dotimes (i 10)
      (setq y (+ (lsh y 1) (logand 1 x))
            x (lsh x -1)) )
    y))

(defun day20-normalize (x)
  (min x (day20-flip x)))

(defun day20-edges (&optional no-normalize)
  (let ((top (day20-from-binary-string
              (buffer-substring (line-beginning-position)
                                (line-end-position))))
        (left 0)
        (right 0)
        bottom)
    (dotimes (i 10)
      (setq left
            (+ (lsh left 1) (day20-from-binary-char (char-after))))
      (setq right
            (+ (lsh right 1) (day20-from-binary-char (char-after (+ 9 (point))))))
      (when (= i 9)
        (setq bottom
              (day20-from-binary-string
               (buffer-substring (line-beginning-position)
                                 (line-end-position)))))
      (forward-line))
    (list (if no-normalize top (day20-normalize top))
          (if no-normalize right (day20-normalize right))
          (if no-normalize bottom (day20-normalize bottom))
          (if no-normalize left (day20-normalize left)))))

(defun day20 (start n)
  (save-excursion
   (goto-char 1)
   (re-search-forward "^;;;;; INPUT$")
   (forward-line)
   (let ((image-hash (make-hash-table))
         image-edges)
     (while (not (or (eobp) (looking-at "^;;;;;")))
       (re-search-forward "[0-9]+")
       (let ((e (cons
                 (string-to-number (match-string 0))
                 (progn
                   (forward-line)
                   (day20-edges)))))
         (setq image-edges (cons (list (car e) (cdr e)) image-edges))
         (puthash (car e) (cdr e) image-hash))
       (when (not (or (eobp) (looking-at "^;;;;;")))
         (forward-line)))
     ;; count edge occurrences
     (let ((h (make-hash-table)))
       (dolist (es image-edges)
         (dolist (e (cadr es))
           (puthash e (1+ (gethash e h 0)) h)))
       (setq image-edges
             (mapcar
              (lambda (es)
                (list
                 (car es)
                 (mapcar (lambda (e) (cons e (gethash e h))) (cadr es))))
              image-edges))
       (let* ((fst (seq-find (lambda (x) (= start (car x))) image-edges))
              (tr (day20-find-trans nil nil (cadr fst)))
              (row (list (cons start tr)))
              (next  (car  (elt (day20-d4-apply (cadr fst) tr) 1)))
              (pick (lambda (left top)
                      (let ((cand image-edges)
                            res)
                        (while (not res)
                          (let ((tr (day20-find-trans left top (cadar cand))))
                            (if tr
                                (setq res (cons (car cand) tr))
                              (setq cand (cdr cand)))))
                        (setq image-edges
                              (seq-remove (lambda (x) (= (caar res) (car x))) image-edges))
                        res)))
              rows)
         (setq image-edges
               (seq-remove (lambda (x) (= start (car x))) image-edges))
         ;; puzzle first row
         (dotimes (i (1- n))
           (let ((ne (funcall pick next nil)))
             (setq row (cons (cons (caar ne) (cdr ne)) row)
                   next (car (elt (day20-d4-apply (cadar ne) (cdr ne)) 1)))))
         (setq rows (list (reverse row)))
         (dotimes (i (1- n))
           (let (next)
             (dotimes (j n)
               (let ((ne (funcall pick
                                  next
                                  (let ((etr (elt (elt rows i) j)))
                                    (day20-d4-apply
                                     )
                                    ))))
                 (setq row (cons (cons (caar ne) (cdr ne)) row)
                       next (car (elt (day20-d4-apply (cadar ne) (cdr ne)) 1))))
               )
             )

           )
         )
       ))))

(day20 3079 3)
((3079 1) (2473 0 . t) (1171 3 . t))



((3079 ((501 . 1) (66 . 1) (116 . 2) (89 . 2))) (2729 ((85 . 2) (9 . 2) (397 . 2) (271 . 1))) (2971 ((161 . 1) (565 . 2) (85 . 2) (78 . 1))) (2473 ((481 . 1) (116 . 2) (234 . 2) (399 . 2))) (1489 ((43 . 1) (18 . 2) (183 . 2) (565 . 2))) (1427 ((183 . 2) (234 . 2) (210 . 2) (9 . 2))) (1171 ((399 . 2) (18 . 2) (24 . 1) (391 . 1))) (1951 ((397 . 2) (318 . 2) (177 . 1) (587 . 1))) (2311 ((210 . 2) (89 . 2) (231 . 1) (318 . 2))))

((3079 2) (2971 2) (1171 2) (1951 2))
;; 3079 2473 1171
;; 2311 1427 1489
;; 1951 2729 2971

(defun day20-d4-apply (l trans)
  (let* ((n (- 4 (car trans)))
         (l (append (last l n) (butlast l n))))
    (when (cdr trans)
      (let ((x (elt l 1)))
        (setf (elt l 1) (elt l 3)
              (elt l 3) x)))
    l))

(day20-d4-apply '((501 . 1) (66 . 1) (116 . 2) (89 . 2)) '(3 . t))

(defun day20-n-to-trans (n)
    (cons (% n 4) (> n 3)))

(defun day20-find-trans (left top sides)
  (let ((n 0)
        (f (lambda (x y) (or (and (not x)
                             (= 1 (cdr y)))
                        (and x (= x (car y))))))
        r)
    (while (and (not r) (< n 8))
      (let ((sr (day20-d4-apply sides (day20-n-to-trans n))))
        (when (and (funcall f left (elt sr 3))
                   (funcall f top (elt sr 0)))
          (setq r (day20-n-to-trans n))))
      (incf n))
    r))


;;;---------------
(apply #'* (mapcar #'car '((2029 2) (1873 2) (1447 2) (3221 2))))
17712468069479

;;;;; INPUT
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
;;;;; END

;; ----------------------------------------------------------------------

;;;;; INPUT
Tile 1319:
#.########
##.#.#.#..
.....#..##
.#.....#..
.........#
#.........
#..##...#.
#.#.#...##
.#....#...
....##..#.

Tile 3547:
##.##.#.##
.....##.##
...#.....#
#..#.##.##
#.....#...
#....##...
...###....
.....#.#.#
#.##....#.
###.#.##.#

Tile 3373:
##.##..#.#
#.###.#..#
#..####.#.
...#...#..
###.###...
...#.#..##
........#.
#.#.#.#.#.
.#.#......
#.#.#..#.#

Tile 3329:
....#...#.
#.....##..
####.##..#
..#..##..#
#........#
#..#..#...
.#..#..#.#
.....####.
....#.....
#..##..##.

Tile 3221:
.##.#.##.#
##.....###
........#.
.#........
#.#......#
..#..#...#
##..#.#...
..#..####.
#.#.......
...#.##.#.

Tile 3307:
##...##...
#..#..#..#
#........#
.#.....##.
...##.#...
.....#...#
.#..##.#..
.....#..#.
..........
#..####...

Tile 2389:
..###...##
...##...#.
#.##..#..#
##.......#
..........
#.......#.
##...#..#.
##...#.#..
.....#...#
.###.#....

Tile 2851:
.####..#..
.......##.
#.....#..#
#..#......
#........#
......#.#.
...#....#.
#....####.
#.##.....#
.#.#.#####

Tile 3271:
.##..##.##
#.#####..#
....#...##
#.####...#
...#..#..#
#....#...#
..##......
.#...#.#..
#...#.#...
##.###....

Tile 3821:
#####..#.#
.......#.#
#......##.
#..#..#..#
.#..##...#
#.....#..#
.#..#....#
#...###..#
#.#.......
...#.....#

Tile 1811:
#..##.###.
......###.
#...##.#.#
.....##.#.
##...#...#
.##..#..#.
#.....##.#
...#..#.##
....##...#
....##.##.

Tile 3739:
.###.##..#
#.##...#.#
#..#...#..
#.....#.##
#.....#...
...##.....
......#...
..#.....##
#.#.#....#
##....#.#.

Tile 2377:
...##.#.#.
##....#.#.
##........
....#....#
......#.##
##...#....
........#.
.......#..
#....#....
.#......##

Tile 3853:
.#..#.#...
###.#.#.##
##....#..#
#.#..#....
..#.#.....
##.##..#.#
.#........
##..#.##..
...###...#
..###.#.#.

Tile 3037:
##.####...
#....##..#
#......###
###.#..##.
........#.
.......##.
..#....#.#
........##
.#.##..#..
#..#..#.##

Tile 2381:
..#.##.###
...#...##.
#....#....
.........#
##.#.....#
.....##.##
#.....####
.###......
........##
.##......#

Tile 1663:
####...##.
#.....#.#.
#..##...#.
.........#
......####
.#.....###
......#..#
.........#
.........#
.#####..##

Tile 3167:
..##...##.
.#.....##.
#......#..
.#.#......
#....#....
#..#.##...
.#..###...
......##..
#...#..#.#
##..#.###.

Tile 1481:
.#.###.#.#
.##......#
####...#..
..........
.....#....
#.........
.#.##..#..
.#.##....#
..###....#
.##.####.#

Tile 3457:
.#.#..####
.........#
#.......##
#........#
.#.......#
#.##.....#
.##..#.##.
.....#...#
#...#....#
....##..#.

Tile 3229:
#..###..#.
.....##...
##..#.#...
#.....##..
..#..#....
..##....##
#.........
.....#..#.
#..#.....#
..#.######

Tile 1447:
.#..##.#.#
.##.##...#
...#.#....
...#...##.
....#.....
.#..#.....
#.#......#
.....#...#
#..#...#.#
.##....#..

Tile 2243:
##.#.##.##
###.#..#..
....##..##
..##.....#
....###...
#..#...#.#
#..#.....#
#...#.#.##
##..##..##
..###.#.#.

Tile 2927:
#.#.#####.
.#......##
#.......#.
#...#....#
....#.#..#
....###...
...#.....#
.##.......
#.#.......
..#.###.##

Tile 2267:
.##....#.#
..###....#
..##.##...
.##..#.#.#
...##...#.
..#...##.#
..#...##.#
..##...#..
..##...#..
#.#..#....

Tile 2027:
###.#....#
..#.#.###.
...#...###
.........#
.#...#..##
...#.....#
#.......#.
#.....####
.#...#...#
#..#######

Tile 3539:
#..#..###.
#...#...#.
....#.#.#.
.###.##.#.
......#...
...#...#.#
###...#...
.......###
#..#...#..
###.#.#.#.

Tile 3319:
.#..###...
#.#.......
......#...
......#.#.
.......###
#...#...#.
..###....#
.#.#...##.
##.#..#.##
.....#...#

Tile 2861:
..#...#.##
...##..#..
.#.......#
##...##..#
.....#....
...#.#...#
..##..#...
...#.....#
..##..#...
....#.#..#

Tile 3833:
#...#..##.
##.#.....#
........##
#....#..##
.#..#.....
......#..#
##..##.#..
#.#..#....
..#....##.
..#######.

Tile 2357:
..#.#....#
##..#..##.
#.##....##
..#......#
#........#
.....#.#.#
...##..#..
.###...###
..#.#....#
###.##..##

Tile 2647:
.#.##.###.
#......#.#
####..#...
##..#.#.##
#..#.....#
#....#....
#.#.......
#.##.#..#.
##.#......
#..#####..

Tile 1103:
.##.#....#
#....#.#..
.#..###.##
##.#.#..#.
..#.####.#
#.###.#.#.
..#......#
#...#..#.#
....#...#.
#.#..##...

Tile 3253:
....#..#..
.........#
#...#.....
...#...#..
..##......
#####.....
#......#..
..#.#.#...
.....##.#.
##..#....#

Tile 1789:
..###.##..
#......#.#
....#.....
#..#..##..
......#.##
....#..#..
#.#.#....#
...#.#.#.#
....#...#.
..####.##.

Tile 2897:
..###...#.
#......#..
#....#....
..........
#.#......#
...##.#...
#.#..#..##
........#.
#....#....
.##.##..#.

Tile 3347:
....#...#.
.#.##.....
..#......#
#.........
#..#.....#
#...#..#.#
##.####..#
..........
####...#..
#.#....#..

Tile 1091:
#.#.##..##
#.##.#.#.#
#.#.#...##
........#.
#.####...#
##.#..####
#.#.#..#..
#.##.....#
....##....
.##..###.#

Tile 1427:
##.#...#..
..#.#....#
....##..#.
....#..#.#
.....#.##.
.#........
........##
##..###..#
.#..#..#..
###...####

Tile 2069:
.##.######
##.......#
..#....#.#
##....#..#
#.#.....##
#....##..#
#....#....
..#...#..#
...#....#.
##..#..###

Tile 3041:
##..#..###
.##.......
.......#..
#.....#...
##..#...##
.....#..##
..#.......
###.#.....
##...#...#
.#..##.#.#

Tile 2879:
#.##.#.#.#
.....#..#.
#.#....#.#
###...#...
#..#......
.....#...#
..##......
#......#.#
#....#.#..
####...#..

Tile 1373:
..#..#..##
.##....#..
#.....#...
#......#.#
#.#....#..
..##..#..#
...#.....#
##.##.##..
.##......#
...#..###.

Tile 3433:
.####..###
##.......#
#..#.....#
...#..#..#
.#...##..#
#.#....##.
...#......
#...#....#
.#.......#
..##.#.###

Tile 2633:
#.###.##..
#...#..#.#
.....#.###
#..#..#..#
.##.#..#.#
..##.....#
....##....
..#.#..###
#.....#...
..#.....#.

Tile 1933:
#.#.#####.
.##..#.#..
###.###..#
#.#.##....
##...#....
##.......#
###..#....
##..#.....
#####.##..
##.#..#..#

Tile 3391:
.#....####
...#.#.#..
..##....##
#.#..#..#.
.#.##.#...
..#.#....#
#.#....#.#
....#.#...
#.....#..#
#.#..###..

Tile 2153:
.#...##...
#.#.......
#..#......
......#...
..###....#
#.###...##
##.......#
...#..##.#
#......#..
.#.#...##.

Tile 1873:
.#..#.####
#..#..#..#
##..##..##
#..##.....
#..#.#...#
..#.....##
#.......#.
###.......
#....##...
##..####..

Tile 3919:
#.###.####
#.........
#.#.#..#..
..#.#.....
..#.#..#..
#..##.....
#..#.#....
#........#
##...##.##
#..#.#.###

Tile 1277:
#.#......#
##...#....
#..#...#.#
.#...#.###
#....#.#.#
....#.....
####......
.....#.#.#
.#...#..##
...###.#.#

Tile 3793:
..##.##.#.
...#.....#
.#.......#
#.#.##....
#..#.....#
##....#...
.......#.#
##.....#.#
#.#.#...##
###..##.#.

Tile 1993:
##..##.#..
..#..##...
#.#....###
.......#..
#........#
..........
....#...#.
....#..#..
#......#..
#.#..#.#..

Tile 1123:
#.#####..#
...#...###
.##..#.#..
.....#.#..
#..#.....#
....#...##
#...##...#
...#.##...
#.##...#.#
.###.###.#

Tile 1231:
#########.
#...#.#..#
..###....#
#..#.....#
####.....#
..#...#..#
.#.##.#...
#...#.....
###..#....
###...#.#.

Tile 1019:
..######.#
#....##..#
...#.....#
##.....#.#
.........#
###......#
..#..#...#
.#....#...
.#...#....
#...###..#

Tile 3863:
....#.#.#.
...#......
..##.###.#
##..###..#
.........#
.#.##....#
#.....##.#
#........#
#.#.......
###.##..##

Tile 1831:
###.#.##.#
.#..#..#.#
......#.#.
#.##.....#
..#.#..#.#
#........#
#...#...#.
#.........
.....##..#
....#####.

Tile 1031:
.#.###.#.#
..........
#..##.....
#..#...#.#
.#.#......
##.#.....#
..#......#
....##...#
..#...#..#
###...###.

Tile 2029:
......#..#
...#.....#
....#.#.##
##.#.#...#
#........#
.......##.
..........
.#.#......
##.....#.#
.#.##..###

Tile 2837:
#...#.#..#
.#........
##.....#.#
...#.....#
....###.##
.#..###...
..###.##.#
#.#..#..##
#....##..#
....#.#.#.

Tile 3877:
###.#.#..#
#.....#..#
.......#..
..###..#..
..##......
..#.#....#
##.......#
..#...#...
.##.#...##
...#..##.#

Tile 1249:
#..#..####
.........#
.........#
...#......
#.......##
...##.#.##
#.........
#.#.......
#...###...
.#.#..##..

Tile 1601:
.##.#..#..
..#.......
#.....####
#........#
#..#...##.
#.#....#.#
#........#
..........
...#..#.##
#..##.##..

Tile 2749:
#.......#.
#...#.....
..#....#.#
.........#
.#....#...
......#..#
....#...#.
.....#....
.###......
##..##.#.#

Tile 3613:
##.#...###
.##..###..
...#......
...#...##.
.....#....
#...#...#.
#.###....#
#.........
.........#
###.##...#

Tile 3491:
.#.#...#..
#...#.....
#..#...##.
..#.......
..#......#
..#...#...
#.#.......
....##.#.#
#..#....##
.####.....

Tile 2441:
#.....###.
#........#
.#....#..#
#.....#..#
#..#...#..
##....#..#
..#.......
....###.#.
#......###
.#.##.###.

Tile 2417:
.....#....
#...###.#.
..#.......
.......#..
#.......#.
..#.##...#
#.........
....#....#
..#.......
##.##....#

Tile 2663:
###.#####.
##..##....
#..#...#..
#.#......#
#.#......#
#...##.##.
#.........
..#..##...
#....#....
..#.#.#.##

Tile 3527:
.####..###
#.#...####
#..##.....
....#..#..
#.......#.
.#.......#
..##..#..#
........#.
##.......#
###...#..#

Tile 1777:
.#.####..#
.#...#.#..
###..#.##.
..##..#...
.......#.#
#.#....#.#
...#....#.
#........#
.#.#.....#
#.##...##.

Tile 1213:
...###.#.#
##......##
#........#
.#........
....#...#.
.#........
..#....#..
...#.#....
..#.#.####
#..##..#..

Tile 3967:
.....#....
##..#...##
##........
#.#.......
#...#..#.#
..........
.....#.#..
##.....#.#
#...##...#
..#.##.#.#

Tile 2683:
...##..#.#
##..##....
#.##......
##.......#
#####...##
#.#..#....
.#.......#
###....#..
.#.......#
.......#.#

Tile 1499:
.#.....#.#
..#.....#.
####....##
#........#
#.#.#....#
#..#....#.
#.#..##...
#.#.#..#.#
#.##......
..#.###.##

Tile 2687:
.#...#.#..
..#.......
.........#
...##.....
#.......#.
.......#.#
#..#.....#
..###...##
.#....#..#
##...#.#.#

Tile 3469:
##.##.....
#.##......
........#.
##.#.###.#
.....#.#..
#.....##..
.#.#.#..#.
#..#.#....
#.#...#..#
...##...##

Tile 1697:
.####.....
...##.#..#
#.#.###..#
##.....#..
.......###
#....#.#..
...#.#...#
...#......
..#..##..#
...#.##.##

Tile 1451:
###.#.#.#.
.#..#.#...
#.....#.##
#.....##.#
###...##..
.#........
.#..####..
#.....####
.#.#..##.#
##..#..#..

Tile 2789:
..#.#.#.#.
...#....#.
#.##.#....
#...#.###.
.........#
#.......#.
###....#.#
.....#...#
.#.....#..
##.##..###

Tile 2213:
.#.#...###
#.#....#..
..#....#..
#..#.#...#
#...#...#.
###.......
#..####..#
##..#..##.
.........#
####....#.

Tile 3637:
..#.##.#.#
......####
#.#...#.#.
..#.#..#.#
#..#..#..#
..........
#..#...#.#
.......#..
..........
...#.#.###

Tile 1997:
##..###..#
..#.#.....
...#.#...#
.......#..
#....#.#..
#..####...
####...##.
...#.....#
#..##.#..#
#.....#.##

Tile 3089:
..##..#.#.
#.##.#.#..
.#..##.#..
...#.#...#
#.##..####
#...#....#
#........#
#.#.......
#..##....#
..#...#...

Tile 2113:
#...#.....
#.#.##..##
#....#...#
.###......
##..#.....
.#....#..#
....##..##
.#.....#.#
..........
#......#..

Tile 1699:
#.####....
###..####.
###.####..
....#....#
....##.#..
#.#.#.....
..#.#....#
###..##..#
........#.
......##.#

Tile 3607:
###..#....
....#..#..
....#.###.
......#...
.........#
##.#.###.#
##..##....
####.....#
#........#
..##..#...

Tile 1867:
#..#..#...
..#..#...#
###......#
#...#.....
.........#
..........
##.#....#.
##.#......
#.......##
...###.#..

Tile 2473:
#.....###.
..#.##...#
##..#.#...
.#.......#
........##
.....#.#.#
#...#.#.##
##..##...#
#..#.....#
##....#.#.

Tile 2707:
#.#..#.###
..#..#....
#.#..#...#
......##..
..#..#....
#..##.....
##.#..##.#
#.##.#.#..
#.#..##.#.
##.#...#.#

Tile 3533:
####...#..
##......##
##..#..###
...#.#...#
.#.#.#....
.###..##..
..#..#.#.#
......#...
#.##.#..#.
.##.####.#

Tile 3019:
##.......#
....##....
#..#.#....
........##
#........#
##....#.##
.......##.
....##...#
..#.......
#.#...#..#

Tile 2699:
#.#.#.#.##
.#...#####
#........#
...#..#.#.
.##.#..#..
#.........
#.#.#...##
.......##.
##...#...#
.#####..##

Tile 3413:
.#.##....#
.....##..#
#...#..#..
#...#.....
#..#....##
.......#..
...#.....#
......##..
#..#....#.
..#..####.

Tile 1063:
###..#.###
#.#.#.....
#.#.......
........#.
#..#......
#.##.##.##
#...#....#
#.#.......
#..##....#
.##.......

Tile 2731:
.####.##..
#.#.......
#.#..##.##
...#...#..
...#......
.....##...
##.#.#...#
##...#....
#.##..##..
.##.##..#.

Tile 2621:
#..#.#..##
##....#...
.#........
.........#
#.......##
#...###.#.
#......###
#.......#.
.....#...#
.#..#####.

Tile 1543:
.#....#.##
###.......
..#..#.###
.#.##.....
....#.#.#.
.##.##...#
.##..#....
.#........
.##.....#.
..###..#..

Tile 1973:
...#......
.#...#...#
#.#.#.#..#
...#...#..
#....#.#..
#####..##.
#..#......
#.#.......
#....#.#.#
####...##.

Tile 1549:
#.#.##.###
.###....#.
#.......#.
#......#.#
#.#...#.##
#...#...##
#.#....##.
###.#....#
##..#..#..
.###.#.###

Tile 1381:
.##.#.##..
...##.....
...#.#...#
#...#...#.
.#.#...#.#
#..#......
##........
..........
..#.....##
.#.....##.

Tile 2131:
####.##..#
####...#..
.##.#.....
#.#....##.
....#....#
#.##...#..
#.....####
#..##....#
.#.##..#.#
#####...#.

Tile 3769:
#.#.#..#.#
#.##.#....
..##..#..#
#.........
#.#....###
##...#.#..
#......##.
#......#..
..........
#..#..##.#

Tile 3001:
.###...##.
###..#....
#........#
#.....##.#
..#.#.#...
.#..#.##..
#.....####
..#.##....
#...#.##..
...#.#..#.

Tile 3299:
##...###.#
##.....###
#..#.##...
.........#
..##.....#
#..#..#...
.....#.###
.#....##..
....#.#...
####...###

Tile 2411:
...#.#....
#..##.....
.#.##..#.#
#..##..#..
#.#......#
#.........
#.###...#.
...##.....
..#......#
.#...#####

Tile 3943:
#.#.#.####
##..#.#...
#.......#.
#..#......
.#.......#
###.#.#...
.......##.
#..##....#
.....#...#
...#..#.#.

Tile 1409:
.###...###
.......#.#
#..##....#
#.####....
##..#..###
.###..#.##
#...#....#
#.....#.##
###..#.#..
##.##.###.

Tile 1459:
...#.##.##
.....#...#
...#......
.......#.#
#...#.....
...#......
##.#...#.#
#.##..#...
..#.#...##
#..#..#.#.

Tile 1637:
#.####...#
.......#.#
.#....#.##
#..#..#..#
#..#.....#
.#....#.##
#....#.###
.....###..
#...#..#.#
######....

Tile 3023:
##.#.###.#
#.#.#.#..#
#.###..#.#
...###..##
#....#...#
##.#......
.....#.#.#
##......#.
#.#......#
.#...#..#.

Tile 2203:
..#..#...#
#...#....#
#.....##.#
##.#.....#
......#..#
...#...#..
#...#....#
.........#
.##...#...
...##.#.##

Tile 1399:
#.#.###.##
.........#
.#.....#..
#.#..##...
#...#.....
#..#......
.#..##....
.....#....
.......#..
#.#.##....

Tile 1151:
##....#.##
###....##.
##...#...#
.....##...
..#..#....
.#..#.....
..........
......##..
#....#..##
#..##...#.

Tile 3187:
#.###....#
#.#...#..#
.........#
......#..#
#..#.#...#
.#...#####
#........#
.....#....
#.#.......
...#.##...

Tile 3079:
##..#.#...
...##.#...
.#..##...#
...#......
.#.#....#.
..........
#..#......
#.#..#....
..##......
..#.#....#

Tile 1693:
#..#...###
.#..#....#
#.#......#
#..###.##.
.......#..
.......###
.#....#...
....##.#..
..........
.#..###..#

Tile 1423:
.##....###
###.#.#..#
#...##...#
#.####.#.#
.......#..
.........#
#..#.#....
#.#.##....
...#.##..#
##.#.#...#

Tile 1039:
..#.#..##.
###..#..##
#..#......
....#.#..#
###....#.#
.#..#.#..#
......##..
#..###.##.
.#..#....#
#.#.#.....

Tile 1523:
#..##.#.#.
.......##.
#......#.#
#...#...##
#..##.....
#..#..#.##
..##....##
#.#...#..#
.....#...#
#....####.

Tile 2957:
#.#.###.##
....#..#..
##..#.....
#.....#..#
.......#..
....#.##.#
.....#....
.........#
......#...
##.#.#....

Tile 2711:
##.###...#
#...##....
...#......
#..#.....#
.##.#..#..
#.####...#
.###...###
#...#....#
.....#....
#.#####.#.

Tile 1009:
.##.#...##
#.#......#
....#.#.#.
#..#......
#.........
#........#
.#..#.####
..##.#####
##....#...
.#..#..###

Tile 2467:
.##....###
....####.#
#..#......
......#...
.....##.##
....#....#
..#.#....#
#...##..#.
.#.......#
#####.#..#

Tile 2383:
#...#.#..#
......#...
###.......
#..#.....#
..#....#..
#..####.##
#....#...#
#..#....##
#.....####
#.....####

Tile 3631:
###.#...##
...#.#...#
..#.#..#..
....#....#
#.#....#..
#..##..#.#
.##...#...
#.....#..#
#.##.#....
##.###....

Tile 3659:
#.#####..#
....#.##.#
#...#.#..#
...#.##..#
#.###.#.#.
#....#.###
...#.#.##.
..#.#.###.
..##.....#
.##.##..##

Tile 2857:
...##.#.#.
#...#....#
........##
#.........
....#.#...
..#.##.#..
#..##..##.
#.###.....
#.####..#.
.#.#.#.##.

Tile 1669:
#.#...#.##
#.##....##
#...#..##.
.##.#.#.#.
#........#
..#..##..#
#.........
#.#..#....
#.......#.
..##..###.

Tile 2521:
...#..####
.##..#.#..
.....#...#
.#....#...
.........#
..#.......
.#.......#
.#.......#
..#....#..
#.###.##..

Tile 3407:
.###.#.##.
#.....#...
#........#
....#.....
..##.#..##
##........
#.#....#.#
........#.
#.#...#..#
..##.#....

Tile 3931:
###.###.#.
.#.#..#..#
###.###...
.#.#.#....
#.....##.#
..#..#.#..
...#.....#
.#....#...
.#........
#.#.....##

Tile 2371:
##.##.....
#.#.###...
..##......
#.#..##...
.#..#..#.#
...####..#
#...#..#.#
.###...#.#
####......
...#..#.##

Tile 1171:
..##..#.##
#..#.....#
........##
...#.#.#.#
.#.......#
#......#.#
#......#..
..##......
.....##..#
#..#.####.

Tile 1489:
#....#..##
...#.#...#
#.#.#..#..
....#..#.#
##.#.###.#
####....##
....#....#
.#.....##.
....#.....
##.##..#.#

Tile 2971:
.####.##.#
#.#.#.#...
.....#..##
....#.....
.#.#......
.#.##.....
...#..#...
...###...#
#..##.####
##...#.###

Tile 2309:
.#...##.#.
#.#.......
.#..#..#.#
..#.##....
.....##...
.......#.#
..###....#
##.#..#.##
.........#
.###.#..##

Tile 1129:
.##..##.##
##.#.#.#..
#.##.#..##
..##..##..
#.....#.#.
..##..#...
#.#..#.#..
#..#....#.
....#..##.
.#.##...#.

Tile 3313:
###.......
###.......
.......#.#
.#.##..#.#
###.#...##
.......##.
....#..##.
..#...####
..#...###.
..#.#..###

Tile 3209:
#.....##..
##......##
#.#.......
..#...#..#
##..#.....
...#..#..#
.#...#.#..
###..##..#
#.##......
#...####.#

Tile 3583:
.##.#...#.
...#....#.
#.....#..#
.....#####
#...#.#.##
#..#......
#.#.######
#.....#...
..........
.#.#......

Tile 3169:
.####..##.
##....#.#.
.#....#..#
##........
#..#.....#
#...#....#
..........
##...#...#
#.....#..#
#...#...##

Tile 2011:
###.###..#
#.##..#.#.
#....###.#
#......##.
....#....#
#..#.#....
#........#
#....#.###
.........#
.#..######
;;;;; END
(defun day8 (fix-line-no)
  (with-current-buffer "input"
    (let ((visited-linenos nil)
          (acc 0))
      (goto-char 1)
      (while (not (memq (line-number-at-pos) visited-linenos))
        (when (eq (point) (point-max))
          (throw 'fixed acc))
        (setq visited-linenos (cons (line-number-at-pos) visited-linenos))
        (let ((delta-lineno 1)
              (instruction (word-at-point))
              (op (string-to-number
                   (buffer-substring (+ 4 (point))
                                     (line-end-position)))))
          (case (if (eq (line-number-at-pos) fix-line-no)
                    (fix instruction)
                  (intern instruction))
            ('nop)
            ('acc
             (setq acc (+ acc op)))
            ('jmp
             (setq delta-lineno op)))
          (forward-line delta-lineno)))
      acc)))

(day8 1000)
1744

(catch 'a (catch 'b (throw 'b 42)))
42
(catch 'a 1)
1

(defun fix (inst)
  (case (intern inst)
    ('nop 'jmp)
    ('jmp 'nop)
    (t (intern inst))))

(defun day8-search ()
  (catch 'fixed
    (with-current-buffer "input"
      (dotimes (i (- (line-number-at-pos (point-max)) 2))
        (message "Trying... %s" i)
        (day8 (1+ i))))
    "not found"))

(day8-search)
1174

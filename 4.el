(defun day4 ()
  (with-current-buffer "input"
    (let ((cnt 0))
      (goto-char 1)
      (while (< (point) (point-max))
        (forward-line)
        (setq go t
              fields (copy-hash-table #s(hash-table size 30 data (ecl t pid t eyr t hcl t byr t iyr t hgt t))))
        (while go
          (while (search-forward ":" (line-end-position) t)
            (forward-char -1)
            (remhash (intern (word-at-point)) fields)
            (forward-char 1))
          (forward-line)
          (setq go (not (eq (point) (line-end-position)))))
        (when (eq 0 (hash-table-count fields))
          (incf cnt)))
      cnt)))

(day4)
213

(defun validate (field val)
  (case (intern field)
    ('byr
     (and (string-match "^[0-9]\\{4\\}$" val)
          (let ((y (string-to-number val)))
            (and (<= 1920 y) (<= y 2002)))))
    ('iyr
     (and (string-match "^[0-9]\\{4\\}$" val)
          (let ((y (string-to-number val)))
            (and (<= 2010 y) (<= y 2020)))))
    ('eyr
     (and (string-match "^[0-9]\\{4\\}$" val)
          (let ((y (string-to-number val)))
            (and (<= 2020 y) (<= y 2030)))))
    ('hgt
     (and
      (string-match "\\(^[0-9]+\\)\\(cm\\|in\\)$" val)
      (let ((x (match-string 1 val))
            (unit (match-string 2 val)))
        (let ((h (string-to-number x)))
          (or (and (string-equal "cm" unit)
                   (<= 150 h)
                   (<= h 193))
              (and (string-equal "in" unit)
                   (<= 59 h)
                   (<= h 76)))))))
    ('hcl
     (string-match "^#[0-9a-f]\\{6\\}$" val))
    ('ecl
     (or (string-equal "amb" val)
         (string-equal "blu" val)
         (string-equal "brn" val)
         (string-equal "gry" val)
         (string-equal "grn" val)
         (string-equal "hzl" val)
         (string-equal "oth" val)))
    ('pid
     (string-match "^[0-9]\\{9\\}$" val))
    ('cid t)))


(defun day4a ()
  (with-current-buffer "input"
    (let ((cnt 0))
      (goto-char 1)
      (while (< (point) (point-max))
        (forward-line)
        (setq go t
              ok t
              fields (copy-hash-table #s(hash-table size 30 data (ecl t pid t eyr t hcl t byr t iyr t hgt t))))
        (while (and go ok)
          (while (and ok (search-forward ":" (line-end-position) t))
            (forward-char -1)
            (beginning-of-thing 'word)
            (re-search-forward "\\([^:]+\\):\\([^ ]+\\)" (line-end-position))
            (remhash (intern (match-string 1)) fields)
            (setq ok (validate (match-string 1) (match-string 2))))
          (forward-line)
          (setq go (not (eq (point) (line-end-position)))))
        (when (and ok (eq 0 (hash-table-count fields)))
          (incf cnt)))
      cnt)))

(day4a)
147

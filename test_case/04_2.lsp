(print-bool (or #t #t #f))
(print-bool (or #f (and #f #t) (not #f)))
(print-bool (and #t (not #f) (or #f #t) (and #t (not #t))))



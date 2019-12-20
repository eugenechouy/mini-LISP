(define bar (lambda (x) (+ x 1)))

(define bar-z (lambda () 2))

(print-num (bar (bar-z)))


(define foo
  (lambda (f x) (f x)))

(print-num
  (foo (lambda (x) (- x 1)) 10))


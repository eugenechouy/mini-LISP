(define add-x
  (lambda (x) (lambda (y) (+ x y))))

(define z (add-x 10))

(print-num (z 1))


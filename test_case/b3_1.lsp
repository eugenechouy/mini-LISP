(define dist-square
  (lambda (x y)
    (define square (lambda (x) (* x x)))
    (+ (square x) (square y))))

(print-num (dist-square 3 4))


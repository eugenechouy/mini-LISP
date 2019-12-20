(define x 0)

(print-num
  ((lambda (x y z) (+ x (* y z))) 10 20 30))


(print-num x)


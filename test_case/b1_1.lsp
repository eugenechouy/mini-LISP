(define fact
  (lambda (n) (if (< n 3) n
               (* n (fact (- n 1))))))

(print-num (fact 2))
(print-num (fact 3))
(print-num (fact 4))
(print-num (fact 10))

(define fib (lambda (x)
  (if (< x 2) x (+
                 (fib (- x 1))
                 (fib (- x 2))))))

(print-num (fib 1))
(print-num (fib 3))
(print-num (fib 5))
(print-num (fib 10))
(print-num (fib 20))


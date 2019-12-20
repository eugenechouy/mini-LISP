(define min
  (lambda (a b)
    (if (< a b) a b)))

(define max
  (lambda (a b)
    (if (> a b) a b)))

(define gcd
  (lambda (a b)
    (if (= 0 (mod (max a b) (min a b)))
        (min a b)
        (gcd (min a b) (mod (max a b) (min a b))))))

(print-num (gcd 100 88))

(print-num (gcd 1234 5678))

(print-num (gcd 81 54))


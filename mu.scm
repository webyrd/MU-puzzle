(load "mk.scm")

;; standard appendo relation
;;
;; could also use CLP(lists) [constraint logic programming over
;; lists], which is based on a lazy appendo constraint that can be
;; efficient when the first list is length-instantiated
(define appendo
  (lambda (l s out)
    (conde
      [(== '() l) (== s out)]
      [(fresh (a d res)
         (== (cons a d) l)
         (== (cons a res) out)
         (appendo d s res))])))

;; production rules from http://en.wikipedia.org/wiki/MU_puzzle
;;
;; Mx -> Mxx
;; xI -> xIU
;; xIIIy -> xUy
;; xUUy -> xy
;;
;; might be more efficient if the lists were reversed
(define stepo
  (lambda (in out)
    (conde
      ((fresh (x xx)
         (== `(M . ,x) in)
         (== `(M . ,xx) out)
         (appendo x x xx)))
      ((fresh (x)
         (appendo x '(I) in)
         (appendo x '(I U) out)))
      ((fresh (x y)
         (appendo x `(I I I . ,y) in)
         (appendo x `(U . ,y) out)))
      ((fresh (x y)
         (appendo x `(U U . ,y) in)
         (appendo x y out))))))

;; reflexive, transitive closure of stepo
(define step*o
  (lambda (in out)
    (conde
      ((== in out))
      ((fresh (res)
         (=/= in res)
         (stepo in res)
         (step*o res out))))))



;; version of step*o that traces (in reverse order!) all the
;; individual steps taken during a derivation; alternatively, could
;; use a meta-interpreter for step*o
(define step*-traceo
  (lambda (in out trace)
    (letrec ((step*-traceo
              (lambda (in out trace-in trace-out)
                (conde
                  ((== in out)
                   (== trace-in trace-out))
                  ((fresh (res)
                     (=/= in res)
                     (stepo in res)
                     (step*-traceo res out `(,res <= . ,trace-in) trace-out)))))))
      (step*-traceo in out `(,in) trace))))

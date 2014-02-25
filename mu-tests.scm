(load "mu.scm")
(load "test-check.scm")


;; MI to MIU.
(test "step*o-1"
  (run 1 (q) (step*o '(M I) '(M I U)))
  '(_.0))

;; MIU to MIUIU.
(test "step*o-2"
  (run 1 (q) (step*o '(M I U) '(M I U I U)))
  '(_.0))

;; MUIIIU to MUUU.
(test "step*o-3"
  (run 1 (q) (step*o '(M U I I I U) '(M U U U)))
  '(_.0))

;; MUUU to MU.
(test "step*o-4"
  (run 1 (q) (step*o '(M U U U) '(M U)))
  '(_.0))



;; MI to ???
(test "step*o-5"
  (run 10 (q) (step*o '(M I) q))
  '((M I)
    (M I I)
    (M I I I I)
    (M I U)
    (M I U I U)
    (M I I U)
    (M I I I I I I I I)
    (M I U I U I U I U)
    (M I I U I I U)
    (M I U I U I U I U I U I U I U I U)))

;; ??? to MIU
(test "step*o-6"
  (run 6 (q) (step*o q '(M I U)))
  '((M I U)
    (U U M I U)
    (M I I)
    (M I)
    (I I I U M I U)
    (M I)))




;; MI to MIUIU.
;;
;; MI -> MIU -> MIUIU
(test "step*-traceo-1"
  (run 1 (q) (step*-traceo '(M I) '(M I U I U) q))
  '(((M I U I U) <= (M I U) <= (M I))))

(test "step*-traceo-2"
  (run 10 (q)
    (fresh (start end trace)
      (step*-traceo start end trace)
      (== `(,start ,end ,trace) q)))
  '((_.0 _.0
    (_.0))
    ((M _.0) (M _.0 _.0)
     ((M _.0 _.0) <= (M _.0)))
    ((M _.0 _.1) (M _.0 _.1 _.0 _.1)
     ((M _.0 _.1 _.0 _.1) <= (M _.0 _.1)))
    ((I) (I U)
     ((I U) <= (I)))
    ((M _.0) (M _.0 _.0 _.0 _.0)
     ((M _.0 _.0 _.0 _.0) <= (M _.0 _.0) <= (M _.0)))
    ((M _.0 _.1 _.2) (M _.0 _.1 _.2 _.0 _.1 _.2)
     ((M _.0 _.1 _.2 _.0 _.1 _.2) <= (M _.0 _.1 _.2)))
    ((M _.0 _.1) (M _.0 _.1 _.0 _.1 _.0 _.1 _.0 _.1)
     ((M _.0 _.1 _.0 _.1 _.0 _.1 _.0 _.1) <= (M _.0 _.1 _.0 _.1) <= (M _.0 _.1)))
    ((M I) (M I I U)
     ((M I I U) <= (M I I) <= (M I)))
    ((M _.0) (M _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0)
     ((M _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0) <= (M _.0 _.0 _.0 _.0) <= (M _.0 _.0) <= (M _.0)))
    ((M _.0 _.1 _.2 _.3) (M _.0 _.1 _.2 _.3 _.0 _.1 _.2 _.3)
     ((M _.0 _.1 _.2 _.3 _.0 _.1 _.2 _.3) <= (M _.0 _.1 _.2 _.3)))))



;; The actual puzzle:
;;
;; is it possible to transition from MI to MU
;;
;; Since there is no solution, this run expression diverges! (And is
;; therefore commented out)
;;
#;(test "step*o-MU-puzzle"
    (run 1 (q) (step*o '(M I) '(M U)))
    '(_.0))

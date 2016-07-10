;;; test-scheme.scm
;;; Mac Radigan

  (import (scheme base))

  (define (foo1 bar) bar)
  (foo1 101)

  (define (foo2 bar) (display bar))
  (foo2 102)

;;; *EOF*

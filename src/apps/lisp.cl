;; clisp
;; Mac Radigan

; (require 'asdf)
; (asdf:operate 'asdf:load-op 'swank-client)
  (ql:quickload :swank-client)
  (use-package :sb-thread)

  (defun swank-server () 
    (swank-loader:init)
    (swank:create-server :port 4005 :dont-close t)
  )

  (defun repl () 
    (format t "~a" ">< ")
    (finish-output *standard-output*)
    (loop (let ( (result (eval (read))) ) 
      (format t "~a~%>< " result)
      (finish-output *standard-output*)
    ))
  )

  (defun main () 
    (make-thread 'swank-server)
    (repl)
  )

;; *EOF*

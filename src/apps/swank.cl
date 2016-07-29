;; swank
;; Mac Radigan

; (require 'asdf)
; (asdf:operate 'asdf:load-op 'swank-client)
  (ql:quickload :swank-client)

  (defun swank-client () 
    (defvar *myswank* (swank-client:slime-connect "127.0.0.1" 4005))
    (format t "type (hup) to quit~%")
    (format t "~a" ">< ")
    (finish-output *standard-output*)
    (loop 
      (let ((line (read)))
        (cond 
          ( (not (equalp line "(hup)"))
            (unwind-protect (restart-case (progn
              (let ( (result (swank-client:slime-eval line *myswank*)) )
                (progn
                  (format t "~a~%>< " result)
                  (finish-output *standard-output*)
                )
              )
            ))) ; protect
          ) ; "hup"
          (t 
            (progn
              (format t "~a~%" "exiting")
              (finish-output *standard-output*)
              (SB-EXT:QUIT)
            ) ; progn
          ) ; t
        ) ; if
      ) ; let
    ) ; loop
  ) ; repl

  (defun main () 
    (swank-client)
  )

;; *EOF*

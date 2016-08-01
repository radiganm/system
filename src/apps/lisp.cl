;; clisp
;; Copyright 2016 Mac Radigan
;; All Rights Reserved

  (asdf:load-system :swank-client)
  (asdf:oos 'asdf:load-op 'unix-options)
  (use-package 'unix-options)
  (use-package :sb-thread)

  (defun cd (path) (sb-posix:chdir path))
  (defun pwd () (sb-posix:getcwd))
  (defun exec (cmd args) (sb-ext:run-program cmd args :output t))

  (defun swank-server (port) 
    (swank-loader:init)
    (swank:create-server :port port :dont-close t)
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
    (make-thread 'swank-server :arguments '4005)
    (repl)
  )
  
;; *EOF*

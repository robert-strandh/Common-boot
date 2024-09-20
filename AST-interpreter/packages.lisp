(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-ast-interpreter
  (:use #:common-lisp)
  (:local-nicknames (#:ico #:iconoclast)
                    (#:iat #:iconoclast-ast-transformations)
                    (#:iaw #:iconoclast-ast-walker)
                    (#:clo #:clostrum)
                    (#:cb #:common-boot)
                    (#:cm #:common-macros))
  (:shadow #:boundp
           #:symbol-value)
  (:export #:eval-expression
           #:compile-ast
           #:client
           #:boundp
           #:symbol-value
           #:origin
           #:stack-entry
           #:called-function
           #:arguments
           #:*stack*))

(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-fast-ast-evaluator
  (:use #:common-lisp)
  (:local-nicknames (#:ico #:iconoclast)
                    (#:iat #:iconoclast-ast-transformations)
                    (#:clo #:clostrum)
                    (#:cm #:common-macros))
  (:shadow #:boundp
           #:symbol-value)
  (:export #:eval-expression
           #:compile-ast
           #:boundp
           #:symbol-value
           #:origin
           #:stack-entry
           #:called-function
           #:arguments
           #:*stack*))

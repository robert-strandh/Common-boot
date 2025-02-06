(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-fast-ast-evaluator
  (:use #:common-lisp)
  (:local-nicknames (#:ico #:iconoclast)
                    (#:iat #:iconoclast-ast-transformations)
                    (#:iaw #:iconoclast-ast-walker)
                    (#:clo #:clostrum)
                    (#:cb #:common-boot)
                    (#:cm #:common-macros))
  (:shadow #:boundp
           #:symbol-value
           #:function)
  (:export #:client
           #:eval-expression
           #:compile-ast
           #:boundp
           #:symbol-value
           #:ast-to-host-form))

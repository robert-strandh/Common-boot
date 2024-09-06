(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-fast-ast-evaluator
  (:use #:common-lisp)
  (:local-nicknames (#:ico #:iconoclast)
                    (#:iat #:iconoclast-ast-transformations)
                    (#:clo #:clostrum)
                    (#:cm #:common-macros)
                    (#:cb #:common-boot))
  (:shadow #:boundp
           #:symbol-value)
  (:export #:eval-expression))
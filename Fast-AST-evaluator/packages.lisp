(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-fast-ast-evaluator
  (:use #:common-lisp)
  (:local-nicknames (#:ico #:iconoclast)
                    (#:cm #:common-macros)
                    (#:cb #:common-boot))
  (:shadow #:boundp
           #:symbol-value)
  (:export))

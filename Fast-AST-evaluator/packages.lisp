(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-fast-ast-evaluator
  (:use #:common-lisp)
  (:local-nicknames (#:ico #:iconoclast))
  (:shadow #:boundp
           #:symbol-value)
  (:export))

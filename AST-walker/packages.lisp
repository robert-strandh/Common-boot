(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-ast-walker
  (:use #:common-lisp)
  (:export #:walk-ast)
  (:export #:walk-ast-node))

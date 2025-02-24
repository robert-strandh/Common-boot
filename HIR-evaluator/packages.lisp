(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-hir-evaluator
  (:use #:common-lisp)
  (:shadow #:symbol-value)
  (:local-nicknames (#:hir #:common-boot-hir)
                    (#:cb #:common-boot)
                    (#:cbah #:common-boot-ast-to-hir))
  (:export #:client))

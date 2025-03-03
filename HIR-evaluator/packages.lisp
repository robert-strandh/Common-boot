(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-hir-evaluator
  (:use #:common-lisp)
  (:shadow #:symbol-value)
  (:local-nicknames (#:hir #:common-boot-hir)
                    (#:cb #:common-boot)
                    (#:ico #:iconoclast)
                    (#:cbah #:common-boot-ast-to-hir))
  (:export #:client))

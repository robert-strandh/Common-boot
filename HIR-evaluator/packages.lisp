(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-hir-evaluator
  (:use #:common-lisp)
  (:local-nicknames (#:hir #:common-boot-hir)
                    (#:cb #:common-boot)
                    (#:ico #:iconoclast)
                    (#:cbah #:common-boot-ast-to-hir))
  (:shadow #:symbol-value
           #:boundp)
  (:export #:client
           #:compile-ast
           #:symbol-value
           #:boundp
           #:closure
           #:*call-stack*
           #:call-stack-entry
           #:origin
           #:arguments
           #:called-function))

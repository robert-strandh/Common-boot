(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-hir-evaluator-test
  (:use #:common-lisp #:parachute)
  (:local-nicknames (#:cbhe #:common-boot-hir-evaluator)
                    (#:cmd #:common-macro-definitions)
                    (#:cb #:common-boot)))

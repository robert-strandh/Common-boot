(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-fast-ast-evaluator-test
  (:use #:common-lisp)
  (:local-nicknames (#:cbfe #:common-boot-fast-ast-evaluator)
                    (#:cmd #:common-macro-definitions)
                    (#:cb #:common-boot)))

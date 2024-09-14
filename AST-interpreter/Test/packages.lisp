(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-ast-interpreter-test
  (:use #:common-lisp #:parachute)
  (:local-nicknames (#:cbfe #:common-boot-fast-ast-evaluator)
                    (#:cmd #:common-macro-definitions)
                    (#:cb #:common-boot)))

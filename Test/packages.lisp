(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-test
  (:use #:common-lisp #:parachute)
  (:local-nicknames (#:cb #:common-boot)
                    (#:cmd #:common-macro-definitions)
                    (#:cbae #:common-boot-ast-evaluator)))


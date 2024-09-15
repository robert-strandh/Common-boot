(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-ast-interpreter-test
  (:use #:common-lisp #:parachute)
  (:local-nicknames (#:cbai #:common-boot-ast-interpreter)
                    (#:cmd #:common-macro-definitions)
                    (#:cb #:common-boot)))

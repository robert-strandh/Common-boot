(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-ast-transformations-test
  (:use #:common-lisp #:parachute)
  (:local-nicknames (#:ico #:iconoclast)
                    (#:bld #:iconoclast-builder)
                    (#:abp #:architecture.builder-protocol)
                    (#:ses #:s-expression-syntax)
                    (#:cmd #:common-macro-definitions)
                    (#:cb #:common-boot)
                    (#:cbat #:common-boot-ast-transformations))
  (:export #:test))

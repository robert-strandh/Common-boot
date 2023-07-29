(cl:in-package #:common-lisp-user)

(defpackage #:common-boot
  (:use #:common-lisp)
  (:local-nicknames (#:clb #:clostrum-basic)
                    (#:clo #:clostrum)
                    (#:ico #:iconoclast)
                    (#:bld #:iconoclast-builder)
                    (#:cmd #:common-macro-definitions)
                    (#:ses #:s-expression-syntax)
                    (#:abp #:architecture.builder-protocol)
                    (#:cst #:concrete-syntax-tree))
  (:export #:create-environment
           #:cst-to-ast))

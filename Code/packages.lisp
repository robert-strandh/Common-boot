(cl:in-package #:common-lisp-user)

(defpackage #:common-boot
  (:use #:common-lisp)
  (:local-nicknames (#:clb #:clostrum-basic)
                    (#:clo #:clostrum)
                    (#:ico #:iconoclast)
                    (#:bld #:iconoclast-builder)
                    (#:cm #:common-macros)
                    (#:cmd #:common-macro-definitions)
                    (#:ses #:s-expression-syntax)
                    (#:abp #:architecture.builder-protocol)
                    (#:cst #:concrete-syntax-tree)
                    (#:cbae #:common-boot-ast-evaluator))
  (:export #:client
           #:macro-preserving-client
           #:macro-expanding-client
           #:macro-function-client
           #:macro-transforming-client
   #:create-environment
           #:eval-expression
           #:cst-to-ast))

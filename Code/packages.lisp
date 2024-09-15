(cl:in-package #:common-lisp-user)

(defpackage #:common-boot
  (:use #:common-lisp)
  (:local-nicknames (#:clb #:clostrum-basic)
                    (#:clo #:clostrum)
                    (#:ico #:iconoclast)
                    (#:bld #:iconoclast-builder)
                    (#:iat #:iconoclast-ast-transformations)
                    (#:cm #:common-macros)
                    (#:cmd #:common-macro-definitions)
                    (#:ses #:s-expression-syntax)
                    (#:abp #:architecture.builder-protocol)
                    (#:cst #:concrete-syntax-tree)
                    (#:cbae #:common-boot-fast-ast-evaluator))
  (:export #:client
           #:environment
           #:macro-preserving-client
           #:macro-expanding-client
           #:macro-function-client
           #:macro-transforming-client
           #:create-environment
           #:eval-cst
           #:eval-expression
           #:cst-to-ast
           #:convert-with-parser-p
           #:convert-with-ordinary-macro-p
           #:no-function-description
           #:name))

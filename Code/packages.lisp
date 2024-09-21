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
                    (#:cst #:concrete-syntax-tree))
  (:export #:client
           #:environment
           #:macro-preserving-client
           #:macro-expanding-client
           #:macro-function-client
           #:macro-transforming-client
           #:create-environment
           #:eval-cst
           #:compile-local-macro-function-ast
           #:eval-expression
           #:cst-to-ast
           #:convert-with-parser-p
           #:convert-with-ordinary-macro-p
           #:no-function-description
           #:make-builder
           #:name
           #:*stack*
           #:stack-entry
           #:origin
           #:called-function
           #:arguments))

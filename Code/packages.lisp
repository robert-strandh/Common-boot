(cl:in-package #:common-lisp-user)

(defpackage #:common-boot
  (:use #:common-lisp)
  (:local-nicknames (#:clb #:clostrum-basic)
                    (#:clo #:clostrum)
                    (#:ico #:iconoclast)
                    (#:bld #:iconoclast-builder)
                    (#:cmd #:common-macro-definitions))
  (:export #:create-environment))

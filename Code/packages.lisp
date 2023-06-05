(cl:in-package #:common-lisp-user)

(defpackage #:common-boot
  (:use #:common-lisp)
  (:local-nicknames (#:clb #:clostrum-basic)
                    (#:clo #:clostrum)
                    (#:cmd #:common-macro-definitions)))

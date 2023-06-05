(cl:in-package #:common-lisp-user)

(defpackage #:common-boot
  (:use #:common-lisp)
  (:local-nicknames (#:clo #:clostrum)
                    (#:cmd #:common-macros)))

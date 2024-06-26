(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-closure-conversion
  (:use #:common-lisp)
  (:local-nicknames (#:ico #:iconoclast)
                    (#:iaw #:iconoclast-ast-walker))
  (:export #:create-function-tree))

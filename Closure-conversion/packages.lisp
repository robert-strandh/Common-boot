(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-closure-conversion
  (:use #:common-lisp)
  (:local-nicknames (#:ico #:iconoclast)
                    (#:iaw #:iconoclast-ast-walker))
  (:export #:let-temporary-ast
           #:make-cell-ast
           #:read-cell-ast
           #:write-cell-ast
           #:create-function-tree))

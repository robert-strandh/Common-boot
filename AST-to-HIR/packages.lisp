(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-ast-to-hir
  (:use #:common-lisp)
  (:local-nicknames (#:ico #:iconoclast)
                    (#:hir #:common-boot-hir)
                    (#:iat #:iconoclast-ast-transformations))
  (:export #:ast-to-hir))

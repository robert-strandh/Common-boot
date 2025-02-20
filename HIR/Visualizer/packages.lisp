(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-hir-visualizer
  (:use #:common-lisp)
  (:local-nicknames (#:ir #:common-boot-hir))
  (:export #:visualize))

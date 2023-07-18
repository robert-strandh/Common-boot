(cl:in-package #:common-boot)

(defun cst-to-ast (client cst environment)
  (let ((*subforms-are-top-level-p* t)
        (*compile-time-too* nil)
        (s-expression-syntax.expression-grammar:*client*
          s-expression-syntax.concrete-syntax-tree::*client*))
    (convert client cst environment)))

(defclass client (trucler-reference:client)
  ())

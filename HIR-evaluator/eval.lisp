(cl:in-package #:common-boot-hir-evaluator)

(defvar *environment*)

(defmethod cb:eval-cst ((client client) cst environment)
  (let* ((ast (cb:cst-to-ast client cst environment))
         (hir (cbah:ast-to-hir client ast))
         (*environment* (trucler:global-environment client environment))
         (function (top-level-hir-to-host-function client hir)))
    (funcall function)))

(defun compile-ast (client ast environment)
  (let* ((hir (cbah:ast-to-hir client ast))
         (*environment* (trucler:global-environment client environment))
         (function (top-level-hir-to-host-function client hir)))
    (funcall function)))

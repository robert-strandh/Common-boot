(cl:in-package #:common-boot-hir-evaluator)

(defvar *environment*)

(defmethod cb:eval-cst ((client client) cst environment)
  (let* ((ast (cb:cst-to-ast client cst environment))
         (hir (cbah:ast-to-hir client ast))
         (*environment* (trucler:global-environment client environment))
         (function (top-level-hir-to-host-function client hir)))
    (hir:check-hir hir)
    (funcall function)))

(defun compile-ast (client ast environment)
  (let* ((hir (cbah:ast-to-hir client ast))
         (*environment* (trucler:global-environment client environment))
         (function (top-level-hir-to-host-function client hir)))
    (funcall function)))

(defmethod cb:compile-local-macro-function-ast
    ((client client) local-function-ast environment)
  (let* ((function-definition-ast
           (ico:name-ast local-function-ast))
         (function-reference-ast
           (make-instance 'ico:function-reference-ast
             :name (ico:name function-definition-ast)
             :definition-ast function-definition-ast))
         (function-ast
           (make-instance 'ico:function-ast
             :name-ast function-reference-ast))
         (labels-ast
           (make-instance 'ico:labels-ast
             :binding-asts (list local-function-ast)
             :form-asts (list function-ast))))
    (reinitialize-instance function-definition-ast
      :reference-asts (list function-reference-ast))
    (let* ((hir (cbah:ast-to-hir client labels-ast))
           (*environment* (trucler:global-environment client environment))
           (function (top-level-hir-to-host-function client hir)))
      function)))

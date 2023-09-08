(cl:in-package #:common-boot)

;;; This method is applicable if the AST we are given has already been
;;; converted, so nothing needs to be done.
(defmethod convert-ast (builder ast)
  (declare (ignorable builder))
  ast)

(defmethod convert-ast (builder (ast ico:unparsed-form-ast))
  (with-builder-components (builder client environment)
    (convert client (ico:form ast) environment)))

(defmethod convert-ast-in-environment
    (client (ast ico:unparsed-form-ast) environment)
  (convert client (ico:form ast) environment))

;;; This method is applicable when we receive an AST that has already
;;; been converted.
(defmethod convert-ast-in-environment (client ast environment)
  ast)

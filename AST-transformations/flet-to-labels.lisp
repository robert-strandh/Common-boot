(cl:in-package #:common-boot-ast-transformations)

;;;; This function turns an AST representing an FLET form into an AST
;;;; representing a LABELS form.  We can do that with no addtional
;;;; work because all the references to functions have already been
;;;; resolved in the FLET AST, so no capture is possible.

(defmethod cbaw:walk-ast-node :around
    ((client client) (ast ico:flet-ast))
  ;; Start by converting any children of this AST node.
  (call-next-method)
  (change-class ast 'ico:labels-ast))

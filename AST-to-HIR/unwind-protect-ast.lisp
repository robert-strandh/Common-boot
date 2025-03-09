(cl:in-package #:common-boot-ast-to-hir)

;;; FIXME: this is not doing the right thing of course.

(defmethod translate-ast (client (ast ico:unwind-protect-ast))
  (let* ((*next-instruction*
           (translate-implicit-progn client (ico:form-asts ast))))
    (translate-ast client (ico:protected-form-ast ast))))

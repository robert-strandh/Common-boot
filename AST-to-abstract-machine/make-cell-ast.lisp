(cl:in-package #:common-boot-ast-to-abstract-machine)

(defmethod translate-ast (client context (ast ico:make-cell-ast))
  (with-context-components (context)
    (assert (eql values-count 1))
    (let ((form-ast (ico:form-ast ast)))
      (with-new-register (nil register)
        (let ((new-context
                (make-context 
                 (cons `(make-cell ,target-register ,register)
                       next-instructions)
                 1 register)))
          (translate-ast client new-context form-ast))))))

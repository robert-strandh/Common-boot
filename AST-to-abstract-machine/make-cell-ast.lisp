(cl:in-package #:common-boot-ast-to-abstract-machine)

(defmethod translate-ast (client context (ast ico:make-cell-ast))
  (let ((target-register (target-register context))
        (next-instructions (next-instructions context))
        (values-count (values-count context))
        (form-ast (ico:form-ast ast)))
    (assert (eql values-count 1))
    (with-new-register (nil register)
      (let ((new-context
              (make-context 
               (cons `(make-cell ,target-register ,register)
                     next-instructions)
               1 register)))
        (translate-ast client new-context form-ast)))))

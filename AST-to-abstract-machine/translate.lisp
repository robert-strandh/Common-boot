(cl:in-package #:common-boot-ast-to-abstract-machine)

(defgeneric translate-ast (client context ast))

(defun translate (client ast)
  (let* ((*register-numbers* (make-hash-table :test #'eq))
         (*next-register-number* 0)
         (*dynamic-environment-register* (new-register))
         (target-register (new-register))
         (context (make-instance 'context
                    :next-instruction `(return ,target-register)
                    :values-count :all
                    :target-register target-register)))
    (translate-ast client context ast)))

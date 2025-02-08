(cl:in-package #:common-boot-ast-to-abstract-machine)

(defgeneric translate-ast (client context ast))

(defun translate (client ast)
  (let ((*register-numbers* (make-hash-table :test #'eq))
        (*next-register-number* 0)
        (context (make-instance 'context
                   :next-instruction '(return)
                   :values-count :all)))
    (translate-ast client context ast)))

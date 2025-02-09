(cl:in-package #:common-boot-ast-to-abstract-machine)

(defgeneric translate-ast (client context ast))

(defun translate (client ast)
  (let ((*register-numbers* '((nil . 0)))
        (*dynamic-environment-register* 0))
    (with-new-register (nil target-register)
      (let ((context
              (make-context
               `((return ,target-register)) :all target-register)))
        (translate-ast client context ast)))))


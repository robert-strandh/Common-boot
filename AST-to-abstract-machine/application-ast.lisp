(cl:in-package #:common-boot-ast-to-abstract-machine)

(defun application-aux (client context asts registers)
  (loop with result = (cons `(funcall ,@registers)
                            (next-instructions context))
        for ast in (reverse asts)
        for register in (reverse registers)
        for new-context = (make-context result 1 register)
        do (setf result
                 (translate-ast client new-context ast))
        finally (return result)))

(defmethod translate-ast (client context (ast ico:application-ast))
  (let* ((function-name-ast (ico:function-name-ast ast))
         (argument-asts (ico:argument-asts ast))
         (register-count (1+ (length argument-asts)))
         (identities (make-list register-count)))
    (with-new-registers (identities registers)
      (application-aux
       client
       context
       (cons function-name-ast argument-asts)
       registers))))

(cl:in-package #:common-boot-ast-to-abstract-machine)

(defmethod translate-ast (client context (ast ico:variable-reference-ast))
  (let ((target-register (target-register context))
        (next-instructions (next-instructions context))
        (values-count (values-count context))
        (register (find-register ast)))
    (ecase values-count
      (0 next-instructions)
      (1 (cons `(assign ,target-register ,register)
               next-instructions))
      (:all (cons `(assign-list ,target-register ,register)
                  next-instructions)))))

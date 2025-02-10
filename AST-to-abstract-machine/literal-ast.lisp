(cl:in-package #:common-boot-ast-to-abstract-machine)

(defmethod translate-ast (client context (ast ico:literal-ast))
  (let ((target-register (target-register context))
        (next-instructions (next-instructions context))
        (values-count (values-count context))
        (literal (ico:literal ast)))
    (ecase values-count
      (0 next-instructions)
      (1 (cons `(literal ,target-register ,literal)
               next-instructions))
      (:all (cons `(literal-list ,target-register ,literal)
                  next-instructions)))))

(cl:in-package #:common-boot-ast-to-abstract-machine)

(defmethod translate-ast (client context (ast ico:literal-ast))
  (with-context-components (context)
    (let ((literal (ico:literal ast)))
      (ecase values-count
        (0 next-instructions)
        (1 (cons `(literal ,target-register ,literal)
                 next-instructions))
        (:all (cons `(literal-list ,target-register ,literal)
                    next-instructions))))))

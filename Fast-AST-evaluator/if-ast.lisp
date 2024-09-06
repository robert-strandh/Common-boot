(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:if-ast))
  (let ((else-ast (ico:else-ast ast)))
    `(if ,(translate-ast client environment (ico:test-ast ast))
         ,(translate-ast client environment (ico:then-ast ast))
         ,@(if (null else-ast)
               '()
               (list (translate-ast client environment else-ast))))))

(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:if-ast))
  (let ((else-ast (ico:else-ast ast)))
    `(if ,(translate-ast client (ico:test-ast ast))
         ,(translate-ast client (ico:then-ast ast))
         ,(if (null else-ast)
              nil
              (translate-ast client else-ast)))))

(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:if-ast))
  (if (interpret-ast client environment (ico:test-ast ast))
      (interpret-ast client environment (ico:then-ast ast))
      (if (null (ico:else-ast ast))
          nil
          (interpret-ast client environment (ico:else-ast ast)))))

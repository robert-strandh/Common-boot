(cl:in-package #:common-boot-ast-to-abstract-machine)

(defmethod translate-ast (client context (ast ico:if-ast))
  (let* ((test-ast (ico:test-ast ast))
         (then-ast (ico:then-ast ast))
         (else-ast (ico:else-ast ast))
         (target-register (target-register context))
         (values-count (values-count context))
         (next-instructions (next-instructions context)))
    (with-new-register (nil test-register)
      (if (null else-ast)
          (let* ((then-code (translate-ast client context then-ast))
                 (test-context
                   (make-context
                    (cons `(jump-nil ,next-instructions) then-code)
                    1 test-register)))
            (translate-ast client test-context test-ast))
          (let* ((else-code
                   (translate-ast client context else-ast))
                 (then-context
                   (make-context
                    (cons `(jump ,next-instructions) else-code)
                    values-count
                    target-register))
                 (then-code
                   (translate-ast client then-context then-ast))
                 (test-context
                   (make-context (cons `(jump-nil ,else-code) then-code)
                                 1 test-register)))
            (translate-ast client test-context test-ast))))))

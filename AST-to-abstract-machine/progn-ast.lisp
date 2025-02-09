(cl:in-package #:common-boot-ast-to-abstract-machine)

(defun translate-implicit-progn (client context asts)
  ;; We might handle empty PROGNs later.
  (assert (not (null asts)))
  (if (null (rest asts))
      (translate-ast client context (first asts))
      (let* ((next-instructions
               (translate-implicit-progn client context (rest asts)))
             (new-context
               (make-context next-instructions 0 nil)))
        (translate-ast client new-context (first asts)))))

(defmethod translate-ast (client context (ast ico:progn-ast))
  (translate-implicit-progn client context (ico:form-asts ast)))

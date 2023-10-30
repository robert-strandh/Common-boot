(cl:in-package #:common-boot-ast-transformations-test)

(defclass client (cb:macro-transforming-client)
  ())

(defun parse-lexify-and-unparse (function-form)
  (let* ((cst (cst:cst-from-expression function-form))
         (environment (cb:create-environment))
         (client (make-instance 'client))
         (cmd:*client* client)
         (ast (cb:cst-to-ast client cst environment))
         (builder (make-instance 'bld:builder)))
    (ses:unparse builder t ast)))

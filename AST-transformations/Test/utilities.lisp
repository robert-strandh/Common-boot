(cl:in-package #:common-boot-ast-transformations-test)

(defclass client (cb:macro-transforming-client)
  ())

(defun parse-lexify-and-unparse (lambda-application)
  (let* ((cst (cst:cst-from-expression lambda-application))
         (environment (cb:create-environment))
         (client (make-instance 'client))
         (cmd:*client* client)
         (ast (cb:cst-to-ast client cst environment))
         (builder (make-instance 'bld:builder))
         (transformed-ast (cbat:lexify-lambda-list ast)))
    (ses:unparse builder t transformed-ast)))

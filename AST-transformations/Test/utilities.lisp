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

(defun forms-similar-p (form1 form2)
  (let ((table (make-hash-table :test #'eq)))
    (labels ((aux (form1 form2)
               (cond ((and (symbolp form1) (null (symbol-package form1))
                           (symbolp form2) (null (symbol-package form2)))
                      (let ((other (gethash form1 table)))
                        (if (null other)
                            (progn (setf (gethash form1 table) form2) t)
                            (eq form2 other))))
                     ((and (atom form1) (atom form2))
                      (eql form1 form2))
                     ((and (consp form1) (consp form2))
                      (and (aux (car form1) (car form2))
                           (aux (cdr form1) (cdr form2))))
                     (t nil))))
      (aux form1 form2))))

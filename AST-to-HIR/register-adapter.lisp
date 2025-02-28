(cl:in-package #:common-boot-ast-to-hir)

(defun adapt-register (register-type)
  (cond ((typep *target-register* register-type)
         (values *next-instruction* *target-register*))
        ((null *target-register*)
         (values *next-instruction* (make-instance register-type)))
        (t
         (let ((new-register (make-instance register-type)))
           (values (make-instance 'hir:assignment-instruction
                     :inputs (list new-register)
                     :outputs (list *target-register*)
                     :successors (list *next-instruction*))
                   new-register)))))

(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:application-ast))
  (let* ((function-name-ast (ico:function-name-ast ast))
         (argument-asts (ico:argument-asts ast))
         (registers
           (loop repeat (1+ (length argument-asts))
                 collect (make-instance 'hir:single-value-register))))
    (multiple-value-bind (*next-instruction* *target-register*)
        (adapt-register 'hir:multiple-value-register)
      (let ((result
              (make-instance 'hir:funcall-instruction
                :origin (ico:origin ast)
                :inputs (cons *dynamic-environment-register* registers)
                :outputs (list *target-register*)
                :successors (list *next-instruction*))))
        (loop for ast in (reverse (cons function-name-ast argument-asts))
              for register in (reverse registers)
              do (let ((*next-instruction* result)
                       (*target-register* register))
                   (setf result
                         (translate-ast client ast))))
        result))))

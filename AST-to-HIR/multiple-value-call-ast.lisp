(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:multiple-value-call-ast))
  (let* ((function-ast (ico:function-ast ast))
         (argument-asts (ico:form-asts ast))
         (function-register (make-instance 'hir:single-value-register))
         (argument-registers
           (loop repeat (length argument-asts)
                 collect (make-instance 'hir:multiple-value-register))))
    (multiple-value-bind (*next-instruction* *target-register*)
        (adapt-register 'hir:multiple-value-register)
      (let ((result
              (make-instance 'hir:multiple-value-call-instruction
                :origin (ico:origin ast)
                :inputs (list* *dynamic-environment-register*
                                function-register
                                argument-registers)
                :outputs (list *target-register*)
                :successors (list *next-instruction*))))
        (loop for ast in (reverse argument-asts)
              for argument-register in (reverse argument-registers)
              do (let ((*next-instruction* result)
                       (*target-register* argument-register))
                   (setf result
                         (translate-ast client ast))))
        (let ((*next-instruction* result)
              (*target-register* function-register))
          (translate-ast client function-ast))))))

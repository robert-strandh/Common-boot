(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:set-static-environment-ast))
  (let* ((function-reference-ast (ico:function-reference-ast ast))
         (form-asts (ico:form-asts ast))
         (registers
           (loop repeat (1+ (length form-asts))
                 collect (make-instance 'hir:single-value-register))))
    (let ((*next-instruction*
            (make-instance 'hir:set-static-environment-instruction
              :origin (ico:origin ast)
              :inputs registers
              :successors (list *next-instruction*))))
      (loop with asts = (cons function-reference-ast form-asts)
            for ast in (reverse asts)
            for register in (reverse registers)
            do (let ((*target-register* register))
                 (setf *next-instruction*
                       (translate-ast client ast))))
      *next-instruction*)))

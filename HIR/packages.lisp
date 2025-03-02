(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-hir
  (:use #:common-lisp)
  (:export
   #:instruction
   #:inputs
   #:outputs
   #:predecessors
   #:successors
   #:parse-arguments-instruction
   #:lambda-list
   #:static-environment-register
   #:dynamic-environment-register
   #:nop-instruction
   #:make-cell-instruction
   #:read-cell-instruction
   #:write-cell-instruction
   #:set-static-environment-instruction
   #:dynamic-environment-instruction
   #:read-static-environment-instruction
   #:if-instruction
   #:exit-point-instruction
   #:unwind-instruction
   #:receive-instruction
   #:funcall-instruction
   #:multiple-value-call-instruction
   #:return-instruction
   #:assignment-instruction
   #:special-variable-binding-instruction
   #:global-function-reference-instruction
   #:function-name
   #:progv-instruction
   #:special-variable-reference-instruction
   #:special-variable-setq-instruction
   #:variable-name
   #:enclose-instruction
   #:catch-instruction
   #:throw-instruction
   #:datum
   #:register
   #:name
   #:readers
   #:writers
   #:value
   #:single-value-register
   #:multiple-value-register
   #:literal))

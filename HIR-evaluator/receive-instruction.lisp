(cl:in-package #:common-boot-hir-evaluator)

(defmethod instruction-thunk
    (client
     (instruction hir:receive-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 0 :outputs 1)
    (setf (output 0) *unwind-values*)
    (successor 0)))

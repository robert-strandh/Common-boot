(cl:in-package #:common-boot-hir-evaluator)

(defmethod instruction-thunk
    (client
     (instruction hir:read-static-environment-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 2 :outputs 1)
    (setf (output 0) (svref (input 0) (input 1)))
    (successor 0)))

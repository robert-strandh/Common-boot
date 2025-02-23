(cl:in-package #:common-boot-hir-evaluator)

(defmethod instruction-thunk
    (client
     (instruction hir:read-write-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 2 :outputs 0 :successors 1)
    (setf (car (input 0)) (input 1))))

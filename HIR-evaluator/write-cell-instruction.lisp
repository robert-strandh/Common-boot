(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:write-cell-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 2 :outputs 0 :successors 1)
    (setf (car (input 0)) (input 1))
    (successor 0)))

(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:nop-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 0 :outputs 0 :successors 1)
    (successor 0)))


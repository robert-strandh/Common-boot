(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:throw-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 3 :outputs 0 :successors 0)
    (throw-unwind (input 0) (input 1) (input 2))))

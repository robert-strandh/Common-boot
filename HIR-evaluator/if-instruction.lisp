(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:if-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 1 :successors 2)
    (if (null (input 0))
        (successor 1)
        (successor 0))))

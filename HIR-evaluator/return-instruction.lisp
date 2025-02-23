(cl:in-package #:common-boot-hir-evaluator)

(defmethod instruction-thunk
    (client
     (instruction hir:return-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 1 :successors 0)
    (throw 'return (apply #'values (input 0)))))

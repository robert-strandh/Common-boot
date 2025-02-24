(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:unwind-instruction)
     lexical-environment)
  (let ((input-count (length (hir:inputs instruction))))
    (if (= input-count 2)
        (make-thunk (client instruction lexical-environment
                     :inputs 2 :outputs 0 :successors 1)
          (unwind (successor 0) (input 0) (input 1)))
        (make-thunk (client instruction lexical-environment
                     :inputs 3 :outputs 0 :successors 1)
          (unwind (successor 0) (input 0) (input 1) (input 2))))))

(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:global-function-reference-instruction)
     lexical-environment)
  (let* ((function-name (hir:function-name instruction))
         (cell (clostrum:ensure-operator-cell
                client *environment* function-name)))
    (make-thunk (client instruction lexical-environment
                 :outputs 1 :successors 1)
      (setf (output 0) (car cell))
      (successor 0))))

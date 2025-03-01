(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:special-variable-setq-instruction)
     lexical-environment)
  (let* ((variable-name (hir:variable-name instruction))
         (cell (clostrum:ensure-variable-cell
                client *environment* variable-name)))
    (make-thunk (client instruction lexical-environment
                 :inputs 2 :outputs 0 :successors 1)
      (setf (symbol-value variable-name cell (input 0))
            (input 1))
      (successor 0))))

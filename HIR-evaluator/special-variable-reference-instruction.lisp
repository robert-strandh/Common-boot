(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
  (client
   (instruction hir:special-variable-reference-instruction)
   lexical-environment)
  (let* ((variable-name (hir:variable-name instruction))
         (cell (clostrum:ensure-variable-cell
                client *environment* variable-name)))
    (make-thunk (client instruction lexical-environment
                 :inputs 1 :outputs 1 :successors 1)
      (setf (output 0)
            (symbol-value variable-name cell (input 0)))
      (successor 0))))

(cl:in-package #:common-boot-hir-evaluator)

(defmethod instruction-thunk
    (client
     (instruction hir:special-variable-binding-instruction)
     lexical-environment)
  (if (= (length (hir:inputs instruction)) 2)
      (make-thunk (client instruction lexical-environment
                   :inputs 2 :outputs 1 :successors 1)
        (setf (output 0)
              (cons (make-instance 'special-variable-bind-entry
                      :name (input 1))
                    (input 0))))
      (make-thunk (client instruction lexical-environment
                   :inputs 3 :outputs 1 :successors 1)
        (setf (output 0)
              (cons (make-instance 'special-variable-bind-entry
                      :name (input 1)
                      :value (input 2))
                    (input 0))))))

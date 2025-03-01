(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:progv-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 3 :outputs 1 :successors 1)
    (let* ((existing-dynamic-environment (input 0))
           (new-dynamic-environment existing-dynamic-environment)
           (symbols (input 1))
           (values (input 2)))
      ;; Bind all variables that should be bound to a value.
      (loop for symbol in symbols
            for value in values
            do (push (make-instance 'special-variable-bind-entry
                       :name symbol
                       :value value)
                     new-dynamic-environment))
      ;; Bind all variable that should have no value.
      (loop for symbol in (nthcdr (length values) symbols)
            do (push (make-instance 'special-variable-bind-entry
                       :name symbol)
                     new-dynamic-environment))
      (setf (output 0) new-dynamic-environment)
    (successor 0))))
  

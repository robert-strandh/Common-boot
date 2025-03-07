(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:exit-point-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 1 :outputs 2 :successors 2)
    (let ((unique-identity (list nil)))
      (setf (output 0)
            (cons (make-instance 'exit-point-entry
                    :unwind-tag *unwind-tag*
                    :unique-identity unique-identity)
                  (input 0)))
      (setf (output 1) unique-identity))
    (successor 0)))

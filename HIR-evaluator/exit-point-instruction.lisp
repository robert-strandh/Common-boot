(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:exit-point-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 1 :outputs 2 :successors 1)
    (let ((unique-identity (list nil))
          (unwind-tag *unwind-tag*))
      (setf (output 0) unique-identity)
      (setf (output 1)
            (cons (make-instance 'exit-point-entry
                    :unwind-tag unwind-tag
                    :unique-identity unique-identity)
                  (input 0))))
    (successor 0)))

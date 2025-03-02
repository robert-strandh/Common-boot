(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:catch-instruction)
     lexical-environment)
  (let ((unwind-tag *unwind-tag*))
    (make-thunk (client instruction lexical-environment
                 :inputs 2 :outputs 1 :successors 2)
      (let* ((existing-dynamic-environment (input 0))
             (new-dynamic-environment existing-dynamic-environment)
             (catch-tag (input 1)))
        (push (make-instance 'catch-entry
                :catch-tag catch-tag
                :unwind-tag unwind-tag
                :successor (successor 1))
              new-dynamic-environment)
        (setf (output 0) new-dynamic-environment))
      (successor 0))))

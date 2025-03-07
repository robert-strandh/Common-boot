(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:enclose-instruction)
     lexical-environment)
  (let ((entry-point nil))
    (add-to-process
     (lambda ()
       (setf entry-point
             (parse-arguments-instruction-to-host-function
              client (hir:parse-arguments-instruction instruction)))))
    (make-thunk (client instruction lexical-environment
                 :inputs 0 :outputs 1)
      (setf (output 0)
            (enclose entry-point))
      (successor 0))))

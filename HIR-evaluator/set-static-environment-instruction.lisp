(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:set-static-environment-instruction)
     lexical-environment)
  (let* ((inputs (hir:inputs instruction))
         (closure-object-input (first inputs))
         (closure-object-lexical-location
           (ensure-lexical-reference
            closure-object-input lexical-environment))
         (static-environment-element-inputs (rest inputs))
         (static-environment-lexical-locations
           (loop for input in static-environment-element-inputs
                 collect (ensure-lexical-reference
                          input lexical-environment)))
         (static-environment-size
           (length static-environment-element-inputs))
         (successor-thunk #'dummy-successor)
         (thunk 
           (lambda (lexical-locations)
             (let ((static-environment (make-array static-environment-size)))
               (loop for lexical-location
                       in static-environment-lexical-locations
                     do (setf (svref static-environment lexical-location)
                              (lexical-value
                               lexical-locations lexical-location)))
               (setf (lexical-value
                      lexical-locations closure-object-lexical-location)
                     static-environment))
             successor-thunk)))
    (setf (gethash instruction *instruction-thunks*) thunk)
    (setf successor-thunk
          (ensure-thunk
           client (first (hir:successors instruction)) lexical-environment))
    thunk))

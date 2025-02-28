(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:multiple-value-call-instruction)
     lexical-environment)
  (let* ((inputs (hir:inputs instruction))
         (dynamic-environment-input (first inputs))
         (dynamic-environment-lexical-location
           (ensure-lexical-reference
            dynamic-environment-input lexical-environment))
         (function-input (second inputs))
         (function-lexical-location
           (ensure-lexical-reference function-input lexical-environment))
         (argument-inputs (rest (rest inputs)))
         (argument-lexical-locations
           (loop for input in argument-inputs
                 collect (ensure-lexical-reference
                          input lexical-environment)))
         (output (first (hir:outputs instruction)))
         (output-lexical-location
           (ensure-lexical-reference output lexical-environment))
         (successor-thunk #'dummy-successor)
         (thunk
           (lambda (lexical-locations)
             (flet ((lv (x)
                      (lexical-value lexical-locations x)))
               (setf (lexical-value
                      lexical-locations output-lexical-location)
                     (let ((*dynamic-environment*
                             (lv dynamic-environment-lexical-location)))
                       (multiple-value-list
                        (apply (lv function-lexical-location)
                               (loop for lc in argument-lexical-locations
                                     append (lv lc)))))))
             successor-thunk)))
    (setf (gethash instruction *instruction-thunks*) thunk)
    (setf successor-thunk
          (ensure-thunk
           client (first (hir:successors instruction)) lexical-environment))
    thunk))
            
                            

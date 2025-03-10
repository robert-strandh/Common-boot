(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:funcall-instruction)
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
         (origin (hir:origin instruction))
         (thunk
           (lambda (lexical-locations)
             (flet ((lv (x)
                      (lexical-value lexical-locations x)))
               (setf (lexical-value
                      lexical-locations output-lexical-location)
                     (let ((*dynamic-environment*
                             (lv dynamic-environment-lexical-location))
                           (function (lv function-lexical-location))
                           (arguments
                             (loop for lc in argument-lexical-locations
                                   collect (lv lc))))
                       (with-new-call-stack-entry
                           (make-instance 'cb:stack-entry
                             :origin origin
                             :called-function function
                             :arguments arguments)
                         (multiple-value-list
                          (apply function arguments))))))
             successor-thunk)))
    (setf (gethash instruction *instruction-thunks*) thunk)
    (setf successor-thunk
          (ensure-thunk
           client (first (hir:successors instruction)) lexical-environment))
    thunk))

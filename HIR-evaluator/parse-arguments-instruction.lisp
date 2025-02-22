(cl:in-package #:common-boot-hir-evaluator)

(defun host-lambda-list-from-register-lambda-list (register-lambda-list)
  (let ((host-lambda-list '())
        ;; Pairs of (<variable> . <register>).
        (pairs '())
        (remaining register-lambda-list))
    (tagbody
     maybe-required
       (when (null remaining)
         (go out))
       (let ((element (pop remaining)))
         (case element
           (&optional (go optional))
           (&rest (go rest))
           (&key (go key)))
         (let ((variable (gensym)))
           (push (cons variable element) pairs)
           (push variable host-lambda-list)))
       (go maybe-required)
     optional
       (push '&optional host-lambda-list)
     maybe-optional
       (when (null remaining)
         (go out))
       (let ((element (pop remaining)))
         (case element
           (&rest (go rest))
           (&key (go key)))
         (let ((parameter-variable (gensym))
               (supplied-p-variable (gensym)))
           (push (cons parameter-variable (first element)) pairs)
           (push (cons supplied-p-variable (second element)) pairs)
           (push `(,parameter-variable nil ,supplied-p-variable)
                 host-lambda-list)))
       (go maybe-optional)
     rest
       (push '&rest host-lambda-list)
       (let ((register (pop remaining))
             (variable (gensym)))
         (push (cons variable register) pairs)
         (push variable host-lambda-list))
       (when (null remaining)
         (go out))
       (let ((element (pop remaining)))
         (assert (eq element '&key))
         (go key))
     key
       (push '&key host-lambda-list)
     maybe-key
       (when (null remaining)
         (go out))
       (let ((element (pop remaining)))
         (when (eq element '&allow-other-keys)
           (push '&allow-other-keys host-lambda-list)
           (go out))
         (let ((parameter-variable (gensym))
               (supplied-p-variable (gensym)))
           (push (cons parameter-variable (second (first element))) pairs)
           (push (cons supplied-p-variable (second element)) pairs)
           (push `((,(first (first element)) ,parameter-variable)
                   nil ,supplied-p-variable)
                 host-lambda-list)))
       (go maybe-key)
     out)
    (values (reverse host-lambda-list) (reverse pairs))))

(defclass closure (closer-mop:funcallable-standard-object)
  ((%static-environment
    :initform nil
    :accessor static-environment))
  (:metaclass closer-mop:funcallable-standard-class))

(defvar *static-environment*)

(defvar *dynamic-environment*)

(defun parse-arguments-instruction-to-host-function
    (client parse-arguments-instruction)
  (multiple-value-bind (host-lambda-list pairs)
      (host-lambda-list-from-register-lambda-list
       (hir:lambda-list parse-arguments-instruction))
    (let* ((lexical-environment (make-lexical-environment))
           (output-lexical-references
             (loop for reference in (hir:outputs parse-arguments-instruction)
                   collect (ensure-lexical-reference
                            reference lexical-environment)))
           (static-environment-lexical-reference
             (first output-lexical-references))
           (dynamic-environment-lexical-reference
             (second output-lexical-references))
           (parameter-lexical-references
             (rest (rest output-lexical-references)))
           (successor (first (hir:successors parse-arguments-instruction)))
           (thunk (ensure-thunk client successor lexical-environment))
           (argument-parser-expression
             `(lambda ,host-lambda-list
                (list ,(mapcar #'car pairs))))
           (argument-parser
             (compile nil argument-parser-expression)))
      (lambda (&rest arguments)
        (let ((lexical-locations
                (make-lexical-locations lexical-environment))
              (parameter-values (apply argument-parser arguments)))
          (loop for parameter-value in parameter-values
                for parameter-lexical-reference
                  in parameter-lexical-references
                do (setf (lexical-value lexical-locations
                                        parameter-lexical-reference)
                         parameter-value))
          (setf (lexical-value lexical-locations
                               dynamic-environment-lexical-reference)
                *dynamic-environment*)
          (setf (lexical-value lexical-locations
                               static-environment-lexical-reference)
                *static-environment*)
          (let ((thunk thunk))
            (catch 'return
              (loop (catch 'unwind
                      (loop (setf thunk
                                  (funcall thunk
                                           lexical-locations))))))))))))

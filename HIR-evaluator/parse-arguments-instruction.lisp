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

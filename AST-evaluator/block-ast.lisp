(cl:in-package #:common-boot-ast-evaluator)

;;; Say the entire BLOCK form is executed in a continuation C.  Before
;;; the BLOCK form is executed, the dynamic environment is D and the
;;; stack is S.  To establish a stack and a dynamic environment for
;;; the forms of the BLOCK, we first push the stack.  This operation
;;; Will create and stack S' so that the top frame F of S' contains C
;;; and D.  We then push a BLOCK-ENTRY E onto the dynamic environment,
;;; creating the dynamic environment D'.  E refers to S'.  
;;;
;;; So the normal control flow (i.e., no RETURN-FROM) means that the
;;; last form of the BLOCK body is executed in a continuation that
;;; pops the stack.  This operation restores S, C and D,
;;;
;;; A non-local control transfer finds E.  It then reinstates the
;;; stack from the stored information in E, i.e., S'.  Finally, it
;;; pops the stack, again resulting in restored S, C, and D.

(defmethod cps (client (ast ico:block-ast) environment continuation)
  (let ((name (gensym))
        (temp (gensym)))
    (setf (lookup ast environment) name)
    `(progn (push-stack)
            (push (make-instance 'block-entry
                    :stack *stack*
                    :name ',name)
                  *dynamic-environment*)
            ,(cps-implicit-progn
              client
              (ico:form-asts ast)
              environment
              `(lambda (&rest ,temp)
                 (pop-stack)
                 ,continuation)))))

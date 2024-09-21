(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:application-ast))
  (let ((function
          (interpret-ast client environment (ico:function-name-ast ast)))
        (arguments
          (loop for argument-ast in (ico:argument-asts ast)
                collect (interpret-ast client environment argument-ast))))
    (let ((cb:*stack* (cons (make-instance 'cb:stack-entry
                              :called-function function
                              :arguments arguments
                              :origin (ico:origin ast))
                            cb:*stack*)))
      (apply function arguments))))

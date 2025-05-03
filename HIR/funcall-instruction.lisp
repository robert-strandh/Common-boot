(cl:in-package #:common-boot-hir)

(defclass funcall-instruction (instruction)
  ())

(setf (documentation 'funcall-instruction 'type)
      (format nil
              "Class precedence list:~@
               funcall-instruction, instruction, standard-object, t~@
               ~@
               An instruction of this type has at least two inputs,~@
               and it has one output.  The first input is a register~@
               contains the function object to be called.  The second~@
               input is a register that contains a dynamic-environment~@
               object.  Each of the remaining inputs is either a~@
               register or a literal, and these remaining inputs are~@
               the arguments to be passed to the callee.  The output~@
               is a register that can be a multiple-value register.~@
               ~@
               And instruction of this type has a single successor.~@
               ~@
               The result of executing an instruction of this type~@
               is that the function will be called with the arguments~@
               in the remaining inputs, and with a dynamic environment~@
               that is the value of the second input.  The values~@
               returned by the function will be contained in the output~@
               register."))

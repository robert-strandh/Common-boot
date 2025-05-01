(cl:in-package #:common-boot-hir)

(defclass assignment-instruction (instruction)
  ())

(setf (documentation 'assignment-instruction 'type)
      (format nil
              "Class precedence list:~@
               assignment-instruction, instruction, standard-object, t~@
               ~@
               An instruction of this type has one input and one~@
               output.  The input is a register or a literal.  The~@
               output is a register.~@
               ~@
               An instruction of this type has a single successor.~@
               ~@
               The result of executing and instruction of this type~@
               is that the register of the output will contain the~@
               object of the literal or the register of the input."))

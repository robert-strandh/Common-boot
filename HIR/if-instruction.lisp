(cl:in-package #:common-boot-hir)

(defclass if-instruction (instruction)
  ())

(setf (documentation 'if-instruction 'type)
      (format nil
              "Class precedence list:~@
               if-instruction, instruction, standard-object, t~@
               ~@
               An instruction of this type has one input and no~@
               outputs.  The input is a register or a literal.~@
               ~@
               An instruction of this type has two successors.~@
               ~@
               The result of executing an instruction of this type~@
               is that the value of input is examined, and if it~@
               is an object other than NIL, then the first successor~@
               is chosen.  If it is the object NIL, then the second~@
               successor is chosen."))

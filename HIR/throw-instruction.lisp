(cl:in-package #:common-boot-hir)

(defclass throw-instruction (instruction)
  ())

(setf (documentation 'throw-instruction 'type)
      (format nil
              "Class precedence list:~@
               throw-instruction, instruction, standard-object, t~@
               ~@
               An instruction of this type has three inputs and no~@
               outputs.  The first input is a register containing~@
               a dynamic-environment object.  The second input is a~@
               register or a literal holding a catch tag.  The third~@
               input is a register or a literal, containing the list~@
               of values to be thrown.~@
               ~@
               An instruction of this type has no successors.~@
               ~@
               The result of executing an instruction of this type~@
               is that the values are transmitted to the corresponding~@
               CATCH-INSTRUCTION."))

(cl:in-package #:common-boot-hir)

(defclass return-instruction (instruction)
  ())

(setf (documentation 'return-instruction 'type)
      (format nil
              "Class precedence list:~@
               return-instruction, instruction, standard-object, t~@
               ~@
               An instruction of this type has one input and no~@
               outputs.  The input is a MULTIPLE-VALUE-REGISTER.~@
               ~@
               An instruction of this type has no successors.~@
               ~@
               The result of executing an instruction of this type~@
               is that control is transferred to the caller of this~@
               function, with the objects in the input register as~@
               the return values."))

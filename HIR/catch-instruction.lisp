(cl:in-package #:common-boot-hir)

(defclass catch-instruction (instruction)
  ())

(setf (documentation 'catch-instruction 'type)
      (format nil
              "Class precedence list:~@
               catch-instruction, instruction, standard-object, t~@
               ~@
               An instruction of this type has two inputs and one~@
               output.  The first input is a register containing a~@
               dynamic-environment object.  The second input is a~@
               register or a literal containing a catch tag.  The~@
               output is a register.
               ~@
               An instruction of this type has two successors.  The~@
               first successor is the instruction corresponding to~@
               the first form of the body of the CATCH form.  The~@
               second successor is the instruction corresponding to~@
               the form to be evaluated after the CATCH form.~@
               ~@
               When the CATCH instruction is entered normally, the~@
               output register will contain a dynamic-environment~@
               object which is like the one in the first input, except~@
               that it has been augmented with an entry corresponding~@
               to the CATCH form.  The first successor is then chosen.~@
               ~@
               The second successor is chosen when the CATCH form is~@
               entered through the corresponding THROW. 
               ~@
               The output register should not be used by the second~@
               successor of an instruction of this type, nor by any of~@
               its successors."))

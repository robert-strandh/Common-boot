(cl:in-package #:common-boot-hir)

(defclass exit-point-instruction (instruction)
  ())

(setf (documentation 'exit-point-instruction 'type)
      (format nil
              "Class precedence list:~@
               exit-point-instruction, instruction, standard-object, t~@
               ~@
               An instruction of this type has one input and two~@
               outputs.  The input is a register containing a~@
               dynamic-environment object.  Each of the two outputs~@
               is a register.
               ~@
               An instruction of this type has a two successors.~@
               The first successor of this instruction corresponds~@
               to the first form of the body of the form from which~@
               this instruction was created, typically a BLOCK or a~@
               TAGBODY.  The second successor corresponds to a form~@
               that follows the body of the form from which this~@
               instruction was created~@
               ~@
               The result of executing an instruction of this type~@
               normally, is that the register of the first output~@
               contains a dynamic-environment object which is like~@
               the one in the input, except that it is augmented with~@
               a new exit point, and the register of the second output~@
               contains a unique identifier for this exit point.~@
               That unique identifier is used by the UNWIND-INSTRUCTION~@
               to find the unique exit point where control is to be~@
               transferred.  The first successor becomes the next~@
               instruction to be executed.~@
               ~@
               When instead this instruction is executed as a result~@
               of an UNWIND-INSTRUCTION, the second successor becomes~@
               the next instruction to be executed.  The output registers~@
               should not be used by the second successor of an instruction~@
               of this type, nor by any of its successors."))

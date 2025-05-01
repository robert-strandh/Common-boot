(cl:in-package #:common-boot-hir)

(defclass write-cell-instruction (instruction)
  ())

(setf (documentation 'write-cell-instruction 'type)
      (format nil
              "Class precedence list:~@
               write-cell-instruction, instruction, standard-object, t~@
               ~@
               An instruction of this type has two inputs and no~@
               outputs.  The first input is a register containing~@
               a cell as created by the MAKE-CELL-INSTRUCTION.~@
               The second input is a register or a literal.
               ~@
               The result of executing and instruction of this type~@
               is that the cell will contain the object in the second~@
               input."))

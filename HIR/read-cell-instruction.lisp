(cl:in-package #:common-boot-hir)

(defclass read-cell-instruction (instruction)
  ())

(setf (documentation 'read-cell-instruction 'type)
      (format nil
              "Class precedence list:~@
               read-cell-instruction, instruction, standard-object, t~@
               ~@
               An instruction of this type has one input and one~@
               output.  The input is a register containing a cell,~@
               as created by the MAKE-CELL-INSTRUCTION.  The output~@
               is a register.~@
               ~@
               An instruction of this type has a single successor.~@
               ~@
               The result of executing an instruction of this type~@
               is that the output register will contain the contents~@
               of the cell."))

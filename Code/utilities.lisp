(cl:in-package #:common-boot)

(defun convert-asts (builder asts)
  (loop for ast in asts
        collect (convert-ast builder ast)))

(defun convert-optional-ast (builder ast)
  (if (null ast) nil (convert-ast builder ast)))

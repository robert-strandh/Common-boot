(cl:in-package #:common-boot)

(defun convert-asts (builder asts)
  (loop for ast in asts
        collect (convert-ast builder ast)))

(defun convert-optional-ast (builder ast)
  (if (null ast) nil (convert-ast builder ast)))

;;; FIXME: This function is used as a temporary way of making
;;; progress.  Parsing declaration specifiers, and especially TYPE
;;; declaration specifiers is not easy, so we want to postpone that
;;; work for now.  The standard allows for an implementation to ignore
;;; all declarations except SPECIAL and NOTINLINE, and NOTINLINE can
;;; also be ignored if the implementation does not inline functions at
;;; all.
;;;

;;; Given a single DECLARATION-AST, trim it so that all declaration
;;; specifiers in it except SPECIAL are removed.
(defun trim-declaration-ast (declaration-ast)
  (let ((declaration-specifier-asts
          (ico:declaration-specifier-asts declaration-ast)))
    (reinitialize-instance declaration-ast
      :declaration-specifier-asts
      (loop for declaration-specifier-ast in declaration-specifier-asts
            when (typep declaration-specifier-ast 'ico:special-ast)
              collect declaration-specifier-ast))))

;;; Given a list of DECLARATION-ASTs, modify each one so that all
;;; declaration specifiers in it except SPECIAL are removed.
(defun trim-declaration-asts (declaration-asts)
  (loop for declaration-ast in declaration-asts
        do (trim-declaration-ast declaration-ast)))

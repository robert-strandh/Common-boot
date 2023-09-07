(cl:in-package #:common-boot)

(defclass client (trucler-reference:client)
  ())

;;; This class is used when the final AST may contain ASTs
;;; representing macro forms.  For example, in a context such as
;;; parsing an editor buffer, it is not necessary to expand macros
;;; with known semantics.
(defclass macro-preserving-client (client)
  ())

;;; This class is used when the final AST may contain only ASTs
;;; representing literals, variables, special forms, and function
;;; forms.
(defclass macro-expanding-client (client)
  ())

;;; This class is used when every AST representing a macro form is
;;; expanded the traditional way, i.e., by looking up a macro function
;;; in the environment, and applying that macro function to the
;;; S-expression represented by the AST.
(defclass macro-function-client (macro-expanding-client)
  ())

;;; This class is used when an attempt is made to transform an AST
;;; representing a macro form using a direct transformation of the
;;; AST.  Only if no direct transformation method exists does it use
;;; the traditional way, i.e. by looking up a macro function in the
;;; environment, and applying that macro function to the S-expression
;;; represented by the AST.
(defclass macro-transforming-client (macro-expanding-client)
  ())

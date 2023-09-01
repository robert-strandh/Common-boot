(cl:in-package #:asdf-user)

;;; The purpose of this system is to take a fully finilized Iconoclast
;;; AST, and evaluate the code that it represents, relative to a
;;; Clostrum environment.  So references to special variables and
;;; global functions are done in the Clostrum environment.
;;;
;;; The main difficulty with an evaluator like this is the handling of
;;; the dynamic environment.  We obviously can't use the dynamic
;;; environment of the host, because there is no simple way of
;;; representing things like bindings of target special variables in
;;; the dynamic environment of the host.  In a previous AST evaluator,
;;; we let the host stack evolve in parallel with the target stack and
;;; dynamic environment, but then we needed a fairly non-obvious
;;; mechanism to pop the host stack, using the host function THROW.
;;;
;;; In this system, we turn the target program into
;;; continuation-passing style, or CPS.  But we do not want to rely on
;;; the host system doing tail-call optimization, so we use
;;; trampolines instead.  Target code is evaluated using an iterative
;;; process.  In each iteration a host function kept in a global host
;;; variable is applied to a list of arguments kept in another global
;;; host variable.  The function then computes a new function and new
;;; arguments and stores them in the global variables and then
;;; returns.  The function in the global variable can be a target
;;; function, a host function, or a continuation.

(defsystem #:common-boot-ast-evaluator
  :depends-on (#:closer-mop
               #:common-boot)
  :serial t
  :components
  ((:file "packages")
   (:file "generic-functions")
   (:file "run-time")
   (:file "utilities")
   (:file "convert")
   (:file "literal-ast")
   (:file "variable-name-ast")
   (:file "function-name-ast")
   (:file "progn-ast")
   (:file "if-ast")
   (:file "let-and-letstar-ast")
   (:file "locally-ast")
   (:file "block-ast")
   (:file "return-from-ast")
   (:file "application-ast")
   (:file "flet-and-labels-ast")
   (:file "multiple-value-call-ast")
   (:file "progv-ast")
   (:file "quote-ast")
   (:file "the-ast")
   (:file "tag-ast")
   (:file "catch-ast")
   (:file "throw-ast")
   (:file "tagbody-segment-ast")
   (:file "tagbody-ast")
   (:file "go-ast")
   (:file "load-time-value-ast")
   (:file "setq-ast")
   (:file "ast-to-cps")
   (:file "evaluator")))

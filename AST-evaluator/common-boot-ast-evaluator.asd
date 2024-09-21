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
;;;
;;; The main advantage of using CPS is that managing the dynamic
;;; environment becomes relatively simple.  The dynamic environment is
;;; kept in the host variable DYNAMIC-ENVIRONMENT and this variable is
;;; captured by each continuation, so that restoring a particular
;;; continuation automatically restores the dynamic environment.
;;;
;;; The CPS conversion function takes an AST representing some form
;;; and a continuation represented as host source code, and it returns
;;; a host form to be evaluated in order to achieve the effect of the
;;; form represented by the AST.  The code returned by the CPS
;;; conversion function must incorporate the continuation it was
;;; passed so that the values of the AST form are passed to that
;;; continuation.

(defsystem #:common-boot-ast-evaluator
  :depends-on (#:closer-mop
               #:common-boot
               #:iconoclast-ast-transformations)
  :serial t
  :components
  ((:file "packages")
   (:file "generic-functions")
   (:file "run-time")
   (:file "utilities")
   (:file "host-lambda-list-from-lambda-list-ast")
   (:file "literal-ast")
   (:file "variable-name-ast")
   (:file "function-name-ast")
   (:file "progn-ast")
   (:file "eval-when")
   (:file "if-ast")
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
   (:file "multiple-value-prog1-ast")
   (:file "function-ast")
   (:file "special-variable-bind-ast")
   (:file "macrolet-ast")
   (:file "symbol-macrolet-ast")
   (:file "ast-to-cps")
   (:file "evaluator")))

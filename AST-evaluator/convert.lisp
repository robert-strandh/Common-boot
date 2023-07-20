(cl:in-package #:common-boot-ast-evaluator)

;;; This code constitutes an experiment.  The real version of this
;;; code will convert ASTs and not S-expressions like this one does.

;;; Protocol
;;;
;;; At the entry of a function, it is assumed that *CONTINUATION* and
;;; *ARGUMENTS* do not contain any information that needs to be
;;; preserved, so the function is free to use those variables.  The
;;; continuation to receive the return values of the function is on
;;; top of hte stack.
;;;
;;; A function must set *ARGUMENTS* to a list of all the return
;;; values, and it must pop the stack and put the result in
;;; *CONTINUATION*.

(defclass target-function (closer-mop:funcallable-standard-object)
  ()
  (:metaclass closer-mop:funcallable-standard-class))

(defun convert-constant (constant continuation)
  `(progn (setq *arguments* (list ,constant))
          (setq *continuation* ,continuation)))

(defun convert-variable (variable continuation)
  `(progn (setq *arguments* (list ,variable))
          (setq *continuation* ,continuation)))

(defun convert-arguments
    (arguments function-variable argument-variables continuation)
  (if (null arguments)
      `(progn
         (push ,continuation *stack*)
         (setq *arguments* (list ,@(reverse argument-variables)))
         (setq *continuation*
               (if (typep ,function-variable 'target-function)
                   ,function-variable
                   (lambda (&rest arguments)
                     (setq *arguments*
                           (multiple-value-list
                            (apply ,function-variable arguments)))
                     (setq *continuation* (pop *stack*))))))
      (let ((variable (gensym)))
        (convert-form
         (car arguments)
         ;; We don't know how many values will be returned here, so we
         ;; must be prepared to receive any number.  But then we keep
         ;; only the first one, or NIL if there are no values.
         `(lambda (&rest ,variable)
            (setq ,variable (car ,variable))
            ,(convert-arguments
              (cdr arguments)
              function-variable
              (cons variable argument-variables)
              continuation))))))

(defun convert-application (application continuation)
  (let ((function-variable (gensym)))
    `(progn (setq *arguments* (list (fdefinition ',(car application))))
            (setq *continuation*
                  (lambda (,function-variable)
                    ,(convert-arguments
                      (cdr application)
                      function-variable
                      '()
                      continuation))))))

(defun convert-form (form continuation)
  (cond ((symbolp form)
         (convert-variable form continuation))
        ((consp form)
         (convert-application form continuation))
        (t
         (convert-constant form continuation))))

(defun convert-top-level-form (form)
  (let ((variable (gensym)))
    `(lambda ()
       ,(convert-form
         form
         `(lambda (&rest ,variable)
            (declare (ignore ,variable))
            (setq *continuation* (pop *stack*)))))))

(defparameter *arguments* nil)

(defparameter *continuation* nil)

(defparameter *stack* '())

(defun eval-step ()
  (apply *continuation* *arguments*)
  (format *trace-output*
          "Continuation: ~s~%Arguments: ~s~%Stack: ~s~%~%"
          *continuation* *arguments* *stack*)
  (values))

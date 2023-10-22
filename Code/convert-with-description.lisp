(cl:in-package #:common-boot)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Converting a symbol that has a definition as a symbol macro.

(defmethod convert-with-description
    (client
     cst
     (description trucler:symbol-macro-description)
     environment)
  (let* ((expansion (trucler:expansion description))
         (expander (symbol-macro-expander expansion))
         (expanded-form
           (funcall expander (cst:raw cst) environment))
         (expanded-cst
           (cst:reconstruct client expanded-form cst)))
    (setf (cst:source expanded-cst) (cst:source cst))
    (with-preserved-toplevel-ness
      (convert client expanded-cst environment))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Converting a symbol that has a definition as a constant variable.

(defmethod convert-with-description
    (client
     cst
     (description trucler:constant-variable-description)
     environment)
  (let ((new-cst (cst:cst-from-expression (trucler:value description))))
    (setf (cst:source new-cst) (cst:source cst))
    (convert-constant client new-cst environment)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Converting a cst special form.

(defmethod convert-with-description
    (client
     cst
     (description trucler:special-operator-description)
     environment)
  (let ((builder (make-builder client environment)))
    (s-expression-syntax:parse builder t cst)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Converting a compound form that calls a local macro.
;;; A local macro can not have a compiler macro associated with it.
;;;
;;; If we found a local macro in ENVIRONMENT, it means that
;;; ENVIRONMENT is not the global environment.  And it must be
;;; the same kind of agumentation environment that was used when the
;;; local macro was created by the use of MACROLET.  Therefore, the
;;; expander should be able to handle being passed the same kind of
;;; environment.

(defmethod convert-with-description
    (client
     cst
     (description trucler:local-macro-description)
     environment)
  (let* ((expander (trucler:expander description))
         (expanded-form
           (funcall expander (cst:raw cst) environment))
         (expanded-cst
           (cst:reconstruct client expanded-form cst)))
    (setf (cst:source expanded-cst) (cst:source cst))
    (with-preserved-toplevel-ness
      (convert client expanded-cst environment))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Converting a compound form that calls a global macro.
;;; A global macro can have a compiler macro associated with it.

(defmethod convert-with-description
    (client
     cst
     (description trucler:global-macro-description) environment)
  (let ((compiler-macro (trucler:compiler-macro description))
        (expander (trucler:expander description)))
    (with-preserved-toplevel-ness
      (if (null compiler-macro)
          ;; There is no compiler macro, so we just apply the macro
          ;; expander, and then convert the resulting form.
          (let* ((expanded-form
                   (funcall expander (cst:raw cst) environment))
                 (expanded-cst
                   (cst:reconstruct client expanded-form cst)))
            (setf (cst:source expanded-cst) (cst:source cst))
            (convert client expanded-cst environment))
          ;; There is a compiler macro, so we must see whether it will
          ;; accept or decline.
          (let ((expanded-form
                  (expand-compiler-macro
                   compiler-macro cst environment)))
            (if (eq (cst:raw cst) expanded-form)
                ;; If the two are EQ, this means that the compiler macro
                ;; declined.  Then we appply the macro function, and
                ;; then convert the resulting form, just like we did
                ;; when there was no compiler macro present.
                (let* ((expanded-form
                         (funcall expander (cst:raw cst) environment))
                       (expanded-cst
                         (cst:reconstruct client expanded-form cst)))
                  (setf (cst:source expanded-cst)
                        (cst:source cst))
                  (convert client expanded-cst environment))
                ;; If the two are not EQ, this means that the compiler
                ;; macro replaced the original form with a new form.
                ;; This new form must then again be converted without
                ;; taking into account the real macro expander.
                (let ((expanded-cst
                        (cst:reconstruct client expanded-form cst)))
                  (setf (cst:source expanded-cst)
                        (cst:source cst))
                  (convert client expanded-cst environment))))))))

(defun convert-arguments (client argument-csts environment)
  (if (cst:null argument-csts)
      (cst:list)
      (cst:cons
       (convert client (cst:first argument-csts) environment)
       (convert-arguments client (cst:rest argument-csts) environment))))

(defun make-application (client cst environment)
  (let ((builder (make-builder client environment)))
    (ses:parse builder (ses:find-syntax 'ses:application) cst)))

;;; Convert a form representing a call to a named global function.
(defmethod convert-with-description
    (client
     cst
     (description trucler:global-function-description)
     environment)
  ;; When we compile a call to a global function, it is possible that
  ;; we are in COMPILE-TIME-TOO mode.  In that case, we must first
  ;; evaluate the form.
  (when (and *current-form-is-top-level-p* *compile-time-too*)
    (eval-cst client cst environment))
  (let ((compiler-macro (trucler:compiler-macro description))
        (notinline (eq 'notinline (trucler:inline description))))
    (if (or notinline (null compiler-macro))
        ;; There is no compiler macro.  Create the application.
        (make-application client cst environment)
        ;; There is a compiler macro.  We must see whether it will
        ;; accept or decline.
        (let ((expanded-form
                (expand-compiler-macro
                 compiler-macro cst environment)))
          (if (eq (cst:raw cst) expanded-form)
              ;; If the two are EQ, this means that the compiler macro
              ;; declined.  We are left with function-call form.
              ;; Create the application, just as if there were no
              ;; compiler macro present.
              (make-application client cst environment)
              ;; If the two are not EQ, this means that the compiler
              ;; macro replaced the original form with a new form.
              ;; This new form must then be converted.
              (let ((expanded-cst
                      (cst:reconstruct client expanded-form cst)))
                (setf (cst:source expanded-cst) (cst:source cst))
                (convert client expanded-cst environment)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Converting a cst representing a compound form that calls a local
;;; function.  A local function can not have a compiler macro
;;; associated with it.

(defmethod convert-with-description
    (client
     cst
     (description trucler:local-function-description)
     environment)
  (make-application client cst environment))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Converting a symbol that has a definition as a special variable.

(defmethod convert-with-description
    (client
     cst
     (description trucler:special-variable-description)
     environment)
  (make-instance 'ico:special-variable-reference-ast
    :name (trucler:name description)
    :origin cst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Converting a symbol that has a definition as a lexical variable.

(defmethod convert-with-description
    (client
     cst
     (description trucler:lexical-variable-description)
     environment)
  (let* ((variable-definition-ast (trucler:identity description))
         (result (make-instance 'ico:variable-reference-ast
                   :origin cst
                   :name (trucler:name description)
                   :variable-definition-ast variable-definition-ast)))
    (reinitialize-instance variable-definition-ast
      :variable-reference-asts
      (append (ico:variable-reference-asts variable-definition-ast)
              (list result)))
    result))

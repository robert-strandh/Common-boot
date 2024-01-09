(cl:in-package #:common-boot)

(defun expand-macro (client ast environment)
  (let* ((builder (make-builder client environment))
         (cst (ses:unparse builder t ast))
         (form (cst:raw cst))
         (macro-function
           (trucler:macro-function (first form) environment))
         (expansion
           (funcall macro-function form environment))
         (expanded-cst
           (cst:reconstruct client expansion cst)))
    (convert client expanded-cst environment)))

;; (defmethod abp:finish-node
;;     ((builder macro-function-builder)
;;      (kind t)
;;      (ast ico:macro-form-ast))
;;   (with-builder-components (builder client environment)
;;     (expand-macro client ast environment)))

(defmethod abp:finish-node :around
    ((builder macro-transforming-builder)
     (kind t)
     (ast ico:macro-form-ast))
  (call-next-method)
  (with-builder-components (builder client environment)
    (cm:expand client ast environment)))

(defmethod cm:expand (client ast environment)
  (expand-macro client ast environment))

(defgeneric convert-with-parser-p (client operator))

(defgeneric convert-with-ordinary-macro-p (client operator))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; CONVERT is responsible for converting a cst to an abstract syntax
;;; tree.

(defmethod convert (client cst environment)
  (let ((form (cst:raw cst)))
    (cond ((or (and (not (consp form)) (not (symbolp form)))
               (keywordp form)
               (member form '(t nil)))
           (convert-constant client cst environment))
          ((symbolp form)
           (convert-variable client cst environment))
          ((symbolp (first form))
           (when (and *current-form-is-top-level-p* *compile-time-too*)
             (eval-cst client cst environment))
           (let* ((operator-cst (cst:first cst))
                  (operator (first form))
                  (description
                    (trucler:describe-function client environment operator)))
             (cond ((convert-with-parser-p client operator)
                    (let ((builder (make-builder client environment)))
                      (ses:parse builder t cst)))
                   ((and (typep description 'trucler:macro-description)
                         (not (eq operator 'defmacro)))
                    ;; When we have a macro definition in the
                    ;; environment, it overrides the macro definition
                    ;; in Common Macro Definitions.
                    (convert-with-description
                     client cst description environment))
                   ((convert-with-ordinary-macro-p client operator)
                    (let* ((expansion (cmd:macroexpand-1 form environment))
                           (new-cst (cst:reconstruct client expansion cst)))
                      (convert client new-cst environment)))
                   (t
                    (let ((d (describe-function
                              client environment operator-cst)))
                      (convert-with-description
                       client cst d environment))))))
          (t
           ;; The form must be a compound form where the CAR is a
           ;; lambda expression.  We use the s-expression-syntax
           ;; library to check the syntax of the form, but we do not
           ;; use the result.  Instead, we turn the CST into a LABELS
           ;; and then convert the resulting CST instead.
           (let ((syntax (ses:find-syntax 'ses:application)))
             (ses:parse 'list syntax cst))
           (let* ((name (gensym))
                  (lambda-expression (first form))
                  (arguments (rest form))
                  (lambda-list (second lambda-expression))
                  (body (rest (rest lambda-expression)))
                  (new-form `(labels ((,name ,lambda-list ,@body))
                               (,name ,@arguments)))
                  (new-cst (cst:reconstruct client new-form cst)))
             (convert client new-cst environment))))))

(defmethod convert :around (client cst environment)
  #+sbcl(declare (sb-ext:muffle-conditions sb-ext:compiler-note))
  (restart-case
      ;; We bind these only here so that if a restart is invoked,
      ;; the new CONVERT call will get the right values
      ;; (i.e., the ones outside our binding)
      (let ((*current-form-is-top-level-p* *subforms-are-top-level-p*)
            (*subforms-are-top-level-p* nil)
            (*origin* (cst:source cst)))
        (call-next-method))
    (continue ()
      :report "Replace with call to ERROR."
      (convert client
               (cst:cst-from-expression
                `(error 'run-time-program-error
                        :expr ',(cst:raw cst)
                        :origin ',(cst:source cst)))
               environment))
    (substitute-form (cst)
      :report "Compile the given form in place of the problematic one."
      (convert client cst environment))))

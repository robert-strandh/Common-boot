(cl:in-package #:common-boot)

(defun expand-macro (client ast environment)
  (let* ((cst (ses:unparse client t ast))
         (form (cst:raw cst))
         (macro-function
           (trucler:macro-function (first form) environment))
         (expansion
           (funcall macro-function form environment))
         (expanded-cst
           (cst:reconstruct client expansion cst)))
    (convert client expanded-cst environment)))

(defmethod abp:finish-node
    ((builder macro-function-builder)
     (kind t)
     (ast ico:macro-form-ast))
  (with-builder-components (builder client environment)
    (expand-macro client ast environment)))

(defmethod abp:finish-node
    ((builder macro-transforming-builder)
     (kind t)
     (ast ico:macro-form-ast))
  (with-builder-components (builder client environment)
    (cm:expand client ast environment)))

(defmethod cm:expand ((client macro-transforming-client) ast environment)
  (expand-macro client ast environment))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; CONVERT is responsible for converting a cst to an abstract syntax
;;; tree.

(defmethod convert (client cst environment)
  ;; (let ((builder (make-builder client environment)))
  ;;   (format *trace-output* "*** ~s ***~%"
  ;;           (ses:classify builder cst)))
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
                  (syntax (ses:find-syntax operator :if-does-not-exist nil)))
             (if (null syntax)
                 ;; There is no syntax available for this operator, so
                 ;; we must see whethere there is a description for
                 ;; it, and act according to that description.
                 (let ((d (describe-function client environment operator-cst)))
                   (convert-with-description client cst d environment))
                 ;; There is a syntax available for this operator, so
                 ;; we parse the expression according to that syntax.
                 (let* ((builder (make-builder client environment)))
                   (ses:parse builder syntax cst)))))
          (t
           ;; The form must be a compound form where the CAR is a lambda
           ;; expression.  Evaluating such a form might have some
           ;; compile-time side effects, so we must check whether we are
           ;; in COMPILE-TIME-TOO mode, in which case we must evaluate
           ;; the form as well.
           (when (and *current-form-is-top-level-p* *compile-time-too*)
             (eval-cst client cst environment))
           (convert-lambda-call client cst environment)))))

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

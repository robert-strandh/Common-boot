(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:progv-ast) continuation)
  (let ((symbols-temp (make-symbol "SYMBOLS"))
        (values-temp (make-symbol "VALUES"))
        (continuation-variable (gensym "C-")))
    `(let* ((,symbols-temp nil)
            (,continuation-variable
              (lambda (&rest ,values-temp)
                (setq ,values-temp (car ,values-temp))
                ;; The parameter contains all the values from them
                ;; evaluation of the VALUES-AST, and we need to pair
                ;; them up with the symbols in the list.  The problem
                ;; here is that we should give the symbol a value only
                ;; if it has a corresponding value in the list of
                ;; values.  So we start with the symbols in
                ;; SYMBOLS-TEMP that do have a corresponding value.
                (loop for symbol in ,symbols-temp
                      for value in ,values-temp
                      do (push (make-instance 'special-variable-entry
                                 :name symbol
                                 :value value)
                               dynamic-environment))
                ;; At this point, if the list of values in VALUES-TEMP
                ;; was shorter than the list of symbols in
                ;; SYMBOLS-TEMP, then some symbols have not been
                ;; entered into the dynamic environment.  So we do
                ;; that now.
                (when (< (length ,values-temp) (length ,symbols-temp))
                  (loop with count = (length ,values-temp)
                        with symbols = (subseq ,symbols-temp count)
                        for symbol in symbols
                        do (push (make-instance 'special-variable-entry
                                 :name symbol)
                                 dynamic-environment)))
                ,(cps-implicit-progn
                  client environment
                  (ico:form-asts ast)
                  continuation)))
            (,continuation-variable
              (lambda (&rest temp)
                (setq ,symbols-temp (car temp))
                ,(cps client environment
                      (ico:values-ast ast)
                      continuation-variable))))
       ,(cps client environment (ico:symbols-ast ast) continuation-variable))))

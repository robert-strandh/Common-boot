(cl:in-package #:common-boot-ast-interpreter-test)

(define-test block-and-return-from)

(define-test block-no-return-from
  :parent block-and-return-from
  (with-default-parameters (client environment global-environment)
    (iss #1=(block b 234)
         (eval-expression client '#1# environment))))

(define-test block-no-return-from-two-forms
  :parent block-and-return-from
  (with-default-parameters (client environment global-environment)
    (iss #1=(block b 234 345)
         (eval-expression client '#1# environment))))

(define-test block-with-return-from
  :parent block-and-return-from
  (with-default-parameters (client environment global-environment)
    (iss #1=(block b (return-from b 345) 234)
         (eval-expression client '#1# environment))))

(define-test block-with-return-from-as-last-form
  :parent block-and-return-from
  (with-default-parameters (client environment global-environment)
    (iss #1=(block b 234 (return-from b 345))
         (eval-expression client '#1# environment))))

(define-test block-with-return-from-inside-let
  :parent block-and-return-from
  (with-default-parameters (client environment global-environment)
    (iss #1=(block b (let () (return-from b 345) 234))
         (eval-expression client '#1# environment))))

(define-test block-two-in-a-row
  :parent block-and-return-from
  (with-default-parameters (client environment global-environment)
    (iss #1=(+ (block a
                 (return-from a 10))
               (block b
                 (return-from b 20)))
         (eval-expression client '#1# environment))))

(define-test block-with-return-from-inside-let-with-variable
  :parent block-and-return-from
  (with-default-parameters (client environment global-environment)
    (iss #1=(block b
              (let ((x nil))
                (return-from b x)))
         (eval-expression client '#1# environment))))

(define-test block-with-return-from-outermost
  :parent block-and-return-from
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 0))
              (labels ((bar (f test)
                         (block nil
                           (if test
                               (funcall f)
                               (bar (lambda () (return)) t)))
                         (incf x)))
                (bar nil nil))
              x)
         (eval-expression client '#1# environment))))

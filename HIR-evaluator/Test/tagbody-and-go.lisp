(cl:in-package #:common-boot-hir-evaluator-test)

(define-test tagbody-and-go)

(define-test tagbody-and-go-empty
  :parent tagbody-and-go
  (with-default-parameters (client environment global-environment)
    (iss #1=(tagbody)
         (eval-expression client '#1# environment))))

(define-test tagbody-and-go-no-go
  :parent tagbody-and-go
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10)) (tagbody (setq x 20)) x)
         (eval-expression client '#1# environment))))

(define-test tagbody-and-go-nested
  :parent tagbody-and-go
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10))
              (tagbody
                 (tagbody (setq x 20) (go a))
               a
                 (tagbody (setq x 10) (go b))
               b)
              x)
         (eval-expression client '#1# environment))))

(define-test tagbody-and-go-one-go
  :parent tagbody-and-go
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10)) (tagbody (go out) (setq x 20) out) x)
         (eval-expression client '#1# environment))))

(define-test tagbody-and-go-one-loop
  :parent tagbody-and-go
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10))
              (tagbody
               again
                 (if (> x 12)
                     (go out)
                     (progn (setq x (1+ x))
                            (go again)))
               out)
              x)
         (eval-expression client '#1# environment))))

(define-test tagbody-and-go-with-block
  :parent tagbody-and-go
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10))
              (block nil
                (tagbody
                 again
                   (if (> x 12)
                       (go out)
                       (progn (setq x (1+ x))
                              (go again)))
                 out
                   (return-from nil)))
              x)
         (eval-expression client '#1# environment))))

(define-test tagbody-and-go-with-go-wrapped-in-let
  :parent tagbody-and-go
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10))
              (tagbody (let ((y 20)) (setq x y) (go out)) (setq x 5) out) x)
         (eval-expression client '#1# environment))))

(define-test tagbody-with-go-to-outermost
  :parent tagbody-and-go
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 0))
              (labels ((bar (f test)
                         (tagbody
                            (if test
                                (funcall f)
                                (bar (lambda () (go out)) t))
                          out)
                         (incf x)))
                (bar nil nil))
              x)
         (eval-expression client '#1# environment))))

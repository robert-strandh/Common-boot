(cl:in-package #:common-boot-ast-transformations-test)

(define-test lexify-lambda-list)

(define-test lexify-lambda-list-already-lexified-no-parameters
  :parent lexify-lambda-list
  (is #'equal
      (parse-lexify-and-unparse '((lambda () 234)))
      '((lambda () 234))))

(define-test lexify-lambda-list-already-lexified-one-required-parameter
  :parent lexify-lambda-list
  (is #'equal
      (parse-lexify-and-unparse '((lambda (x) 234)))
      '((lambda (x) 234))))

(define-test lexify-lambda-list-already-lexified-one-optional-parameter
  :parent lexify-lambda-list
  (is #'equal
      (parse-lexify-and-unparse '((lambda (&optional (x nil x-p)) 234)))
      '((lambda (&optional (x nil x-p)) 234))))

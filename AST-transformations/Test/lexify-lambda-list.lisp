(cl:in-package #:common-boot-ast-transformations-test)

(define-test lexify-lambda-list)

(define-test lexify-lambda-list-already-lexified-no-parameters
  :parent lexify-lambda-list
  (is #'equal
      (parse-lexify-and-unparse '(function (lambda () 234)))
      '(function (lambda () 234))))

(cl:in-package #:common-boot-ast-transformations-test)

(define-test lexify-lambda-list)

(define-test lexify-lambda-list-one-required-special
  :parent lexify-lambda-list
  (is #'forms-similar-p
      (parse-lexify-and-unparse '((lambda (x) (declare (special x)) 234)))
      `((lambda (#1=:a)
          (let* ((x #1#)) (declare (special x)) 234)))))

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

(define-test lexify-lambda-list-not-lexified-one-optional-parameter
  :parent lexify-lambda-list
  (is #'forms-similar-p
      (parse-lexify-and-unparse '((lambda (&optional x) 234)))
      '((lambda (&optional (#1=#:a nil #2=#:a-p))
          (let* ((x (if #2# #1# nil)))
            234)))))

(define-test lexify-lambda-list-already-lexified-one-key-parameter
  :parent lexify-lambda-list
  (is #'equal
      (parse-lexify-and-unparse '((lambda (&key (x nil x-p)) 234)))
      '((lambda (&key (x nil x-p)) 234))))

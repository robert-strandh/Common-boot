(cl:in-package #:common-boot)

(defgeneric convert (client cst environment))

(defgeneric convert-with-description (client cst info environment))

(defgeneric convert-ast (builder ast))

(defgeneric eval-cst (client cst environment))

(defgeneric compile-local-macro-function-ast (client lambda-ast environment))

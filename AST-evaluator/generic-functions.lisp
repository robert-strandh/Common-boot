(cl:in-package #:common-boot-ast-evaluator)

(defgeneric push-stack (client))

(defgeneric pop-stack (client))

(defgeneric cps (client ast continuation))

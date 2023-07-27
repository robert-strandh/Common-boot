(cl:in-package #:common-boot-ast-evaluator)

(defgeneric cps (client ast environment continuation))

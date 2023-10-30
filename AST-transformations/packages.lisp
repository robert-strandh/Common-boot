(cl:in-package #:common-lisp-user)

(defpackage #:common-boot-ast-transformations
  (:use #:common-lisp)
  (:local-nicknames
   (#:cbaw #:common-boot-ast-walker)
   (#:ico #:iconoclast))
  (:export
   #:client
   #:canonicalize-declaration-asts
   #:application-lambda-to-labels
   #:function-lambda-to-labels
   #:flet-to-labels
   #:let-to-labels
   #:let*-to-labels
   #:eliminate-special-declarations
   #:lexify-lambda-list))

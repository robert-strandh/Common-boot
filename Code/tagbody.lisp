(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:tagbody-ast))
  (with-builder-components (builder client environment)
    (let ((new-environment environment))
      (loop for segment-ast in (ico:segment-asts ast)
            for tag-ast = (ico:tag-ast segment-ast)
            do (unless (null tag-ast)
                 (let ((name (ico:name tag-ast)))
                   (change-class tag-ast 'ico:tag-definition-ast)
                   (setf new-environment
                         (trucler:add-tag
                          client new-environment name tag-ast)))))
      (loop with new-builder = (make-builder client new-environment)
            for segment-ast in (ico:segment-asts ast)
            do (reinitialize-instance segment-ast
                 :statement-asts
                 (loop for statement-ast in (ico:statement-asts segment-ast)
                       collect (convert-ast new-builder statement-ast))))))
  ast)

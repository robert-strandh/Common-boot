(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:go-ast))
  (let* ((tag-reference-ast (ico:tag-ast ast))
         (tag-definition-ast (ico:tag-definition-ast tag-reference-ast))
         (segment-ast (ico:segment-ast tag-definition-ast))
         (tagbody-ast (ico:tagbody-ast segment-ast))
         (identity (lookup tagbody-ast environment))
         (segment-asts (ico:segment-asts tagbody-ast))
         (relevant-segment-asts
           (if (null (ico:tag-ast (first segment-asts)))
               (rest segment-asts)
               segment-asts))
         (entry (do-go identity *dynamic-environment*))
         (index (position tag-definition-ast relevant-segment-asts
                          :test #'eq :key #'ico:tag-ast)))
    (funcall (aref (unwinders entry) index))))

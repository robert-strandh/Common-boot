(cl:in-package #:common-boot)

(defun describe-function (client environment function-name-cst)
  (let* ((function-name (cst:raw function-name-cst))
         (result (trucler:describe-function
                  client environment function-name)))
    (loop while (null result)
          do (restart-case (error "No function description for ~s"
                                  function-name)
               (consider-global ()
                 :report (lambda (stream)
                           (format stream
                                   "Treat it as the name of a global function."))
                 (return-from describe-function
                   (make-instance 'trucler:global-function-description
                     ;; :origin (cst:source function-name-cst)
                     :name function-name)))
               (substitute (new-function-name)
                 :report (lambda (stream)
                           (format stream "Substitute a different name."))
                 :interactive (lambda ()
                                (format *query-io* "Enter new name: ")
                                (list (read *query-io*)))
                 (setq result
                       (trucler:describe-function
                        client environment new-function-name)))))
    result))

(defun describe-tag (client environment tag-name)
  (let ((result (trucler:describe-tag client environment tag-name)))
    (loop while (null result)
          do (restart-case (error "No tag name ~s" tag-name)
               (substitute (new-tag-name)
                 :report (lambda (stream)
                           (format stream "Substitute a different name."))
                 :interactive (lambda ()
                                (format *query-io* "Enter new name: ")
                                (list (read *query-io*)))
                 (setq result
                       (trucler:describe-tag
                        client environment new-tag-name)))))
    result))

(defun describe-block (client environment block-name)
  (let ((result (trucler:describe-block client environment block-name)))
    (loop while (null result)
          do (restart-case (error "No block name ~s" block-name)
               (substitute (new-block-name)
                 :report (lambda (stream)
                           (format stream "Substitute a different name."))
                 :interactive (lambda ()
                                (format *query-io* "Enter new name: ")
                                (list (read *query-io*)))
                 (setq result
                       (trucler:describe-block
                        client environment new-block-name)))))
    result))

(defmethod declaration-proclamations (client environment)
  '())

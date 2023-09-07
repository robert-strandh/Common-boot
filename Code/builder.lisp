(cl:in-package #:common-boot)

(defgeneric environment (builder))

(defgeneric client (builder))

(defclass builder (bld:builder)
  ((%client
    :initarg :client
    :reader client)
   (%environment
    :initarg :environment
    :reader environment)))

(defclass macro-preserving-builder (builder)
  ())

(defclass macro-expanding-builder (builder)
  ())

(defclass macro-function-builder (macro-expanding-builder)
  ())

(defclass macro-transforming-builder (macro-function-builder)
  ())

(defgeneric make-builder (client environment))

(defmethod make-builder ((client macro-preserving-client) environment)
  (make-instance 'macro-preserving-builder
    :client client
    :environment environment))

(defmethod make-builder ((client macro-expanding-client) environment)
  (make-instance 'macro-expanding-builder
    :client client
    :environment environment))

(defmethod make-builder ((client macro-function-client) environment)
  (make-instance 'macro-function-builder
    :client client
    :environment environment))

(defmethod make-builder ((client macro-transforming-client) environment)
  (make-instance 'macro-transforming-builder
    :client client
    :environment environment))

(defun builder-components (builder)
  (values (client builder) (environment builder)))

(defmacro with-builder-components
    ((builder-form client-name environment-name) &body body)
  `(multiple-value-bind (,client-name ,environment-name)
       (builder-components ,builder-form)
     ,@body))

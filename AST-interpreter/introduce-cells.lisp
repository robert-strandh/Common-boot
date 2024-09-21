(cl:in-package #:common-boot-ast-interpreter)

(defclass global-function-cell-ast (ico:ast)
  ((%cell :initarg :cell :reader cell)))

(defclass introduce-cells-client ()
  ((%environment :initarg :environment :reader environment)
   (%client :initarg :client :reader client)))

(defun introduce-cells-helper (igfc-client ast)
  (let* ((global-environment (environment igfc-client))
         (client (client igfc-client))
         (name (ico:name ast))
         (cell (clostrum:ensure-operator-cell
                client global-environment name)))
    (change-class ast 'global-function-cell-ast :cell cell)))

(defmethod iaw:walk-ast-node :around
    ((igfc-client introduce-cells-client)
     (ast ico:global-function-name-reference-ast))
  ;; Start by converting any children of this AST node.
  (call-next-method)
  (let ()
    (introduce-cells-helper igfc-client ast)))

(defun introduce-cells (client environment ast)
  (let ((igfc-client (make-instance 'introduce-cells-client
                       :environment environment
                       :client client)))
    (iaw:walk-ast igfc-client ast)))

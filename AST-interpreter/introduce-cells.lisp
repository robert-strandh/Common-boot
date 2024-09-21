(cl:in-package #:common-boot-ast-interpreter)

(defclass global-function-cell-ast (ico:ast)
  ((%cell :initarg :cell :reader cell)))

(defclass special-variable-cell-ast (ico:ast)
  ((%cell :initarg :cell :reader cell)
   (%name :initarg :name :reader name)))

(defclass introduce-cells-client ()
  ((%environment :initarg :environment :reader environment)
   (%client :initarg :client :reader client)))

(defmethod iaw:walk-ast-node :around
    ((igfc-client introduce-cells-client)
     (ast ico:global-function-name-reference-ast))
  ;; Start by converting any children of this AST node.
  (call-next-method)
  (let* ((global-environment (environment igfc-client))
         (client (client igfc-client))
         (name (ico:name ast))
         (cell (clostrum:ensure-operator-cell
                client global-environment name)))
    (change-class ast 'global-function-cell-ast :cell cell)))

(defmethod iaw:walk-ast-node :around
    ((igfc-client introduce-cells-client)
     (ast ico:special-variable-reference-ast))
  ;; Start by converting any children of this AST node.
  (call-next-method)
  (let* ((global-environment (environment igfc-client))
         (client (client igfc-client))
         (name (ico:name ast))
         (cell (clostrum:ensure-variable-cell
                client global-environment name)))
    (change-class ast 'special-variable-cell-ast
                  :name name
                  :cell cell)))

(defun introduce-cells (client environment ast)
  (let ((igfc-client (make-instance 'introduce-cells-client
                       :environment environment
                       :client client)))
    (iaw:walk-ast igfc-client ast)))

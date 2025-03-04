(cl:in-package #:common-boot-hir-visualizer)

(clim:define-application-frame visualizer ()
  ((%initial-instruction :initarg :initial-instruction
                         :accessor initial-instruction)
   (%highlight-successors
    :initform (make-hash-table :test #'eq)
    :accessor highlight-successors)
   (%highlight-clients
    :initform (make-hash-table :test #'eq)
    :accessor highlight-clients)
   (%highlight-data
    :initform (make-hash-table :test #'eq)
    :accessor highlight-data))
  (:panes (application
           :application
           :scroll-bars nil
           :display-function 'display-hir
           :text-style (clim:make-text-style :sans-serif :roman 20))
          (interactor :interactor :scroll-bars nil))
  (:layouts (default (clim:vertically (:width 1200 :height 900)
                       (4/5 (clim:scrolling () application))
                       (1/5 (clim:scrolling () interactor))))))

(defun node-label (node)
  (label node))

(defun node-width (node pane)
  (+ (clim:text-size pane (node-label node)) 5))

(defun node-height (pane)
  (+ (nth-value 1 (clim:text-size pane "A")) 5))

;;; Compute the width of a layer of nodes.
(defun compute-layer-width (nodes pane)
  (loop for node in nodes
        for width = (node-width node pane)
        for hpos = (+ (floor width 2) 10)
          then (+ hpos width horizontal-node-separation)
        finally (return hpos)))

(defun find-enclose-instructions (parse-arguments-instruction)
  (let ((table (make-hash-table :test #'eq))
        (result '()))
    (labels ((traverse (instruction)
               (unless (gethash instruction table)
                 (setf (gethash instruction table) t)
                 (when (typep instruction 'ir:enclose-instruction)
                   (push instruction result))
                 (loop for successor in (ir:successors instruction)
                       do (traverse successor)))))
      (traverse parse-arguments-instruction))
    (reverse result)))

(defun next-rack (rack)
  (loop for instruction in rack
        for enclose-instructions = (find-enclose-instructions instruction)
        for parse-arguments-instructions
          = (mapcar #'ir:parse-arguments-instruction enclose-instructions)
        append parse-arguments-instructions))

(defun layout-program (parse-arguments-instruction pane)
  (loop for hpos = 50 then (+ hpos (+ rack-width horizontal-node-separation))
        for rack = (list parse-arguments-instruction) then (next-rack rack)
        for dimensions = (loop for inst in rack
                               collect (multiple-value-bind (width height)
                                           (compute-function-dimensions inst pane)
                                         (cons width height)))
        for rack-width = (loop for dim in dimensions maximize (car dim))
        until (null rack)
        do (loop for parse-arguments-instruction in rack
                 for dimension in dimensions
                 for vpos = 10
                   then (+ vpos (cdr dimension) vertical-rack-separation)
                 do (layout-function parse-arguments-instruction hpos vpos))))

(defun draw-node (node hpos vpos pane)
  (let ((width (node-width node pane))
        (height (node-height pane))
        (highlight-p
          (loop for predecessor in (ir:predecessors node)
                thereis (gethash predecessor
                                 (highlight-successors clim:*application-frame*)))))
    (clim:with-output-as-presentation
        (pane node 'ir:instruction)
      (clim:draw-rectangle* pane
                            (- hpos (floor width 2))
                            (- vpos (floor height 2))
                            (+ hpos (floor width 2))
                            (+ vpos (floor height 2))
                            :ink (if highlight-p clim:+blue+ clim:+black+)
                            :line-thickness (if highlight-p 2 1)
                            :filled nil)
      (clim:draw-text* pane
                       (string (node-label node))
                       hpos vpos
                       :ink (if highlight-p clim:+blue+ clim:+black+)
                       :align-x :center :align-y :center))))

(defun draw-nodes (initial-instruction pane)
  (ir:map-instructions-arbitrary-order
   (lambda (node)
     (multiple-value-bind (hpos vpos) (instruction-position node)
       (draw-node node hpos vpos pane)))
   initial-instruction))

(defun layout-datum (datum)
  (let* ((writers (ir:writers datum))
         (readers (ir:readers datum))
         (instructions (append writers readers)))
    (let ((max-vpos (loop for instruction in instructions
                          maximize (instruction-vertical-position instruction)))
          (min-hpos (loop for instruction in instructions
                          minimize (instruction-horizontal-position instruction)))
          (min-vpos (loop for instruction in instructions
                          minimize (instruction-vertical-position instruction))))
      (let ((hpos (+ min-hpos 300)))
        (setf (datum-position datum) (cons hpos (/ (+ max-vpos min-vpos) 2)))))))

(defun layout-inputs-and-outputs (instruction)
  (loop for input in (ir:inputs instruction)
        do (layout-datum input))
  (loop for output in (ir:outputs instruction)
        do (layout-datum output)))

(defun layout-data (initial-instruction pane)
  (declare (ignore pane))
  (ir:map-instructions-arbitrary-order
   (lambda (instruction) (layout-inputs-and-outputs instruction))
   initial-instruction))

(defun data-edge-should-be-highlighted-p (instruction datum)
  (or (gethash datum (highlight-clients clim:*application-frame*))
      (gethash instruction (highlight-data clim:*application-frame*))))

(defun draw-data-edge (instruction datum pane ink)
  (let ((line-thickness
          (if (data-edge-should-be-highlighted-p instruction datum) 3 1)))
    (multiple-value-bind (hpos1 vpos1) (instruction-position instruction)
      (multiple-value-bind (hpos2 vpos2) (datum-position datum)
        (let ((h1 (if (> hpos2 hpos1)
                      (+ hpos1 (/ (node-width instruction pane) 2))
                      (- hpos1 (/ (node-width instruction pane) 2))))
              (h2 (if (> hpos2 hpos1)
                      (- hpos2 30)
                      (+ hpos2 30)))
              (v2 (if (> vpos2 vpos1)
                      (- vpos2 10)
                      (+ vpos2 10))))
          (clim:draw-line* pane
                           h1 vpos1
                           h2 v2
                           :line-thickness line-thickness
                           :ink ink
                           :line-dashes t))))))

(defun datum-should-be-highlighted-p (datum)
  (or (gethash datum (highlight-clients clim:*application-frame*))
      (loop for instruction in (ir:readers datum)
              thereis (gethash instruction
                               (highlight-data clim:*application-frame*)))
      (loop for instruction in (ir:writers datum)
              thereis (gethash instruction
                               (highlight-data clim:*application-frame*)))))

(defgeneric draw-datum (datum pane))

(defmethod draw-datum :around (datum pane)
  ;; Avoid drawing data which have coordinates too high for xlib to
  ;; handle.
  (multiple-value-bind (hpos vpos) (datum-position datum)
    (when (or (> hpos 20000)
              (> vpos 20000))
      (return-from draw-datum)))
  (let ((line-thickness
          (if (datum-should-be-highlighted-p datum) 2 1))
        (ink
          (if (datum-should-be-highlighted-p datum) clim:+magenta+ clim:+black+)))
    (clim:with-drawing-options (pane :ink ink :line-thickness line-thickness)
      (clim:with-output-as-presentation
          (pane datum 'ir:datum)
        (call-next-method)))))

(defmethod draw-datum (datum pane)
  (multiple-value-bind (hpos vpos) (datum-position datum)
    (clim:draw-oval* pane hpos vpos
                     (floor datum-width 2) (floor datum-height 2)
                     :filled nil)))

(defun ink-for-location (location)
  (etypecase location
    (ir:register clim:+dark-green+)))

(defmethod draw-datum ((datum ir:register) pane)
  (multiple-value-bind (hpos vpos) (datum-position datum)
    (clim:draw-oval* pane hpos vpos
                     (floor datum-width 2) (floor datum-height 2)
                     :filled nil)
    (clim:with-text-size (pane :small)
      (clim:draw-text* pane (string (ir:name datum))
                       hpos vpos
                       :align-x :center :align-y :center
                       :ink (ink-for-location datum)))))

(defmethod draw-datum ((datum ir:literal) pane)
  (multiple-value-bind (hpos vpos) (datum-position datum)
    (clim:draw-oval* pane hpos vpos
                     (floor datum-width 2) (floor datum-height 2)
                     :ink clim:+pink+
                     :filled t)
    (clim:draw-oval* pane hpos vpos
                     (floor datum-width 2) (floor datum-height 2)
                     :filled nil)
    (let ((label (princ-to-string (ir:value datum))))
      (clim:with-text-size (pane :small)
        (clim:draw-text* pane
                         (subseq label 0 (min 15 (length label)))
                         hpos vpos
                         :align-x :center :align-y :center
                         :ink clim:+dark-blue+)))))

(defun draw-data (pane)
  (loop for datum being each hash-key of *data-position-table*
        do (draw-datum datum pane)
           (loop for instruction in (ir:writers datum)
                 do (draw-data-edge instruction datum pane clim:+red+))
           (loop for instruction in (ir:readers datum)
                 do (draw-data-edge instruction datum pane clim:+dark-green+))))

(defun display-hir (frame pane)
  (let ((*instruction-position-table* (make-hash-table :test #'eq))
        (*data-position-table* (make-hash-table :test #'eq)))
    (multiple-value-bind (*base-width* *base-height*)
        (clim:text-size pane "enclose")
      (layout-program (initial-instruction frame) pane)
      (draw-nodes (initial-instruction frame) pane)
      (layout-data (initial-instruction frame) pane)
      (fix-data-overlaps (initial-instruction frame))
      (draw-data pane)
      (draw-arcs pane (make-arcs pane *instruction-position-table*)))))

(defun visualize (initial-instruction &key new-process-p)
  (ir:initialize-predecessors-and-data initial-instruction)
  (let ((frame (clim:make-application-frame
                'visualizer
                :initial-instruction initial-instruction)))
    (flet ((run ()
             (clim:run-frame-top-level frame)))
      (if new-process-p
          (clim-sys:make-process #'run)
          (run)))))

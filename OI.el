;;; OI.el --- Description -*- lexical-binding: t; -*-
;; Author:  <pifka@deel>
;; Maintainer:  <pifka@deel>
;; Created: September 20, 2024
;; Modified: September 20, 2024
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.4"))
;;
;; This file is not part of GNU Emacs.
;;
;;  Description
;;      Function for reading code from robotContainer.java and printing
;;; Code:
;;;
;;;

(defun OI-get-robot-buttons (&optional ROBOTCONTAINER)
"Takes path of robotContainer.java 'ROBOTCONTAINER' and parses button mappings"
(interactive)
(if (not ROBOTCONTAINER)
  (setq ROBOTCONTAINER (read-file-name "robotContainer.java : " )))

(with-temp-buffer
  (insert-file-contents robot-container)
  (setq robot-container-contents (split-string (buffer-string) "\n")))

(setq robot-buttons ())
(dolist (item robot-container-contents)
  (if (> (length item) 6)
      (if (equal (substring (string-trim-left item) 0 2) "OI")
          (progn
            (setq rbutton (nth 1 (split-string item "\\.")))
            (setq rcommand
                  (if (string-match "new" item )
                  (substring item
                             (string-match "new" item)
                             (length item))
                  '("runOnceCommand")))
            (setq robot-buttons (push (list rbutton rcommand) robot-buttons))
(print robot-buttons))))))

(provide 'OI)

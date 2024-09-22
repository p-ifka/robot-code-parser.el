;;; OI.el --- Description -*- lexical-binding: t; -*-
;; Author:  <pifka@deel>
;; Maintainer:  <pifka@deel>
;; Created: September 20, 2024
;; Modified: September 20, 2024
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.4"))
;; Homepage: https://github.com/p-ifka/robot-code-parser.el
;; This file is not part of GNU Emacs.
(defvar robot-container)
(defvar robot-container-contents)
(defvar robot-buttons)
(defvar r-button)
(defvar r-command)


(defun OI-get-robotContainer-buttons (&optional ROBOTCONTAINER)
"Takes path of robotContainer.java 'ROBOTCONTAINER' and parses button mappings"
(interactive)
(if (not ROBOTCONTAINER)
  (setq ROBOTCONTAINER (read-file-name "robotContainer.java : " ))) ;; if 'ROBOTCONTAINER' is not provided, ask for it

(with-temp-buffer
  (insert-file-contents robot-container)
  (setq robot-container-contents (split-string (buffer-string) "\n"))) ;; get contents of file 'ROBOTCONTAINER'

(setq robot-buttons ())
(dolist (item robot-container-contents)
  (if (> (length item) 6)
      (if (equal (substring (string-trim-left item) 0 2) "OI") ;; get all lines starting with 'OI'
          (progn
            (setq r-button (nth 1 (split-string item "\\."))) ;; get button
            (setq r-command ;; get command
                  (if (string-match "new" item )
                  (substring item
                             (string-match "new" item)
                             (length item))
                  '("runOnceCommand")))
            (setq robot-buttons (push (list r-button r-command) robot-buttons)) ;; push button and command to list
(print robot-buttons)))))) ;; TODO: use better output method
;; ====================================================================================================
;;
;; ====================================================================================================
;;TODO : add function for getting hardware values from 'OI.java'
;;TODO : add optional file output into 'README.md'
(provide 'OI)

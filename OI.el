;;; OI.el --- Description -*- lexical-binding: t; -*-
;; Author:  <pifka@deel>
;; Maintainer:  <pifka@deel>
;; Created: September 20, 2024
;; Modified: September 20, 2024
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.4"))
;; Homepage: https://github.com/p-ifka/robot-code-parser.el
;; This file is not part of GNU Emacs.
(defvar robot-container-contents)
(defvar robot-buttons)
(defvar r-button)
(defvar r-command)


(defun OI-get (&optional DIR)
"Takes path of robotContainer.java 'ROBOTCONTAINER' and parses button mappings"
(interactive)
(if (not DIR)
  (setq DIR (read-directory-name "/robot : " ))) ;; if 'ROBOTCONTAINER' is not provided, ask for it

(with-temp-buffer
  (insert-file-contents (concat DIR "/" "RobotContainer.java"))
  (setq robot-container-contents (split-string (buffer-string) "\n"))) ;; get contents of file 'ROBOTCONTAINER'

(setq robot-buttons ())
(dolist (item robot-container-contents)
  (if (> (length item) 6)
      (if (equal (substring (string-trim-left item) 0 2) "OI") ;; get all lines starting with 'OI'
          (progn
            (setq r-button (nth 1 (split-string item "\\."))) ;; get button
            (setq r-command ;; get command
                  (if (string-match "new" item ) ;; get command
                  (substring item
                             (string-match "new" item)
                             (length item))
                  (if (string-match "{" item) ;; get multiline runOnceCommand
                      "multiline runOnceCommand"
                      ;; TODO: get all lines below until ending }

                  (substring item ;; get single line runOnceCommand
                             ( -(string-match ">" item) 1)
                             (-(length item) 1)))))
            (setq robot-buttons (push (list r-button r-command) robot-buttons)) ;; push button and command to list
))))
;; == Add Map Type From OI == ;;
  (with-temp-buffer
    (insert-file-contents (concat DIR "/" "OI.java"))
    (setq oi-contents (split-string (buffer-string) "\n")))
  (setq cmd-i 0)
  (dolist (cmd robot-buttons)
    (dolist (line oi-contents)
      (if (string-match (nth 0 cmd) line)

          ;; push either 'Driver Map' or 'Operator Map'
          (if (string-match "DRIVER_MAP" line )
              (push "Driver Map" (nth cmd-i robot-buttons))
            (if (string-match "OPERATOR_MAP" line)
                (push "Operator Map" (nth cmd-i robot-buttons))
              (push "[err: command map type not found]" (nth cmd-i robot-buttons)))))
)(setq cmd-i (+ cmd-i 1)))

(if (yes-or-no-p "output to buffer?: ")
    (OI-output robot-buttons)
    ))
;; ====================================================================================================
;;
;; ====================================================================================================

;; -- Buffer Print -- ;;
(defun OI-output (OUTPUT)
 (setq output-buffer (generate-new-buffer "*OI-output*"))
 (set-buffer output-buffer)
(setq driver-map "")
(setq operator-map "")
 (dolist (item OUTPUT)
   (setq rcommand-name (substring (nth 2 item) 3 (cl-position 40 (string-to-list (nth 2 item))) ))
   (setq rargs (substring (nth 2 item)
        (cl-position 40 (string-to-list (nth 2 item)))
        (- (length (nth 2 item)) 2)))
   (if (equal (nth 0 item) "Driver Map")
       (setq driver-map (concat driver-map "- " (nth 1 item) " - " rcommand-name ": " rargs "\n"))
        (setq operator-map (concat operator-map "- " (nth 1 item) " - " rcommand-name ": " rargs "\n"))
        )) ;; end of dolist
(insert (concat
         "#+title: OI.el output\n"
         "* Operator\n"
         operator-map
         "* Driver\n"
         driver-map))
(org-mode)
(setq buffer-read-only t))
    ;; (insert (concat "*" (nth 0 item) "*" " - " rcommand-name ": " rargs "\n"))

;; ====================================================================================================
;;
;; ====================================================================================================
(provide 'OI)

;; (progn
;;   (with-temp-buffer
;;     (insert-file-contents (expand-file-name "~/src/LER-2024/src/main/java/frc/robot/OI.java"))
;;     (setq oi-contents (split-string (buffer-string) "\n")))
;;   (setq cmd-i 0)
;;   (dolist (cmd robot-buttons)
;;     (dolist (line oi-contents)
;;       (if (string-match (nth 0 cmd) line)

;;           ;; push either 'Driver Map' or 'Operator Map'
;;           (if (string-match "DRIVER_MAP" line )
;;               (push "Driver Map" (nth cmd-i robot-buttons))
;;             (if (string-match "OPERATOR_MAP" line)
;;                 (push "Operator Map" (nth cmd-i robot-buttons))
;;               (push "[err: command map type not found]" (nth cmd-i robot-buttons)))))


;; )(setq cmd-i (+ cmd-i 1)))
;; (print robot-buttons))

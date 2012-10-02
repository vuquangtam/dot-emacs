;;; my-misc.el --- Miscellaneous settings
;;; -*- lexical-bind: t -*-

;;; Commentary:
;; Author: Andrey Kotlarski <m00naticus@gmail.com>

;;; Code:

(require 'my-utils)

;;; Imenu
(when-library t imenu (global-set-key (kbd "C-`") 'imenu))

;;; Proced
(when-library t proced (global-set-key "\C-^" 'proced))

;;; Ace Jump
(if (require 'ace-jump-mode nil t)
    (define-key global-map "\C-c " 'ace-jump-mode))

;;; helm
(when-library
 nil helm
 (global-set-key [f5] 'helm-M-x)
 (global-set-key "\C-x\C-f" 'helm-find-files)

 (unless (featurep 'ergoemacs-mode)
   (global-set-key "\M-y" 'helm-show-kill-ring)
   (define-keys minibuffer-local-map
     "\M-y" 'yank-pop
     "\M-SPC" 'helm-mark-candidate)))

;;; Ditaa
(let ((ditaa-path (executable-find "ditaa.jar")))
  (when ditaa-path
    (when-library t org (setq org-ditaa-jar-path ditaa-path))

    (defun ditaa-generate ()
      "Invoke ditaa over current buffer."
      (interactive)
      (start-process "ditaa" "*Ditaa*" "java" "-jar"
		     org-ditaa-jar-path buffer-file-name)
      (display-buffer "*Ditaa*"))))

;;; Dictionary
(when-library
 nil dictionary
 (global-set-key "\C-cd" 'dictionary-search)

 ;; workarround view-mode capturing <return>
 (eval-after-load "dictionary"
   '(add-hook 'view-mode-hook
	      (lambda () (if (dictionary-mode-p)
			(local-set-key [return] 'link-selected))))))

(provide 'my-misc)

;;; my-misc.el ends here

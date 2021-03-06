;;; my-display.el --- Display settings

;;; Commentary:
;; Author: Andrey Kotlarski <m00naticus@gmail.com>

;;; Code:

(custom-set-variables
 '(column-number-mode t)
 '(display-time-mode t)
 '(frame-title-format "%f (%b)")
 '(size-indication-mode t)
 '(sml/no-confirm-load-theme t)
 '(visual-line-fringe-indicators '(left-curly-arrow
				   right-curly-arrow)))

;;; smart/powerline
(if (require 'smart-mode-line nil t)
    (sml/setup))

;;; TabBar
(when (require 'tabbar nil t)
  (defadvice tabbar-buffer-help-on-tab (after tabbar-add-file-path
					      activate compile)
    "Attach full file path to help message.
If not a file, attach current directory."
    (let* ((tab-buffer (tabbar-tab-value tab))
	   (full-path (buffer-file-name tab-buffer)))
      (if full-path
	  (setq ad-return-value (concat full-path "\n"
					ad-return-value))
	(with-current-buffer tab-buffer
	  (setq ad-return-value (concat default-directory "\n"
					ad-return-value))))))

  (defadvice tabbar-buffer-groups (around tabbar-groups-extension
					  activate compile)
    "Add some rules for grouping tabs to run before original."
    (cond
     ((memq major-mode '(woman-mode completion-list-mode
				    slime-fuzzy-completions-mode))
      (setq ad-return-value (list "Help")))
     ((eq major-mode 'asdf-mode)
      (setq ad-return-value (list "Lisp")))
     ((string-match-p "^*tramp" (buffer-name))
      (setq ad-return-value (list "Tramp")))
     ((string-match-p "^*helm" (buffer-name))
      (setq ad-return-value (list "Helm")))
     ((string-match-p "^emms" (symbol-name major-mode))
      (setq ad-return-value (list "EMMS")))
     ((string-match-p "^*inferior" (buffer-name))
      (setq ad-return-value (list "Process")))
     ((string-match-p "^*slime" (buffer-name))
      (setq ad-return-value (list "Slime")))
     ((memq major-mode '(fundamental-mode org-mode))
      (setq ad-return-value (list "Common")))
     (t ad-do-it)))	      ; if none of above applies, run original

  (setq tabbar-use-images nil)
  (tabbar-mode 1)
  (setq-default mode-line-buffer-identification "")

  (defun next-tab (arg)
    "Go to next tab. With prefix, next group."
    (interactive "P")
    (if arg (tabbar-forward-group)
      (tabbar-forward-tab)))

  (defun prev-tab (arg)
    "Go to previous tab. With prefix, previous group."
    (interactive "P")
    (if arg (tabbar-backward-group)
      (tabbar-backward-tab)))

  (global-set-key (kbd "C-<tab>") 'next-tab)
  (global-set-key (win-or-nix (kbd "C-S-<tab>")
			      (kbd "<C-S-iso-lefttab>"))
		  'prev-tab)

  (add-hook 'org-load-hook
	    (lambda () "Allow tabbar keys in Org."
	      (define-key org-mode-map (kbd "C-<tab>") nil))))

(provide 'my-display)

;;; my-display.el ends here

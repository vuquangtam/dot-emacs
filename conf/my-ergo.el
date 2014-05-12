;;; my-ergo.el --- ErgoEmacs settings

;;; Commentary:
;; Author: Andrey Kotlarski <m00naticus@gmail.com>

;;; Code:

(require 'my-utils)

;;; ErgoEmacs minor mode
(custom-set-variables
 '(ergoemacs-keyboard-layout "colemak")
 '(ergoemacs-theme "standard"))

(when (require 'ergoemacs-mode nil t)
  (defun ergoemacs-change-keyboard (layout)
    "Change ErgoEmacs keyboard bindings according to LAYOUT."
    (interactive (list (completing-read "Enter layout (default us): "
					(ergoemacs-get-layouts)
					nil t nil nil "us")))

    (unless (string-equal layout ergoemacs-keyboard-layout)
      (setq ergoemacs-keyboard-layout layout)
      (ergoemacs-setup-keys)))

  ;;; fixes for some modes
  ;; occur fixes
  (eval-after-load "replace"
    '(define-keys occur-mode-map
       "n" 'occur-next "p" 'occur-prev
       "o" 'occur-mode-display-occurrence
       "\C-c\C-c" 'occur-mode-goto-occurrence-other-window))

  (or +old-emacs+
      (when-library
       nil helm
       (ergoemacs-key "M-V" 'helm-show-kill-ring)))

  (when-library
   nil paredit
   (add-hook 'activate-lisp-minor-modes-hook
	     (lambda () (ergoemacs-define-overrides
		    (define-keys paredit-mode-map
		      "\M-d" nil "\M-r" nil
		      "\M-s" nil "\M-S" nil
		      "\M-J" nil "\M-;" nil
		      (kbd "<f9>") 'paredit-split-sexp
		      (kbd "<f10>") 'paredit-raise-sexp
		      (kbd "S-<f9>") 'paredit-join-sexps
		      (kbd "S-<f10>") 'paredit-splice-sexp
		      [remap kill-visual-line] 'paredit-kill)))))

  (when-library
   nil slime
   (add-hook 'slime-connected-hook
	     (lambda () (ergoemacs-define-overrides
		    (define-keys slime-mode-map
		      (kbd "<f11>") 'slime-next-note
		      (kbd "<f12>") 'slime-previous-note))))

   (add-hook 'slime-connected-hook
	     (lambda ()
	       (ergoemacs-define-overrides
		(define-keys slime-repl-mode-map
		  "\M-r" nil "\M-s" nil
		  (kbd "<f11>") 'slime-repl-previous-input
		  (kbd "<f12>") 'slime-repl-next-input
		  (kbd "S-<f11>")
		  'slime-repl-previous-matching-input
		  (kbd "S-<f12>")
		  'slime-repl-next-matching-input)))))

  (setq ergoemacs-handle-ctl-c-or-ctl-x 'only-C-c-and-C-x
	ergoemacs-use-ergoemacs-metaleft nil
	ergoemacs-use-ergoemacs-metaright nil)

  (ergoemacs-key "\C-f" 'search-forward-regexp)
  (ergoemacs-key (kbd "C-S-f") 'search-backward-regexp)

  ;; activate
  (ergoemacs-mode 1))

(provide 'my-ergo)

;;; my-ergo.el ends here

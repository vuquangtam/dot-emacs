;;; my-ergo.el --- ErgoEmacs settings

;;; Commentary:
;; Author: Andrey Kotlarski <m00naticus@gmail.com>

;;; Code:

(require 'my-utils)

;;; ErgoEmacs minor mode
(custom-set-variables
 '(ergoemacs-keyboard-layout "colemak")
 '(ergoemacs-theme "lvl3"))

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
  (when-library
   t doc-view
   (add-to-list
    'ergoemacs-minor-mode-layout-lvl3
    '(doc-view-mode-hook
      ((isearch-forward doc-view-search doc-view-mode-map)
       (isearch-backward doc-view-search-backward doc-view-mode-map)
       (next-line doc-view-next-line-or-next-page doc-view-mode-map)
       (previous-line doc-view-previous-line-or-previous-page
		      doc-view-mode-map)))))

  ;; occur fixes
  (eval-after-load "replace"
    '(define-keys occur-mode-map
       "n" 'occur-next "p" 'occur-prev
       "o" 'occur-mode-display-occurrence
       "\C-c\C-c" 'occur-mode-goto-occurrence-other-window))

  (when-library
   nil browse-kill-ring
   (ergoemacs-key "M-V" 'browse-kill-ring))

  (when-library
   nil paredit
   (add-to-list
    'ergoemacs-minor-mode-layout-lvl3
    '(activate-lisp-minor-modes-hook
      (("M-r" nil paredit-mode-map)
       ("M-R" nil paredit-mode-map)
       ("M-S" nil paredit-mode-map)
       ("M-J" nil paredit-mode-map)
       ("M-;" nil paredit-mode-map)
       ("<f9>" paredit-split-sexp paredit-mode-map)
       ("<f10>" paredit-raise-sexp paredit-mode-map)
       ("S-<f9>" paredit-join-sexps paredit-mode-map)
       ("S-<f10>" paredit-splice-sexp paredit-mode-map)
       (comment-dwim paredit-comment-dwim paredit-mode-map)
       (backward-kill-word paredit-backward-kill-word
			   paredit-mode-map)
       (forward-kill-word paredit-forward-kill-word paredit-mode-map)
       (delete-backward-char paredit-backward-delete paredit-mode-map)
       (delete-char paredit-forward-delete paredit-mode-map)
       (kill-line paredit-kill paredit-mode-map)))))

  (when-library
   nil slime
   (add-to-list
    'ergoemacs-minor-mode-layout-lvl3
    '(slime-connected-hook
      (("M-n" nil slime-mode-map)
       ("M-p" nil slime-mode-map)
       ("<f11>" slime-next-note slime-mode-map)
       ("<f12>" slime-previous-note slime-mode-map))))

   (add-to-list
    'ergoemacs-minor-mode-layout-lvl3
    '(slime-repl-mode-hook
      (("M-n" nil slime-repl-mode-map)
       ("M-p" nil slime-repl-mode-map)
       ("M-r" nil slime-repl-mode-map)
       ("M-s" nil slime-repl-mode-map)
       ("<f11>" slime-repl-previous-input slime-repl-mode-map)
       ("<f12>" slime-repl-next-input slime-repl-mode-map)
       ("S-<f11>" slime-repl-previous-matching-input
	slime-repl-mode-map)
       ("S-<f12>" slime-repl-next-matching-input
	slime-repl-mode-map)))))

  (delete "C-d" ergoemacs-redundant-keys)
  (delete "C-j" ergoemacs-redundant-keys)

  ;; activate
  (ergoemacs-mode 1)

  (ergoemacs-key "C-e" 'search-forward-regexp)
  (ergoemacs-key "C-S-E" 'search-backward-regexp)

  (ergoemacs-fixed-key "<M-up>" nil)
  (ergoemacs-fixed-key "<M-down>" nil))

(provide 'my-ergo)

;;; my-ergo.el ends here

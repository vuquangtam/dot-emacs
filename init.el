;;; init.el --- Andrey Kotlarski's .emacs

;;; Commentary:
;; Author: Andrey Kotlarski <m00naticus@gmail.com>

;;; Code:

;;; do some OS recognition
(defconst +win-p+ (eval-when-compile
		    (memq system-type '(windows-nt ms-dos)))
  "Windows detection.")

(defconst +old-emacs+ (< (string-to-number emacs-version) 24)
  "Not using latest Emacs?")

(defmacro win-or-nix (win &rest nix)
  "OS conditional.  WIN may be a list and is executed on windows systems.
NIX forms are executed on all other platforms."
  (if +win-p+
      (if (consp win)
	  (let ((form (car win)))
	    (cond ((not (consp form)) win)
		  ((cadr win) `(progn ,@win))
		  (t form)))
	win)
    (if (cadr nix) `(progn ,@nix)
      (car nix))))

;;; set some path constants.
(defconst +home-path+
  (win-or-nix
   (cond ((string-match "\\(.*[/\\]home[/\\]\\)" exec-directory)
	  (match-string 0 exec-directory)) ; usb
	 ((file-exists-p (concat exec-directory "../../home"))
	  (file-truename (concat exec-directory "../../home/")))
	 (t #1=(concat (getenv "HOME") "/")))
   #1#)
  "Home path.")

(defconst +conf-path+ (concat user-emacs-directory "conf/")
  "Elisp configuration path.")

;;; add `+conf-path+' and subdirs to `load-path'
(add-to-list 'load-path +conf-path+)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; load configurations

(when (or (require 'package nil t)
	  (require 'package-23 nil t))
  (defadvice package-activate (around package-safe-activate
				      activate compile)
    (condition-case ex
	ad-do-it
      (error (message "Error on package activation of %s: %s"
		      package ex))))

  (package-initialize)
  (setq package-enable-at-startup nil))

(require 'my-display)
(require 'my-themes)
(require 'my-custom)
(require 'my-ergo)

(with-idle-timers
 2 ((win-or-nix (require 'my-windows)))
 ((require 'my-mail) (message "Loaded mail settings"))
 ((require 'my-net) (message "Loaded network settings"))
 ((require 'my-lisp) (message "Loaded lisp settings"))
 ((require 'my-prog) (message "Loaded programming settings"))
 ((require 'my-fun) (message "Loaded fun settings"))
 ((require 'my-misc) (message "All settings loaded")))

;;; init.el ends here

;;; General Emacs behavior
;;; Settings in this section relate to the behavior of Emacs independently of
;;; the used mode or the ivoked command.

;; Display column number.
;; Useful in some language to identify a compile error.
(setq column-number-mode t)

;; Put autosave files in .cache directory instead of producing garbage tilde
;; file everywhere.
(setq backup-directory-alist `((".*" . , "~/.cache/emacs")))

;; Theme customization
;; Use the default Wombat theme but with the background matching the default
;; terminal background for a better integration.
;; Also change some faces which don't fit well with dark backgrounds.
(custom-set-variables
 '(custom-enabled-themes (quote (wombat))))
(custom-set-faces
 '(default      ((t (:background "unspecified-bg"))))
 '(diff-removed ((t (:background "#e5786d"))))
 '(diff-added   ((t (:background "#337733"))))
 '(diff-header  ((t (:background "#444444"))))
 )


;;; Additional modes loading
;;; Load additional Emacs modes installed in /usr/share/emacs/site-lisp

;; Add go mode.
;(add-to-list 'load-path "/usr/share/emacs/site-lisp/go-mode/")
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

;; Add haskell mode.
;(add-to-list 'load-path "/usr/share/emacs/site-lisp/haskell-mode/")
(load "haskell-mode-autoloads")
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentations)

;; Add lua mode.
(autoload 'lua-mode "lua-mode" nil t)
(add-to-list 'auto-mode-alist '("\.lua$" . lua-mode))


;;; Per mode Emacs behavior
;;; Settings in this section modify the behavior of Emacs depending on the used
;;; mode.

;; Set indentation length for C to 8.
;; See https://www.kernel.org/doc/html/v4.10/process/coding-style.html
(setq-default c-basic-offset  8
	      tab-width       8
	      indent-tab-mode t)

;; Set indentation length for Java to 4
;; Java is much more verbose than C, so need more space to write.
(add-hook 'java-mode-hook
 (lambda () (setq c-basic-offset   4
		  tab-width        4
		  indent-tabs-mode t)))

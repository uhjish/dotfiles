;;; bootstrap
; (setq auser:el-get-packages (loop for src in el-get-sources
;                                   collect (el-get-source-name src)))
;starter-kit starter-kit-lisp starter-kit-eshell
;                       starter-kit-bindings scpaste
;                       clojure-mode clojure-test-mode ess
;                       paredit
;                       markdown-mode yaml-mode tuareg
;                       marmalade oddmuse scpaste

(setq el-get-dir (concat (file-name-directory load-file-name) "el-get") )

(add-to-list 'load-path (concat el-get-dir "/el-get"))

(unless (require 'el-get nil t)
	(url-retrieve "https://raw.github.com/dimitri/el-get/master/el-get-install.el" (lambda (s) (goto-char (point-max)) (eval-print-last-sexp))))

; Traditional packages
(setq auser-el-get-packages
			'(el-get
				 paredit
				 nav
				 lusty-explorer
         clojure-mode
         scala-mode
         markdown-mode
         vimpulse
				 ))

; Any customizations on top of packages
(setq auser-el-get-custom-sources
			'())

(defun sync-packages ()
  "Synchronize packages"
  (interactive)
  ;; use a shallow clone for all git packages
  (setq el-get-git-shallow-clone t)

	;(el-get 'sync '(el-get package))
	(require 'package)
	(add-to-list 'package-archives '("tromey" . "http://tromey.com/elpa/"))
	(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
	(package-initialize)
	; define my packages
  (setq my-packages
  			(append auser-el-get-packages
  							(mapcar 'el-get-source-name auser-el-get-custom-sources)))
  (el-get 'sync my-packages))

(sync-packages)
(provide 'auser-el-get)

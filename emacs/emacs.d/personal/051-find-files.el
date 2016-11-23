; (add-to-list 'load-path (concat libfiles-dir "/prioject-root"))
; (require 'project-root)

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories
   "~/.emacs.d/.cask/24.3.50.1/elpa/auto-complete-20130724.1750/dict")
(ac-config-default)
(setq ac-ignore-case nil)
(add-to-list 'ac-modes 'enh-ruby-mode)
(add-to-list 'ac-modes 'web-mode)

; (setq project-roots
;       `(("Git Project"
;          :root-contains-files (".git")
;          )))

; ;; http://www.emacswiki.org/emacs/InteractivelyDoThings
; (defun nm-ido-project-files ()
;   "Use ido to select a file from the project."
;   (interactive)
;   (let (my-project-root project-files tbl)
;     (unless project-details (project-root-fetch))
;     (setq my-project-root (cdr project-details))
;     ;; get project files
;     (setq project-files 
;       (split-string 
;         (shell-command-to-string 
;           ;; (concat "find "
;           ;;   my-project-root
;           ;;   " \\( -name \"*.svn\" -o -name \"*.git\" -name \"node_modules\" -name \"bower_components\" -name \"node_modules\" \\) -prune -o -type f -print | grep -E -v \"\.(pyc)$\""
;           ;;   )

;           (concat "cd " my-project-root " && git ls-files | awk '{print \"" my-project-root "\" $1}'")

;           ) "\n"))

;     ;; populate hash table (display repr => path)
;     (setq tbl (make-hash-table :test 'equal))
;     (let (ido-list)
;       (mapc (lambda (path)
;               ;; format path for display in ido list
;               (setq key (replace-regexp-in-string "\\(.*?\\)\\([^/]+?\\)$" "\\2|\\1" path))
;               ;; strip project root
;               (setq key (replace-regexp-in-string my-project-root "" key))
;               ;; remove trailing | or /
;               (setq key (replace-regexp-in-string "\\(|\\|/\\)$" "" key))
;               (puthash key path tbl)
;               (push key ido-list)
;               )
;         project-files)
;       (find-file (gethash (ido-completing-read "project-files: " ido-list) tbl)))))

; ; (define-key viper-comma-map (kbd "p") 'nm-ido-project-files)
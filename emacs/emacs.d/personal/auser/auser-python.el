(push "~/.virtualenvs/default/bin" exec-path)
(setenv "PATH"
        (concat
         "~/.virtualenvs/default/bin" ":"
         (getenv "PATH")
         ))


(add-hook 'python-mode-hook 'my-python-hook)

(defun my-python-hook ()
  (define-key python-mode-map (kbd "RET") 'newline-and-indent))

(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'jedi:ac-setup)

(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")

; (pymacs-load "ropemacs" "rope-")
; (elpy-enable)

(provide 'auser-python)
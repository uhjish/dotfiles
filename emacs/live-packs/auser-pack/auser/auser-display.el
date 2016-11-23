;; PARENT MODE
(setq-default inhibit-startup-screen t)

(transient-mark-mode 1) ; highlight text selection
(delete-selection-mode 1) ; delete seleted text when typing

;; Buffers
(global-set-key (kbd "s-{") 'previous-buffer)
(global-set-key (kbd "s-}") 'next-buffer)
(global-set-key (kbd "s-<") 'beginning-of-buffer)
(global-set-key (kbd "s->") 'end-of-buffer)
(define-key global-map (kbd "RET") 'newline-and-indent)

;; Hightlight code beetween {}
(require 'paren)
(setq show-paren-style 'expression)
(show-paren-mode 1)

;; custom font
(when (not (eq window-system nil))
  (progn
    (set-frame-height (selected-frame) 60)
    (set-frame-width (selected-frame) 120)
    (set-face-attribute 'default nil :font "Menlo-12"))
  )

(global-font-lock-mode 1) ; turn on syntax coloring

(show-paren-mode 1) ; turn on paren match highlighting
(setq show-paren-style 'expression) ; highlight entire bracket expression

(global-linum-mode 1) ; display line numbers in margin. Emacs 23 only.
(column-number-mode 1)

(tool-bar-mode -1)

(provide 'auser-display)

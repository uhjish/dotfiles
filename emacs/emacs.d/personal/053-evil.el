;; Turn on viper mode
(setq evil-mode t)
(evil-mode 1)        ;; enable evil-mode
; (turn-on-evil-mode)

(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

; Tabs
; (define-key evil-normal-state-map (kbd "C-0") (lambda() (interactive) (elscreen-goto 0)))
; (define-key evil-normal-state-map (kbd "C- ") (lambda() (interactive) (elscreen-goto 0)))
; (define-key evil-normal-state-map (kbd "C-1") (lambda() (interactive) (elscreen-goto 1)))
; (define-key evil-normal-state-map (kbd "C-2") (lambda() (interactive) (elscreen-goto 2)))
; (define-key evil-normal-state-map (kbd "C-3") (lambda() (interactive) (elscreen-goto 3)))
; (define-key evil-normal-state-map (kbd "C-4") (lambda() (interactive) (elscreen-goto 4)))
; (define-key evil-normal-state-map (kbd "C-5") (lambda() (interactive) (elscreen-goto 5)))
; (define-key evil-normal-state-map (kbd "C-6") (lambda() (interactive) (elscreen-goto 6)))
; (define-key evil-normal-state-map (kbd "C-7") (lambda() (interactive) (elscreen-goto 7)))
; (define-key evil-normal-state-map (kbd "C-8") (lambda() (interactive) (elscreen-goto 8)))
; (define-key evil-normal-state-map (kbd "C-9") (lambda() (interactive) (elscreen-goto 9)))
; (define-key evil-insert-state-map (kbd "C-0") (lambda() (interactive) (elscreen-goto 0)))
; (define-key evil-insert-state-map (kbd "C- ") (lambda() (interactive) (elscreen-goto 0)))
; (define-key evil-insert-state-map (kbd "C-1") (lambda() (interactive) (elscreen-goto 1)))
; (define-key evil-insert-state-map (kbd "C-2") (lambda() (interactive) (elscreen-goto 2)))
; (define-key evil-insert-state-map (kbd "C-3") (lambda() (interactive) (elscreen-goto 3)))
; (define-key evil-insert-state-map (kbd "C-4") (lambda() (interactive) (elscreen-goto 4)))
; (define-key evil-insert-state-map (kbd "C-5") (lambda() (interactive) (elscreen-goto 5)))
; (define-key evil-insert-state-map (kbd "C-6") (lambda() (interactive) (elscreen-goto 6)))
; (define-key evil-insert-state-map (kbd "C-7") (lambda() (interactive) (elscreen-goto 7)))
; (define-key evil-insert-state-map (kbd "C-8") (lambda() (interactive) (elscreen-goto 8)))
; (define-key evil-insert-state-map (kbd "C-9") (lambda() (interactive) (elscreen-goto 9)))

; Leader, like in vim
(setq evil-leader/in-all-states 1)
(global-evil-leader-mode)
(evil-leader/set-leader ",")

(setq-default tab-width 2)
(setq-default evil-shift-width 2)
;; Some modes have their own tab-width variables which need to be overridden.
(setq-default css-indent-offset 2)


; Searching
(require 'evil-search-highlight-persist)
(global-evil-search-highlight-persist t)

; Clear highlights with <leader> + SPACE
(evil-leader/set-key "SPC" 'evil-search-highlight-persist-remove-all)

(evil-leader/set-key
  "h" 'help
  "b" 'ido-switch-buffer)

;; Ensure we evil-leader works in non-editing modes like magit. This is referenced from evil-leader's README.
(setq evil-leader/no-prefix-mode-rx '("magit-.*-mode"))

(defun backward-kill-line (arg)
  "Delete backward (Ctrl-u) as in Bash."
  (interactive "p")
  (kill-line (- 1 arg)))

;;
;; Ag (silver searcher)
;;
;; Note that ag mode configures itself to start in Evil's "motion" state.
;; compile-goto-error is what the "Return" key does.
(evil-define-key 'motion ag-mode-map "o" 'compile-goto-error)


; Powerline
;(powerline-evil-vim-color-theme)
(display-time-mode t)

; Long line wrapping
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

; Page up and down
(define-key evil-normal-state-map (kbd "C-k") (lambda ()
                    (interactive)
                    (evil-scroll-up nil)))
(define-key evil-normal-state-map (kbd "C-j") (lambda ()
                        (interactive)
                        (evil-scroll-down nil)))

; AUTO INDENT!!!!
(define-key global-map (kbd "RET") 'newline-and-indent)




(provide 'auser-evil)

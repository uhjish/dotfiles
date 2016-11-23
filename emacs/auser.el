(setq this-dir (file-name-directory load-file-name))
(add-to-list 'load-path (concat this-dir "/auser"))

(defun remap-evil-lisp-mode-keys ()
  ;; (evil-define-key 'normal evil-paredit-mode-map
  ;;   (kbd "j") 'evil-paredit-delete
  ;;   (kbd "d") 'evil-backward-char
  ;;   (kbd "c") 'evil-paredit-change
  ;;   (kbd "y") 'evil-paredit-yank
  ;;   (kbd "D") 'evil-paredit-delete-line
  ;;   (kbd "C") 'evil-paredit-change-line
  ;;   (kbd "S") 'evil-paredit-change-whole-line
  ;;   (kbd "S") 'evil-paredit-change-whole-line
  ;;   (kbd "S") 'evil-paredit-change-whole-line
  ;;   (kbd "Y") 'evil-paredit-yank-line
  ;;   (kbd "X") 'paredit-backward-delete
  ;;   (kbd "x") 'paredit-forward-delete)

  (define-key evil-lisp-state-map "d" 'evil-backward-char)
  (define-key evil-lisp-state-map "h" 'evil-next-visual-line)
  (define-key evil-lisp-state-map "t" 'evil-previous-visual-line)
  (define-key evil-lisp-state-map "n" 'evil-forward-char)

  (define-key evil-lisp-state-map "j" nil)
  (define-key evil-lisp-state-map "J" nil)

  (defconst evil-lisp-customizations
    '(("js" . sp-kill-symbol)
      ("Js" . sp-backward-kill-symbol)
      ("jw" . sp-kill-word)
      ("Jw" . sp-backward-kill-word)
      ("jx" . sp-kill-sexp)
      ("Jx" . sp-backward-kill-sexp)

      ("k" . sp-transpose-sexp)

      ("d" . sp-backward-symbol)
      ("D" . sp-backward-sexp)
      ("h" . lisp-state-next-closing-paren)
      ("H" . sp-join-sexp)
      ("t" . lisp-state-prev-opening-paren)
      ("T" . lisp-state-forward-symbol)
      ("n" . lisp-state-forward-symbol)
      ("N" . sp-forward-sexp)))

  (eval-after-load 'evil-lisp-state
    (dolist (x evil-lisp-customizations)
      (let ((key (car x))
            (cmd (cdr x)))
        (eval
         `(progn
            (define-key evil-lisp-state-map ,(kbd key) ',cmd)
            ;; (if evil-lisp-state-global
            ;;     (evil-leader/set-key
            ;;       ,(kbd (concat evil-lisp-state-leader-prefix " " key))
            ;;       (evil-lisp-state-enter-command ,cmd))
            ;;   (dolist (mm evil-lisp-state-major-modes)
            ;;     (evil-leader/set-key-for-mode mm
            ;;       ,(kbd (concat evil-lisp-state-leader-prefix " " key))
            ;;       (evil-lisp-state-enter-command ,cmd))))
            ))))))

(defun remap-helm-keys ()
  (with-eval-after-load 'helm
    (define-key helm-map (kbd "C-h") 'helm-next-line)
    (define-key helm-map (kbd "C-t") 'helm-previous-line)
    (define-key helm-map (kbd "C-n") 'helm-next-source)
    (define-key helm-map (kbd "C-d") 'helm-previous-source)
    (define-key helm-find-files-map (kbd "C-h") 'helm-next-line)
    (define-key helm-find-files-map (kbd "C-t") 'helm-previous-line))
  (with-eval-after-load 'helm-projectile-find-file-map
    (define-key helm-projectile-find-file-map (kbd "C-h") 'helm-next-line)
    (define-key helm-projectile-find-file-map (kbd "C-t") 'helm-previous-line)))

(defun remap-dired-keys ()
  (eval-after-load 'dired
    '(progn
       ;; use the standard Dired bindings as a base
       (evil-make-overriding-map dired-mode-map 'normal t)
       (evil-define-key 'normal dired-mode-map
         "d" 'evil-backward-char
         "h" 'evil-next-line
         "t" 'evil-previous-line
         "n" 'evil-forward-char
         "H" 'dired-goto-file
         "T" 'dired-do-kill-lines
         "r" 'dired-do-redisplay))))

(defun remap-auto-completion-keys ()
  (with-eval-after-load 'company
    (define-key company-active-map (kbd "C-d") 'company-show-doc-buffer)
    (define-key company-active-map (kbd "C-h") 'company-select-next)
    (define-key company-active-map (kbd "C-t") 'company-select-previous)
    (define-key company-active-map (kbd "C-l") 'company-complete-selection)))

(defun add-paredit-hooks ()
  (add-hook 'clojure-mode-hook    (lambda () (paredit-mode 1)))
  (add-hook 'cider-repl-mode-hook (lambda () (paredit-mode 1)))
  (add-hook 'emacs-lisp-mode-hook (lambda () (paredit-mode 1))))

(defun add-clojure-hooks ()
  (add-hook 'cider-repl-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'company-mode))

(defun remap-evil-for-dvp ()
  ;; DVP
  (define-key evil-normal-state-map "d" 'evil-backward-char)
  (define-key evil-normal-state-map "D" 'evil-delete-line)
  (define-key evil-normal-state-map "h" 'evil-next-line)
  (define-key evil-normal-state-map "t" 'evil-previous-line)
  (define-key evil-normal-state-map "n" 'evil-forward-char)

  (define-key evil-normal-state-map (kbd "<right>") 'evil-window-increase-width)
  (define-key evil-normal-state-map (kbd "<left>") 'evil-window-decrease-width)
  (define-key evil-normal-state-map (kbd "<down>") 'evil-window-increase-height)
  (define-key evil-normal-state-map (kbd "<up>")   'evil-window-decrease-height)

  (define-key evil-motion-state-map "d" 'evil-backward-char)
  (define-key evil-motion-state-map "h" 'evil-next-line)
  (define-key evil-motion-state-map "t" 'evil-previous-line)
  (define-key evil-motion-state-map "n" 'evil-forward-char)

  (define-key evil-motion-state-map "k" 'evil-find-char-to)
  (define-key evil-motion-state-map "K" 'evil-find-char-to-backward)

  (define-key evil-window-map "d" 'evil-window-left)
  (define-key evil-window-map "D" 'evil-window-move-far-left)
  (define-key evil-window-map "h" 'evil-window-down)
  (define-key evil-window-map "H" 'evil-window-move-very-bottom)
  (define-key evil-window-map "t" 'evil-window-up)
  (define-key evil-window-map "T" 'evil-window-move-very-top)
  (define-key evil-window-map "n" 'evil-window-right)
  (define-key evil-window-map "N" 'evil-window-move-far-right)

  (define-key evil-normal-state-map "j" 'evil-delete)
  (define-key evil-motion-state-map "j" 'evil-delete)

  (define-key evil-motion-state-map "l" 'evil-search-next)
  (define-key evil-motion-state-map "L" 'evil-search-previous)

  (define-key evil-normal-state-map (kbd "C-t") nil))

(defun remap-org-mode-keys ()
  (eval-after-load 'evil-org
    '(progn
       ;; normal state shortcuts
       (evil-define-key 'normal evil-org-mode-map
         "d" 'evil-backward-char
         "h" 'evil-next-line
         "t" 'evil-previous-line
         "n" 'evil-forward-char
         "gd" 'outline-up-heading
         "gh" (if (fboundp 'org-forward-same-level) ;to be backward compatible with older org version
                  'org-forward-same-level
                'org-forward-heading-same-level)
         "gt" (if (fboundp 'org-backward-same-level)
                  'org-backward-same-level
                'org-backward-heading-same-level)
         "gn" 'outline-next-visible-heading
         "k" 'org-todo
         "K" '(lambda () (interactive) (evil-org-eol-call (lambda() (org-insert-todo-heading nil))))
         "D" 'org-beginning-of-line
         "N" 'org-end-of-line
         "-" 'org-end-of-line
         "_" 'org-beginning-of-line
         "+" 'org-cycle-list-bullet
         (kbd "TAB") 'org-cycle)

       ;; normal & insert state shortcuts.
       (mapc (lambda (state)
               (evil-define-key state evil-org-mode-map
                 (kbd "M-n") 'org-metaright
                 (kbd "M-d") 'org-metaleft
                 (kbd "M-t") 'org-metaup
                 (kbd "M-h") 'org-metadown
                 (kbd "M-N") 'org-shiftmetaright
                 (kbd "M-D") 'org-shiftmetaleft
                 (kbd "M-T") 'org-shiftmetaup
                 (kbd "M-H") 'org-shiftmetadown
                 (kbd "M-k") '(lambda () (interactive)
                                (evil-org-eol-call
                                 '(lambda()
                                    (org-insert-todo-heading nil)
                                    (org-metaright))))))
             '(normal insert)))))

(defun add-vim-like-paredit-bindings ()
  (evil-leader/set-key ">" 'paredit-forward-slurp-sexp)
  (evil-leader/set-key "<" 'paredit-forward-barf-sexp))

(defun setup-C-c-key ()
  ;; C-c as general purpose escape key sequence.
  (defun my-esc (prompt)
  "Functionality for escaping generally.  Includes exiting Evil insert state and C-g binding. "
    (cond
    ;; If we're in one of the Evil states that defines [escape] key, return [escape] so as
    ;; Key Lookup will use it.
     ((or (evil-insert-state-p)
          (evil-normal-state-p)
          (evil-replace-state-p)
          (evil-visual-state-p)
          (evil-lisp-state-p)) [escape])
    ;; This is the best way I could infer for now to have C-c work during evil-read-key.
    ;; Note: As long as I return [escape] in normal-state, I don't need this.
    ;;((eq overriding-terminal-local-map evil-read-key-map) (keyboard-quit) (kbd ""))
    (t (kbd "C-g"))))

  (define-key key-translation-map (kbd "C-c") 'my-esc)
  ;; Works around the fact that Evil uses read-event directly when in operator state, which
  ;; doesn't use the key-translation-map.
  (define-key evil-operator-state-map (kbd "C-c") 'keyboard-quit)

  ;; Not sure what behavior this changes, but might as well set it, seeing the Elisp manual's
  ;; documentation of it.
  ;;(set-quit-char (kbd "C-c"))
  )

(provide 'auser-init)

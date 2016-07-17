;;;
;;; minizinc.el -- major mode for editing MiniZinc under Emacs
;;; Very simple hack, heavily based on Prolog mode prolog.el.
;;;
;;; Created by Hakan Kjellerstrand (hakank@gmail.com)

;;; (For other MiniZinc related stuff see http://www.hakank.org/minizinc .)
;;;
;;; Original copyright text of prolog.el below.

;;;
;;; minizinc.el --- major mode for editing and running Prolog under Emacs

;; Copyright (C) 1986, 1987, 2001, 2002, 2003, 2004, 2005, 2006, 2007
;; Free Software Foundation, Inc.

;; ;;; Author: Masanobu UMEDA <umerin@mse.kyutech.ac.jp>
;; Author: Hakan Kjellerstrand <hakank@gmail.com>
;; Keywords: languages

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This package provides a major mode for editing MiniZinc.  
;; Note: The interactive stuff don't work since MiniZinc don't support
;; interactive session (like Prolog).

;;; Code:

(defvar comint-prompt-regexp)


(defgroup minizinc nil
  "Major mode for editing and running MiniZinc under Emacs."
  :link '(custom-group-link :tag "Font Lock Faces group" font-lock-faces)
  :group 'languages)


(defcustom minizinc-program-name
  (let ((names '("minizinc")))
    (while (and names
		(not (executable-find (car names))))
      (setq names (cdr names)))
    (or (car names) "mzx.pl"))
  "Program name for invoking an inferior MiniZinc with `run-minizinc'."
  :type 'string
  :group 'minizinc)

(defcustom minizinc-consult-string "reconsult(user).\n"
  "(Re)Consult mode..... "
  :type 'string
  :group 'minizinc)

(defcustom minizinc-compile-string "compile(user).\n"
  "Compile mode (for Minizinc)."
  :type 'string
  :group 'minizinc)

(defcustom minizinc-eof-string "end_of_file.\n"
  "String that represents end of file for Minizinc.
When nil, send actual operating system end of file."
  :type 'string
  :group 'minizinc)

(defcustom minizinc-indent-width 4
  "Level of indentation in Minizinc buffers."
  :type 'integer
  :group 'minizinc)

(defvar minizinc-font-lock-keywords
  '(("\\(#[<=]=>\\|:-\\)\\|\\(#=\\)\\|\\(#[#<>\\/][=\\/]*\\|!\\)"
     0 font-lock-keyword-face)
    ("\\<\\(of\\|if\\|then\\|else\\|elseif\\|endif\\|int_search\\|set_search\\|constraint\\|length\\|solve\\|satisfy\\|array\\|var\\|int\\|float\\|sum\\|in\\|set\\|forall\\|predicate\\|bool2int\\|int2float\\|ceil\\|show\\|let\\|minimize\\|maximize\\)\\>"
     1 font-lock-keyword-face)
    ("^\\(\\sw+\\)\\s-*\\((\\(.+\\))\\)*"
     (1 font-lock-function-name-face)
     (3 font-lock-variable-name-face)))
  "Font-lock keywords for Minizinc mode.")

(defvar minizinc-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?\\ "\\" table)
    (modify-syntax-entry ?/ ". 14" table)
    (modify-syntax-entry ?* ". 23" table)
    (modify-syntax-entry ?+ "." table)
    (modify-syntax-entry ?- "." table)
    (modify-syntax-entry ?= "." table)
    (modify-syntax-entry ?% "<" table)
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?< "." table)
    (modify-syntax-entry ?> "." table)
    (modify-syntax-entry ?\' "\"" table)
    table))

(defvar minizinc-mode-abbrev-table nil)
(define-abbrev-table 'minizinc-mode-abbrev-table ())

(defun minizinc-mode-variables ()
  (make-local-variable 'paragraph-separate)
  (setq paragraph-separate (concat "%\\|$\\|" page-delimiter)) ;'%..'
  (make-local-variable 'paragraph-ignore-fill-prefix)
  (setq paragraph-ignore-fill-prefix t)
  (make-local-variable 'imenu-generic-expression)
  (setq imenu-generic-expression '((nil "^\\sw+" 0)))
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'minizinc-indent-line)
  (make-local-variable 'comment-start)
  (setq comment-start "% ")
  (make-local-variable 'comment-start-skip)
  (setq comment-start-skip "\\(?:%+\\|/\\*+\\)[ \t]*")
  (make-local-variable 'comment-end-skip)
  (setq comment-end-skip "[ \t]*\\(\n\\|\\*+/\\)")
  (make-local-variable 'comment-column)
  (setq comment-column 48))

(defvar minizinc-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\e\C-x" 'minizinc-consult-region)
    (define-key map "\C-c\C-l" 'inferior-minizinc-load-file)
    (define-key map "\C-c\C-z" 'switch-to-minizinc)
    map))
 
(easy-menu-define minizinc-mode-menu minizinc-mode-map "Menu for Minizinc mode."
  ;; Mostly copied from scheme-mode's menu.
  ;; Not tremendously useful, but it's a start.
  '("Minizinc"
    ["Indent line" indent-according-to-mode t]
    ["Indent region" indent-region t]
    ["Comment region" comment-region t]
    ["Uncomment region" uncomment-region t]
    "--"
    ["Run interactive Minizinc session" run-minizinc t]
    ))

;;;###autoload
(defun minizinc-mode ()
  "Major mode for editing Minizinc code for Minizincs.
Blank lines and `%...' separate paragraphs.  `%'s start comments.
Commands:
\\{minizinc-mode-map}
Entry to this mode calls the value of `minizinc-mode-hook'
if that value is non-nil."
  (interactive)
  (kill-all-local-variables)
  (use-local-map minizinc-mode-map)
  (set-syntax-table minizinc-mode-syntax-table)
  (setq major-mode 'minizinc-mode)
  (setq mode-name "Minizinc")
  (minizinc-mode-variables)
  (set (make-local-variable 'comment-add) 0)
  ;; font lock
  (setq font-lock-defaults '(minizinc-font-lock-keywords
                             nil nil nil
                             beginning-of-line))
  (run-mode-hooks 'minizinc-mode-hook))

(defun minizinc-indent-line ()
  "Indent current line as Minizinc code.
With argument, indent any additional lines of the same clause
rigidly along with this one (not yet)."
  (interactive "p")
  (let ((indent (minizinc-indent-level))
	(pos (- (point-max) (point))))
    (beginning-of-line)
    (indent-line-to indent)
    (if (> (- (point-max) pos) (point))
	(goto-char (- (point-max) pos)))))

(defun minizinc-indent-level ()
  "Compute Minizinc indentation level."
  (save-excursion
    (beginning-of-line)
    (skip-chars-forward " \t")
    (cond
     ((looking-at "%") 0)		;Large comment starts
     ((looking-at "%[^%]") comment-column) ;Small comment starts
     ((bobp) 0)				;Beginning of buffer
     (t
      (let ((empty t) ind more less)
	(if (looking-at ")")
	    (setq less t)		;Find close
	  (setq less nil))
	;; See previous indentation
	(while empty
	  (forward-line -1)
	  (beginning-of-line)
 	  (if (bobp)
 	      (setq empty nil)
 	    (skip-chars-forward " \t")
 	    (if (not (or (looking-at "%[^%]") (looking-at "\n")))
 		(setq empty nil))))
 	(if (bobp)
 	    (setq ind 0)		;Beginning of buffer
	  (setq ind (current-column)))	;Beginning of clause
	;; See its beginning
	(if (looking-at "%[^%]")
	    ind
	  ;; Real minizinc code
	  (if (looking-at "(")
	      (setq more t)		;Find open
	    (setq more nil))
	  ;; See its tail
	  (end-of-minizinc-clause)
	  (or (bobp) (forward-char -1))
	  (cond ((looking-at "[,(;>]")
		 (if (and more (looking-at "[^,]"))
		     (+ ind minizinc-indent-width) ;More indentation
		   (max tab-width ind))) ;Same indentation
		((looking-at "-") tab-width) ;TAB
		((or less (looking-at "[^.]"))
		 (max (- ind minizinc-indent-width) 0)) ;Less indentation
		(t 0))			;No indentation
	  )))
     )))

(defun end-of-minizinc-clause ()
  "Go to end of clause in this line."
  (beginning-of-line 1)
  (let* ((eolpos (save-excursion (end-of-line) (point))))
    (if (re-search-forward comment-start-skip eolpos 'move)
	(goto-char (match-beginning 0)))
    (skip-chars-backward " \t")))

;;;
;;; Inferior minizinc mode
;;;
(defvar inferior-minizinc-mode-map
  (let ((map (make-sparse-keymap)))
    ;; This map will inherit from `comint-mode-map' when entering
    ;; inferior-minizinc-mode.
    (define-key map [remap self-insert-command]
      'inferior-minizinc-self-insert-command)
    map))

(defvar inferior-minizinc-mode-syntax-table minizinc-mode-syntax-table)
(defvar inferior-minizinc-mode-abbrev-table minizinc-mode-abbrev-table)

(define-derived-mode inferior-minizinc-mode comint-mode "Inferior Minizinc"
  "Major mode for interacting with an inferior Minizinc process.

The following commands are available:
\\{inferior-minizinc-mode-map}

Entry to this mode calls the value of `minizinc-mode-hook' with no arguments,
if that value is non-nil.  Likewise with the value of `comint-mode-hook'.
`minizinc-mode-hook' is called after `comint-mode-hook'.

You can send text to the inferior Minizinc from other buffers using the commands
`process-send-region', `process-send-string' and \\[minizinc-consult-region].

Commands:
Tab indents for Minizinc; with argument, shifts rest
 of expression rigidly with the current line.
Paragraphs are separated only by blank lines and '%'.
'%'s start comments.

Return at end of buffer sends line as input.
Return not at end copies rest of line to end and sends it.
\\[comint-kill-input] and \\[backward-kill-word] are kill commands, imitating normal Unix input editing.
\\[comint-interrupt-subjob] interrupts the shell or its current subjob if any.
\\[comint-stop-subjob] stops. \\[comint-quit-subjob] sends quit signal."
  (setq comint-prompt-regexp "^| [ ?][- ] *")
  (minizinc-mode-variables))

(defvar inferior-minizinc-buffer nil)

(defun inferior-minizinc-run (&optional name)
  (with-current-buffer (make-comint "minizinc" (or name minizinc-program-name))
    (inferior-minizinc-mode)
    (setq-default inferior-minizinc-buffer (current-buffer))
    (make-local-variable 'inferior-minizinc-buffer)
    (when (and name (not (equal name minizinc-program-name)))
      (set (make-local-variable 'minizinc-program-name) name))
    (set (make-local-variable 'inferior-minizinc-flavor)
         ;; Force re-detection.
         (let* ((proc (get-buffer-process (current-buffer)))
                (pmark (and proc (marker-position (process-mark proc)))))
           (cond
            ((null pmark) (1- (point-min)))
            ;; The use of insert-before-markers in comint.el together with
            ;; the potential use of comint-truncate-buffer in the output
            ;; filter, means that it's difficult to reliably keep track of
            ;; the buffer position where the process's output started.
            ;; If possible we use a marker at "start - 1", so that
            ;; insert-before-marker at `start' won't shift it.  And if not,
            ;; we fall back on using a plain integer.
            ((> pmark (point-min)) (copy-marker (1- pmark)))
            (t (1- pmark)))))
    (add-hook 'comint-output-filter-functions
              'inferior-minizinc-guess-flavor nil t)))

(defun inferior-minizinc-process (&optional dontstart)
  (or (and (buffer-live-p inferior-minizinc-buffer)
           (get-buffer-process inferior-minizinc-buffer))
      (unless dontstart
        (inferior-minizinc-run)
        ;; Try again.
        (inferior-minizinc-process))))

(defvar inferior-minizinc-flavor 'unknown
  "Either a symbol or a buffer position offset by one.
If a buffer position, the flavor has not been determined yet and
it is expected that the process's output has been or will
be inserted at that position plus one.")

(defun inferior-minizinc-guess-flavor (&optional ignored)
  (save-excursion
    (goto-char (1+ inferior-minizinc-flavor))
    (setq inferior-minizinc-flavor
          (cond
           ((looking-at "GNU Minizinc") 'gnu)
           ((looking-at "Welcome to SWI-Minizinc") 'swi)
           ((looking-at ".*\n") 'unknown) ;There's at least one line.
           (t inferior-minizinc-flavor))))
  (when (symbolp inferior-minizinc-flavor)
    (remove-hook 'comint-output-filter-functions
                 'inferior-minizinc-guess-flavor t)
    (if (eq inferior-minizinc-flavor 'gnu)
        (set (make-local-variable 'comint-process-echoes) t))))

;;;###autoload
(defalias 'run-minizinc 'switch-to-minizinc)
;;;###autoload
(defun switch-to-minizinc (&optional name)
  "Run an inferior Minizinc process, input and output via buffer *minizinc*.
With prefix argument \\[universal-prefix], prompt for the program to use."
  (interactive
   (list (when current-prefix-arg
           (let ((proc (inferior-minizinc-process 'dontstart)))
             (if proc
                 (if (yes-or-no-p "Kill current process before starting new one? ")
                     (kill-process proc)
                   (error "Abort")))
             (read-string "Run Minizinc: " minizinc-program-name)))))
  (unless (inferior-minizinc-process 'dontstart)
    (inferior-minizinc-run name))
  (pop-to-buffer inferior-minizinc-buffer))

(defun inferior-minizinc-self-insert-command ()
  "Insert the char in the buffer or pass it directly to the process."
  (interactive)
  (let* ((proc (get-buffer-process (current-buffer)))
         (pmark (and proc (marker-position (process-mark proc)))))
    (if (and (eq inferior-minizinc-flavor 'gnu)
             pmark
             (null current-prefix-arg)
             (eobp)
             (eq (point) pmark)
             (save-excursion
               (goto-char (- pmark 3))
               (looking-at " \\? ")))
        (comint-send-string proc (string last-command-char))
      (call-interactively 'self-insert-command))))

(defun minizinc-consult-region (compile beg end)
  "Send the region to the Minizinc process made by \"M-x run-minizinc\".
If COMPILE (prefix arg) is not nil, use compile mode rather than consult mode."
  (interactive "P\nr")
  (let ((proc (inferior-minizinc-process)))
    (comint-send-string proc
                        (if compile minizinc-compile-string
                          minizinc-consult-string))
    (comint-send-region proc beg end)
    (comint-send-string proc "\n")		;May be unnecessary
    (if minizinc-eof-string
        (comint-send-string proc minizinc-eof-string)
      (with-current-buffer (process-buffer proc)
        (comint-send-eof))))) ;Send eof to minizinc process.

(defun minizinc-consult-region-and-go (compile beg end)
  "Send the region to the inferior Minizinc, and switch to *minizinc* buffer.
If COMPILE (prefix arg) is not nil, use compile mode rather than consult mode."
  (interactive "P\nr")
  (minizinc-consult-region compile beg end)
  (pop-to-buffer inferior-minizinc-buffer))

(defun inferior-minizinc-load-file ()
  "Pass the current buffer's file to the inferior minizinc process."
  (interactive)
  (save-buffer)
  (let ((file buffer-file-name)
        (proc (inferior-minizinc-process)))
    (with-current-buffer (process-buffer proc)
      (comint-send-string proc (concat "['" (file-relative-name file) "'].\n"))
      (pop-to-buffer (current-buffer)))))

(provide 'minizinc)

;; arch-tag: f3ec6748-1272-4ab6-8826-c50cb1607636
;;; minizinc.el ends here

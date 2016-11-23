;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'cask "/usr/local/share/emacs/site-lisp/cask.el")
(cask-initialize)

(require 'pallet)
(pallet-mode t)

(mapc 'load (directory-files "~/.emacs.d/personal" t "^[0-9]+.*\.el$"))

(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(package-selected-packages
   (quote
    (js-comint ruby-electric yasnippet-bundle react-snippets pbcopy zoom-frm zencoding-mode yard-mode yaml-mode wrap-region web-beautify web w3m virtualenvwrapper viper-in-more-modes tagedit tabbar starter-kit soft-morning-theme sml-modeline smart-whitespace-comment-fixup shell-switcher scss-mode sbt-mode sass-mode rust-mode ruby-tools rubocop rspec-mode robe repl-toggle redo+ recentf-ext rainbow-mode rainbow-delimiters quickref python-mode pyflakes projectile-rails project-root project-explorer pow phi-search pcmpl-git pallet nodejs-repl noctilux-theme multi-web-mode multi-term molokai-theme mew maxframe markdown-mode mac-key-mode lua-mode less-css-mode js2-refactor jedi ipython idomenu ido-vertical-mode ido-select-window idle-highlight ibuffer-vc grizzl graphene gitignore-mode gitconfig-mode git-timemachine git-gutter-fringe git fuzzy flx-ido floobits find-file-in-repository feature-mode expand-region evil-search-highlight-persist evil-leader enh-ruby-mode enclose elpy elixir-mode elixir-mix elisp-slime-nav ecb easy-after-load drag-stuff dockerfile-mode direx dired-details+ diminish dash-at-point csv-nav csv-mode color-theme-sanityinc-tomorrow coffee-mode clojurescript-mode clojure-mode-extra-font-locking cljsbuild-mode cider-profile cider-decompile calfw bundler buffer-move bind-key better-defaults ag adaptive-wrap ace-jump-zap ac-python ac-js2 ac-html-bootstrap ac-emmet ac-cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

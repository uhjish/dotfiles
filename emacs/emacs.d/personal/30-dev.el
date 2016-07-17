(setq this-dir (file-name-directory load-file-name))
(add-to-list 'load-path (concat this-dir "/auser"))

; (load "clojure.el")
; (load "js.el")
(require 'auser-clojure)
(require 'auser-js)
(require 'auser-html)
(require 'auser-css)
(require 'auser-python)
(require 'auser-ruby)

(provide 'dev)

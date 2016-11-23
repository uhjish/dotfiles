;; Setup SQL
(defun setup-sql
    (progn (print "Setting up sql"))
    (setq sql-postgres-login-params
            '((user :default "postgres")
            (database :default "postgres")
            (server :default "localhost")
            (port :default 5432)))

    (setq sql-connection-alist
            '((webdev (sql-product 'postgres)
                    (sql-port 5432)
                    (sql-server "localhost")
                    (sql-user "auser")
                    (sql-database "webdev"))
            ))

    (defun my-sql-save-history-hook ()
        (let ((lval 'sql-input-ring-file-name)
            (rval 'sql-product))
        (if (symbol-value rval)
            (let ((filename 
                    (concat "~/.emacs.d/sql/"
                            (symbol-name (symbol-value rval))
                            "-history.sql")))
                (set (make-local-variable lval) filename))
            (error
            (format "SQL history will not be saved because %s is nil"
                    (symbol-name rval))))))

    (defun auser/sql-connect-server (connection)
        "Connect to the input server using tmtxt/sql-servers-list"
        (interactive
        (helm-comp-read "Select server: " (mapcar (lambda (item)
                                                    (list
                                                    (symbol-name (nth 0 item))
                                                    (nth 0 item)))
                                                    sql-connection-alist))))

    (add-hook 'sql-interactive-mode-hook
                (lambda ()
                (toggle-truncate-lines t)
                (my-sql-save-history-hook)
                (setq-local show-trailing-whitespace nil)))
    )

(provide 'auser-sql)


;;; rc-ruby.el ---                                   -*- lexical-binding: t; -*-

;;======================================================
;; Ruby
;;======================================================

;; Smartparens can be used to match "end"s in Ruby code
(require 'smartparens)

(add-hook 'ruby-mode-hook 'my-ruby-hook)

(defun my-ruby-hook ()
  (enh-ruby-mode)
  (require 'inf-ruby)
  (require 'smartparens-ruby)
  (show-smartparens-mode)
  (defun ruby-run-current-file ()
    (interactive)
    (save-buffer)
    (shell-command (format "chmod +x %s" (buffer-real-name)))
    (shell-command (format "ruby %s" (buffer-real-name))))
  (require 'ruby-mode)
  (define-key ruby-mode-map (kbd "<f5>") 'ruby-run-current-file)
  (define-key enh-ruby-mode-map (kbd "<f5>") 'ruby-run-current-file)
  )


(provide 'rc-ruby)
;;; rc-ruby.el ends here
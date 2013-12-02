; no toolbar please
(tool-bar-mode -1)

; spaces, not tabs
(setq-default indent-tabs-mode nil)

; golang 
(add-to-list 'load-path "/usr/local/go/misc/emacs")
(require 'go-mode-load)
(defun my-go-mode-hook () 
  (add-hook 'before-save-hook 'gofmt-before-save) 
  (setq tab-width 4 indent-tabs-mode 1)) 
(add-hook 'go-mode-hook 'my-go-mode-hook) 

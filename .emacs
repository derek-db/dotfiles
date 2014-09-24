(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)


;; adjustments of running on mac
;; (when (eq system-type 'darwin)
;;   ;; set the Command key (⌘) as Meta key.
;;   (setq mac-option-key-is-meta  nil
;;         mac-command-key-is-meta t
;;         mac-command-modifier    'meta
;;         mac-option-modifier     nil)
;;   ;; do NOT use native fullscreen for OS X
;;   (setq ns-use-native-fullscreen nil)
;;   )

; i'm lazy
(fset 'yes-or-no-p 'y-or-n-p)

; no toolbar please
(if (boundp 'tool-bar-mode)
    (tool-bar-mode -1))

(when window-system 
  ; scroll-bars on mac are fugly
  (if (boundp 'scroll-bar-mode)
      (scroll-bar-mode -1))
  (set-frame-size (selected-frame) 200 55)
  )

; without scroll bars, these are 'nice'
(line-number-mode 1)
(column-number-mode 1)
; and this lets you find the end of the file
(set-default 'indicate-empty-lines t)

; 'cause volume is often 0
(setq visible-bell 1)

; help navigate windows/panes
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)

;; Turn on the clock!
;(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
;(setq display-time-use-mail-icon t)
(setq display-time-default-load-average nil)
(display-time-mode t)

; C-o after C-s is mickey magic
(defun isearch-occur ()
  "Invoke `occur' from within isearch."
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
    (occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))))
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)

; spaces, not tabs (go-mode resets this for .go files)
(setq-default indent-tabs-mode nil)

(require 'projectile)
(projectile-global-mode) ;; to enable in all buffers


; ctrl-c c -> compile-again, which remembers last compile
; ... except that I can just M-x recompile ...
;(global-set-key [(control c) (c)] 'compile-again)
(setq compilation-last-buffer nil)
(defun compile-again (pfx)
  """Run the same compile as the last time.

If there was no last time, or there is a prefix argument, this acts like
M-x compile.
"""
 (interactive "p")
 (if (and (eq pfx 1)
	  compilation-last-buffer)
     (progn
       (set-buffer compilation-last-buffer)
       (revert-buffer t t))
   (call-interactively 'compile)))


; auto-complete mode
(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

; golang 
(setq exec-path (append exec-path '("/Users/derekdb/src/gocode/bin" "/usr/local/go/bin")))
(add-to-list 'load-path "/usr/local/go/misc/emacs")
(require 'go-mode-load)
(defun compile-go-test ()
  "Invoke compile for 'go test'"
  (interactive) 
  (compile "go test"))
(defun compile-go-install ()
  "Invoke compile for 'go install'"
  (interactive) 
  (compile "go install"))
(defun my-go-mode-hook () 
  (add-hook 'before-save-hook 'gofmt-before-save) 
  (setq tab-width 4 indent-tabs-mode 1)
  (local-set-key (kbd "C-c c") 'compile-go-install)
  (local-set-key (kbd "C-c C-c") 'compile-go-install)
  (local-set-key (kbd "C-c t") 'compile-go-test)
  (flycheck-mode 1)
  (auto-complete-mode 1)) 
(add-hook 'go-mode-hook 'my-go-mode-hook) 
; use goimports, rather than gofmt
(setq gofmt-command "goimports")
; flycheck
(add-to-list 'load-path "~/src/gocode/src/github.com/dougm/goflymake")
(require 'go-flycheck)
; gocode autocomplete for go-modexs
(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)

;using magit for now..
(require 'magit)

; all files, human sizes long format and filetypes
(setq dired-listing-switches "-ahlF")
; On Mac OS X, ls -F prints an @ symbol when printing symlinks.
(when (eq system-type 'darwin)
  (setq dired-ls-F-marks-symlinks t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)

; Reload the current file while remembering the cursor position
(defun reload-file ()
  (interactive)
  (let ((curr-scroll (window-vscroll)))
    (find-file (buffer-name))
    (set-window-vscroll nil curr-scroll)))

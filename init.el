;; -*- lexical-binding: t -*-
;;
;; Author: vollcheck (λ)
;;
;; -- Package initialization.

(require 'package)


;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)


(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/")
	("melpa" . "https://melpa.org/packages/")
	))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-verbose t
      package-native-compile t
      comp-deferred-compilation t)


;; -- Better defaults.

(prefer-coding-system 'utf-8)
(defalias 'yes-or-no-p 'y-or-n-p)


(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(fringe-mode -1)
(show-paren-mode 1)
(save-place-mode t)
(delete-selection-mode 1)

(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      initial-scratch-message nil
      inhibit-startup-message t
      auto-revert-mode t

      ;; Supress native compilation warnings
      native-comp-async-report-warnings-errors nil

      ;; "Command attempted to use minibuffer while in minibuffer" gets old fast.
      ;; enable-recursive-minibuffers t
      ;; mouse-wheel-progressive-speed nil
      visible-bell 1
      ring-bell-function 'ignore
      electric-pair-mode t
      global-subword-mode t


      ;; Select help windows when I pop them so that I can kill them with <q>.
      help-window-select t
      ;; Most *NIX tools work best when files are terminated with a newline.
      require-final-newline t

      custom-file "~/.emacs.d/custom.el")

(setq-default indent-tabs-mode nil)

;; Hack on font...
(load custom-file 'noerror)

;; -- 3rd party programs
;; TODO: switch to the `rg` instead of `grep`
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Grep-Searching.html

;; -- Appearance.
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; themes that look good
  ;; doom-opera
  ;; doom-miramare
  ;; doom-ayu-mirage
  ;; doom-earl-grey ;; but it's super light
  (load-theme 'doom-miramare t)

  ;; Enable flashing mode-line on errors
  ;; (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  )

(setq doom-modeline-height 32)
(setq doom-modeline-icon nil)

(defvar *h*
  ;; dell xps specific - 4k screen
  250
  ;; 500
  )

(add-to-list 'default-frame-alist
	     ;; I know that's pretty big,
	     ;; need to align that to the high DPI
	     '(height . *h*)
	     '(font . "SF Mono")
	     )

(set-face-attribute 'default t
		    :height *h*
		    :font  "SF Mono"
		    )  ;; HiDPI once again

(set-face-attribute 'default nil :font "SF Mono-25")

;; (use-package mini-modeline
;;   :config (mini-modeline-mode t))

(use-package fira-code-mode
  :hook (prog-mode))

;; (use-package nano-theme
;;   :config (load-theme 'nano-light))

(use-package hl-todo
  :config (global-hl-todo-mode t))

;; -- Functions.

(defun my-revert-buffer-noconfirm ()
  "Call `revert-buffer' with the NOCONFIRM argument set."
  (interactive)
  (revert-buffer nil t))
(global-set-key (kbd "C-c r") 'revert-buffer)

(defun kill-current-buffer ()
  "Kills the current buffer."
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x k") 'kill-current-buffer)

(defun config-visit ()
  "Visits your own configuration."
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c e") 'config-visit)

(defun intendation-or-begin ()
  "~Smart~ backing to beginning to start of the line."
  (interactive)
   (if (= (point) (progn (back-to-indentation) (point)))
       (beginning-of-line)))
(global-set-key (kbd "C-a") 'intendation-or-begin)

(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(defun indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))
(global-set-key [f12] 'indent-buffer)

(defun requests-visit ()
  "Visits your own set of requests."
  (interactive)
  (find-file "~/code/requests.http")) ;; path is hardcoded unfortunately
(global-set-key (kbd "C-c 1") 'requests-visit)

(defun previev-buffer-in-browser ()
  (interactive)
  (start-process "previev-adoc" nil "chromium" buffer-file-name))
(global-set-key (kbd "C-c 2") 'previev-buffer-in-browser)

(defun previev-global-notes ()
  (interactive)
  (find-file "~/notes.org"))
(global-set-key (kbd "C-c 3") 'previev-global-notes)

(defun my-insert-eval-last-sexp ()
  (interactive)
  (let ((beg (point)))
    (let ((current-prefix-arg '(4)))
      (call-interactively 'eval-last-sexp))
    (goto-char beg)
    (if (looking-back ")")
        (insert " ; "))
    (insert "⇒ ")
    (move-end-of-line 1)))

(+ 1 2) ; ⇒ 3

;; -- Packages.

;; https://github.com/purcell/exec-path-from-shell
(use-package exec-path-from-shell)

(when (memq window-system '(x))
  (exec-path-from-shell-initialize))

(when (daemonp)
  (exec-path-from-shell-initialize))

(use-package which-key
  :config (which-key-mode))

(use-package swiper
  :bind ("C-s" . 'swiper))

(use-package multiple-cursors
  :config (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines))

(use-package avy
  :bind ("C-q" . avy-goto-char))

(use-package magit
  :config (global-set-key (kbd "C-x g") 'magit-status))

(use-package restclient
  :load-path "~./.emacs.d/lisp/restclient.el/restclient.el"
  :mode (("\\.http\\'" . restclient-mode)
	 ("\\.https\\'" . restclient-mode))
  :config (setq restclient-inhibit-cookies t))

(use-package yasnippet)

;; First install the package:
(use-package flycheck-clj-kondo)

;; then install the checker as soon as `clojure-mode' is loaded
(use-package clojure-mode
  :config
  (require 'flycheck-clj-kondo))

(use-package cider
  :config
  (setq cider-repl-display-help-banner nil
        cider-comment-prefix " ;; => ")

  ;; add extra space before comment
  ;; cider-repl-newline-and-indent

  :custom
  (cider-repl-use-clojure-font-lock t)
  (cider-repl-use-pretty-printing t)
  )

(use-package clj-deps-new)

(defun cljr-clojure-mode-hook ()
    (clj-refactor-mode 1)
    (yas-minor-mode 1) ; for adding require/use/import statements
    ;; This choice of keybinding leaves cider-macroexpand-1 unbound
    (cljr-add-keybindings-with-prefix "C-c C-m"))


;; Yo, so here's the issue with nbb REPL driven development:
;; 1. You either need to use vscode & calva IDE (requires learning)
;; 2. You need to add following:
;;    later you can type `nbb nrepl-server :port 1339'
;;    and in emacs: `cider-connect-cljs', `localhost', `1339', `nbb'
;;    note: https://github.com/nextjournal/clerk/blob/sci-nrepl/doc/browser-repl.md#cider

;; Maybe extend cider with nbb module one day?

(with-eval-after-load 'cider
  (cider-register-cljs-repl-type 'nbb "(println \"Hey nbb!\")")
  )

(defun mm/cider-connected-hook ()
  (when (eq 'nbb cider-cljs-repl-type)
    (setq-local cider-show-error-buffer nil)
    (cider-set-repl-type 'cljs)))

(add-hook 'cider-connected-hook #'mm/cider-connected-hook)

;; clerk

(defun clerk-show ()
  (interactive)
  (when-let
      ((filename
        (buffer-file-name)))
    (save-buffer)
    (cider-interactive-eval
     (concat "(nextjournal.clerk/show! \"" filename "\")"))))

(define-key clojure-mode-map (kbd "<M-return>") 'clerk-show)


(use-package expand-region

  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'er/expand-region))

(use-package marginalia

  :hook
  (after-init . marginalia-mode))

(use-package orderless

  :custom
  (completion-styles '(orderless))
  (orderless-component-separator 'orderless-escapable-split-on-space))

(use-package vertico

  :custom (vertico-resize nil)
  :hook (after-init . vertico-mode))

(use-package company

  :hook after-init-hook)


(use-package lsp-mode

  :hook ((clojure-mode . lsp)
         (clojurec-mode . lsp)
         (clojurescript-mode . lsp)
         (web-mode . lsp)
         )

  :config
  ;; add paths to your local installation of project mgmt tools, like lein
  (setenv "PATH" (concat "/usr/local/bin" path-separator (getenv "PATH")))

  (dolist (m '(clojure-mode
               clojurec-mode
               clojurescript-mode
               clojurex-mode))
    (add-to-list 'lsp-language-id-configuration `(,m . "clojure")))

  :custom
  ;; turn this on to capture client/server comms before
  ;; submitting bug reports with `lsp-workspace-show-log`
  ;; (lsp-log-io t)

  (lsp-eldoc-enable-hover nil)
  (lsp-enable-indentation nil)
  (lsp-enable-folding nil)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-idle-delay 0.5)
  (lsp-keymap-prefix nil)
  )

;; lsp-ui provides handy tooltips but they cover too much
;; of the window. enable this if you want them back:
(use-package lsp-ui

  ;; :disabled t
  :commands lsp-ui-mode)

;; (use-package company-lsp
;;   :config
;;   (push 'company-lsp company-backends)
;;   )

;; (use-package lsp-java
;;   :config (add-hook 'java-mode-hook 'lsp))

(use-package vterm)

(use-package graphql-mode)

(use-package yaml-mode)

(use-package darkroom
  :config
  (setq darkroom-margins 0.1))

(use-package pdf-tools)

;; (use-package popup)

;; used for forum-transcripts development
;; (use-package google-translate
;;   :config
;;   (setq google-translate-default-source-language "zh-TW"
;;         google-translate-default-target-language "en"
;;         ;; google-translate-backend-method 'curl
;;         ))
;; (setq google-translate-backend-method 'curl)

;; --- JavaScript ---
(setq js-indent-level 2)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-jsx-mode))

;; --- CSS ---
(setq-default css-indent-offset 2)

;; --- Org mode ---
(setq org-babel-clojure-backend 'cider)

(org-babel-do-load-languages
 'org-babel-load-languages '((clojure . t)))

(setq org-default-notes-file "~/org-capture/notes.org")

;; https://orgmode.org/manual/Capture-templates.html
(setq org-capture-templates
      '(("t" "Task" entry (file+headline "~/org-capture/tasks.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("i" "Inspiraton" entry (file+datetree "~/org-capture/inspirations.org")
         "* %?\nEntered on %U\n  %i\n")))

;; -- JUXT-specific configuration.

(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)


;; Delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(add-to-list 'auto-mode-alist '("\\.adoc\\'" . text-mode))

(global-set-key "\C-x\C-b" 'ibuffer)
(global-set-key "\C-xg" 'magit-status)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
;(global-set-key (kbd "C-c r") 'reset)


(use-package paredit
  :hook clojure-mode-hook)
;;(add-hook 'clojure-mode-hook #'cljr-clojure-mode-hook)
;; (add-hook 'clojure-mode-hook #'paredit-mode)
;; (add-hook 'cider-repl-mode-hook #'paredit-mode)
;; (add-hook 'lisp-mode-hook #'paredit-mode)
;; (add-hook 'emacs-lisp-mode-hook #'paredit-mode)

;; Window navigation

(windmove-default-keybindings) ; move with Shift-arrow

;; This is less intuitive but doesn't require arrow keys (your fingers
;; can remain on their home keys)

;; (defun prev-window ()
;;   (interactive)
;;   (other-window -1))

;; (global-set-key (kbd "C-.") #'other-window)
;; (global-set-key (kbd "C-,") #'prev-window)

;; Window navigation extras (requires package: buffer-move)
;; (use-package buffer-move
;;   ) ;; TODO: not sure about it

(setq gc-cons-threshold (* 2 1000 1000))
(put 'downcase-region 'disabled nil)

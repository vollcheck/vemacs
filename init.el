;; -*- lexical-binding: t -*-
;;
;; Author: vollcheck

;; -- Package initialization.

(require 'package)

(setq package-archives
      (append package-archives '(("melpa" . "http://melpa.org/packages/"))))

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

      ;; Minimize garbage collection during startup
      gc-cons-threshold most-positive-fixnum

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

(load custom-file 'noerror)

(setq-default bidi-paragraph-direction 'left-to-right)

(if (version<= "27.1" emacs-version)
    (setq bidi-inhibit-bpa t))


;; -- Hooks.
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'prog-mode-hook 'subword-mode)


;; -- Appearance.

;; (load-theme 'adwaita)

(use-package nano-theme
  :config (load-theme 'nano-light))

(add-to-list 'default-frame-alist
	     '(font . "SF Mono"))

(defvar mode-line-symbols
  '(
    (clojure-mode . "λ")
    ))

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
  (find-file "~/code/requests.http"))
(global-set-key (kbd "C-c 1") 'requests-visit)


;; -- Packages.

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
  :mode (("\\.http\\'" . restclient-mode)
	 ("\\.https\\'" . restclient-mode))
  :config (setq restclient-inhibit-cookies t))

(use-package graphql-mode)

(use-package json-mode)

(use-package js
  :mode (("\\.ts\\'" . js-mode)
	 ("\\.tsx\\'" . js-mode)))

(use-package js2-mode)

(use-package cider
  ;; Standard cider.
  :config (setq cider-repl-display-help-banner nil)

  ;; My hacked one.
  ;; :load-path ("~/.emacs.d/hacks/cider/")  ;; TODO: Compile it.
  ;; :config (setq cider-repl--insert-banner-p nil
  ;; 		;; it doesn't matter as long as `cider-repl--insert-banner-p' is nil
  ;; 		cider-repl-display-help-banner nil
  ;; 		cider-repl--insert-startup-commands-p nil
  ;; 		cider-repl--insert-words-of-encouragement-p t)

  :custom
  (cider-repl-use-clojure-font-lock t)
  (cider-repl-use-pretty-printing t))

(use-package expand-region
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'er/expand-region))

;; TODO: Install and configure `paredit'.
;; TODO: Replace corfu/orderless/vertico stack with prescient/selectrum one.

(use-package corfu
  :init
  (corfu-global-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay .5))

(use-package dabbrev
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand)))

(use-package emacs
  :init
  (setq
   ;; TAB cycle if there are only few candidates
   completion-cycle-threshold 3

   ;; Enable indentation+completion using the TAB key.
   ;; `completion-at-point' is often bound to M-TAB.
   tab-always-indent 'complete))

(use-package marginalia
  :hook
  (after-init . marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless))
  (orderless-component-separator 'orderless-escapable-split-on-space))

(use-package vertico
  :custom
  (vertico-resize nil)
  :hook
  (after-init . vertico-mode))

;; !!!
;; DEFINIETLY you must check following out:
;; https://github.com/kostafey/ejc-sql
(use-package ejc-sql)

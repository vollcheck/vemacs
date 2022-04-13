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

(use-package cider)

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package expand-region
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'er/expand-region))

(use-package corfu
  :hook
  (after-init . corfu-global-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay .5))

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

;; TODO: To be configured...
;; (use-package paredit
;;   :init
;;   (add-hook 'lisp-mode-hook 'paredit-mode)
;;   (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
;;   (add-hook 'clojure-mode-hook 'paredit-mode)
;;   (add-hook 'cider-repl-mode-hook 'enable-paredit-mode))

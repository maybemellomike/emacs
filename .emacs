;;; -*- lexical-binding: t -*-

;; --------------------------------
;; Package Management
;; --------------------------------
(require 'package)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(defvar my/packages
  '(evil
    evil-collection
    doom-themes
    nerd-icons
    undo-fu
    vertico
    consult
    orderless
    marginalia
    shrink-path
    org-modern))

(dolist (pkg my/packages)
  (unless (package-installed-p pkg)
    (package-install pkg)))

;; --------------------------------
;; UI cleanup
;; --------------------------------
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; --------------------------------
;; Line Numbers (Vim-style)
;; --------------------------------
(setq-default display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)
(setq display-line-numbers-width-start t)

(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                vterm-mode-hook
                treemacs-mode-hook
                minibuffer-setup-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; --------------------------------
;; Evil (Vim Emulation)
;; --------------------------------
(require 'evil)
(evil-mode 1)

;; --------------------------------
;; Telescope-like Completion Stack
;; --------------------------------

(require 'vertico)
(vertico-mode 1)

(require 'marginalia)
(marginalia-mode)

(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides
      '((file (styles basic partial-completion))))

(require 'consult)

(global-set-key (kbd "C-p") #'consult-buffer)
(global-set-key (kbd "C-f") #'consult-ripgrep)
(global-set-key (kbd "C-s") #'consult-line)

(setq consult-preview-key "M-.")

(recentf-mode 1)

;; --------------------------------
;; Theme Configuration
;; --------------------------------

(setq custom-safe-themes t)

(require 'doom-themes)
(load-theme 'doom-monokai-machine t)

;; --------------------------------
;; Org Mode Enhancements
;; --------------------------------

(require 'org)

;; nicer bullets and visuals
(require 'org-modern)
(add-hook 'org-mode-hook #'org-modern-mode)

;; dynamic heading sizes
(custom-set-faces
 '(org-level-1 ((t (:height 1.4 :weight bold))))
 '(org-level-2 ((t (:height 1.3 :weight bold))))
 '(org-level-3 ((t (:height 1.2 :weight bold))))
 '(org-level-4 ((t (:height 1.1 :weight bold))))
 '(org-level-5 ((t (:height 1.05))))
 '(org-level-6 ((t (:height 1.02))))
 '(org-level-7 ((t (:height 1.0))))
 '(org-level-8 ((t (:height 1.0)))))

;; better org readability
(add-hook 'org-mode-hook
          (lambda ()
            (variable-pitch-mode 1)
            (visual-line-mode 1)))

;; --------------------------------
;; Custom Variables
;; --------------------------------
(custom-set-variables
 '(package-selected-packages
   '(cyberpunk-theme doom-themes evil-collection
     evil-emacs-cursor-model-mode gruber-darker-theme
     nerd-icons shrink-path undo-fu)))

;; --------------------------------
;; Text Wrapping / Word-Processor Behavior
;; --------------------------------

(defun my/text-mode-line-wrapping ()
  "Enable word-wrapping like a word processor."
  ;; Visual wrapping at word boundaries
  (visual-line-mode 1)
  ;; Prevent truncating long lines horizontally
  (setq truncate-lines nil)
  ;; Optional: uncomment to insert hard line breaks automatically
  ;; (setq fill-column 80)
  ;; (auto-fill-mode 1)
  )

;; Apply the wrapping function to specific file types
(dolist (hook '(typ-mode-hook
                org-mode-hook
                markdown-mode-hook
                latex-mode-hook))
  (add-hook hook #'my/text-mode-line-wrapping))

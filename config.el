(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")
        ("nongnu". "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; use-package is built-in from Emacs 29. This line makes it auto-install
;; any package declared with :ensure t if it isn't already present.
(require 'use-package)
(setq use-package-always-ensure t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq-default display-line-numbers-type 'relative)
(setq-default display-line-numbers-width 3)
(global-display-line-numbers-mode t)

(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                vterm-mode-hook
                treemacs-mode-hook
                minibuffer-setup-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Re-assert fixed gutter width in org-mode AFTER variable-pitch-mode fires.
;; The trailing `t` appends this hook so it runs after all others on the hook list.
(add-hook 'org-mode-hook
          (lambda ()
            (setq-local display-line-numbers-width 3)
            (setq-local display-line-numbers-width-start nil))
          t)

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil)  ;; required when using evil-collection
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package undo-fu)

(use-package vertico
  :config
  (vertico-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :config
  (marginalia-mode))

(use-package consult
  :bind
  (("C-p" . consult-buffer)
   ("C-f" . consult-ripgrep)
   ("C-s" . consult-line))
  :custom
  (consult-preview-key "M-.")
  :config
  (recentf-mode 1))

(use-package doom-themes
  :custom
  (custom-safe-themes t)
  :config
  (load-theme 'doom-monokai-machine t))

(use-package nerd-icons)

(use-package org
  :ensure nil  ;; org is built-in; :ensure nil prevents use-package trying to reinstall it
  :hook
  ((org-mode . variable-pitch-mode)
   (org-mode . visual-line-mode))
  :custom-face
  (org-level-1 ((t (:height 1.4 :weight bold))))
  (org-level-2 ((t (:height 1.3 :weight bold))))
  (org-level-3 ((t (:height 1.2 :weight bold))))
  (org-level-4 ((t (:height 1.1 :weight bold))))
  (org-level-5 ((t (:height 1.05))))
  (org-level-6 ((t (:height 1.02))))
  (org-level-7 ((t (:height 1.0))))
  (org-level-8 ((t (:height 1.0))))
  (org-block            ((t (:inherit fixed-pitch :background "#2d2d2d"))))
  (org-block-begin-line ((t (:inherit fixed-pitch :foreground "#aaaaaa"))))
  (org-block-end-line   ((t (:inherit fixed-pitch :foreground "#aaaaaa"))))
  (org-code             ((t (:inherit fixed-pitch)))))

(use-package org-modern
  :after org
  :hook
  (org-mode . org-modern-mode))

(use-package olivetti
  :commands olivetti-mode
  :init
  (defun my/zen-mode ()
    "Toggle a distraction-free writing mode without fullscreening Emacs."
    (interactive)
    (if (bound-and-true-p olivetti-mode)
        (progn
          (olivetti-mode -1)
          (display-line-numbers-mode 1))
      (progn
        (olivetti-mode 1)
        (olivetti-set-width 88)
        (display-line-numbers-mode 0))))
  :hook
  ((LaTeX-mode . my/zen-mode)
   (latex-mode . my/zen-mode))
   ;; Uncomment once you have a typst major mode installed (e.g. typst-ts-mode):
   ;; (typst-mode . my/zen-mode)
  :bind
  ("C-c z" . my/zen-mode))

(defun my/text-mode-line-wrapping ()
  "Enable word-wrapping like a word processor."
  (visual-line-mode 1)
  (setq truncate-lines nil))
  ;; Optional: uncomment for hard breaks
  ;; (setq fill-column 80)
  ;; (auto-fill-mode 1)

(dolist (hook '(typst-mode-hook
                org-mode-hook
                markdown-mode-hook
                latex-mode-hook))
  (add-hook hook #'my/text-mode-line-wrapping))

(use-package shrink-path)

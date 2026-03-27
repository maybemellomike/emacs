;;; init.el

;; Tangle config.org -> config.el if org file is newer, safely
(let ((config-el (expand-file-name "config.el" user-emacs-directory))
      (config-org (expand-file-name "config.org" user-emacs-directory)))
  (when (and (file-exists-p config-org)
             (or (not (file-exists-p config-el))          ; missing entirely
                 (file-newer-than-file-p config-org config-el)))
    (require 'org)
    (org-babel-tangle-file config-org config-el "emacs-lisp"))
  (when (file-exists-p config-el)
    (load config-el nil t)))

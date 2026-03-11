(require 'org)
(org-babel-tangle-file "~/.emacs.d/config.org"
                       "~/.emacs.d/config.el"
                       "emacs-lisp")
(load-file "~/.emacs.d/config.el")

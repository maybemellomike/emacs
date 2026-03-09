;;; avy-jump-helm-line.el --- Avy-jump to a candidate in helm window

;; Copyright (C) 2015  Junpeng Qiu

;; Author: Junpeng Qiu <qjpchmail@gmail.com>
;; URL: https://github.com/sunlin7/avy-jump-helm-line
;; Package-Version: 20250626.154841
;; Keywords: extensions
;; Version: 0.4.0
;; Package-Requires: ((avy "0.4.0") (helm "1.6.3"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;                           ____________________

;;                            AVY-JUMP-HELM-LINE

;;                               Junpeng Qiu
;;                           ____________________


;; Table of Contents
;; _________________

;; 1 Setup
;; 2 Usage
;; .. 2.1 Keys & UI
;; .. 2.2 Different Actions: move-only, persistent or select
;; .. 2.3 Automatic Idle Execution
;; .. 2.4 Line Hints Preview
;; 3 Example settings
;; 4 Demos(only showing the basic feature)
;; 5 Similar Package
;; 6 Acknowledgment


;; [[file:http://melpa.org/packages/avy-jump-helm-line-badge.svg]]
;; [[file:http://stable.melpa.org/packages/avy-jump-helm-line-badge.svg]]

;; *Avy-jump to a candidate in helm window.*

;; This package makes use of the `avy.el'.


;; [[file:http://melpa.org/packages/avy-jump-helm-line-badge.svg]]
;; http://melpa.org/#/avy-jump-helm-line

;; [[file:http://stable.melpa.org/packages/avy-jump-helm-line-badge.svg]]
;; http://stable.melpa.org/#/avy-jump-helm-line


;; 1 Setup
;; =======

;;   ,----
;;   | (add-to-list 'load-path "/path/to/avy-jump-helm-line.el")
;;   | (require 'avy-jump-helm-line)
;;   `----

;;   You can use the following code to bind `avy-jump-helm-line' to a
;;   key(say, C-'):
;;   ,----
;;   | (eval-after-load "helm"
;;   | '(define-key helm-map (kbd "C-'") 'avy-jump-helm-line))
;;   `----


;; 2 Usage
;; =======

;;   When in a helm session, for example, after you call `helm-M-x', you
;;   can use your key binding(for example, C-') to invoke
;;   `avy-jump-helm-line'. See the following demos.

;;   *Note*: Since *2016-02-19*, you can configure `avy-jump-helm-line' in
;;   a similar way as `avy'. The old-fashioned variable
;;   `avy-jump-helm-line-use-avy-style' is discarded now. There is no
;;   effect by setting this variable(I dropped this variable because `avy'
;;   has become much more configurable since I first developed this
;;   package).


;; 2.1 Keys & UI
;; ~~~~~~~~~~~~~

;;   You can customize following variables:
;;   1. `avy-jump-helm-line-keys': the keys to be used for
;;      `avy-jump-helm-line'. If you don't set this variable, `avy-keys'
;;      will be used.
;;   2. `avy-jump-helm-line-style': You can set the styles to be used for
;;      `avy-jump-helm-line'. The values can be `pre', `at', `at-full',
;;      `post', and `de-bruijn', the same as `avy-style'. If you don't set
;;      this variable, `avy-style' will be used.
;;   3. `avy-jump-helm-line-background': Whether you want to use a
;;      background or not. The default value is `nil'.

;;   For old version users: if you want to achieve the same effect of
;;     `(setq avy-jump-helm-line-use-avy-style nil)', use the following
;;     code:
;;   ,----
;;   | (setq avy-jump-helm-line-keys (number-sequence ?a ?z))
;;   | (setq avy-jump-helm-line-style 'at)
;;   | (setq avy-jump-helm-line-background t)
;;   `----


;; 2.2 Different Actions: move-only, persistent or select
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;;   You can now specify the action that will be executed after the cursor
;;   has been moved to the candidate. This is controlled by the value of
;;   `avy-jump-helm-line-default-action'. Three different kinds of values
;;   are available:
;;   1. `nil' or `move-only': This is the default one. Just move the cursor
;;      to the candidate and do nothing.
;;   2. `persistent': After the cursor has been moved to the candidate,
;;      execute the persistent action on that candidate.
;;   3. `select': After the cursor has been moved to the candidate, select
;;      the candidate and exit the helm session.

;;   Thanks to `avy' 0.4.0, we can now switch the action after we see the
;;   avy prompt. Three different keys can be used to switch the action:
;;   1. `avy-jump-helm-line-move-only-key'
;;   2. `avy-jump-helm-line-persistent-key'
;;   3. `avy-jump-helm-line-select-key'

;;   For example, if we have following settings:
;;   ,----
;;   | (setq avy-jump-helm-line-default-action 'select)
;;   | (setq avy-jump-helm-line-select-key ?e) ;; this line is not neeeded
;;   | ;; Set the move-only and persistent keys
;;   | (setq avy-jump-helm-line-move-only-key ?o)
;;   | (setq avy-jump-helm-line-persistent-key ?p)
;;   `----

;;   Say after we invoke `avy-jump-helm-line', we can use f to jump to a
;;   candidate. Since the default action is `select', the candidate will be
;;   automatically selected and the helm session will be ended after the
;;   cursor has been moved to it. But suddenly I change my mind and only
;;   want to move to it. Instead of pressing f, I can press of where o is
;;   defined by the `avy-jump-helm-line-move-only-key' and is used to
;;   switch the action to `move-only'. Similarly, if I press pf, then the
;;   persistent action on the candidate will be executed.

;;   Note in this example, setting `avy-jump-helm-line-select-key' has no
;;   effect because the default action is `select'. It makes no senses that
;;   we need to have an extra key to switch to the `select' action. So if
;;   your default action is `nil' or `move-only',
;;   `avy-jump-helm-line-move-only-key' is not needed and
;;   `avy-jump-helm-line-persistent-key' is not needed if your default
;;   action is `persistent'. However, you're *safe* to set these variables
;;   regardless of your default action since the variable corresponding to
;;   your default action will just be ignored.

;;   If you wonder why this feature is useful, here is an example: if you use
;;   `helm-find-files' and set the default action to be `select', you can now
;;   use `avy-jump-helm-line-persistent-key' to complete the directory name
;;   instead of opening the directory in dired. This means you can use
;;   `avy-jump-helm-line' until you finally find the target file.

;;   For compatibility issues, there are also two identical pre-defined
;;   commands: `avy-jump-helm-line-and-select' and
;;   `avy-jump-helm-line-execute-action'. Their default action is to select
;;   the candidate and exit the helm session. Now you can achieve the same
;;   effect using `avy-jump-helm-line' by the following setting:
;;   ,----
;;   | (setq avy-jump-helm-line-default-action 'select)
;;   `----


;; 2.3 Automatic Idle Execution
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;;   `avy-jump-helm-line' can be automatically executed if there is no
;;   input after the user launches a helm command. The delay can be
;;   specified by setting the variable `avy-jump-helm-line-idle-delay' in
;;   seconds. The default value is 1.

;;   Use the following code to enable this feature for a helm command, say,
;;   `helm-mini':
;;   ,----
;;   | (avy-jump-helm-line-idle-exec-add 'helm-mini)
;;   `----

;;   After adding this setting, `avy-jump-helm-line' will be automatically
;;   triggerred if there is no input for `avy-jump-helm-line-idle-delay'
;;   seconds after `helm-mini' is called.

;;   To remove it, use:
;;   ,----
;;   | (avy-jump-helm-line-idle-exec-remove 'helm-mini)
;;   `----

;;   Note this feature is *experimental*. Please file an issue if you find
;;   any problems. As I couldn't find good documentation about adding hooks
;;   to a helm command, the implementation is a simple yet dirty hack. And
;;   don't try to set the value of `avy-jump-helm-line-idle-delay' to be
;;   `nil'. It doesn't work.


;; 3 Example settings
;; ==================

;;   ,----
;;   | (eval-after-load "helm"
;;   | '(define-key helm-map (kbd "C-'") 'avy-jump-helm-line))
;;   | ;; or if using key-chord-mode
;;   | ;; (eval-after-load "helm"
;;   | ;;  '(key-chord-define helm-map "jj" 'avy-jump-helm-line))
;;   | (setq avy-jump-helm-line-style 'pre)
;;   | (setq avy-jump-helm-line-background t)
;;   | (setq avy-jump-helm-line-default-action 'select)
;;   | (setq avy-jump-helm-line-select-key ?e) ;; this line is not neeeded
;;   | ;; Set the move-only and persistent keys
;;   | (setq avy-jump-helm-line-move-only-key ?o)
;;   | (setq avy-jump-helm-line-persistent-key ?p)
;;   | ;; enable idle execution for `helm-mini'
;;   | (avy-jump-helm-line-idle-exec-add 'helm-mini)
;;   `----


;; 4 Demos(only showing the basic feature)
;; =======================================

;;   The following demo are recorded in pre-0.4 version. It's a little
;;   out-dated.

;;   Use `avy' style to jump to a helm candidate:
;;   [./screencasts/avy-jump-style.gif]

;;   Or use a different style similar to `avy-jump-mode' (by setting the
;;   values of `avy-jump-helm-line-keys', `avy-jump-helm-line-style' and
;;   `avy-jump-helm-line-background'):
;;   [./screencasts/avy-jump-mode-style.gif]

;;   The new features after v0.4 are not recorded yet.:-(


;; 5 Similar Package
;; =================

;;   [This issue of Helm] has been solved by adding a new minor mode
;;   `helm-linum-relative-mode' to `linum-relative'. You can take a look if
;;   you don't like `avy' and want to find an alternative. As a heavy user
;;   of `avy', I don't find the way that `helm-linum-relative-mode'
;;   provides very appealing. Thanks to `avy', this package provides more
;;   customizations and more consistent user experience for `avy' users.


;;   [This issue of Helm] https://github.com/emacs-helm/helm/issues/1257


;; 6 Acknowledgment
;; ================

;;   - Thank [Oleh Krehel] for the awesome [avy] package.
;;   - Thank @hick for the original idea.


;;   [Oleh Krehel] https://github.com/abo-abo/

;;   [avy] https://github.com/abo-abo/avy

;;; Code:

(require 'avy)
(require 'helm)

(defvar avy-jump-helm-line-keys nil
  "Keys used for `avy-jump-helm-line'.")

(defvar avy-jump-helm-line-style nil
  "Style used for `avy-jump-helm-line'.")

(defvar avy-jump-helm-line-background nil
  "Use background or not in `avy-jump-helm-line'.")

(defvar avy-jump-helm-line-use-avy-style t
  "Useless variable since v0.4.
Please set `avy-jump-helm-line-keys', `avy-jump-helm-line-style'
and `avy-jump-helm-line-background' instead.")

(defvar avy-jump-helm-line-persistent-key nil
  "The key to perform persistent action.")

(defvar avy-jump-helm-line-select-key nil
  "The key to select.
Used for `avy-jump-helm-line'.")

(defvar avy-jump-helm-line-move-only-key nil
  "The key to only move the selection.
 Used for `avy-jump-helm-line-and-select'.")

(defvar avy-jump-helm-line-default-action nil
  "The default action when jumping to a candidate.")

(defvar avy-jump-helm-line-idle-delay 1
  "The delay to trigger automatic `avy-jump-helm-line'.")

(defvar avy-jump-helm-line--tree-leafs nil)

(defvar avy-jump-helm-line--action-type nil)

(defvar avy-jump-helm-line--last-win-start -1)

(defun avy-jump-helm-line-action-persistent (pt)
  (goto-char pt)
  (setq avy-jump-helm-line--action-type 'persistent)
  (avy-jump-helm-line--move-selection)
  (helm-execute-persistent-action))

(defun avy-jump-helm-line-action-select (pt)
  (goto-char pt)
  (setq avy-jump-helm-line--action-type 'select)
  (avy-jump-helm-line--move-selection)
  (helm-exit-minibuffer))

(defun avy-jump-helm-line-action-move-only (pt)
  (goto-char pt)
  (setq avy-jump-helm-line--action-type 'move-only)
  (avy-jump-helm-line--move-selection))

(defun avy-jump-helm-line--move-selection ()
  (let (helm-after-preselection-hook
        helm-move-selection-after-hook
        helm-after-update-hook
        (orig-point (point)))
    (helm-move-selection-common :where 'line :direction 'previous)
    (unless (= (point) orig-point)
      (helm-move-selection-common :where 'line :direction 'next))))

(defun avy-jump-helm-line--get-dispatch-alist ()
  (when (boundp 'avy-dispatch-alist)
    (let* ((default-action (or avy-jump-helm-line-default-action
                               'move-only))
           (full-list (list 'persistent 'select 'move-only))
           (action-list (delete default-action full-list))
           dispatch-alist)
      (dolist (w action-list dispatch-alist)
        (let ((key-sym (intern (format "avy-jump-helm-line-%s-key" w)))
              (action-sym (intern (format "avy-jump-helm-line-action-%s" w))))
          (eval `(and ,key-sym
                      (push (cons ,key-sym ',action-sym) dispatch-alist))))))))

(defun avy-jump-helm-line--collect-lines (win-start &optional win-end)
  "Collect lines in helm window."
  (save-excursion
    (save-restriction
      (let ((win-end (or win-end
                         (save-excursion
                           (goto-char win-start)
                           (forward-line
                            (ceiling (window-screen-lines)))
                           (line-beginning-position))))
            candidates)
        (setq avy-jump-helm-line--last-win-start win-start)
        (narrow-to-region win-start win-end)
        (goto-char (point-min))
        (while (or (helm-pos-header-line-p)
                   (helm-pos-candidate-separator-p))
          (forward-line 1))
        (while (< (point) (point-max))
          (push (cons (point) (selected-window))
                candidates)
          (forward-line 1)
          (while (and (or (helm-pos-header-line-p)
                          (helm-pos-candidate-separator-p))
                      (< (point) (point-max)))
            (forward-line 1)))
        (nreverse candidates)))))

(defun avy-jump-helm-line--do ()
  (if helm-alive-p
      (let* ((orig-window (selected-window))
             (avy-background avy-jump-helm-line-background)
             (avy-keys (or avy-jump-helm-line-keys
                           avy-keys))
             (avy-dispatch-alist (avy-jump-helm-line--get-dispatch-alist))
             (avy-style
              (or avy-jump-helm-line-style
                  avy-style))
             avy-action
             avy-all-windows)
        (unwind-protect
            (with-selected-window (helm-window)
              (and (numberp
                    (avy--process (avy-jump-helm-line--collect-lines
                                   (window-start)
                                   (window-end (selected-window) t))
                                  (avy--style-fn avy-style)))
                   (or avy-action
                       (avy-jump-helm-line--exec-default-action))))
          (select-window orig-window)))
    (error "No helm session is running")))

(defun avy-jump-helm-line--exec-default-action ()
  (when (and helm-alive-p
             (eq avy-jump-helm-line-default-action
                 avy-jump-helm-line--action-type))
    (avy-jump-helm-line--move-selection)
    (cond
     ((eq avy-jump-helm-line-default-action 'select)
      (helm-exit-minibuffer))
     ((eq avy-jump-helm-line-default-action 'persistent)
      (helm-execute-persistent-action)))))

(defmacro avy-jump-helm-line--with-helm-minibuffer-setup-hook (fun &rest body)
  "Temporarily add FUN to `helm-minibuffer-set-up-hook' while executing BODY."
  (declare (indent 1) (debug t))
  (let ((hook (make-symbol "setup-hook")))
    `(let (,hook)
       (setq ,hook
             (lambda ()
               (remove-hook 'helm-minibuffer-set-up-hook ,hook)
               (funcall ,fun)))
       (unwind-protect
           (progn
             (add-hook 'helm-minibuffer-set-up-hook ,hook)
             ,@body)
         (remove-hook 'helm-minibuffer-set-up-hook ,hook)))))

(defun avy-jump-helm-line--do-if-empty ()
  (when (string-equal (minibuffer-contents) "")
    (condition-case err
        (avy-jump-helm-line)
      (error
       (message "%s" (error-message-string err))))))

(defun avy-jump-helm-line--maybe (orig-func &rest args)
  (avy-jump-helm-line--with-helm-minibuffer-setup-hook
      (lambda ()
        (run-at-time avy-jump-helm-line-idle-delay nil
                     #'avy-jump-helm-line--do-if-empty))
    (apply orig-func args)))

(defun avy-jump-helm-line--cleanup-overlays ()
  (with-helm-window (avy--done)))

;;;###autoload
(defun avy-jump-helm-line ()
  "Jump to a candidate and execute the default action."
  (interactive)
  (let ((avy-jump-helm-line--action-type
         avy-jump-helm-line-default-action))
    (avy-jump-helm-line--do)))

;;;###autoload
(defun avy-jump-helm-line-and-select ()
  "Jump to and select the candidate in helm window."
  (interactive)
  (let ((avy-jump-helm-line-default-action 'select))
    (avy-jump-helm-line)))

;;;###autoload
(defalias 'avy-jump-helm-line-execute-action 'avy-jump-helm-line-and-select)

;;;###autoload
(defun avy-jump-helm-line-idle-exec-add (func)
  (advice-add func :around #'avy-jump-helm-line--maybe))

;;;###autoload
(defun avy-jump-helm-line-idle-exec-remove (func)
  (advice-remove func #'avy-jump-helm-line--maybe))


(provide 'avy-jump-helm-line)
;;; avy-jump-helm-line.el ends here

;;; ansi-workaround.el --- Handle ESC [ and ESC O key sequences with ANSI support -*- lexical-binding: t -*-
;; Author: gudzpoz <gudzpoz at live.com>

;; Version: 0.0.1

;;
;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; So "M-\[" and "M-O" key bindings cause trouble under terminal, because ANSI
;; uses "ESC [" and "ESC O" to represent these keys but cannot distinguish other
;; ANSI sequences from them. For example, arrows keys are sent as "ESC O
;; A/B/C/D", which is identical to pressing "M-O" and then "A/B/C/D".
;;
;; Evil mode and viper mode are facing similar problems: the ESC key also leads
;; ANSI sequences. They solve this by putting key delay into consideration: an
;; ESC key followed immediately by other keys is probably ANSI, while ESC
;; followed by nothing should possibly be sent by a user key press.
;;
;; This tiny script copies what Evil does: it rewrites `input-decode-map' to
;; yield different keys depending on pending input. It need to do one thing
;; more, however, to actually avoid triggering "M-O/\[" bindings prematurely: it
;; advises `define-key' to remap bindings to "M-O/\[" to symbolic `M-O' or
;; `M-\['. Otherwise, Emacs will always prioritize the existing bindings,
;; ignoring any events that follow. Evil does not need to do this because Emacs
;; represents an ESC key press as a symbolic `escape' event, which Evil binds
;; to. No, if any program is binding to "ESC" the character instead of `escape',
;; I don't think Evil (under TUI) will not work any longer.
;;
;; Because it maps the keys with `define-key' advices, this mode shoud be loaded
;; before any "M-O" or "M-\[" key is actually bound.

;;; Code:

(require 'easy-mmode)
(require 'nadvice)
(require 'cl-macs)

(defvar ansi-workaround-bindings
  '((?\M-\[ [?\e ?\[] M-\[)
    (?\M-O  [?\e ?O]  M-O))
  "Keys to remap.")

(defun ansi-workaround--remap-key (key)
  "Map M-O bindings to `M-O' (symbol)."
  (if (sequencep key)
      (prog1 (setq key (vconcat key))
        (dotimes (i (min (length key) 3))
          (if-let* ((event (aref key i))
                    (mapping (assq event ansi-workaround-bindings)))
              (aset key i (caddr mapping))))))
  key)

(defun ansi-workaround--define-key-advice (f keymap key def &optional remove)
  (funcall f keymap
           (if (eq keymap input-decode-map) key (ansi-workaround--remap-key key))
           def remove))
(defun ansi-workaround--add-advice ()
  "Add advice to remap keys with `ansi-workaround--remap-key'.

Note that we don't support undo the advice because it is pointless: we
cannot undo the changes done to keymaps, and merely undoing the advice
is not helpful."
  (unless (advice-member-p #'ansi-workaround--define-key-advice 'define-key)
    (advice-add 'define-key :around #'ansi-workaround--define-key-advice)))

(defvar ansi-workaround-delay 0.01
  "Time in seconds to wait for subsequent events after ESC [ or ESC O.")

(defvar ansi-workaround-mode nil
  "Non-nil if ANSI Workaround mode is enabled.")

(defun ansi-workaround--esc-seq-filter (seq mapped)
  "Filter function for ESC sequences.
Returns either the translated key or original keymap based on input timing.
SEQ is the expected sequence part (either ?[ or ?O).
KEYMAP is the original keymap for the sequence."
  (lambda (map)
    (if (and (equal seq (this-single-command-keys))
             (sit-for ansi-workaround-delay))
        mapped
      map)))

(defun ansi-workaround-init (frame)
  "Initialize ANSI workaround for FRAME."
  (with-selected-frame frame
    (let ((term (frame-terminal frame)))
      (unless (terminal-parameter term 'ansi-workaround-original)
        (set-terminal-parameter
         term 'ansi-workaround-original
         (cl-loop
          for binding in ansi-workaround-bindings
          collect
          ;; Install filtered bindings
          (let* ((seq (if (eq (terminal-live-p term) t)
                          (cadr binding)
                        (vector (car binding))))
                 (original (lookup-key input-decode-map seq)))
            (define-key input-decode-map seq
                        `(menu-item ""
                                    ,original
                                    :filter
                                    ,(ansi-workaround--esc-seq-filter
                                      seq
                                      (vector (caddr binding)))))
            ;; Save original bindings
            (cons seq original))))))))

(defun ansi-workaround-deinit (frame)
  "Remove ANSI workaround for FRAME."
  (with-selected-frame frame
    (let ((term (frame-terminal frame)))
      ;; Restore original bindings
      (cl-loop for binding in (terminal-parameter term 'ansi-workaround-original)
               do (define-key input-decode-map (car binding) (cdr binding)))
      ;; Clear terminal parameters
      (set-terminal-parameter term 'ansi-workaround-original nil))))

;;;###autoload
(define-minor-mode ansi-workaround-mode
  "Global minor mode to handle ESC [ and ESC O with ANSI sequence support.

Please note that once the mode is disabled, you won't be able to used
any `M-O' or `M-\[' mapping anymore, even under GUI."
  :global t
  (if ansi-workaround-mode
      (progn
        (ansi-workaround--add-advice)
        (add-hook 'after-make-frame-functions #'ansi-workaround-init)
        (mapc #'ansi-workaround-init (frame-list)))
    (remove-hook 'after-make-frame-functions #'ansi-workaround-init)
    (mapc #'ansi-workaround-deinit (frame-list))))

(provide 'ansi-workaround)
;;; ansi-workaround.el ends here

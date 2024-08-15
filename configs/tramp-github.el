;;; tramp-github.el --- Tramp extension to access GitHub repo in Emacs  -*- lexical-binding:t -*-

;; Copyright (C) 2024 The Tramp GitHub Developers
;;
;; Version: 0.1.0
;; Author: gudzpoz <gudzpoz@apache.org>
;; Keywords: tramp, emacs, github, rest
;; Package-Requires: ((emacs "28.0"))
;; Acknowledgements: Thanks to tramp-hdfs.el, tramp-sh.el for inspiration & code.
;;
;; Contains code from GNU Emacs <https://www.gnu.org/software/emacs/>,
;; released under the GNU General Public License version 3 or later.
;; Contains code from tramp-hdfs.el <https://github.com/raghavgautam/tramp-hdfs>,
;; released under the GNU General Public License version 3 or later.
;; You should have received a copy of the GNU General Public License
;; along with tramp-github.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;; Access GitHub repo over Tramp.
;; This program uses api.github.com to access GitHub contents.
;;
;; Please note that GitHub poses a rate limit over api.github.com access.
;; The limit for unauthorized access is around 60 per hour. You might
;; want to set `tramp-github-api-token' to work around this.
;; (https://github.com/settings/tokens/new?description=TRAMP&scopes=public_repo)
;;
;; Usage:
;;   open /gh:repo@user:/branch/file_path in Emacs
;;   where user & repo is taken from the GitHub url github.com/user/repo.
;;
;;; Code:

(require 'tramp)
(require 'tramp-sh)
(require 'tramp-compat)
(require 'json)

;;;###autoload
(defconst tramp-github-method "gh"
  "Method to browse GitHub repos.")

(defgroup tramp-github nil
  "Tramp extension to access GitHub repo in Emacs.")
(defcustom tramp-github-check-parent-listing t
  "If a file is not present in the listing in its parent directory,
do not bother checking its existence with another API call.
Most often, the parent directory of a file is already in the cache，
and checking this can save lots of API requests initiated by other modes.
Note that GitHub limits the directory listing to ~1000 entries.
If you are access a directory with over a thousand files, consider disabling this."
  :type '(boolean)
  :group 'tramp-github)
(defcustom tramp-github-api-token ""
  "The API token to use when fetching remote contents."
  :type '(string)
  :group 'tramp-github)

;; It must be a `defsubst' in order to push the whole code into
;; tramp-loaddefs.el.  Otherwise, there would be recursive autoloading.
;;;###autoload
(defsubst tramp-github-file-name-p (vec-or-filename)
  "Check if it's a FILENAME for GitHub TRAMP."
  (when-let* ((vec (tramp-ensure-dissected-file-name vec-or-filename)))
    (string= (tramp-file-name-method vec) tramp-github-method)))

;;;###autoload
(defun tramp-github-file-name-handler (operation &rest args)
  "Invoke GitHub related OPERATION.
First arg specifies the OPERATION, second arg is a list of arguments to
pass to the OPERATION.
Optional argument ARGS is a list of arguments to pass to the OPERATION."
  (if (not (boundp 'tramp-locked))
      (tramp-github-file-name-handler-nolock operation args)
    (error "tramp-github: locking unsupported, upgrade your emacs")))

(defun tramp-github-file-name-handler-nolock (operation args)
  (save-match-data
    (let ((fn (assoc operation tramp-github-file-name-handler-alist)))
      (if fn
          (apply (cdr fn) args)
        (tramp-run-real-handler operation args)))))

;; API request cache.
(setq tramp-github--request-caches
      (list (make-hash-table :test 'equal) (make-hash-table :test 'equal)))
(defconst tramp-github--cache-time-limit 3600)
(defsubst tramp-github--now ()
  (time-convert (current-time) 'integer))
(defsubst tramp-github--get-cache (raw)
  (if raw
      (car tramp-github--request-caches)
    (cadr tramp-github--request-caches)))
(defsubst tramp-github--cache-get (raw url)
  (let ((pair (gethash url (tramp-github--get-cache raw))))
    (when pair
      (if (< (tramp-github--now) (+ tramp-github--cache-time-limit (car pair)))
          (cadr pair)
        (remhash url (tramp-github--get-cache raw))))))
(defsubst tramp-github--cache-put (raw url value)
  (puthash url (list (tramp-github--now) value) (tramp-github--get-cache raw)))
(defun tramp-github-cache-clear ()
  (interactive)
  (clrhash (car tramp-github--request-caches))
  (clrhash (cadr tramp-github--request-caches)))
(defun tramp-github-cache-evict (&optional raw)
  (interactive)
  (let* ((map (tramp-github--get-cache raw))
         (keys (let (alist)
                 (maphash (lambda (k v) (push k alist)) map)
                 alist)))
    (dolist (k keys) (tramp-github--cache-get raw k))))
(run-with-idle-timer 600 t (lambda ()
                             (tramp-github-cache-evict nil)
                             (tramp-github-cache-evict t)))

(defun tramp-github--url-get (url vec &optional raw)
  "Do a rest call using method METHOD to the url & return the results."
  (when vec (tramp-message vec 10 "Url: %s" url))
  (let ((cache (tramp-github--cache-get raw url)))
    (if cache cache
      (let ((response (tramp-github--url-get-body url raw)))
        (tramp-github--cache-put raw url response)
        (when vec (tramp-message vec 10 "Url: %s Response: %s" url response))
        response))))

(defun tramp-github--url-get-body (url raw)
  "Given a BUFFER with HTTP response, delete the headers.  Return parsed status and headers as list."
  (let ((url-mime-accept-string (if raw "application/vnd.github.raw+json" "application/vnd.github.object+json"))
        (url-request-extra-headers (if (equal tramp-github-api-token "")
                                       '()
                                     `(("Authorization" . ,(concat "Bearer " tramp-github-api-token))))))
    (with-current-buffer (url-retrieve-synchronously url)
      (delete-region (point-min) (1+ url-http-end-of-headers))
      (buffer-string))))

(defun tramp-github--get-default-branch (vec)
  "Get the default branch of a repo."
  (let* ((owner (tramp-file-name-host vec))
         (repo (tramp-file-name-user vec))
         (url (format "https://api.github.com/repos/%s/%s" owner repo))
         (response (tramp-github--parse-json (tramp-github--url-get url vec) vec)))
    (url-hexify-string (gethash "default_branch" response))))

(defun tramp-github--list-repo-branches (vec)
  "List the branches of a repo."
  (let* ((owner (tramp-file-name-host vec))
         (repo (tramp-file-name-user vec))
         (url (format "https://api.github.com/repos/%s/%s/branches" owner repo))
         (response (tramp-github--parse-json (tramp-github--url-get url vec) vec)))
    (mapcar (lambda (branch) (url-hexify-string (gethash "name" branch))) response)))

(defun tramp-github--list-directory (path vec)
  "List the files in a directory.  Return a list of '(child-type child-name).
  PATH is a string.  VEC is a tramp vector."
  (if (or (equal path "") (equal path "/"))
      (mapcar (apply-partially #'list 'dir) (tramp-github--list-repo-branches vec))
    (let* ((url (tramp-github-create-file-url path vec))
           (response (tramp-github--parse-json (tramp-github--url-get url vec) vec))
           (type (intern (gethash "type" response))))
      (if (not (eq type 'dir)) type
        (mapcar (lambda (item) (list
                                (intern (gethash "type" item)) ;; 'dir or 'file
                                (gethash "name" item)))
                (gethash "entries" response))))))

(defun tramp-github--get-file (path vec)
  "Get the contents of a file.  PATH is a string.  VEC is a tramp vector."
  (let* ((url (tramp-github-create-file-url path vec))
         (type (tramp-github--list-directory path vec)))
    (if (not (eq 'file type)) type
      (let* ((info (tramp-github--parse-json (tramp-github--url-get url vec) vec))
             (content (gethash "content" info))
             (encoding (gethash "encoding" info)))
        (if (equal encoding "base64")
            (base64-decode-string content)
          (tramp-github--url-get url vec t))))))

(defun tramp-github-create-file-url (path vec)
  "Concatenates parts into a GitHub API url."
  (let* ((owner (tramp-file-name-host vec))
         (repo (tramp-file-name-user vec))
         (realpath (file-truename (s-replace "//" "/" (concat "/" path))))
         (sep (or (string-match "/" realpath 1) (length realpath)))
         (branch (url-unhex-string (substring realpath 1 sep)))
         (p (if (= sep (length realpath)) "" (substring realpath (1+ sep)))))
    (format "https://api.github.com/repos/%s/%s/contents/%s?ref=%s"
            owner repo p branch)))

(defun tramp-github-handle-expand-file-name (name &optional dir)
  "This implementation is mostly copied from `tramp-handle-expand-file-name'.
Search for `NOTE' in the comments to see the only modification to expand a default branch."
  ;; If DIR is not given, use `default-directory' or "/".
  (setq dir (or dir default-directory "/"))
  ;; Unless NAME is absolute, concat DIR and NAME.
  (unless (file-name-absolute-p name)
    (setq name (concat (file-name-as-directory dir) name)))
  ;; If NAME is not a Tramp file, run the real handler.
  (if (not (tramp-connectable-p name))
      (tramp-run-real-handler 'expand-file-name (list name nil))
    ;; Dissect NAME.
    (with-parsed-tramp-file-name
        name nil
      (unless (tramp-run-real-handler 'file-name-absolute-p (list localname))
        ;; NOTE: The following line is the only modification.
        (setq localname (concat "/" (tramp-github--get-default-branch v) "/" localname)))
      ;; There might be a double slash, for example when "~/"
      ;; expands to "/".  Remove this.
      (while (string-match "//" localname)
        (setq localname (replace-match "/" t t localname)))
      ;; No tilde characters in file name, do normal
      ;; `expand-file-name' (this does "/./" and "/../").  We bind
      ;; `directory-sep-char' here for XEmacs on Windows, which would
      ;; otherwise use backslash.  `default-directory' is bound,
      ;; because on Windows there would be problems with UNC shares or
      ;; Cygwin mounts.
      (let ((directory-sep-char ?/)
            (default-directory tramp-compat-temporary-file-directory))
        (tramp-make-tramp-file-name
         v
         (tramp-drop-volume-letter
          (tramp-run-real-handler
           'expand-file-name (list localname))))))))

(defun tramp-github--file-exists-pre-p (localname vec)
  "Checks if a file exists according to `tramp-github-check-parent-listing'."
  (if (not tramp-github-check-parent-listing) t
    (let* ((parent (file-name-parent-directory localname))
           (name (file-name-nondirectory (directory-file-name localname)))
           (url (tramp-github-create-file-url parent vec)))
      (if (not parent) t
        (let ((info (tramp-github--parse-json (tramp-github--url-get url vec) vec)))
          (seq-filter (lambda (item) (equal name (gethash "name" item)))
                      (if (typep info 'hash-table)
                          (gethash "entries" info)
                        ;; Although we request application/vnd.github.object+json,
                        ;; GitHub sometimes still returns an array instead of an object.
                        ;; No idea why...
                        info)))))))

(defun tramp-github-handle-file-attributes (filename &optional id-format)
  "Like `file-attributes' for Tramp files.
Argument FILENAME the file.
Optional argument ID-FORMAT ignored."
  (unless id-format (setq id-format 'integer))
  (ignore-errors
    (with-parsed-tramp-file-name
        (expand-file-name filename) nil
      (with-tramp-file-property v localname (format "file-attributes-%s" id-format)
        (when (tramp-github--file-exists-pre-p localname v)
          (let* ((url (tramp-github-create-file-url localname v))
                 (info (tramp-github--parse-json (tramp-github--url-get url v) v)))
            (tramp-github--decode-file-status info v)))))))

(defun tramp-github--parse-json (string vec)
  "Convert supplied JSON to Lisp notation.
Argument STRING the json string.
Argument VEC specifies the connection."
  (condition-case err
      (json-parse-string string)
    (json-parse-error (tramp-error vec 'file-error "%s" err))))

(defun tramp-github--decode-file-status (info vec)
  "Decode association list to normal list.  Return value similar to `file-attributes'.
Argument FILE-STATUS is the file status as is returned by `json-parse-string'.
Argument VEC specifies the connection."
  (let* ((type (intern (gethash "type" info)))
         (dir? (eq type 'dir))
         (default-time (time-convert 0 nil))
         (size (gethash "size" info)))
    (list
     ;; 0. t for directory, string (name linked to) for symbolic link, or nil.
     dir?
     ;; 1. Number of links to file.
     (if dir? (length (gethash "items" info)) 1)
     ;; 2. File uid as a string or (if ID-FORMAT is integer or a string value
     ;;                                cannot be looked up) as an integer.
     0
     ;; 3. File gid, likewise.
     0
     ;; 4. Last access time, in the style of current-time.
     ;; (See a note below about access time on FAT-based filesystems.)
     default-time
     ;; 5. Last modification time, likewise.  This is the time of the last
     ;; change to the file's contents.
     default-time
     ;; 6. Last status change time, likewise.  This is the time of last change
     ;; to the file's attributes: owner and group, access mode bits, etc.
     default-time
     ;; 7. Size in bytes, as an integer.
     size
     ;; 8. File modes, as a string of ten letters or dashes as in ls -l.
     (concat (if dir? "d" "-") "r-xr--r--")
     ;; 9. An unspecified value, present only for backward compatibility.
     t
     ;; 10. inode number, as a nonnegative integer.
     (tramp-get-inode vec)
     ;; 11. Filesystem device identifier, as an integer or a cons cell of integers.
     (tramp-get-device vec))))

(defun tramp-github-handle-file-directory-p (filename)
  "Like `file-directory-p' for Tramp files.
FILENAME the filename to check."
  (and (file-exists-p filename)
       (eq ?d (aref (nth 8 (file-attributes filename)) 0))))

(defun tramp-github-handle-file-local-copy (filename)
  "Like `file-local-copy' for Tramp files.
FILENAME the filename to be copied locally."
  (with-parsed-tramp-file-name
      filename nil
    (unless (and (file-exists-p filename) (not (file-directory-p filename)))
      (tramp-error
       v 'file-error
       "Cannot make local copy of non-existing file `%s'" filename))
    (let* ((content (tramp-github--get-file localname v))
           (tmpfile (tramp-compat-make-temp-file filename)))
      (message tmpfile)
      (let ((coding-system-for-write 'no-conversion)) (write-region content nil tmpfile))
      ;; Set proper permissions.
      (set-file-modes tmpfile (tramp-default-file-modes filename))
      ;; Set local user ownership.
      (tramp-set-file-uid-gid tmpfile)
      (message "Written content to: %s %s %s" tmpfile (md5 content) (md5 tmpfile))
      (run-hooks 'tramp-handle-file-local-copy-hook)
      tmpfile)))

(defun tramp-github-handle-file-name-all-completions (file directory)
  "Like `file-name-all-completions' for Tramp files.
Return a list of all completions of file name FILE in directory DIRECTORY.
These are all file names in directory DIRECTORY which begin with FILE."
  (all-completions
   file
   (with-parsed-tramp-file-name
       directory nil
     (with-tramp-file-property
         v localname "file-name-all-completions"
       (let ((file-list (tramp-github--list-directory localname v)))
         (mapcar (lambda (pair)
                   (let ((type (car pair))
                         (name (cadr pair)))
                     (concat name (if (eq type 'dir) "/" ""))))
                 file-list))))))

(defun tramp-github-handle-insert-directory
    (filename switches &optional wildcard full-directory-p)
  "Like `insert-directory' for Tramp files."
  (setq filename (expand-file-name filename))
  (with-parsed-tramp-file-name
      filename nil
    (save-match-data
      (with-current-buffer (current-buffer)
        (insert (mapconcat (lambda (pair)
                             (let ((type (car pair))
                                   (name (cadr pair)))
                               (concat name (if (eq type 'dir) "/" "") "\n")))
                           (if full-directory-p
                               (tramp-github--list-directory localname v)
                             (list (list 'file localname)))
                           ""))))))

;; New handlers should be added here.
(defconst tramp-github-file-name-handler-alist
  '(;; `access-file' performed by default handler.
    (add-name-to-file . ignore)
    ;; `byte-compiler-base-file-name' performed by default handler.
    (copy-directory . ignore)
    (copy-file . ignore)
    (delete-directory . ignore)
    (delete-file . ignore)
    ;; `diff-latest-backup-file' performed by default handler.
    (directory-file-name . tramp-handle-directory-file-name)
    (directory-files . tramp-handle-directory-files)
    (directory-files-and-attributes . tramp-handle-directory-files-and-attributes)
    (dired-call-process . ignore)
    (dired-compress-file . ignore)
    (dired-recursive-delete-directory . ignore)
    (dired-uncache . tramp-handle-dired-uncache)
    (expand-file-name . tramp-github-handle-expand-file-name)
    (file-accessible-directory-p . tramp-github-handle-file-directory-p)
    (file-acl . ignore)
    (file-attributes . tramp-github-handle-file-attributes)
    (file-directory-p . tramp-github-handle-file-directory-p)
    (file-executable-p . tramp-handle-file-exists-p)
    (file-exists-p . tramp-handle-file-exists-p)
    ;; `file-in-directory-p' performed by default handler.
    (file-local-copy . tramp-github-handle-file-local-copy)
    (file-modes . tramp-handle-file-modes)
    (file-name-all-completions . tramp-github-handle-file-name-all-completions)
    (file-name-as-directory . tramp-handle-file-name-as-directory)
    (file-name-completion . tramp-handle-file-name-completion)
    (file-name-directory . tramp-handle-file-name-directory)
    (file-name-nondirectory . tramp-handle-file-name-nondirectory)
    (file-newer-than-file-p . tramp-handle-file-newer-than-file-p)
    (file-notify-add-watch . tramp-handle-file-notify-add-watch)
    (file-notify-rm-watch . tramp-handle-file-notify-rm-watch)
    (file-ownership-preserved-p . ignore)
    (file-readable-p . tramp-handle-file-exists-p)
    (file-regular-p . tramp-handle-file-regular-p)
    (file-remote-p . tramp-handle-file-remote-p)
    ;; `file-selinux-context' performed by default handler.
    ;; `file-truename' performed by default handler.
    (file-writable-p . ignore)
    ;; `find-file-noselect' performed by default handler.
    ;; `get-file-buffer' performed by default handler.
    (insert-directory . tramp-github-handle-insert-directory)
    (insert-file-contents . tramp-handle-insert-file-contents)
    (insert-file-contents-literally . ignore)
    (load . tramp-handle-load)
    (make-auto-save-file-name . ignore)
    (make-directory . ignore)
    (make-symbolic-link . ignore)
    (process-file . ignore)
    (rename-file . ignore)
    (set-file-acl . ignore)
    (set-file-modes . ignore)
    (set-file-selinux-context . ignore)
    (set-file-times . ignore)
    (set-visited-file-modtime . tramp-handle-set-visited-file-modtime)
    (shell-command . ignore)
    (start-file-process . ignore)
    (unhandled-file-name-directory . ignore)
    (vc-registered . ignore)
    (verify-visited-file-modtime . tramp-handle-verify-visited-file-modtime)
    (write-region . ignore))
  "Alist of handler functions.
Operations not mentioned here will be handled by the default Emacs primitives.")

;; ... and add it to the method list.
;;;###autoload
(eval-after-load 'tramp
  (lambda ()
    (add-to-list 'tramp-methods
                 `(,tramp-github-method))
    (add-to-list 'tramp-foreign-file-name-handler-alist
                 (cons #'tramp-github-file-name-p #'tramp-github-file-name-handler))))

(tramp-set-completion-function tramp-github-method '())
(add-hook 'tramp-unload-hook (lambda () (unload-feature 'tramp-github 'force)))

(provide 'tramp-github)

;;; tramp-github.el ends here

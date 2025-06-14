;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. "~/.mycontribs/")
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers '(;; Languages
                                       bibtex
                                       c-c++
                                       cmake
                                       csv
                                       d
                                       emacs-lisp
                                       go
                                       graphviz
                                       html
                                       ;; Great. Now I have
                                       ;; .project/.classpath/.settings files
                                       ;; everywhere in my monolithic Java
                                       ;; project. java
                                       (javascript :variables
                                                   js2-basic-offset 2
                                                   js-indent-level 2
                                                   javascript-backend 'lsp)
                                       (lua :variables lua-backend 'lua-mode)
                                       markdown
                                       nginx
                                       php
                                       protobuf
                                       (python :variables
                                               python-fill-column 120
                                               python-backend 'lsp
                                               python-lsp-server 'pylsp)
                                       rust
                                       (scheme :variables scheme-implementations '(chez))
                                       sql
                                       systemd
                                       typescript
                                       vimscript
                                       yaml

                                       ;; Programming
                                       (auto-completion :variables
                                                        auto-completion-idle-delay 0.0
                                                        spacemacs-default-company-backends '(company-files company-capf)
                                                        :disabled-for org)
                                       debug
                                       dtrt-indent
                                       (git :variables
                                            git-enable-magit-delta-plugin t
                                            git-enable-magit-todos-plugin t
                                            git-magit-status-fullscreen t)
                                       lsp
                                       parinfer
                                       (version-control :variables version-control-diff-side 'left)

                                       ;; Text editing
                                       emoji
                                       (org :variables
                                            ;; ; valign mandates no space before cell contents, while org-table-align automatically do so
                                            ;; org-enable-valign t
                                            org-enable-roam-support t
                                            org-enable-roam-ui t
                                            org-enable-roam-protocol t
                                            org-enable-notifications t
                                            org-start-notification-daemon-on-startup t)
                                       multiple-cursors
                                       spacemacs-visual
                                       spacemacs-editing-visual
                                       unicode-fonts

                                       ;; Emacs
                                       better-defaults
                                       helpful
                                       ibuffer
                                       ivy
                                       treemacs

                                       ;; Apps
                                       (erc :variables
                                            erc-enable-sasl-auth t)
                                       ;; (erc :variables
                                       ;;      erc-enable-notifications t
                                       ;;      erc-enable-sasl-auth t
                                       ;;      erc-server-list '(("irc.libera.chat" :port "6697" :ssl t)))
                                       eww
                                       finance
                                       gnus
                                       (llm-client :variables
                                                   llm-client-enable-ellama t)
                                       (restclient :variables
                                                   restclient-use-org t)
                                       semantic
                                       (shell :variables
                                              shell-default-shell 'eshell
                                              shell-default-term-shell "/bin/zsh"
                                              shell-default-position 'full)
                                       ;; spell-checking
                                       syntax-checking
                                       xclipboard
                                       )

   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(;; Languages
                                      bbcode-mode
                                      (cp2k-mode :location (recipe :fetcher url
                                                                   :url "https://cdn.jsdelivr.net/gh/gudzpoz/cp2k@emacs-package-headers/tools/input_editing/emacs/cp2k-mode.el"))
                                      dockerfile-mode
                                      docker-compose-mode

                                      ;; Apps
                                      (edraw :location (recipe :fetcher github :repo "misohena/el-easydraw"))
                                      ement
                                      mastodon
                                      literate-calc-mode
                                      (ready-player :location (recipe :fetcher github :repo "xenodium/ready-player"))

                                      ;; Editing
                                      beacon
                                      flycheck-vale
                                      evil-easymotion
                                      pangu-spacing
                                      sis
                                      writegood-mode

                                      ;; Utils
                                      all-the-icons
                                      (appindicator :location (recipe :fetcher github :repo "jumper047/emacs-appindicator"))
                                      (codegeex :location (recipe :fetcher url
                                                                  :url "https://cdn.jsdelivr.net/gh/hzhangxyz/codegeex.el@main/codegeex.el"))
                                      elisp-benchmarks
                                      eshell-vterm
                                      esup
                                      emacs-everywhere
                                      hnreader
                                      jedi
                                      jupyter
                                      org-ql
                                      project-tab-groups
                                      rg
                                      rotate
                                      scratch
                                      super-save
                                      (tramp-github :location (recipe :fetcher url
                                                                      :url "https://cdn.jsdelivr.net/gh/gudzpoz/sys-jumble@main/configs/tramp-github.el"))
                                      xclip
                                      zoxide)

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(evil-escape
                                    erc-image
                                    erc-social-graph
                                    erc-tweet
                                    erc-view-log
                                    erc-yt)

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need to
   ;; compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;;
   ;; WARNING: pdumper does not work with Native Compilation, so it's disabled
   ;; regardless of the following setting when native compilation is in effect.
   ;;
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=$HOME/.emacs.d/.cache/dumps/spacemacs-27.1.pdmp
   ;; (default (format "spacemacs-%s.pdmp" emacs-version))
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'hybrid

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version nil

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner nil

   ;; Scale factor controls the scaling (size) of the startup banner. Default
   ;; value is `auto' for scaling the logo automatically to fit all buffer
   ;; contents, to a maximum of the full image height and a minimum of 3 line
   ;; heights. If set to a number (int or float) it is used as a constant
   ;; scaling factor for the default logo size.
   dotspacemacs-startup-banner-scale 'auto

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   ;; The exceptional case is `recents-by-project', where list-type must be a
   ;; pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
   ;; number is the project limit and the second the limit on the recent files
   ;; within a project.
   dotspacemacs-startup-lists '((recents   . 5)
                                (agenda    . 7)
                                (todos     . 7)
                                (bookmarks . 5))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Show numbers before the startup list lines. (default t)
   dotspacemacs-show-startup-list-numbers t

   ;; The minimum delay in seconds between number key presses. (default 0.4)
   dotspacemacs-startup-buffer-multi-digit-delay 0.4

   ;; If non-nil, show file icons for entries and headings on Spacemacs home buffer.
   ;; This has no effect in terminal or if "all-the-icons" package or the font
   ;; is not installed. (default nil)
   dotspacemacs-startup-buffer-show-icons t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'org-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent nil

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable nil

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message "* math

#+begin_src literate-calc
  Answer = 42
  = fsolve([Question, Answer], [Question])
#+end_src
"

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(modus-vivendi-tinted modus-operandi-deuteranopia)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(doom :separator nil :separator-scale 1.2)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts. This setting has no effect when
   ;; running Emacs in terminal. The font set here will be used for default and
   ;; fixed-pitch faces. The `:size' can be specified as
   ;; a non-negative integer (pixel size), or a floating-point (point size).
   ;; Point size is recommended, because it's device independent. (default 10.0)
   dotspacemacs-default-font '("Sarasa Term SC Nerd"
                               :size 10.5
                               :weight normal
                               :width normal)

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "<M-return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location nil

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 1.0

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; It is also possible to use a posframe with the following cons cell
   ;; `(posframe . position)' where position can be one of `center',
   ;; `top-center', `bottom-center', `top-left-corner', `top-right-corner',
   ;; `top-right-corner', `bottom-left-corner' or `bottom-right-corner'
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; Whether side windows (such as those created by treemacs or neotree)
   ;; are kept or minimized by `spacemacs/toggle-maximize-window' (SPC w m).
   ;; (default t)
   dotspacemacs-maximize-window-keep-side-windows t

   ;; If nil, no load-hints enabled. If t, enable the `load-hints' which will
   ;; put the most likely path on the top of `load-path' to reduce walking
   ;; through the whole `load-path'. It's an experimental feature to speedup
   ;; Spacemacs on Windows. Refer the FAQ.org "load-hints" session for details.
   dotspacemacs-enable-load-hints nil

   ;; If t, enable the `package-quickstart' feature to avoid full package
   ;; loading, otherwise no `package-quickstart' attemption (default nil).
   ;; Refer the FAQ.org "package-quickstart" section for details.
   dotspacemacs-enable-package-quickstart nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default t) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup t

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' to obtain fullscreen
   ;; without external boxes. Also disables the internal border. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes the
   ;; transparency level of a frame background when it's active or selected. Transparency
   ;; can be toggled through `toggle-background-transparency'. (default 90)
   dotspacemacs-background-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols nil

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Show the scroll bar while scrolling. The auto hide time can be configured
   ;; by setting this variable to a number. (default t)
   dotspacemacs-scroll-bar-while-scrolling nil

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but only visual lines are counted. For example, folded lines will not be
   ;; counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers t

   ;; Code folding method. Possible values are `evil', `origami' and `vimish'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil and `dotspacemacs-activate-smartparens-mode' is also non-nil,
   ;; `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil smartparens-mode will be enabled in programming modes.
   ;; (default t)
   dotspacemacs-activate-smartparens-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; The backend used for undo/redo functionality. Possible values are
   ;; `undo-fu', `undo-redo' and `undo-tree' see also `evil-undo-system'.
   ;; Note that saved undo history does not get transferred when changing
   ;; your undo system. The default is currently `undo-fu' as `undo-tree'
   ;; is not maintained anymore and `undo-redo' is very basic.
   dotspacemacs-undo-system 'undo-fu

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; If nil then Spacemacs uses default `frame-title-format' to avoid
   ;; performance issues, instead of calculating the frame title by
   ;; `spacemacs/title-prepare' all the time.
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%a"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Color highlight trailing whitespace in all prog-mode and text-mode derived
   ;; modes such as c++-mode, python-mode, emacs-lisp, html-mode, rst-mode etc.
   ;; (default t)
   dotspacemacs-show-trailing-whitespace t

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; The variable `global-spacemacs-whitespace-cleanup-modes' controls
   ;; which major modes have whitespace cleanup enabled or disabled
   ;; by default.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'all

   ;; If non-nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfere with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Accept SPC as y for prompts if non-nil. (default nil)
   dotspacemacs-use-SPC-as-y nil

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non-nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source t

   ;; If non-nil then byte-compile some of Spacemacs files.
   dotspacemacs-byte-compile nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."

  (load "~/Workspaces/sys-jumble/configs/emacs/ansi-workaround.el")
  (ansi-workaround-mode 1)

  ;; To capture bugs that are hard to capture
  ;; (setq debug-on-error t)
  ;; (setq backtrace-on-redisplay-error t)

  (setq configuration-layer-elpa-archives
        '(("melpa-cn"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
          ("gnu-cn"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
          ("nongnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
          ;; org-contrib causes problems
          ;; ("org-cn"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
          ))

  ;; Evil collection
  (setq evil-want-keybinding nil)
  ;; Visual lines
  (setq evil-respect-visual-line-mode t)

  ;; Putting the initialization in user-config seems to cause errors:
  ;;   Selecting deleted buffer
  (require 'cns nil t)
  (global-cns-mode))


(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  (require 'org))


(defun mine/org-config ()
  "My org-mode configurations"

  ;; Alerts
  (setq
   alert-default-style 'notifications
   ;; Just prefer sticky notifications
   alert-persist-idle-time 5
   ;; Don't use day-wide events (or else it notifies about once per minute)
   org-wild-notifier--day-wide-events t
   ;; Repeats alerts
   org-wild-notifier-alert-time '(1 5 10 30 60)
   org-wild-notifier-alert-times-property "reminder")

  ;; Auto-fill
  (add-hook 'org-mode-hook #'turn-on-auto-fill)

  ;; Pomodoro
  (setq org-pomodoro-clock-break t
        org-pomodoro-manual-break t)

  ;; https://github.com/misohena/el-easydraw
  (with-eval-after-load 'org
    (require 'edraw-org)
    (edraw-org-setup-default))

  (setq org-directory "~/Documents/Nutstore/Org-Mode/")

  ;; Org-journal
  (setq org-journal-dir (file-name-concat org-directory "Journal"))

  ;; Org-roam
  (setq org-roam-directory (file-name-concat org-directory "Roam"))
  (setq org-roam-database-connector 'sqlite-builtin)
  (setq org-roam-capture-templates
        '(("d" "default" plain
           "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)
          ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
           :unnarrowed t)))
  ;; (org-roam-db-autosync-mode) ;; See `mine/preload-time-consuming-libs'

  ;; Org-roam-protocol
  (require 'org-protocol)
  (require 'org-roam-protocol)

  ;; Org-babel
  ;; Don't prompt
  (setq org-confirm-babel-evaluate
        (lambda (&rest _)
          (or scratch-buffer
              (not (string-prefix-p (expand-file-name org-directory) (buffer-file-name))))))
  ;; Calc
  (org-babel-do-load-languages 'org-babel-load-languages '((calc . t)))
  (org-babel-do-load-languages 'org-babel-load-languages '((js . t)))
  (org-babel-do-load-languages 'org-babel-load-languages '((shell . t)))
  (add-to-list 'org-babel-default-header-args:elisp '(:lexical . "t"))
  ;; Inline code
  (spacemacs/set-leader-keys-for-major-mode
    'org-mode "i."
    (lambda (&optional lang)
      (interactive
       (if current-prefix-arg
           (list (read-from-minibuffer "Inline code language: "))
         nil))
      (setq lang (or lang "elisp"))
      (insert (format "src_%s{}" lang))
      (backward-char)
      (evil-insert-state)))

  ;; Org-mode
  ;; https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
  (setq org-inbox-file-path    "~/Documents/Nutstore/Org-Mode/GTD/inbox.org")
  (setq org-projects-file-path "~/Documents/Nutstore/Org-Mode/GTD/projects.org")
  (setq org-archive-file-path  "~/Documents/Nutstore/Org-Mode/GTD/archive.org")
  (setq org-watchdog-file-path "~/Documents/Nutstore/Org-Mode/GTD/watchdog.org")
  (setq org-gtd-dir "~/Documents/Nutstore/Org-Mode/GTD")
  (setq org-agenda-files (directory-files org-gtd-dir t ".*\\.org"))

  ;; Blogging
  (setq org-footnote-auto-label nil)
  (setq org-link-file-path-type 'relative)

  ;; GTD: Capturing
  (setq org-capture-templates
        `(,`("i" "inbox" entry ,`(file ,org-inbox-file-path)
             "* TODO %i%?
:PROPERTIES:
:CREATED: %U
:END:"
             :empty-lines 1)))
  (defun org-capture-to-inbox()
    (interactive)
    (org-capture nil "i"))
  (spacemacs/set-leader-keys "aoi" #'org-capture-to-inbox)

  ;; GTD: Reviewing
  ;; Save the corresponding buffers
  (defun gtd-save-org-buffers ()
    "Save `org-agenda-files' buffers without user confirmation.
See also `org-save-all-org-buffers'"
    (interactive)
    (message "Saving org-agenda-files buffers...")
    (save-some-buffers t (lambda ()
                           (when (member (buffer-file-name) org-agenda-files)
                             t)))
    (message "Saving org-agenda-files buffers... done"))
  (advice-add 'org-refile :after (lambda (&rest _) (gtd-save-org-buffers)))
  ;; Destinations
  (setq org-refile-targets `(,`(,org-projects-file-path :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")
                             ,`(,org-watchdog-file-path :level . 1)
                             ,`(,org-archive-file-path  :level . 1)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)

  ;; GTD: Finding the next task
  (setq org-todo-keywords '((sequence "TODO(t)" "PENDING(p@/!)" "NEXT(n)" "|" "DONE(d!)" "CANCELLED(c@)")))
  (defun log-todo-next-creation-date (&rest ignore)
    "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
    (when (and (string= (org-get-todo-state) "NEXT")
               (not (org-entry-get nil "ACTIVATED")))
      (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d %H:%M]"))))
  (add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)
  ;; https://www.gnu.org/software/emacs/manual/html_node/org/Closing-items.html
  (setq org-log-done 'time)
  (setq org-log-redeadline 'note)
  (setq org-log-reschedule 'note)
  (setq org-log-into-drawer t)

  ;; GTD: Agenda
  (setq org-agenda-show-future-repeats nil)
  (setq org-agenda-window-setup 'only-window)
  (add-to-list 'org-agenda-custom-commands
               '("g" "Get Things Done (GTD)"
                 ((agenda ""
                          ((org-deadline-warning-days 0)))
                  (todo "NEXT"
                        ((org-agenda-skip-function
                          '(org-agenda-skip-entry-if 'deadline))
                         (org-agenda-prefix-format "  %i %-12:c [%e] ")
                         (org-agenda-overriding-header "\nTasks\n")))
                  (org-ql-block '(and (todo) (scheduled :to -1))
                                ((org-ql-block-header "Overdue")))
                  (tags-todo "inbox"
                             ((org-agenda-prefix-format "  %?-12t% s")
                              (org-agenda-overriding-header "\nInbox\n")))
                  (tags "CLOSED>=\"<today>\""
                        ((org-agenda-overriding-header "\nCompleted today\n"))))))
  (defun org-gtd-agenda()
    (interactive)
    (org-agenda nil "g"))
  (spacemacs/set-leader-keys "aog" #'org-gtd-agenda)

  ;; Styling & UX
  ;; Avoid the situation when the cursor gets trapped after the ellipsis.
  (add-hook 'org-tab-first-hook (lambda () (when (org-fold-folded-p) (org-end-of-line))))
  ;; Wrap lines: We don't use org tables that often.
  (setq org-startup-truncated nil)
  ;; More blank lines
  (setq org-blank-before-new-entry '((heading . t) (plain-list-item . t)))
  ;; Use M-RET M-RET then.
  ;; (with-eval-after-load "org"
  ;;  (define-key org-mode-map (kbd "M-RET") #'org-meta-return))
  ;; Automatically sync if modified by other devices
  (add-hook 'org-mode-hook #'auto-revert-mode)

  ;; Others
  ;; Insert a zero-width-space
  (with-eval-after-load "org"
    (define-key org-mode-map (kbd "C-|") (lambda () (interactive) (insert-char #x200b)))))

(defun mine/whitespace-config ()
  "Configure whitespace displaying"

  (use-package whitespace :config
    ;; Global whitespace displaying
    (setq whitespace-style
          '(face
            ;; highlight malformed white-spaces
            tabs spaces newline
            ;; display tabs
            tab-mark
            ;; trailing blanks
            trailing
            ;; tab-width or more spaces at beginning of line
            indentation
            ;; mixed white-spaces
            space-before-tab
            space-after-tab
            ;; empty lines at beginning and/or end of buffer
            empty
            ;; missing newline at the end of the file
            missing-newline-at-eof
            ))
    ;; Only neighboring spaces are displayed
    (setq whitespace-space-regexp "\\( \\{2,\\}\\)")
    (global-whitespace-mode t))

  ;; dtrt-indent
  (use-package dtrt-indent :config (dtrt-indent-global-mode))

  ;; pangu
  (use-package pangu-spacing :config (global-pangu-spacing-mode 1))

  ;; Display glyphless chars
  (update-glyphless-char-display 'glyphless-char-display-control
                                 '((c0-control          . hex-code)
                                   (c1-control          . hex-code)
                                   (format-control      . empty-box)
                                   (bidi-control        . acronym) ; not available in emacs 28
                                   (variation-selectors . acronym)
                                   (no-font             . hex-code)
                                   )))

(defun mine/evil-config ()
  "My evil mode configurations"

  ;; Undo
  (define-key evil-normal-state-map (kbd "U") 'evil-redo)
  (setq evil-want-fine-undo t)

  ;; Stop macro binding
  (define-key evil-normal-state-map (kbd "Q") 'evil-record-macro)
  (define-key evil-normal-state-map (kbd "q") nil)

  ;; Closes window instead of quiting
  (evil-ex-define-cmd "q[uit]" 'save-buffers-kill-terminal)

  ;; Avy
  (define-key evil-normal-state-map (kbd "f") #'evil-avy-goto-char-in-line)
  (define-key evil-normal-state-map (kbd "F") #'evil-avy-goto-char-2)

  ;; Easy motion
  (define-key evil-normal-state-map (kbd "g j") 'evilem-motion-next-visual-line)
  (define-key evil-normal-state-map (kbd "g k") 'evilem-motion-previous-visual-line)

  ;; Lisp parenthesis
  (setq evil-cleverparens-complete-parens-in-yanked-region t)
  (add-hook 'prog-mode-hook #'evil-cleverparens-mode)
  (add-hook 'prog-mode-hook #'highlight-parentheses-mode)
  (add-hook 'prog-mode-hook #'electric-pair-local-mode)
  (show-paren-mode 1)
  ;; Parinfer
  (remove-hook 'emacs-lisp-mode-hook #'parinfer-rust-mode)
  (setq parinfer-rust-check-before-enable nil) ; We always manually enable it.
  (spacemacs/set-leader-keys-for-major-mode 'emacs-lisp-mode "=p" #'parinfer-rust-mode)

  ;; Info mode
  (evil-define-key 'normal Info-mode-map
    (kbd "<left>") 'Info-prev
    (kbd "<right>") 'Info-next)

  ;; No mouse in console, so as to enable using mouse to select-&-copy things.
  (xterm-mouse-mode -1)

  (xclip-mode 1)
  (setq wayland-detected nil)
  (add-to-list 'after-make-frame-functions
               (lambda (_frame)
                 (when (and (getenv "WAYLAND_DISPLAY") (not wayland-detected))
                   (setq wayland-detected t)
                   (setq xclip-method 'wl-copy)
                   (setq xclip-program "wl-copy"))))

  ;; Replace Ctrl+S with swiper
  (global-set-key (kbd "C-s") #'swiper)
  (global-set-key (kbd "C-r") #'swiper-backward)
  (define-key evil-normal-state-map (kbd "C-r") #'swiper-backward))

(defun mine/fcitx-config ()
  "Fcitx integration"

  (use-package sis :config
    (add-hook 'evil-hybrid-state-exit-hook #'sis-set-english)
    (add-to-list 'sis-context-hooks 'evil-hybrid-state-entry-hook)
    (sis-ism-lazyman-config "1" "2" 'fcitx5)
    (sis-global-respect-mode t)
    (sis-global-context-mode t)
    (sis-global-inline-mode t)
    (define-advice sis-global-respect-mode (:around (f &rest args))
      (when (not sis-global-respect-mode)
        (remove-hook 'evil-hybrid-state-exit-hook #'sis-set-english))
      (apply f args))))

(defun mine/motion-config ()
  "Cursor navigating settings"

  ;; Chinese word segmentation
  (setq cns-recent-segmentation-limit 20)
  (setq cns-debug nil)
  (when (featurep 'cns)
    (add-hook 'find-file-hook 'cns-auto-enable)
    (add-hook 'term-mode-hook (lambda () (cns-mode -1))))

  ;; Chinese word segmentation
  (define-key evil-normal-state-map (kbd "w") 'cns-forward-word)
  (define-key evil-motion-state-map (kbd "w") 'cns-forward-word)
  (define-key evil-visual-state-map (kbd "w") 'cns-forward-word)
  (define-key evil-operator-state-map (kbd "w") 'cns-forward-word)

  (define-key evil-normal-state-map (kbd "b") 'cns-backward-word)
  (define-key evil-motion-state-map (kbd "b") 'cns-backward-word)
  (define-key evil-visual-state-map (kbd "b") 'cns-backward-word)
  (define-key evil-operator-state-map (kbd "b") 'cns-backward-word))

(defun lisp-scratch-buffer ()
  "Scratch buffer in lisp mode"
  (interactive)
  (scratch 'lisp-interaction-mode))

(defun advice-prefix-repeat (func)
  (advice-add
   func
   :around
   (lambda (original &optional repeat)
     (interactive "p")
     (dotimes (_ repeat)
       (funcall original)))))

(defun mine/ibuffer-config ()
  "IBuffer & buffer selector config"

  (add-hook 'ibuffer-mode-hook
            #'(lambda () (ibuffer-filter-by-visiting-file (current-buffer))))
  (setq ibuffer-expert t)
  (setq ibuffer-show-empty-filter-groups nil)

  (use-package super-save :custom
    (super-save-auto-save-when-idle t)
    (super-save-idle-duration 30)
    :config (super-save-mode +1))

  ;; Original lisp-interaction-mode scratch buffer
  (spacemacs/set-leader-keys "bS" #'lisp-scratch-buffer)

  ;; Open files with zoxide
  (spacemacs/set-leader-keys "fF" #'zoxide-find-file)

  ;; Convenient shortcut for `other-window'
  (define-key global-map (kbd "M-o") #'other-window)
  (define-key evil-normal-state-map (kbd "M-o") #'other-window)
  (evil-define-key 'normal evil-cleverparens-mode-map (kbd "M-o") nil)

  ;; Rotate
  (define-key global-map (kbd "s-o")
              #'(lambda () (interactive)
                  (if (< 1 (length (window-list)))
                      (rotate-layout)
                    (if (< (frame-width) (* 2 (frame-height)))
                        (spacemacs/window-split-single-column)
                      (spacemacs/window-split-double-columns))))))

(defun mine/font-config ()
  "Chinese font config"

  (spacemacs|do-after-display-system-init
    (set-face-attribute 'default nil :family "Sarasa Term SC Nerd")
    (set-fontset-font "fontset-default" 'han (font-spec :family "Sarasa Term SC Nerd"))
    (set-fontset-font "fontset-default" 'cjk-misc (font-spec :family "Sarasa Term SC Nerd"))

    ;; Use serif for variable pitch fonts
    (create-fontset-from-fontset-spec
     (font-xlfd-name (font-spec :registry "fontset-reader" :family "Liberation Serif")))
    (set-fontset-font "fontset-reader" 'kana (font-spec :family "Noto Serif CJK JP" :size 10.5))
    (set-fontset-font "fontset-reader" 'han (font-spec :family "Noto Serif CJK SC" :size 10.5))
    (set-fontset-font "fontset-reader" 'cjk-misc (font-spec :family "Noto Serif CJK SC" :size 10.5))
    (set-face-attribute 'variable-pitch nil
                        :family "Liberation Serif"
                        :height 120
                        :fontset "fontset-reader"))
  ;; Toggle serif fonts
  (spacemacs/set-leader-keys "tr" #'variable-pitch-mode))

(defun mine/tramp-config ()
  "Tramp configuration"

  (setq password-cache-expiry nil)

  ;; Disable network-intensive modes
  (setq lsp-auto-register-remote-clients nil)
  ;; https://github.com/syl20bnr/spacemacs/issues/11381
  (define-advice projectile-project-root (:around (func &optional dir))
    (unless (file-remote-p default-directory) (funcall func dir)))

  ;; (setq tramp-verbose 10)
  ;; Set it to nil, if you use Control* or Proxy* options in your ssh configuration.
  (setq tramp-use-ssh-controlmaster-options nil))

(defun mine/completion-config()
  "Completion config"

  (spacemacs/set-leader-keys "o\\" #'codegeex-buffer-completion)

  (setq helm-move-to-line-cycle-in-source nil)
  (setq helm-ff-allow-non-existing-file-at-point t)

  (setq company-dabbrev-downcase nil)
  (setq company-idle-delay 0)

  (setq ivy-extra-directories nil)

  ;; Search for elisp documentation
  (spacemacs/set-leader-keys-for-major-mode 'emacs-lisp-mode "hi" #'elisp-index-search)
  (spacemacs/set-leader-keys-for-major-mode 'emacs-lisp-mode "hd" #'shortdoc-display-group)

  ;; Temporarily fixes: https://github.com/org-roam/org-roam/issues/2406
  (setq org-roam-ref-annotation-function (lambda (_) ""))

  (setq lsp-auto-guess-root t)
  (setq lsp-java-server-install-dir "/usr/share/java/jdtls/"
        lsp-java-jdt-ls-prefer-native-command t)
  (setq lsp-signature-doc-lines 3)

  ;; Spell checking
  (require 'flycheck-vale)
  (flycheck-vale-setup))

(declare-function emacs-everywhere-abort "emacs-everywhere" ())
(declare-function emacs-everywhere--finish-or-ctrl-c-ctrl-c "emacs-everywhere" ())
(defun mine/emacs-everywhere-config()
  "Emacs Everywhere"

  (require 'emacs-everywhere)
  (spacemacs/set-leader-keys-for-minor-mode 'emacs-everywhere-mode "," #'emacs-everywhere--finish-or-ctrl-c-ctrl-c)
  (spacemacs/set-leader-keys-for-minor-mode 'emacs-everywhere-mode "k" #'emacs-everywhere-abort))

(declare-function ledger-report "ledger-report" (report-name edit))
(defun ledger-monthly-report()
  "Report monthly expenses"

  (interactive)
  (ledger-report "reg-M" ())
  (run-with-idle-timer 0.1 () (lambda () (goto-char (point-max)))))

(defun mine/git-config()
  "Git/Magit config"

  (setq vc-follow-symlinks t)

  ;; Magit-delta config
  ;; (require 'magit-delta) ;; See `mine/preload-time-consuming-libs'

  (setq magit-repository-directories
        '(("~/.emacs.d"  . 0)
          ("~/Workspaces/" . 2))))

(defun mine/extra-emacs-config()
  "Extra emacs config"

  ;; We use a emacs daemon so probably there won't be any editing conflicts.
  (setq create-lockfiles nil)

  ;; Please do not pop up every time
  (setq warning-minimum-level :error)

  ;; Yeah
  (setq mouse-wheel-scroll-amount '(4)
        mouse-wheel-progressive-speed t
        pixel-scroll-precision-use-momentum t
        pixel-scroll-precision-interpolate-page t)
  (pixel-scroll-precision-mode 1)
  (scroll-bar-mode)

  ;; Tabs
  (use-package tab-line
    :custom
    (tab-line-new-button-show nil)
    (tab-line-exclude-modes '(completion-list-mode helpful-mode))
    :config
    (global-tab-line-mode 1)
    (define-key evil-normal-state-map (kbd "g t") 'tab-line-switch-to-next-tab)
    (define-key evil-normal-state-map (kbd "g T") 'tab-line-switch-to-prev-tab))
  (use-package project-tab-groups
    :config
    (project-tab-groups-mode 1))

  ;; Magit fringe
  (use-package fringe :config
    (fringe-mode (cdr (assoc "half-width" fringe-styles))))


  ;; Strip text properties from history entries
  (setq savehist-additional-plain-text-variables '(search-ring
                                                   regexp-search-ring
                                                   kill-ring))
  (defun unpropertize-savehist-variables ()
    (dolist (var (append savehist-additional-plain-text-variables savehist-minibuffer-history-variables))
      (let ((value (and (boundp var) (symbol-value var))))
        (when (and value (cl-every (apply-partially #'eq 'string) (mapcar #'type-of value)))
          (setf (symbol-value var) (mapcar #'substring-no-properties value))))))
  (add-hook 'savehist-save-hook #'unpropertize-savehist-variables)

  ;; More kill-ring contents
  (setq kill-ring-max 1000)

  ;; Global visual line mode
  (global-visual-line-mode 1)

  ;; Personally I don't need BIDI
  (setq-default bidi-display-reordering nil)
  (setq bidi-inhibit-bpa t
        long-line-threshold 1000
        large-hscroll-threshold 1000
        syntax-wholeline-max 1000)

  )

(defun mine/app-config()
  "Config for apps in the Emacs OS."

  ;; CSS mode fix
  ;; Instead of (use-package css-mode :defer :init (require 'flymake-proc)),
  ;; let's simply make 'flymake-proc mandatory for 'flymake.
  (use-package flymake :defer :config (require 'flymake-proc))

  ;; Web-mode
  (add-to-list 'auto-mode-alist '("\\.tmpl\\'" . web-mode))
  (use-package web-mode :defer :config
    (add-to-list 'web-mode-engine-file-regexps '("mako" . "\\.tmpl\\'")))

  ;; LLM
  (require 'llm-ollama)
  (use-package ellama :defer :custom (ellama-language "中文"))
  (setopt ellama-provider
          (make-llm-ollama
           :chat-model "qwen2.5:latest"
           :embedding-model "snowflake-arctic-embed2:latest"
           :default-chat-non-standard-params '(("num_ctx" . 8192))))

  ;; Ready player
  (use-package ready-player :config (ready-player-add-to-auto-mode-alist))

  (use-package ledger :defer :config
    (setq ledger-reports '(("bal" "%(binary) -f %(ledger-file) bal")
                           ("reg" "%(binary) -f %(ledger-file) reg")
                           ("reg-M" "%(binary) -f %(ledger-file) reg -M")
                           ("tag" "%(binary) -f %(ledger-file) bal tag %(tagname)")
                           ("account" "%(binary) -f %(ledger-file) reg %(account)")))
    (spacemacs/declare-prefix-for-mode 'ledger-mode "M" "monthly-report")
    (spacemacs/set-leader-keys-for-major-mode 'ledger-mode "M" 'ledger-monthly-report))

  ;; Eshell
  (setq eshell-modules-list
        '(eshell-alias
          eshell-basic
          eshell-cmpl
          eshell-dirs
          eshell-extpipe
          eshell-glob
          eshell-hist
          eshell-ls
          eshell-pred
          eshell-prompt
          eshell-script
          eshell-term
          eshell-unix))

  ;; Geiser
  (use-package geiser :defer :config (setq geiser-chez-binary "/usr/bin/chez"))

  ;; Hacker News
  (spacemacs/set-leader-keys "awh" #'hnreader-news)

  ;; ERC
  (defun erc-libera-chat()
    (interactive)
    (require 'erc)
    (defvar erc-sasl-auth-source-function)
    (let ((erc-sasl-auth-source-function #'erc-sasl-auth-source-password-as-host))
      (erc-tls :server "irc.ea.libera.chat" :port 6697
               :nick "kanakana" :user "kanakana"
               :password "Libera.Chat")))
  (spacemacs/set-leader-keys "acil" #'erc-libera-chat)
  (use-package erc :defer :custom
    (erc-hide-list '("JOIN" "PART" "QUIT"))
    (erc-autojoin-channels-alist '(("libera.chat" "#emacs"))))

  ;; Terminal-here
  (use-package terminal-here :config
    (setq terminal-here-linux-terminal-command 'xfce4-terminal)))

(defun mine/preload-time-consuming-libs ()
  "Several libraries takes a long time (seconds, frozen) to load,
so we load them here."

  (run-with-idle-timer
   30 nil (lambda ()
            ;; See also `mine/org-config'
            (org-roam-db-autosync-mode)
            ;; Better magit diffs. See also `mine/git-config'
            (require 'magit-delta)
            (setq magit-delta-delta-args (append magit-delta-delta-args
                                                 '("--wrap-max-lines" "unlimited"
                                                   "--max-line-length" "0")))
            ;; https://github.com/tuhdo/semantic-refactor for every elisp buffer
            (spacemacs/load-srefactor)))

  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."

  (mine/app-config)
  (mine/completion-config)
  (mine/emacs-everywhere-config)
  (mine/evil-config)
  (mine/extra-emacs-config)
  (mine/fcitx-config)
  (mine/font-config)
  (mine/git-config)
  (mine/ibuffer-config)
  (mine/motion-config)
  (mine/org-config)
  (mine/tramp-config)
  (mine/whitespace-config)

  (mine/preload-time-consuming-libs))


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(auth-source-save-behavior nil)
   '(connection-local-criteria-alist
     '(((:application tramp :protocol "kubernetes")
        tramp-kubernetes-connection-local-default-profile)
       ((:application eshell) eshell-connection-default-profile)
       ((:application tramp :protocol "flatpak")
        tramp-container-connection-local-default-flatpak-profile)
       ((:application tramp) tramp-connection-local-default-system-profile
        tramp-connection-local-default-shell-profile)))
   '(connection-local-profile-alist
     '((tramp-kubernetes-connection-local-default-profile
        (tramp-config-check . tramp-kubernetes--current-context-data)
        (tramp-extra-expand-args 97
                                 (tramp-kubernetes--container
                                  (car tramp-current-connection))
                                 104
                                 (tramp-kubernetes--pod
                                  (car tramp-current-connection))
                                 120
                                 (tramp-kubernetes--context-namespace
                                  (car tramp-current-connection))))
       (eshell-connection-default-profile (eshell-path-env-list))
       (tramp-container-connection-local-default-flatpak-profile
        (tramp-remote-path "/app/bin" tramp-default-remote-path "/bin" "/usr/bin"
                           "/sbin" "/usr/sbin" "/usr/local/bin" "/usr/local/sbin"
                           "/local/bin" "/local/freeware/bin" "/local/gnu/bin"
                           "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin"
                           "/opt/bin" "/opt/sbin" "/opt/local/bin"))
       (tramp-connection-local-darwin-ps-profile
        (tramp-process-attributes-ps-args "-acxww" "-o"
                                          "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                          "-o" "state=abcde" "-o"
                                          "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
        (tramp-process-attributes-ps-format (pid . number) (euid . number)
                                            (user . string) (egid . number)
                                            (comm . 52) (state . 5)
                                            (ppid . number) (pgrp . number)
                                            (sess . number) (ttname . string)
                                            (tpgid . number) (minflt . number)
                                            (majflt . number)
                                            (time . tramp-ps-time) (pri . number)
                                            (nice . number) (vsize . number)
                                            (rss . number) (etime . tramp-ps-time)
                                            (pcpu . number) (pmem . number) (args)))
       (tramp-connection-local-busybox-ps-profile
        (tramp-process-attributes-ps-args "-o"
                                          "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                          "-o" "stat=abcde" "-o"
                                          "ppid,pgid,tty,time,nice,etime,args")
        (tramp-process-attributes-ps-format (pid . number) (user . string)
                                            (group . string) (comm . 52)
                                            (state . 5) (ppid . number)
                                            (pgrp . number) (ttname . string)
                                            (time . tramp-ps-time) (nice . number)
                                            (etime . tramp-ps-time) (args)))
       (tramp-connection-local-bsd-ps-profile
        (tramp-process-attributes-ps-args "-acxww" "-o"
                                          "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                          "-o"
                                          "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
        (tramp-process-attributes-ps-format (pid . number) (euid . number)
                                            (user . string) (egid . number)
                                            (group . string) (comm . 52)
                                            (state . string) (ppid . number)
                                            (pgrp . number) (sess . number)
                                            (ttname . string) (tpgid . number)
                                            (minflt . number) (majflt . number)
                                            (time . tramp-ps-time) (pri . number)
                                            (nice . number) (vsize . number)
                                            (rss . number) (etime . number)
                                            (pcpu . number) (pmem . number) (args)))
       (tramp-connection-local-default-shell-profile (shell-file-name . "/bin/sh")
                                                     (shell-command-switch . "-c"))
       (tramp-connection-local-default-system-profile (path-separator . ":")
                                                      (null-device . "/dev/null"))))
   '(magit-todos-exclude-globs '(".git/" "*.map"))
   '(magit-todos-insert-after '(bottom) nil nil "Changed by setter of obsolete option `magit-todos-insert-at'")
   '(package-selected-packages
     '(ac-ispell ace-jump-helm-line ace-link add-node-modules-path aggressive-indent
                 appindicator auto-compile auto-dictionary auto-highlight-symbol
                 auto-yasnippet bbcode-mode beacon bui cargo centered-cursor-mode
                 clean-aindent-mode column-enforce-mode company-go company-web
                 counsel counsel-css counsel-gtags dactyl-mode dap-mode
                 define-word devdocs diminish dired-quick-sort docker-compose-mode
                 dockerfile-mode dotenv-mode drag-stuff dumb-jump editorconfig
                 elisp-benchmarks elisp-def elisp-slime-nav emacs-everywhere
                 emmet-mode emr esh-help eshell-prompt-extras eshell-z
                 eval-sexp-fu evil-anzu evil-args evil-cleverparens
                 evil-collection evil-easymotion evil-escape evil-evilified-state
                 evil-exchange evil-goggles evil-iedit-state evil-indent-plus
                 evil-lion evil-lisp-state evil-matchit evil-mc
                 evil-nerd-commenter evil-numbers evil-org evil-snipe
                 evil-surround evil-textobj-line evil-tutor evil-unimpaired
                 evil-visual-mark-mode evil-visualstar expand-region eyebrowse
                 fancy-battery fcitx flx-ido flycheck-elsa flycheck-golangci-lint
                 flycheck-package flycheck-rust flyspell-correct-helm font-lock+
                 fuzzy ggtags gh-md git-link git-messenger git-modes
                 git-timemachine gitignore-templates gnuplot go-eldoc
                 go-fill-struct go-gen-test go-guru go-impl go-mode go-rename
                 go-tag godoctor golden-ratio google-translate graphviz-dot-mode
                 grizzl haml-mode helm-c-yasnippet helm-company helm-css-scss
                 helm-descbinds helm-git-grep helm-gtags helm-ls-git helm-make
                 helm-mode-manager helm-org helm-org-rifle helm-projectile
                 helm-purpose helm-swoop helm-themes helm-xref help-fns+
                 hide-comnt highlight-indentation highlight-numbers
                 highlight-parentheses hl-todo holy-mode htmlize hungry-delete
                 hybrid-mode ibuffer-projectile impatient-mode import-js
                 indent-guide info+ inspector ivy journalctl-mode js-doc js2-mode
                 js2-refactor link-hint livid-mode load-env-vars load-relative
                 loc-changes lorem-ipsum macrostep markdown-toc mastodon mmm-mode
                 multi-line multi-term multi-vterm multiple-cursors mwim nameless
                 nginx-mode nodejs-repl npm-mode open-junk-file org-alert
                 org-cliplink org-download org-mime org-pomodoro org-present
                 org-projectile org-rich-yank org-special-block-extras
                 org-superstar orgit-forge overseer ox-html-stable-ids
                 ox-html-stable-ids.el paradox password-generator pcre2el
                 pip-requirements pipenv pippel poetry popwin pos-tip prettier-js
                 project-tab-groups protobuf-mode pug-mode py-isort pydoc
                 pyenv-mode pylookup pytest pythonic pyvenv quickrun racer
                 rainbow-delimiters realgud request restart-emacs ron-mode
                 rust-mode sass-mode scss-mode shell-pop simple-httpd sis
                 skewer-mode slim-mode smeargle space-doc spaceline-all-the-icons
                 spacemacs-purpose-popwin spacemacs-whitespace-cleanup sphinx-doc
                 stickyfunc-enhance string-edit-at-point string-inflection swiper
                 symbol-overlay symon systemd tagedit term-cursor terminal-here
                 tern test-simple texfrag toc-org toml-mode tramp-github
                 treemacs-evil treemacs-icons-dired treemacs-magit treemacs-persp
                 treemacs-projectile typescript-mode undo-tree unfill uuidgen
                 vi-tilde-fringe vim-powerline vimrc-mode volatile-highlights
                 wc-mode web-beautify web-completion-data web-mode which-key winum
                 writeroom-mode ws-butler xcscope xterm-color yaml-mode yapfify
                 yasnippet-snippets))
   '(package-vc-selected-packages
     '((ox-html-stable-ids :url
                           "https://github.com/jeffkreeftmeijer/ox-html-stable-ids.el.git")
       (ox-html-stable-ids.el :vc-backend Git :url
                              "https://github.com/jeffkreeftmeijer/ox-html-stable-ids.el.git")))
   '(paradox-github-token t)
   '(rst-new-adornment-down t)
   '(rst-preferred-adornments
     '((35 over-and-under 1) (61 over-and-under 0) (61 simple 0) (45 simple 0)
       (126 simple 0) (43 simple 0) (34 simple 0) (46 simple 0)))
   '(safe-local-variable-directories
     '("/home/otaku/Workspaces/blogs/kyo/" "/home/otaku/Workspaces/clones/nikola/"))
   '(safe-local-variable-values
     '((etags-regen-ignores "test/manual/etags/")
       (etags-regen-regexp-alist
        (("c" "objc") "/[ \11]*DEFVAR_[A-Z_ \11(]+\"\\([^\"]+\\)\"/\\1/"
         "/[ \11]*DEFVAR_[A-Z_ \11(]+\"[^\"]+\",[ \11]\\([A-Za-z0-9_]+\\)/\\1/"))
       (magit-todos-exclude-globs "*/build/*") (javascript-backend . tide)
       (javascript-backend . tern))))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(markdown-code-face ((t (:family "Sarasa Term SC Nerd" :inherit fixed-pitch)))))
  )

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
   dotspacemacs-configuration-layers
   '((auto-completion :variables auto-completion-idle-delay 0.0
                      :disabled-for org)
     better-defaults
     bibtex
     cmake
     csv
     d
     debug
     dtrt-indent
     ;; eaf ; Throws errors under cli
     emacs-lisp
     emoji
     (erc :variables
          erc-enable-notifications t
          erc-enable-sasl-auth t
          erc-server-list '(("irc.libera.chat" :port "6697" :ssl t)))
     eww
     finance
     (git :variables
          git-enable-magit-delta-plugin t
          git-enable-magit-todos-plugin t
          git-magit-status-fullscreen t)
     go
     helpful
     html
     ibuffer
     ivy
     java
     (javascript :variables
                 js2-basic-offset 2
                 js-indent-level 2
                 javascript-backend 'lsp)
     lsp
     (lua :variables lua-backend 'lua-mode)
     markdown
     multiple-cursors
     nginx
     (org :variables
          ;; ; valign mandates no space before cell contents, while org-table-align automatically do so
          ;; org-enable-valign t
          org-enable-org-journal-support t
          org-enable-roam-support t
          org-enable-roam-ui t
          org-enable-roam-protocol t
          org-enable-notifications t
          org-start-notification-daemon-on-startup t)
     parinfer
     php
     protobuf
     (python :variables
             python-fill-column 120
             python-backend 'lsp
             python-lsp-server 'pylsp)
     (restclient :variables
                 restclient-use-org t)
     rust
     (scheme :variables scheme-implementations '(chez))
     semantic
     (shell :variables
            shell-default-shell 'eshell
            shell-default-term-shell "/bin/zsh"
            shell-default-position 'full)
     spacemacs-visual
     spacemacs-editing-visual
     sql
     syntax-checking
     systemd
     tabs
     treemacs
     typescript
     (unicode-fonts :variables
                    unicode-fonts-enable-ligatures t)
     version-control
     xclipboard
     yaml
     )


   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(all-the-icons
                                      bbcode-mode
                                      (codegeex :location (recipe :fetcher url
                                                                  :url "https://cdn.jsdelivr.net/gh/hzhangxyz/codegeex.el@main/codegeex.el"))
                                      (cp2k-mode :location (recipe :fetcher url
                                                                   :url "https://cdn.jsdelivr.net/gh/gudzpoz/cp2k@emacs-package-headers/tools/input_editing/emacs/cp2k-mode.el"))
                                      dockerfile-mode
                                      docker-compose-mode
                                      (edraw :location (recipe :fetcher github :repo "misohena/el-easydraw"))
                                      ellama
                                      ement
                                      eshell-vterm
                                      esup
                                      (ready-player :location (recipe :fetcher github :repo "xenodium/ready-player"))
                                      emacs-everywhere
                                      evil-easymotion
                                      fcitx
                                      flycheck-vale
                                      gcmh
                                      hnreader
                                      jedi
                                      jupyter
                                      mastodon
                                      mlscroll
                                      org-ql
                                      pangu-spacing
                                      rg
                                      rime
                                      rotate
                                      scratch
                                      super-save
                                      (tramp-github :location (recipe :fetcher url
                                                                      :url "https://cdn.jsdelivr.net/gh/gudzpoz/sys-jumble@main/configs/tramp-github.el"))
                                      wc-mode
                                      xclip
                                      zoxide
                                      )

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(;; https://github.com/syl20bnr/spacemacs/issues/15667
                                    term-cursor
                                    ;; https://github.com/joaotavora/yasnippet/issues/114
                                        ; yasnippet
                                        ; auto-yasnippet
                                    )

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
   dotspacemacs-scratch-buffer-unkillable t

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator nil :separator-scale 1.0)

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
   dotspacemacs-which-key-delay 0.4

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
   dotspacemacs-enable-package-quickstart t

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
  (spacemacs/load-spacemacs-env)
  )

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."

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

  ;; Putting the initialization in user-config seems to cause errors:
  ;;   Selecting deleted buffer
  (require 'cns nil t)
  (global-cns-mode)

  ;; Server daemon
  ;; (setq server-use-tcp t)
  ;; (setq server-port 5172)

  )


(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )


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

  ;; Pomodoro
  (setq org-pomodoro-clock-break t
        org-pomodoro-manual-break t)

  ;; https://github.com/misohena/el-easydraw
  (with-eval-after-load 'org
    (require 'edraw-org)
    (edraw-org-setup-default))

  ;; Org-journal
  (setq org-journal-dir "~/Documents/Nutstore/Org-Mode/Journal")

  ;; Org-roam
  (setq org-roam-directory "~/Documents/Nutstore/Org-Mode/Roam")
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

  ;; Don't prompt
  (setq org-confirm-babel-evaluate
        (lambda (&rest _) (not (string-prefix-p (expand-file-name "~/Documents/Nutstore/Org-Mode/") (buffer-file-name)))))

  ;; Org-mode
  ;; https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
  (setq org-inbox-file-path    "~/Documents/Nutstore/Org-Mode/GTD/inbox.org")
  (setq org-projects-file-path "~/Documents/Nutstore/Org-Mode/GTD/projects.org")
  (setq org-archive-file-path  "~/Documents/Nutstore/Org-Mode/GTD/archive.org")
  (setq org-watchdog-file-path "~/Documents/Nutstore/Org-Mode/GTD/watchdog.org")
  (setq org-gtd-dir "~/Documents/Nutstore/Org-Mode/GTD")
  (setq org-agenda-files (directory-files org-gtd-dir t ".*\\.org"))

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
    (define-key org-mode-map (kbd "C-|") (lambda () (interactive) (insert-char #x200b))))

  )

(defun mine/whitespace-config ()
  "Configure whitespace displaying"

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
  (require 'whitespace)
  (global-whitespace-mode t)

  ;; Spaces over tabs
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2)
  (setq dtrt-indent-global-mode t)
  ;; But not in lisp files since some libraries are indented with mixed spaces and tabs...
  (add-hook 'emacs-lisp-mode-hook (lambda () (setq tab-width 8)))

  ;; Display glyphless chars
  (update-glyphless-char-display 'glyphless-char-display-control
                                 '((c0-control          . hex-code)
                                   (c1-control          . hex-code)
                                   (format-control      . empty-box)
                                   (bidi-control        . acronym) ; not available in emacs 28
                                   (variation-selectors . acronym)
                                   (no-font             . hex-code)
                                   ))

  (global-pangu-spacing-mode 1)

  )

(defun mine/evil-config ()
  "My evil mode configurations"

  ;; Visual lines
  (setq evil-respect-visual-line-mode t)

  ;; Delete with modifying kill-ring
  (define-key evil-normal-state-map (kbd "DEL") #'evil-delete-backward-char)

  ;; Undo
  (define-key evil-normal-state-map (kbd "U") 'evil-redo)

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

  ;; Compatibility: https://emacs.stackexchange.com/questions/46371/how-can-i-get-ret-to-follow-org-mode-links-when-using-evil-mode
  (with-eval-after-load 'evil-maps
    (define-key evil-motion-state-map (kbd "SPC") nil)
    (define-key evil-motion-state-map (kbd "RET") nil)
    (define-key evil-motion-state-map (kbd "TAB") nil))

  ;; Lisp parenthesis
  (setq evil-cleverparens-complete-parens-in-yanked-region t)
  (add-hook 'prog-mode-hook #'evil-cleverparens-mode)
  (add-hook 'prog-mode-hook #'highlight-parentheses-mode)
  (add-hook 'prog-mode-hook #'electric-pair-local-mode)
  (show-paren-mode 1)

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
  (define-key evil-normal-state-map (kbd "C-r") #'swiper-backward)

  )

(defun mine/mode-line-config ()
  "Mode-line & scroll-bar configuration"

  ;; Diminish minor modes
  (spacemacs|diminish hybrid-mode " Ⓔ" " E")
  (spacemacs|diminish super-save-mode " ss" " ss")

  ;; Turn off things in mode-line
  (spaceline-toggle-buffer-size-off)
  (spaceline-toggle-buffer-position-off)
  (spaceline-toggle-purpose-off)
  (spaceline-toggle-hud-off)

  ;; Hint when debug mode / recursive editing is active
  (unless (seq-contains-p global-mode-string "%[%]")
    (add-to-list 'global-mode-string "%[%]"))

  (setq mlscroll-right-align nil)
  (scroll-bar-mode 1)

  )

(defun mine/fcitx-config ()
  "Fcitx integration"

  (setq fcitx-active-evil-states '(insert emacs hybrid)
        fcitx-remote-command "fcitx5-remote"
        fcitx-use-dbus nil)
  (fcitx-aggressive-setup)
  (fcitx-prefix-keys-add "M-m")

  (defun fcitx-disable-on-need ()
    (when (fcitx--evil-should-disable-fcitx-p) (fcitx--deactivate)))
  (add-hook 'isearch-mode-end-hook #'fcitx-disable-on-need)
  (add-hook 'minibuffer-inactive-mode-hook #'fcitx-disable-on-need)


  )

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
  (define-key evil-operator-state-map (kbd "b") 'cns-backward-word)

  )

(defun lisp-scratch-buffer ()
  "Scratch buffer in lisp mode"

  (interactive)

  (scratch 'lisp-interaction-mode)

  )

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

  (setq super-save-auto-save-when-idle t)
  (setq super-save-idle-duration 30)
  (super-save-mode +1)

  ;; Original lisp-interaction-mode scratch buffer
  (spacemacs/set-leader-keys "bS" 'lisp-scratch-buffer)

  ;; Open files with zoxide
  (spacemacs/set-leader-keys "fF" 'zoxide-find-file)

  ;; Persp fixes
  (setq persp-old-state-put-fn persp-window-state-put-function)
  (setq persp-window-state-put-function (lambda (pwc &optional frame rwin)
                                          (when (display-graphic-p)
                                            (funcall persp-old-state-put-fn pwc frame rwin))))

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
                      (spacemacs/window-split-double-columns)))))

  )

(defun mine/centaur-tabs-config ()
  "Centaur tabs config."

  ;; Centaur-tabs fixes
  (setq centaur-tabs-set-bar 'under)
  (defun centaur-tabs--daemon-mode (_)
    (unless (and (featurep 'centaur-tabs) (centaur-tabs-mode-on-p))
      (run-at-time nil nil (lambda () (centaur-tabs-mode)))))
  (when (daemonp)
    (add-hook 'after-make-frame-functions #'centaur-tabs--daemon-mode))

  ;; Customized grouping
  (setq emacs-log-buffer-names
        '("*Native-compile-Log*" "*Messages*" "*Compile-Log*" "*Async-native-compile-log*" "*Warnings*"))
  (defun emacs-log-buffer-p (name)
    (or (seq-contains-p emacs-log-buffer-names name)
        (string-match-p "^\\*[A-Z][[:alnum:]\\-]+\\*$" name)))
  (defun org-agenda-file-p (file)
    (and file
         (seq-find (apply-partially #'file-equal-p file) (org-agenda-files))))
  (defun org-roam-file-p (file)
    (and file org-roam-directory
         (file-in-directory-p file org-roam-directory)))
  (defun centaur-tabs-ensure-tabsets (tabsets)
    (let ((sets (remq nil tabsets)))
      (or sets (list centaur-tabs-common-group-name))))
  (defun centaur-tabs-misc-classifier (name)
    (cond
     ((string-prefix-p "*helm" name) "Helm")
     ((or (string-prefix-p "*HN" name) (string-prefix-p "*eww" name)) "Reader")
     ((seq-contains-p '("*scratch*" "*lisp-interaction*") name) "Scratch")
     ((emacs-log-buffer-p name) "Emacs")
     (t "Misc")))
  (defun centaur-tabs-buffer-groups-custom-advice (original)
    (let ((group (cond
                  ((org-roam-file-p (buffer-file-name)) "OrgRoam")
                  ((org-agenda-file-p (buffer-file-name)) "OrgAgenda")
                  ((derived-mode-p 'org-mode) "OrgMode")
                  ((memq major-mode '(helpful-mode help-mode)) "Help")
                  ((memq major-mode '(Info-mode)) "Info")
                  ((or (derived-mode-p 'emacs-lisp-mode)
                       (derived-mode-p 'debugger-mode))
                   "Elisp")
                  ((memq major-mode '(magit-process-mode
                                      magit-status-mode
                                      magit-diff-mode
                                      magit-log-mode
                                      magit-file-mode
                                      magit-blob-mode
                                      magit-blame-mode
                                      ))
                   "Magit")
                  ((string-prefix-p "*" (buffer-name)) (centaur-tabs-misc-classifier (buffer-name))))))
      (centaur-tabs-ensure-tabsets
       (if group (list group) (funcall original)))))
  (advice-add 'centaur-tabs-buffer-groups :around #'centaur-tabs-buffer-groups-custom-advice)
  (defun centaur-tabs-projectile-buffer-groups-custom-advice (original)
    (let ((group (when
                     (string-prefix-p "*" (buffer-name))
                   (centaur-tabs-misc-classifier (buffer-name)))))
      (centaur-tabs-ensure-tabsets
       (if group (list group) (funcall original)))))
  (advice-add 'centaur-tabs-projectile-buffer-groups :around #'centaur-tabs-projectile-buffer-groups-custom-advice)
  (defun centaur-tabs-capture-error-and-restart (original)
    (condition-case err
        (funcall original)
      (error
       (message "centaur-tabs errs agains... (%s)" err)
       (centaur-tabs-mode -1)
       (run-at-time nil nil #'centaur-tabs-mode +1)
       "")))
  (advice-add 'centaur-tabs-line :around #'centaur-tabs-capture-error-and-restart)
  (centaur-tabs-buffer-update-groups)

  ;; Keybindings
  (spacemacs/set-leader-keys "bg" #'centaur-tabs-group-by-projectile-project)
  (spacemacs/set-leader-keys "bG" #'centaur-tabs-group-buffer-groups)
  (spacemacs/set-leader-keys "bt" #'centaur-tabs-ace-jump)
  (spacemacs/set-leader-keys "bT" #'centaur-tabs-switch-group)

  ;; Modify things to accept prefix arguments
  (advice-prefix-repeat 'spacemacs/tabs-forward)
  (advice-prefix-repeat 'spacemacs/tabs-backward)
  (defun centaur-tabs-close-all-tabs ()
    (interactive)
    (dolist (buffer (centaur-tabs-tab-values (centaur-tabs-current-tabset)))
      (with-current-buffer buffer (spacemacs/kill-this-buffer))))
  (spacemacs/set-leader-keys "bC" #'centaur-tabs-close-all-tabs)

  )

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
  (spacemacs/set-leader-keys "tr" #'variable-pitch-mode)

  )

(defun mine/tramp-config ()
  "Tramp configuration"

  (setq password-cache-expiry nil)

  ;; Disable network-intensive modes
  (setq lsp-auto-register-remote-clients nil)
  ;; https://github.com/syl20bnr/spacemacs/issues/11381
  (defadvice projectile-project-root (around ignore-remote first activate)
    (unless (file-remote-p default-directory) ad-do-it))

  ;; (setq tramp-verbose 10)
  ;; Set it to nil, if you use Control* or Proxy* options in your ssh configuration.
  (setq tramp-use-ssh-controlmaster-options nil)

  )

(defun mine/wc-config ()
  "Word count config"

  (setq wc-modeline-format "[%tw/%tc]")
  (setq wc-idle-wait 1)
  ;; Count Chinese words
  (setq wc-count-words-function
        (function (lambda (rstart rend)
                    (how-many "[[:nonascii:]]\\|\\w+" rstart rend))))

  )

(defun mine/completion-config()
  "Completion config"

  (spacemacs/set-leader-keys "o\\" #'codegeex-buffer-completion)

  (setq helm-move-to-line-cycle-in-source nil)
  (setq helm-ff-allow-non-existing-file-at-point t)

  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 1)

  ;; Search for elisp documentation
  (spacemacs/set-leader-keys-for-major-mode 'emacs-lisp-mode "hi" #'elisp-index-search)
  (spacemacs/set-leader-keys-for-major-mode 'emacs-lisp-mode "hd" #'shortdoc-display-group)

  ;; Temporarily fixes: https://github.com/org-roam/org-roam/issues/2406
  (setq org-roam-ref-annotation-function (lambda (_) ""))

  (setq lsp-auto-guess-root t)
  (setq lsp-java-server-install-dir "/usr/share/java/jdtls/")
  (setq lsp-signature-doc-lines 3)

  (defun lsp-booster--advice-json-parse (old-fn &rest args)
    "Try to parse bytecode instead of json."
    (or
     (when (equal (following-char) ?#)
       (let ((bytecode (read (current-buffer))))
         (when (byte-code-function-p bytecode)
           (funcall bytecode))))
     (apply old-fn args)))
  (advice-add (if (progn (require 'json)
                         (fboundp 'json-parse-buffer))
                  'json-parse-buffer
                'json-read)
              :around
              #'lsp-booster--advice-json-parse)

  (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
    "Prepend emacs-lsp-booster command to lsp CMD."
    (let ((orig-result (funcall old-fn cmd test?)))
      (if (and (not test?)                             ;; for check lsp-server-present?
               (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
               lsp-use-plists
               (not (functionp 'json-rpc-connection))  ;; native json-rpc
               (executable-find "emacs-lsp-booster"))
          (progn
            (message "Using emacs-lsp-booster for %s!" orig-result)
            (cons "emacs-lsp-booster" orig-result))
        orig-result)))
  (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

  ;; Spell checking
  (require 'flycheck-vale)
  (flycheck-vale-setup)

  )

(declare-function emacs-everywhere-abort "emacs-everywhere" ())
(declare-function emacs-everywhere--finish-or-ctrl-c-ctrl-c "emacs-everywhere" ())
(defun mine/emacs-everywhere-config()
  "Emacs Everywhere"

  (require 'emacs-everywhere)
  (spacemacs/set-leader-keys-for-minor-mode 'emacs-everywhere-mode "," #'emacs-everywhere--finish-or-ctrl-c-ctrl-c)
  (spacemacs/set-leader-keys-for-minor-mode 'emacs-everywhere-mode "k" #'emacs-everywhere-abort)

  )

(declare-function ledger-report "ledger-report" (report-name edit))
(defun ledger-monthly-report()
  "Report monthly expenses"

  (interactive)
  (ledger-report "reg-M" ())
  (run-with-idle-timer 0.1 () (lambda () (goto-char (point-max))))

  )

(defun mine/ledger-config()
  "Ledger-mode config"

  (setq ledger-reports '(("bal" "%(binary) -f %(ledger-file) bal")
                         ("reg" "%(binary) -f %(ledger-file) reg")
                         ("reg-M" "%(binary) -f %(ledger-file) reg -M")
                         ("tag" "%(binary) -f %(ledger-file) bal tag %(tagname)")
                         ("account" "%(binary) -f %(ledger-file) reg %(account)")))
  (spacemacs/declare-prefix-for-mode 'ledger-mode "M" "monthly-report")
  (spacemacs/set-leader-keys-for-major-mode 'ledger-mode "M" 'ledger-monthly-report)

  )

(defun mine/git-config()
  "Git/Magit config"

  (setq vc-follow-symlinks t)

  (setq magit-repository-directories
        '(("~/.emacs.d"  . 0)
          ("~/Workspaces/" . 2)))

  ;; Magit-delta config
  ;; (require 'magit-delta) ;; See `mine/preload-time-consuming-libs'

  )

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

  ;; Disable GC in mini buffer
  (add-hook 'minibuffer-setup-hook
            (lambda () (setq inhibit-message t
                             gc-cons-threshold most-positive-fixnum
                             gc-cons-percentage 1.0)))
  (add-hook 'minibuffer-exit-hook
            (lambda () (setq inhibit-message (> (minibuffer-depth) 1)
                             gc-cons-threshold (car dotspacemacs-gc-cons)
                             gc-cons-percentage (cdr dotspacemacs-gc-cons))))

  )

(defun mine/llama-config()
  "Llama bindings"

  (declare-function make-llm-ollama "llm-ollama")
  (require 'llm-ollama)
  (setq ellama-provider (make-llm-ollama :chat-model "llama3" :embedding-model "llama3"))
  ;; Ellama key bindings
  (spacemacs/declare-prefix "oo" "ollama-bindings")
  (spacemacs/set-leader-keys "ooa" #'ellama-ask)
  (spacemacs/set-leader-keys "oob" #'ellama-ask-about)
  (spacemacs/set-leader-keys "ood" #'ellama-define-word)
  (spacemacs/set-leader-keys "ooo" #'ellama-complete)
  (spacemacs/set-leader-keys "oos" #'ellama-summarize)

  )

(defun read-mastodon-compat-info()
  "Read Mastodon instance info from `auth-sources'
so as to avoid exposing them in config files."

  (let* ((auth (car (auth-source-search :port "mastodon" :max 1)))
         (host (plist-get auth :host))
         (user (plist-get auth :user)))
    (when auth
      (setq mastodon-instance-url (concat "https://" host)
            mastodon-active-user user)))

  )

(defvar hubfs-process-list nil)
(defun mount-hubfs()
  (interactive)

  (let ((url (read-string "Enter GitHub URL: "))
        (tmp-dir (make-temp-file "hubfs" t)))
    (add-to-list 'hubfs-process-list
                 (start-process "hubfs" nil "hubfs" "-auth" "none" url tmp-dir))
    (find-file tmp-dir)))

(defun unmount-all-hubfs()
  (interactive)

  (let ((plist hubfs-process-list))
    (setq hubfs-process-list nil)
    (mapcar #'stop-process plist)))

(defun mine/app-config()
  "Config for apps in the Emacs OS."

  ;; Emacs-Rime
  (setq rime-share-data-dir "~/.local/share/fcitx5/rime/"
        default-input-method "rime"
        rime-show-candidate 'posframe)

  ;; Ready player
  (require 'ready-player)
  (ready-player-add-to-auto-mode-alist)

  ;; Ement
  (setq ement-save-sessions t)
  (spacemacs/declare-prefix "acm" "matrix")
  (spacemacs/set-leader-keys "acmc" 'ement-connect)
  (spacemacs/set-leader-keys "acml" 'ement-list-rooms)
  (spacemacs/set-leader-keys "acmm" 'ement-notify-switch-to-mentions-buffer)
  (spacemacs/set-leader-keys "acmn" 'ement-notify-switch-to-notifications-buffer)

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

  ;; Mastodon.el
  (read-mastodon-compat-info)
  (spacemacs/declare-prefix "acf" "fediverse")
  (spacemacs/set-leader-keys "acfm" 'mastodon)
  (evil-set-initial-state 'mastodon-mode 'emacs)

  ;; Geiser
  (setq geiser-chez-binary "/usr/bin/chez")

  ;; HubFS
  (spacemacs/declare-prefix "awf" "fuse-fs")
  (spacemacs/set-leader-keys "awfh" #'mount-hubfs)
  (spacemacs/set-leader-keys "awfu" #'umount-all-hubfs)

  ;; Hacker News
  (spacemacs/set-leader-keys "awh" #'hnreader-news)
  (defun eww-ext-img-for-hn (dom &optional url)
    "Renders placeholder GIFs in Hacker News."
    (when (equal (car shr-base) "https://news.ycombinator.com")
      (let* ((tag (car dom))
             (props (cadr dom))
             (src (alist-get 'src props))
             (width (string-to-number (or (alist-get 'width props) "0")))
             (height (alist-get 'height props)))
        (when (and (eq tag 'img)
                   (equal src "s.gif")
                   (equal height "1")
                   (integerp width))
          (dotimes (_ (floor width 20))
            (shr-insert "//")))))
    (shr-tag-img dom url))
  (setq shr-external-rendering-functions
        '((img . eww-ext-img-for-hn)))

  ;; Terminal-here
  (setq terminal-here-linux-terminal-command 'xfce4-terminal)

  )

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

  (require 'gcmh)
  (gcmh-mode 1)

  (add-function :after
                after-focus-change-function
                (lambda () (unless (frame-focus-state) (garbage-collect))))

  (mine/app-config)
  (mine/centaur-tabs-config)
  (mine/completion-config)
  (mine/emacs-everywhere-config)
  (mine/evil-config)
  (mine/extra-emacs-config)
  (mine/fcitx-config)
  (mine/font-config)
  (mine/git-config)
  (mine/ibuffer-config)
  (mine/ledger-config)
  (mine/llama-config)
  (mine/mode-line-config)
  (mine/motion-config)
  (mine/org-config)
  (mine/tramp-config)
  (mine/wc-config)
  (mine/whitespace-config)

  (mine/preload-time-consuming-libs)

  )


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
     '(((:application eshell)
        eshell-connection-default-profile)
       ((:application tramp :protocol "flatpak")
        tramp-container-connection-local-default-flatpak-profile)
       ((:application tramp)
        tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)))
   '(connection-local-profile-alist
     '((eshell-connection-default-profile
        (eshell-path-env-list))
       (tramp-container-connection-local-default-flatpak-profile
        (tramp-remote-path "/app/bin" tramp-default-remote-path "/bin" "/usr/bin" "/sbin" "/usr/sbin" "/usr/local/bin" "/usr/local/sbin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/opt/bin" "/opt/sbin" "/opt/local/bin"))
       (tramp-connection-local-darwin-ps-profile
        (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
        (tramp-process-attributes-ps-format
         (pid . number)
         (euid . number)
         (user . string)
         (egid . number)
         (comm . 52)
         (state . 5)
         (ppid . number)
         (pgrp . number)
         (sess . number)
         (ttname . string)
         (tpgid . number)
         (minflt . number)
         (majflt . number)
         (time . tramp-ps-time)
         (pri . number)
         (nice . number)
         (vsize . number)
         (rss . number)
         (etime . tramp-ps-time)
         (pcpu . number)
         (pmem . number)
         (args)))
       (tramp-connection-local-busybox-ps-profile
        (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
        (tramp-process-attributes-ps-format
         (pid . number)
         (user . string)
         (group . string)
         (comm . 52)
         (state . 5)
         (ppid . number)
         (pgrp . number)
         (ttname . string)
         (time . tramp-ps-time)
         (nice . number)
         (etime . tramp-ps-time)
         (args)))
       (tramp-connection-local-bsd-ps-profile
        (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
        (tramp-process-attributes-ps-format
         (pid . number)
         (euid . number)
         (user . string)
         (egid . number)
         (group . string)
         (comm . 52)
         (state . string)
         (ppid . number)
         (pgrp . number)
         (sess . number)
         (ttname . string)
         (tpgid . number)
         (minflt . number)
         (majflt . number)
         (time . tramp-ps-time)
         (pri . number)
         (nice . number)
         (vsize . number)
         (rss . number)
         (etime . number)
         (pcpu . number)
         (pmem . number)
         (args)))
       (tramp-connection-local-default-shell-profile
        (shell-file-name . "/bin/sh")
        (shell-command-switch . "-c"))
       (tramp-connection-local-default-system-profile
        (path-separator . ":")
        (null-device . "/dev/null"))))
   '(magit-todos-exclude-globs '(".git/" "*.map"))
   '(magit-todos-insert-after '(bottom) nil nil "Changed by setter of obsolete option `magit-todos-insert-at'")
   '(package-selected-packages
     '(tramp-github bbcode-mode mastodon typescript-mode company-web web-completion-data counsel-css emmet-mode helm-css-scss pug-mode sass-mode haml-mode scss-mode slim-mode tagedit web-mode docker-compose-mode dockerfile-mode yaml-mode protobuf-mode pip-requirements pipenv load-env-vars pippel poetry py-isort pydoc pyenv-mode pythonic pylookup pytest pyvenv sphinx-doc stickyfunc-enhance xcscope yapfify realgud test-simple loc-changes load-relative company-go flycheck-golangci-lint go-eldoc go-fill-struct go-gen-test go-guru go-impl go-rename go-tag go-mode godoctor wc-mode nginx-mode add-node-modules-path impatient-mode import-js grizzl js-doc js2-refactor multiple-cursors livid-mode nodejs-repl npm-mode prettier-js skewer-mode js2-mode simple-httpd tern web-beautify systemd journalctl-mode cargo counsel-gtags counsel swiper ivy dap-mode bui flycheck-rust ggtags helm-gtags racer pos-tip ron-mode rust-mode toml-mode evil-goggles vim-powerline mwim org-superstar nameless toc-org unfill evil-visual-mark-mode expand-region string-edit-at-point golden-ratio org-projectile hl-todo hide-comnt column-enforce-mode eshell-z gitignore-templates shell-pop dotenv-mode link-hint helm-purpose drag-stuff helm-company auto-dictionary holy-mode which-key symon auto-compile ace-link evil-iedit-state string-inflection helm-ls-git writeroom-mode evil-args macrostep ac-ispell editorconfig elisp-def ibuffer-projectile helm-make password-generator fancy-battery treemacs-magit evil-cleverparens info+ gh-md git-modes git-messenger xterm-color rainbow-delimiters fcitx evil-mc evil-anzu overseer org-rich-yank highlight-indentation helm-c-yasnippet define-word gnuplot htmlize smeargle flycheck-package helm-xref auto-highlight-symbol treemacs-projectile evil-tutor hybrid-mode markdown-toc indent-guide evil-lion fuzzy helm-swoop org-download evil-snipe term-cursor volatile-highlights dumb-jump helm-mode-manager evil-indent-plus clean-aindent-mode space-doc quickrun evil-matchit git-link treemacs-persp helm-projectile evil-visualstar restart-emacs eval-sexp-fu ws-butler flycheck-elsa esh-help helm-org-rifle spacemacs-whitespace-cleanup helm-git-grep paradox help-fns+ evil-lisp-state vi-tilde-fringe highlight-parentheses helm-descbinds evil-textobj-line lorem-ipsum terminal-here dired-quick-sort multi-line org-present google-translate open-junk-file org-pomodoro multi-vterm flyspell-correct-helm devdocs evil-surround centered-cursor-mode yasnippet-snippets winum evil-evilified-state diminish org-mime emacs-everywhere spaceline-all-the-icons evil-collection undo-tree treemacs-icons-dired symbol-overlay spacemacs-purpose-popwin evil-escape flx-ido evil-numbers ace-jump-helm-line popwin evil-easymotion auto-yasnippet eshell-prompt-extras evil-nerd-commenter treemacs-evil emr evil-exchange eyebrowse org-cliplink multi-term aggressive-indent uuidgen texfrag evil-org org-alert orgit-forge request hungry-delete helm-themes mmm-mode elisp-slime-nav git-timemachine font-lock+ helm-org evil-unimpaired pcre2el highlight-numbers inspector))
   '(rst-new-adornment-down t)
   '(rst-preferred-adornments
     '((35 over-and-under 1)
       (61 over-and-under 0)
       (61 simple 0)
       (45 simple 0)
       (126 simple 0)
       (43 simple 0)
       (34 simple 0)
       (46 simple 0)))
   '(safe-local-variable-values
     '((magit-todos-exclude-globs "*/build/*")
       (javascript-backend . tide)
       (javascript-backend . tern))))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(markdown-code-face ((t (:family "Sarasa Term SC Nerd" :inherit fixed-pitch)))))
  )

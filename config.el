;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Chanon Yothavut"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox
      doom-font (font-spec :family "Iosevka Term Extended" :size 10.0 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "Iosevka Aile" :size 12.0 :weight 'medium)
      +zen-text-scale 0
      +zen-window-divider-size 4)

(setq doom-gruvbox-dark-variant "hard")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/University/")
(setq org-agenda-files (list org-directory))
(setq org-cite-csl-styles-dir "~/Zotero/styles")
(setq org-latex-src-block-backend 'engraved)
(setq org-latex-engraved-theme 'doom-one-light)
(setq org-latex-caption-above nil)

(setq mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(0.07))

(keychain-refresh-environment)

;; Disable apheleia for C# since it doesn't respect editorconfig yet
(add-to-list '+format-on-save-disabled-modes 'csharp-mode)

;; Since apheleia is disabled, lsp-format-buffer is used instead to format the current buffer on save
(add-hook 'csharp-mode-hook (lambda () (add-hook 'before-save-hook 'lsp-format-buffer nil t)))

(add-to-list 'default-frame-alist '(alpha-background . 90))

(defun generateRandStr ()
  (substring (shell-command-to-string "xxd -l 4 -c 4 -p < /dev/random") 0 -1))

(map! :map csharp-mode-map
      :localleader
      (:desc "Sharper" "s" #'sharper-main-transient))

(map! :map org-mode-map
      :localleader
      (:prefix ("j" . "citar")
       :desc "Insert citation" "c" #'citar-insert-citation
       :desc "Insert reference" "r" #'citar-insert-reference
       :desc "Open files" "o" #'citar-open-files
       ))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! dap-mode
  (setq dap-python-debugger 'debugpy))

(after! lsp-mode
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "clangd")
                    :major-modes '(c++-mode)
                    :remote? t
                    :server-id 'clangd-remote)))

(after! org
  (plist-put org-format-latex-options :scale 1.0)
  )

(after! ox-latex
  (add-to-list 'org-latex-classes
               '("report-noparts"
                 "\\documentclass[12pt]{extreport}"
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  )

(after! treemacs
  (setq treemacs-position 'right)
  )

(use-package! ligature
  :config
  (ligature-set-ligatures 't '(
                               "[ERROR]" "[DEBUG]" "[INFO]" "[WARN]" "[WARNING]" "[ERR]" "[FATAL]" "[TRACE]" "[FIXME]" "[TODO]"
                               "[BUG]" "[NOTE]" "[HACK]" "[MARK]" "# ERROR" "# DEBUG" "# INFO" "# WARN" "# WARNING" "# ERR"
                               "# FATAL" "# TRACE" "# FIXME" "# TODO" "# BUG" "# NOTE" "# HACK" "# MARK" "// ERROR" "// DEBUG"
                               "// INFO" "// WARN" "// WARNING" "// ERR" "// FATAL" "// TRACE" "// FIXME" "// TODO" "// BUG"
                               "// NOTE" "// HACK" "// MARK" "!!" "!=" "!==" "!!!" "!≡" "!≡≡" "!>" "!=<" "#(" "#_" "#{" "#?"
                               "#>" "##" "#_(" "%=" "%>" "%>%" "%<%" "&%" "&&" "&*" "&+" "&-" "&/" "&=" "&&&" "&>" "$>" "***"
                               "*=" "*/" "*>" "++" "+++" "+=" "+>" "++=" "--" "-<" "-<<" "-=" "->" "->>" "---" "-->" "-+-"
                               "-\\/" "-|>" "-<|" ".." "..." "..<" ".>" ".~" ".=" "/*" "//" "/>" "/=" "/==" "///" "/**" ":::"
                               "::" ":=" ":≡" ":>" ":=>" ":(" ":-(" ":)" ":-)" ":/" ":\\" ":3" ":D" ":P" ":>:" ":<:" "<$>" "<*"
                               "<*>" "<+>" "<-" "<<" "<<<" "<<=" "<=" "<=>" "<>" "<|>" "<<-" "<|" "<=<" "<~" "<~~" "<<~" "<$"
                               "<+" "<!>" "<@>" "<#>" "<%>" "<^>" "<&>" "<?>" "<.>" "</>" "<\\>" "<\">" "<:>" "<~>" "<**>"
                               "<<^" "<!" "<@" "<#" "<%" "<^" "<&" "<?" "<." "</" "<\\" "<\"" "<:" "<->" "<!--" "<--" "<~<"
                               "<==>" "<|-" "<<|" "<-<" "<-->" "<<==" "<==" "=<<" "==" "===" "==>" "=>" "=~" "=>>" "=/=" "=~="
                               "==>>" "≡≡" "≡≡≡" "≡:≡" ">-" ">=" ">>" ">>-" ">>=" ">>>" ">=>" ">>^" ">>|" ">!=" ">->" "??" "?~"
                               "?=" "?>" "???" "?." "^=" "^." "^?" "^.." "^<<" "^>>" "^>" "\\\\" "\\>" "\\/-" "@>" "|=" "||"
                               "|>" "|||" "|+|" "|->" "|-->" "|=>" "|==>" "|>-" "|<<" "||>" "|>>" "|-" "||-" "~=" "~>" "~~>"
                               "~>>" "[[" "]]" "\">" "_|_"))
  (global-ligature-mode t))

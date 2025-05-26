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
(setq doom-theme 'modus-vivendi
      doom-font (font-spec :family "Aporetic Sans Mono" :size 12.0 :height 1.0 )
      ;;doom-font (font-spec :family "Iosevka Term Extended" :size 12.0 :height 1.0 :weight 'normal)
      ;;doom-font "Terminus (TTF):pixelsize=20:antialias=off"
      doom-variable-pitch-font (font-spec :family "Inter" :size 10.0)
      ;;doom-variable-pitch-font (font-spec :family "Aporetic Sans Mono Term" :size 12.0 :height 1.0)
      +zen-text-scale 0
      +zen-window-divider-size 4)

(setq doom-gruvbox-dark-variant "hard")
(setq doom-gruvbox-light-variant "hard")
(setq doom-gruvbox-light-brighter-comments t)
(setq doom-gruvbox-light-comment-bg t)
(setq doom-miramare-brighter-comments t)
(setq doom-badger-brighter-comments t)
(setq doom-badger-comment-bg nil)
(setq doom-Iosvkem-brighter-comments t)
(setq doom-acario-light-brighter-comments t)
(setq doom-acario-light-comment-bg nil)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/University/")
(setq org-agenda-files (list org-directory))
(setq org-cite-csl-styles-dir "~/Zotero/styles")
(setq citar-bibliography '("~/FinalYearProject/Thesis/Thesis.bib"))
(setq langtool-default-language "en-GB")
(setq org-latex-src-block-backend 'engraved)
(setq org-latex-engraved-theme 'modus-operandi)
(setq org-export-with-sub-superscripts '{})
(setq org-latex-compiler "xelatex")
(setq org-latex-caption-above nil)
(setq org-id-link-to-org-use-id t)
(setq org-id-link-consider-parent-id nil)
(setq org-latex-pdf-process '
      ("%latex -interaction nonstopmode --shell-escape -output-directory %o %f"
       "%latex -interaction nonstopmode --shell-escape -output-directory %o %f"
       "%latex -interaction nonstopmode --shell-escape -output-directory %o %f"
       "%latex -interaction nonstopmode --shell-escape -output-directory %o %f")
      )
(setq org-latex-engraved-preamble "\\usepackage{fvextra}

[FVEXTRA-SETUP]

% Make line numbers smaller and grey.
\\renewcommand\\theFancyVerbLine{\\footnotesize\\color{black!40!white}\\arabic{FancyVerbLine}}

\\usepackage{xcolor}

% In case engrave-faces-latex-gen-preamble has not been run.
\\providecolor{EfD}{HTML}{f7f7f7}
\\providecolor{EFD}{HTML}{28292e}

% Define a Code environment to prettily wrap the fontified code.
\\usepackage[xparse]{tcolorbox}
\\DeclareTColorBox[]{Code}{o}%
{colback=EfD!98!EFD, colframe=EfD!95!EFD,
  fontupper=\\footnotesize\\setlength{\\fboxsep}{0pt},
  colupper=EFD,
  IfNoValueTF={#1}%
  {boxsep=2pt, arc=2.5pt, outer arc=2.5pt,
    boxrule=0.5pt, left=2pt}%
  {boxsep=2.5pt, arc=0pt, outer arc=0pt,
    boxrule=0pt, leftrule=1.5pt, left=0.5pt},
  right=2pt, top=1pt, bottom=0.5pt}

[LISTINGS-SETUP]")

(add-to-list 'default-frame-alist '(alpha-background . 90))

(setq mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(0.07))

(keychain-refresh-environment)

;; Add hook for modeline (doom's +light modeline) in zen mode
(add-hook 'writeroom-mode-hook #'+modeline-mode)


(defun langtool-on-save ()
  (add-hook 'before-save-hook 'langtool-check-buffer nil 'local)
  )

(add-hook 'org-mode-hook 'langtool-on-save)

(map! :map org-mode-map
      :localleader
      :desc "Kill noter session" "k" #'org-noter-kill-session
      (:prefix ("j". "citar")
       :desc "Insert citation" "c" #'citar-insert-citation
       :desc "Insert reference" "r" #'citar-insert-reference
       :desc "Open files" "o" #'citar-open-files
       )
      )

(map! :map pdf-view-mode-map
      :localleader
      :desc "New noter session" "n" #'org-noter
      :desc "Add note on current page" "i" #'org-noter-insert-note
      :desc "Kill noter session" "k" #'org-noter-kill-session
      )

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

(use-package! dts-mode
  :mode "\\.overlay\\'"
  )

(use-package! asm-mode
  :mode "\\.INC\\'"
  )

(use-package! asm-mode
  :mode "\\.inc\\'"
  )

(after! mixed-pitch-mode
  (setq mixed-pitch-set-height t)
  (set-face-attribute 'variable-pitch nil :height 3.0)
  )

(after! dap-mode
  (setq dap-python-debugger 'debugpy)
  )

(after! lsp-mode
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "clangd")
                    :major-modes '(c++-mode)
                    :remote? t
                    :server-id 'clangd-remote
                    )
   )
  (map! :map c-mode-map
        :localleader
        :desc "Switch source/header" "s" #'lsp-clangd-find-other-file
        )
  (map! :map c++-mode-map
        :localleader
        :desc "Switch source/header" "s" #'lsp-clangd-find-other-file
        )
  )

(after! dart-mode
  (map! :map dart-mode-map
        :localleader
        (:prefix ("f". "flutter")
         :desc "Flutter outline toggle" "o" #'lsp-dart-show-flutter-outline
         :desc "Outline toggle" "t" #'lsp-dart-show-outline
         )
        )
  )

(after! writeroom-mode
  (setq writeroom-width 120)
  )

(set-eglot-client! 'cc-mode '("ccls" "--init={\"index\": {\"threads\": 3}}"))

(after! org-mode
  (plist-put org-format-latex-options :scale 1.0)
  ;;(hl-todo-mode)
  (display-line-numbers-mode -1)
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
  (add-to-list 'org-latex-classes
               '("org-plain-latex"
                 "\\documentclass{report}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
               '("mimore"
                 "\\documentclass{mimore}
 [NO-DEFAULT-PACKAGES]
 [PACKAGES]
 [EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
               '("mimosis"
                 "\\documentclass{mimosis}
 [NO-DEFAULT-PACKAGES]
 [PACKAGES]
 [EXTRA]
\\newcommand{\\mboxparagraph}[1]{\\paragraph{#1}\\mbox{}\\\\}
\\newcommand{\\mboxsubparagraph}[1]{\\subparagraph{#1}\\mbox{}\\\\}"
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\mboxparagraph{%s}" . "\\mboxparagraph*{%s}")
                 ("\\mboxsubparagraph{%s}" . "\\mboxsubparagraph*{%s}")))
  )

(after! treemacs
  (setq treemacs-position 'right)
  )

;; Workspace is shown all the time with this function
(after! persp-mode
  (defun display-workspaces-in-minibuffer ()
    (with-current-buffer " *Minibuf-0*"
      (erase-buffer)
      (insert (+workspace--tabline))))
  (run-with-idle-timer 1 t #'display-workspaces-in-minibuffer)
  (+workspace/display))

(defun disable-banner ()
  ()
  )

(setq +doom-dashboard-ascii-banner-fn #'disable-banner)

;;(use-package! ligature
;;  :config
;;  ;;(ligature-set-ligatures 't '(
;;  ;;                             "[ERROR]" "[DEBUG]" "[INFO]" "[WARN]" "[WARNING]" "[ERR]" "[FATAL]" "[TRACE]" "[FIXME]" "[TODO]"
;;  ;;                             "[BUG]" "[NOTE]" "[HACK]" "[MARK]" "# ERROR" "# DEBUG" "# INFO" "# WARN" "# WARNING" "# ERR"
;;  ;;                             "# FATAL" "# TRACE" "# FIXME" "# TODO" "# BUG" "# NOTE" "# HACK" "# MARK" "// ERROR" "// DEBUG"
;;  ;;                             "// INFO" "// WARN" "// WARNING" "// ERR" "// FATAL" "// TRACE" "// FIXME" "// TODO" "// BUG"
;;  ;;                             "// NOTE" "// HACK" "// MARK" "!!" "!=" "!==" "!!!" "!≡" "!≡≡" "!>" "!=<" "#(" "#_" "#{" "#?"
;;  ;;                             "#>" "##" "#_(" "%=" "%>" "%>%" "%<%" "&%" "&&" "&*" "&+" "&-" "&/" "&=" "&&&" "&>" "$>" "***"
;;  ;;                             "*=" "*/" "*>" "++" "+++" "+=" "+>" "++=" "--" "-<" "-<<" "-=" "->" "->>" "---" "-->" "-+-"
;;  ;;                             "-\\/" "-|>" "-<|" ".." "..." "..<" ".>" ".~" ".=" "/*" "//" "/>" "/=" "/==" "///" "/**" ":::"
;;  ;;                             "::" ":=" ":≡" ":>" ":=>" ":(" ":-(" ":)" ":-)" ":/" ":\\" ":3" ":D" ":P" ":>:" ":<:" "<$>" "<*"
;;  ;;                             "<*>" "<+>" "<-" "<<" "<<<" "<<=" "<=" "<=>" "<>" "<|>" "<<-" "<|" "<=<" "<~" "<~~" "<<~" "<$"
;;  ;;                             "<+" "<!>" "<@>" "<#>" "<%>" "<^>" "<&>" "<?>" "<.>" "</>" "<\\>" "<\">" "<:>" "<~>" "<**>"
;;  ;;                             "<<^" "<!" "<@" "<#" "<%" "<^" "<&" "<?" "<." "</" "<\\" "<\"" "<:" "<->" "<!--" "<--" "<~<"
;;  ;;                             "<==>" "<|-" "<<|" "<-<" "<-->" "<<==" "<==" "=<<" "==" "===" "==>" "=>" "=~" "=>>" "=/=" "=~="
;;  ;;                             "==>>" "≡≡" "≡≡≡" "≡:≡" ">-" ">=" ">>" ">>-" ">>=" ">>>" ">=>" ">>^" ">>|" ">!=" ">->" "??" "?~"
;;  ;;                             "?=" "?>" "???" "?." "^=" "^." "^?" "^.." "^<<" "^>>" "^>" "\\\\" "\\>" "\\/-" "@>" "|=" "||"
;;  ;;                             "|>" "|||" "|+|" "|->" "|-->" "|=>" "|==>" "|>-" "|<<" "||>" "|>>" "|-" "||-" "~=" "~>" "~~>"
;;  ;;                             "~>>" "[[" "]]" "\">" "_|_"))
;;  (global-ligature-mode t))


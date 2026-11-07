;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Chanon Yothavut"
      user-mail-address "john@doe.com")

(modus-themes-include-derivatives-mode 1)
;; (standard-themes-take-over-modus-themes-mode 1)
(modus-themes-load-theme 'ef-owl)

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
(setq doom-theme 'ef-owl
      ;;doom-font (font-spec :family "Aporetic Sans Mono Term SmEx" :size 10.0)
      ;;doom-font (font-spec :family "Aporetic Sans Mono" :size 10.0 :weight 'medium)
      ;;doom-font (font-spec :family "CommitMono" :size 10.0)
      ;;doom-font (font-spec :family "Iosevka Custom Semi-Extended" :size 10.0)
      ;;doom-font (font-spec :family "Iosevka Custom" :size 8.0)
      ;;doom-font (font-spec :family "Monoid" :size 8.0)
      ;;doom-font "Monoid:size=10:style=Retina"
      ;;doom-font "Monoid:size=10"
      ;;doom-font (font-spec :family "Iosevka" :size 8.0)
      doom-font "Iosevka:pixelsize=11"
      ;;doom-font "Iosevka Term:size=10"
      ;;doom-font "EnvyCodeR Nerd Font Mono:size=12"
      ;;doom-font (font-spec :family "EnvyCodeR Nerd Font Mono" :size 8.0 :spacing 100)
      ;;doom-font "Iosevka Custom:pixelsize=12"
      ;;doom-font (font-spec :family "Input Mono Condensed" :size 8.0)
      ;;doom-font (font-spec :family "Ioskeley Mono Semi\-Condensed" :size 10.0)
      ;;doom-font (font-spec :family "CommitMonoDev5" :size 8.0 :spacing 100 :slant 'normal)
      ;;doom-font (font-spec :family "Hack" :size 9.0)
      ;;doom-font "Terminus:pixelsize=12:antialias=off"
      ;;doom-font (font-spec :family "IBM Plex Mono" :size 8.0 :weight 'normal :spacing 110)
      ;;doom-font "GohuFont uni11 Nerd Font Mono:pixelsize=11:antialias=on"
      ;;doom-font "Gohu GohuFont:pixelsize=11:antialias=off"
      ;;doom-font "Unifont:pixelsize=16:antialias=off"
      doom-variable-pitch-font (font-spec :family "Inter" :size 12.0)
      ;;doom-variable-pitch-font (font-spec :family "Aporetic Sans Mono Term" :size 12.0 :height 1.0)
      +zen-text-scale 0
      +zen-window-divider-size 4)

(use-package! org-alert
  :commands org-alert-check org-alert-enable org-alert-disable)
(setq alert-default-style 'libnotify)
(setq org-alert-interval 300
      org-alert-notify-cutoff 10
      org-alert-notify-after-event-cutoff 10)

(org-alert-enable)

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

(setq treesit-font-lock-level 2)

(setq lsp-sqls-workspace-config-path "root")

(set-email-account! "Work"
                    '((mu4e-sent-folder       . "/Work/Sent")
                      (mu4e-drafts-folder     . "/Work/Drafts")
                      (mu4e-trash-folder      . "/Work/Trash")
                      (mu4e-refile-folder     . "/Work/Inbox")
                      (smtpmail-smtp-user     . "chanon.y@y-matrix.com"))
                    t)
(setq
 smtpmail-smtp-server "smtp.m101.websupport.se"
 smtpmail-smtp-service 465
 smtpmail-stream-type 'tls
 smtpmail-smtp-user "chanon.y@y-matrix.com"

 send-mail-function #'smtpmail-send-it
 message-send-mail-function #'smtpmail-send-it
 )

(after! csv-mode
  (add-to-list 'csv-separators ";")
  ) 

(after! gptel
  (setq gptel-tools
        (list (gptel-make-tool
               :name "$web_search"
               :function (lambda (&optional search_result)
                           (json-serialize
                            `(:search_result ,search_result)))
               :description "Moonshot builtin web search. Only usable by moonshot model (kimi), ignore this if you are not."
               :args '((:name "search_result" :type object :optional t))
               :category "web")))

  (setq
   gptel-model 'kimi-k2-0905-preview
   gptel-backend
   (gptel-make-openai "Moonshot"
     :host "api.moonshot.ai" :stream t :key gptel-api-key
     :models '(
               kimi-latest
               kimi-k2-0711-preview
               kimi-k2-0905-preview
               kimi-k2-turbo-preview
               kimi-k2-thinking
               kimi-k2-turbo
               )
     :request-params '(:tools [(:type "builtin_function" :function (:name "$web_search"))])
     )
   )

  (gptel-make-openai "Llama.cpp" :protocol "http" :stream t :host "localhost:9931" :models '(local))
  (gptel-make-gemini "Gemini" :stream t :key gptel-api-key)
  (gptel-make-deepseek "Deepseek" :stream t :key gptel-api-key)
  (gptel-make-openai-oauth "Codex" :request-params '(:tools [(:type "web_search")]))
  (setq gptel-default-mode 'org-mode)

  (gptel-make-preset 'local
    :backend "Llama.cpp"
    :model 'local
    :tools '()
    )
  (gptel-make-preset 'moonshot
    :backend "Moonshot"
    :model 'kimi-k2-0905-preview
    :tools '("$web_search")
    )

  (gptel-make-preset 'gemini-flash
    :backend "Gemini"
    :model 'gemini-2.5-flash
    :tools '()
    )

  (gptel-make-preset 'gemini-pro
    :backend "Gemini"
    :model 'gemini-2.5-pro
    :tools '()
    )
  )

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(global-hl-line-mode -1)
(hl-line-mode -1)

;;(setq doom-modeline-height 10)
(setq +modeline-height 10)
(setq scroll-margin 10)

(after! compile
  (setq compilation-scroll-output t)
  )
(global-display-fill-column-indicator-mode 1)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes/")

(setq org-agenda-files (list org-directory))
(setq org-agenda-custom-commands
      '(
        ("n" "All agenda" ((agenda) (alltodo)))
        ("w" todo "TODO"
         ((org-agenda-sorting-strategy '(priority-down))
          (org-agenda-prefix-format "  TODO: "))
         )
        )
      )

;; (setq lsp-clients-angular-language-server-command
;;       '("node"
;;         "/usr/lib/node_modules/@angular/language-server"
;;         "--ngProbeLocations"
;;         "/usr/lib/node_modules"
;;         "--tsProbeLocations"
;;         "/usr/lib/node_modules"
;;         "--stdio"))
(setq lsp-clients-angular-language-server-command
      '("ngserver"
        "--stdio"
        "--tsProbeLocations"
        "/home/seasea128/.nvm/versions/node/v22.23.1/lib/node_modules/"
        "--ngProbeLocations"
        "/home/seasea128/.nvm/versions/node/v22.23.1/lib/node_modules/@angular/language-server/node_modules/"
        ))


(add-to-list 'default-frame-alist '(alpha-background . 100))

(defun my/project-todos ()
  (interactive)
  (consult-ripgrep
   (projectile-project-root)
   "TODO\\|FIXME\\|HACK\\|REVIEW\\|XXX"))
(map! :leader
      :desc "Project TODOs"
      "p t" #'my/project-todos)

(map! :leader
      :desc "File TODOs"
      "s t" #'hl-todo-occur)

(setq mouse-wheel-progressive-speed nil)

;; Add hook for modeline (doom's +light modeline) in zen mode
(add-hook 'writeroom-mode-hook #'+modeline-mode)
;; Hook for lsp in protobuf mode
(add-hook 'protobuf-mode-hook #'lsp)

(map! :after dap-mode
      :map dap-mode-map
      :desc "Step over" "<f5>" #'dape-next
      :desc "Step into" "<f6>" #'dape-step-in
      :desc "Step out" "<f7>" #'dape-step-out
      )

(map! :n "SPC d u" #'dape-until)
(map! :n "SPC TAB g" #'+workspace/switch-to)

(map! :after org
      :map org-mode-map
      :localleader
      :desc "Kill noter session" "k" #'org-noter-kill-session
      (:prefix-map ("j" . "citar")
       :desc "Insert citation" "c" #'citar-insert-citation
       :desc "Insert reference" "r" #'citar-insert-reference
       :desc "Open files" "o" #'citar-open-files
       )
      )

(map! :after pdf-view-mode
      :map pdf-view-mode-map
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

(use-package! just-mode
  :mode "\\justfile\\'" "\\.just\\'"
  )

(use-package! typst-ts-mode
  :mode "\\.typ\\'")

(use-package! asm-mode
  :mode "\\.INC\\'"
  )

(use-package! asm-mode
  :mode "\\.inc\\'"
  )

(use-package! opascal-mode
  :mode "\\.pas\\'"
  )

(use-package! hurl-mode
  :mode "\\.hurl\\'"
  )

(use-package! bitbake-ts-mode
  :mode "\\.bb\\'" "\\.bbappend\\'" "\\.bbclass\\'"
  )

(use-package! yaml-mode
  :mode "\\.yaml\\'"
  )

(use-package! odin-ts-mode
  :mode "\\.odin\\'")

(use-package! go-mod-ts-mode
  :mode "\\.mod\\'")

(use-package wingman
  :ensure t
  :init
  ;; Point to your local Ollama instance
  (setq wingman-llama-endpoint "http://localhost:8080/infill")
  ;; :hook (prog-mode . wingman-mode)
  )

(after! treesit
  (add-to-list 'treesit-language-source-alist
               '(odin "https://github.com/tree-sitter-grammars/tree-sitter-odin")))

(after! dap-mode
  (setq dap-python-debugger 'debugpy)
  )

(after! evil
  (map! :v "$" "g$"))

(add-hook 'typst-ts-mode-local-vars-hook #'lsp!)
(add-hook 'odin-ts-mode-hook #'lsp!)

(after! go-mode
  (setq flycheck-go-staticcheck-executable "staticcheck")
  )

(after! hurl-mode
  (map! :map hurl-mode-map
        :localleader
        :desc "Send request" "e" #'hurl-mode-send-request-single
        )
  )

(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
  (lsp-register-client (make-lsp-client
                        :new-connection (lsp-stdio-connection "tinymist")
                        :activation-fn (lsp-activate-on "typst")
                        :server-id 'tinymist
                        ))

  (add-to-list 'lsp-language-id-configuration '(bitbake-ts-mode . "bitbake"))
  (lsp-register-client (make-lsp-client
                        :new-connection (lsp-stdio-connection "language-server-bitbake")
                        :activation-fn (lsp-activate-on "bitbake")
                        :server-id 'bitbake
                        ))

  (lsp-register-client (make-lsp-client
                        :new-connection (lsp-stdio-connection '("buf" "lsp" "serve"))
                        :activation-fn (lsp-activate-on "proto")
                        :server-id 'buf-protobuf
                        ))

  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "clangd")
                    :major-modes '(c++-mode)
                    :remote? t
                    :server-id 'clangd-remote
                    ))

  (map! :map c-ts-mode-map
        :localleader
        :desc "Switch source/header" "s" #'lsp-clangd-find-other-file
        )
  (map! :map c++-ts-mode-map
        :localleader
        :desc "Switch source/header" "s" #'lsp-clangd-find-other-file
        )
  )

(after! dart-ts-mode
  (map! :map dart-ts-mode-map
        :localleader
        (:prefix ("f". "flutter")
         :desc "Flutter outline toggle" "o" #'lsp-dart-show-flutter-outline
         :desc "Outline toggle" "t" #'lsp-dart-show-outline
         )
        )
  )

(after! writeroom-mode
  (setq writeroom-width 100)
  )

(after! corfu
  (corfu-popupinfo-mode 1)
  )

(after! csharp-ts-mode
  (map! :map csharp-ts-mode-map
        :localleader
        :desc "Sharper" "m" #'sharper-main-transient
        )
  )

(after! org
  (add-to-list 'org-src-lang-modes (cons "proto" 'protobuf))
  (plist-put org-format-latex-options :scale 1.0)
  (plist-put org-format-latex-options :foreground nil)
  (plist-put org-format-latex-options :background nil)

  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-cite-csl-styles-dir "~/Zotero/styles")
  (setq citar-bibliography '("~/FinalYearProject/Thesis/Thesis.bib"))
  (setq langtool-default-language "en-GB")
  (setq org-latex-src-block-backend 'engraved)
  (setq org-latex-engraved-theme 'ef-light)
  (setq org-latex-caption-above t)
  (setq org-export-with-sub-superscripts '{})
  (setq org-latex-compiler "xelatex")
  (setq org-latex-caption-above nil)
  (setq org-image-align 'center)
  (setq org-id-link-to-org-use-id t)
  (setq org-id-link-consider-parent-id nil)
  (setq go-ts-mode-indent-offset 4)
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

(after! dirvish
  (setq dirvish-hide-cursor nil)
  (setq dirvish-side-display-alist '((side . right) (slot . -1))
        )
  )

(after! compile
  (set-popup-rule! "^\\*compilation" :ignore t))

;; Show workspace in normal mode
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

(setq +dashboard-ascii-banner-fn #'disable-banner)

(with-eval-after-load 'ghostel
  (setq ghostel-module-auto-install 'compile))

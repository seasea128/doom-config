;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Chanon Yothavut"
      user-mail-address "john@doe.com")

(modus-themes-include-derivatives-mode 1)
;;(standard-themes-take-over-modus-themes-mode 1)
;;(modus-themes-load-theme 'ef-bio)

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
      ;;doom-font (font-spec :family "Aporetic Sans Mono Term SmEx" :size 10.0)
      ;;doom-font (font-spec :family "Aporetic Sans Mono" :size 10.0 :weight 'medium)
      ;;doom-font (font-spec :family "CommitMono" :size 10.0)
      doom-font (font-spec :family "Iosevka Term" :size 10.0 :height 1.0)
      ;;doom-font "Terminus:pixelsize=12:antialias=off"
      ;;doom-font (font-spec :family "IBM Plex Mono" :size 10.0 :weight 'normal :spacing 110)
      ;;doom-font "Terminus (TTF):pixelsize=20:antialias=off"
      doom-variable-pitch-font (font-spec :family "Inter" :size 11.0)
      ;;doom-variable-pitch-font (font-spec :family "Aporetic Sans Mono Term" :size 12.0 :height 1.0)
      +zen-text-scale 0
      +zen-window-divider-size 4)

(use-package! org-alert
  :commands org-alert-check org-alert-enable org-alert-disable)
(setq alert-default-style 'libnotify)
(setq org-alert-interval 300
      org-alert-notify-cutoff 10
      org-alert-notify-after-event-cutoff 10)

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

(setq treesit-font-lock-level 3)

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

  (gptel-make-openai "Llama.cpp" :protocol "http" :stream t :host "localhost:8080" :models '(local))
  (gptel-make-gemini "Gemini" :stream t :key gptel-api-key)
  (gptel-make-deepseek "Deepseek" :stream t :key gptel-api-key)
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

(setq doom-modeline-height 25)

(after! compile
  (setq compilation-scroll-output t)
  )
(global-display-fill-column-indicator-mode 1)

;; Setup for lsp-booster
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
          (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
            (setcar orig-result command-from-exec-path))
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

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

(setq lsp-clients-angular-language-server-command
      '("node"
        "/usr/lib/node_modules/@angular/language-server"
        "--ngProbeLocations"
        "/usr/lib/node_modules"
        "--tsProbeLocations"
        "/usr/lib/node_modules"
        "--stdio"))


(add-to-list 'default-frame-alist '(alpha-background . 100))

(setq mouse-wheel-progressive-speed nil)

;; Add hook for modeline (doom's +light modeline) in zen mode
(add-hook 'writeroom-mode-hook #'+modeline-mode)

(map! :after dap-mode
      :map dap-mode-map
      :desc "Step over" "<f5>" #'dape-next
      :desc "Step into" "<f6>" #'dape-step-in
      :desc "Step out" "<f7>" #'dape-step-out
      )

(map! :n "SPC d u" #'dape-until)

(map! :after org-mode
      :map org-mode-map
      :localleader
      :desc "Kill noter session" "k" #'org-noter-kill-session
      (:prefix ("j". "citar")
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

(use-package! typst-ts-mode
  :mode "\\.typ\\'")

(use-package! asm-mode
  :mode "\\.INC\\'"
  )

(use-package! asm-mode
  :mode "\\.inc\\'"
  )

(after! dap-mode
  (setq dap-python-debugger 'debugpy)
  )

(add-hook 'typst-ts-mode-local-vars-hook #'lsp!)

(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
  (lsp-register-client (make-lsp-client
                        :new-connection (lsp-stdio-connection "tinymist")
                        :activation-fn (lsp-activate-on "typst")
                        :server-id 'tinymist
                        ))

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
  (setq writeroom-width 100)
  )

(after! csharp-mode
  (map! :map csharp-mode-map
        :localleader
        :desc "Sharper" "m" #'sharper-main-transient
        )
  )

(after! org
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

(setq +doom-dashboard-ascii-banner-fn #'disable-banner)

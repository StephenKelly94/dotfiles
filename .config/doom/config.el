;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Identity

(setq user-full-name "Stephen Kelly"
      user-mail-address "ske@onskeskyen.dk")

;;; UI

(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 12)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font" :size 12))
(setq doom-theme 'doom-nord)
(setq display-line-numbers-type 'relative)

;;; Editor & behaviour

(setq delete-by-moving-to-trash t)
(global-subword-mode 1)
(setq which-key-idle-delay 0.4)
(setq recentf-max-saved-items 200)
(setq +workspaces-on-switch-project-behavior t)   ; per-project workspace, always

;; NS build: left Option composes special chars (@ {} [] | etc.); Meta on right
;; Option (Esc also works as a Meta prefix).
(when (featurep :system 'macos)
  (setq ns-option-modifier       'none
        ns-right-option-modifier 'meta))

;;; Org

(setq org-directory "~/emacs/org/")

;;; Keybindings

(map! :leader :desc "Terminal (ghostel)" "o t" #'ghostel)

;; C-h/j/k/l window nav (normal/visual/motion; C-h stays `help' in insert).
(map! :nvm
      "C-h" #'evil-window-left
      "C-j" #'evil-window-down
      "C-k" #'evil-window-up
      "C-l" #'evil-window-right)

;; Tmux-zoom-style maximize toggle.
(defvar +window-maximize--saved nil
  "Saved layout for `+window-toggle-maximize'.")
(defun +window-toggle-maximize ()
  "Maximize the current window, or restore the saved layout if already maximized."
  (interactive)
  (if +window-maximize--saved
      (progn (set-window-configuration +window-maximize--saved)
             (setq +window-maximize--saved nil))
    (if (> (count-windows) 1)
        (progn (setq +window-maximize--saved (current-window-configuration))
               (delete-other-windows))
      (message "Only one window"))))
(map! :leader :desc "Toggle maximize window" "w z" #'+window-toggle-maximize)

;;; Package

;;;; ghostel — terminal

(use-package! evil-ghostel            ; evil ops (dd/c/x) drive the shell line editor
  :after (ghostel evil)
  :hook (ghostel-mode . evil-ghostel-mode))

;; Open ghostel in a bottom popup (like vterm), not the current window.
(set-popup-rule! "^\\*ghostel" :side 'bottom :size 0.3 :select t :quit nil :ttl nil)

;;;; magit

(after! magit
  (setq magit-diff-refine-hunk 'all))

;; Readable diff colours: subtle tinted backgrounds, light foregrounds (the
;; default word-level refine highlight was dark text on a bright background).
(custom-set-faces!
 '(magit-diff-added             :background "#37423a" :foreground "#a3be8c")
 '(magit-diff-added-highlight   :background "#41543f" :foreground "#b8d6a0")
 '(diff-refine-added            :background "#5e7a4d" :foreground "#eceff4")
 '(magit-diff-removed           :background "#463639" :foreground "#bf616a")
 '(magit-diff-removed-highlight :background "#573f44" :foreground "#d78d95")
 '(diff-refine-removed          :background "#8a4a52" :foreground "#eceff4"))

;;;; lsp-mode — Helm charts

;; Treat chart YAML as helm-ls, and auto-start LSP under any dir with Chart.yaml.
(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '("/templates/.*\\.ya?ml\\'" . "helm-ls"))
  (add-to-list 'lsp-language-id-configuration '("/\\(Chart\\|values\\)\\.ya?ml\\'" . "helm-ls")))

(add-hook 'yaml-mode-hook
          (defun +helm-chart-lsp-maybe-h ()
            (when (and buffer-file-name
                       (locate-dominating-file buffer-file-name "Chart.yaml"))
              (lsp-deferred))))

;;;; agent-shell — Claude Code (ACP)

(use-package! agent-shell-anthropic
  :commands (agent-shell-anthropic-start-claude-code
             agent-shell-new-shell agent-shell-toggle agent-shell-other-buffer
             agent-shell-prompt-compose agent-shell-send-region
             agent-shell-send-file agent-shell-send-screenshot
             agent-shell-send-clipboard-image agent-shell-open-transcript)
  :init
  ;; Make `SPC o a' a prefix (unbind first — reload keeps the stale command).
  (define-key doom-leader-map (kbd "o a") nil)
  (map! :leader
        (:prefix ("o a" . "agent-shell")   ; global: launch + send from any buffer
         :desc "Start/reuse Claude"    "a" #'agent-shell-anthropic-start-claude-code
         :desc "New shell"             "n" #'agent-shell-new-shell
         :desc "Send region"           "r" #'agent-shell-send-region
         :desc "Send file"             "f" #'agent-shell-send-file
         :desc "Send screenshot"       "s" #'agent-shell-send-screenshot
         :desc "Send clipboard image"  "i" #'agent-shell-send-clipboard-image))
  :config
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t))
  (setq agent-shell-session-restore-verbosity 'full)   ; replay full convo on restore
  ;; Transcripts under ~/emacs/agent-transcripts/<project>/, out of the repos.
  (setq agent-shell-transcript-file-path-function
        (lambda ()
          (let* ((root (or (and (fboundp 'doom-project-root) (doom-project-root))
                           default-directory))
                 (project (file-name-nondirectory (directory-file-name root)))
                 (dir (expand-file-name (format "agent-transcripts/%s/" project)
                                        "~/emacs/")))
            (make-directory dir t)
            (expand-file-name (format-time-string "%F-%H-%M-%S.md") dir))))
  ;; Shell-buffer localleader (SPC m / ,).
  (map! :map agent-shell-mode-map
        :localleader
        :desc "Compose prompt"        "c" #'agent-shell-prompt-compose
        :desc "Switch to viewport"    "o" #'agent-shell-other-buffer
        :desc "Toggle shell window"   "t" #'agent-shell-toggle
        :desc "Send region"           "r" #'agent-shell-send-region
        :desc "Send file"             "f" #'agent-shell-send-file
        :desc "Send screenshot"       "s" #'agent-shell-send-screenshot
        :desc "Send clipboard image"  "i" #'agent-shell-send-clipboard-image
        :desc "Open transcript"       "T" #'agent-shell-open-transcript)
  ;; RET: newline in insert, send in normal.
  (map! :map agent-shell-mode-map
        :i "RET" #'newline
        :n "RET" #'comint-send-input))

;; Viewport/diff are read-only with bare keys (n/p/f/b/r/y…) evil would shadow;
;; motion state + an intercept map lets them win over evil (incl. snipe) while
;; j/k/gg still fall through.
(after! agent-shell-viewport
  (evil-set-initial-state 'agent-shell-viewport-view-mode 'motion)
  (evil-make-intercept-map agent-shell-viewport-view-mode-map 'motion)
  (map! :map agent-shell-viewport-view-mode-map    ; RET toggles the fold at point
        "RET"    #'agent-shell-ui-toggle-fragment
        [return] #'agent-shell-ui-toggle-fragment))

(after! agent-shell-diff
  (evil-set-initial-state 'agent-shell-diff-mode 'motion)
  (evil-make-intercept-map agent-shell-diff-mode-map 'motion))

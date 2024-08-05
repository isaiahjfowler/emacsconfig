;; Initialize package sources

(require 'server)
(unless (server-running-p)
  (server-start))

    (setenv "LSP_USE_PLISTS" "true")

  (setq gc-cons-threshold (* 1000 1024 1024)) ;; 50 MB

  (setq read-process-output-max (* 50 1024 1024)) ;; 5 MB

		    (require 'package)

		    (setq package-archives '(("melpa" . "https://melpa.org/packages/")
					     ("org" . "https://orgmode.org/elpa/")
					     ("elpa" . "https://elpa.gnu.org/packages/")
					    ("gnu-devel" . "https://elpa.gnu.org/devel/")))

		    (package-initialize)
		    (unless package-archive-contents
		    (package-refresh-contents))

		      ;; Initialize use-package on non-Linux platforms
		    (unless (package-installed-p 'use-package)
		      (package-install 'use-package))

		    (require 'use-package)

		    (setq use-package-always-ensure t)

		  ;; Enable native compilation
		  (setq comp-deferred-compilation t)
		  (setq native-comp-deferred-compilation-deny-list '())
		  (setq native-comp-eln-load-path '("~/.emacs.d/eln-cache"))

		  ;; Ensure that Emacs uses the right compilers
		  (setq comp-async-report-warnings-errors nil)
		  (setq native-comp-async-report-warnings-errors nil)

		(if (featurep 'native-compile)
		    (message "Native compilation is enabled!")
		  (message "Native compilation is not enabled."))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox-developer-edition")

(defvar runemacs/default-font-size 120) 

   (set-frame-parameter nil 'alpha-background 100)

   (scroll-bar-mode -1)        ; Disable visible scrollbar
   (tool-bar-mode -1)          ; Disable the toolbar
   (tooltip-mode -1)           ; Disable ooltips
   (set-fringe-mode 10)        ; Give some breathing room
   (menu-bar-mode -1)          ; Disable the menu bar
   (global-display-line-numbers-mode 1) 

  (setq inhibit-startup-message t) 
  (setq visible-bell nil) 
  (setq display-line-numbers-type 'relative) ;

   ;; Disable line numbers for some modes
   (dolist (mode '(org-mode-hook
		   term-mode-hook
		   vterm-mode-hook
		   pdf-view-mode-hook
		   shell-mode-hook
		   eshell-mode-hook))
     (add-hook mode (lambda () (display-line-numbers-mode 0))))

(add-hook 'prog-mode (electric-pair-mode t))

(set-face-attribute 'default nil
:font "Fira Code Nerd Font" :height runemacs/default-font-size)
;; Font Configuration ----------------------------------------------------------

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Nerd Font" :height 130)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 135 :weight 'regular)

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled

  (load-theme 'doom-vibrant t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package all-the-icons)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package ivy
      :diminish
      :init (ivy-mode 1)
      :bind (("C-s" . swiper)
	     :map ivy-minibuffer-map
	     ("TAB" . ivy-alt-done)
	     ("C-l" . ivy-alt-done)
	     ("C-j" . ivy-next-line)
	     ("C-k" . ivy-previous-line)
	     :map ivy-switch-buffer-map
	     ("C-k" . ivy-previous-line)
	     ("C-l" . ivy-done)
	     ("C-d" . ivy-switch-buffer-kill)
	     :map ivy-reverse-i-search-map
	     ("C-k" . ivy-previous-line)
	     ("C-d" . ivy-reverse-i-search-kill)))

  (use-package ivy-rich
    :init
    (ivy-rich-mode 1))

  (use-package counsel
    :bind (("M-x" . counsel-M-x)
	   ("C-x b" . persp-counsel-switch-buffer)
	   ("C-x C-f" . counsel-find-file)
	   :map minibuffer-local-map
	   ("C-r" . 'counsel-minibuffer-history)))

(setcdr (assoc 'counsel-M-x ivy-initial-inputs-alist) "")

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out"))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
			  '(("^ *\\([-]\\) "
			     (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
		  (org-level-2 . 1.1)
		  (org-level-3 . 1.05)
		  (org-level-4 . 1.0)
		  (org-level-5 . 1.1)
		  (org-level-6 . 1.1)
		  (org-level-7 . 1.1)
		  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(setq org-agenda-window-setup 'only-window)
	  (setq org-agenda-files (directory-files-recursively "~/OrgFiles" "\\.org$"))

	  (defun isaiah/org-mode-setup ()
	    (variable-pitch-mode 1)
	    (visual-line-mode 1))

	  (use-package org
	    :hook (org-mode . isaiah/org-mode-setup)
	    :config
	    (setq org-ellipsis " ▾")

	    (setq org-agenda-start-with-log-mode t)
	    (setq org-log-done 'time)
	    (setq org-log-into-drawer t)

	    (require 'org-habit)
	    (add-to-list 'org-modules 'org-habit)
	    (setq org-habit-graph-column 60)

	    (setq org-todo-keywords
		  '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
		    (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

	    (setq org-refile-targets
		  '(("Archive.org" :maxlevel . 1)
		    ("Tasks.org" :maxlevel . 1)))

	    ;; Save Org buffers after refiling!
	    (advice-add 'org-refile :after 'org-save-all-org-buffers)

	    (setq org-tag-alist
		  '((:startgroup)
						  ; Put mutually exclusive tags here
		    (:endgroup)
		    ("@errand" . ?e)
		    ("@home" . ?h)
		    ("@work" . ?w)
		    ("@study" . ?s)))

	    ;; Configure custom agenda views
	    (setq org-agenda-custom-commands
		  '(("d" "Dashboard"
		     ((agenda "" ((org-deadline-warning-days 7)))
		      (todo "NEXT"
			    ((org-agenda-overriding-header "Next Tasks")))
		      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

		    ("n" "Next Tasks"
		     ((todo "NEXT"
			    ((org-agenda-overriding-header "Next Tasks")))))

		    ("W" "Work Tasks" tags-todo "+work-email")

		    ;; Low-effort next actions
		    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
		     ((org-agenda-overriding-header "Low Effort Tasks")
		      (org-agenda-max-todos 20)
		      (org-agenda-files org-agenda-files)))

		    ("w" "Workflow Status"
		     ((todo "WAIT"
			    ((org-agenda-overriding-header "Waiting on External")
			     (org-agenda-files org-agenda-files)))
		      (todo "REVIEW"
			    ((org-agenda-overriding-header "In Review")
			     (org-agenda-files org-agenda-files)))
		      (todo "PLAN"
			    ((org-agenda-overriding-header "In Planning")
			     (org-agenda-todo-list-sublevels nil)
			     (org-agenda-files org-agenda-files)))
		      (todo "BACKLOG"
			    ((org-agenda-overriding-header "Project Backlog")
			     (org-agenda-todo-list-sublevels nil)
			     (org-agenda-files org-agenda-files)))
		      (todo "READY"
			    ((org-agenda-overriding-header "Ready for Work")
			     (org-agenda-files org-agenda-files)))
		      (todo "ACTIVE"
			    ((org-agenda-overriding-header "Active Projects")
			     (org-agenda-files org-agenda-files)))
		      (todo "COMPLETED"
			    ((org-agenda-overriding-header "Completed Projects")
			     (org-agenda-files org-agenda-files)))
		      (todo "CANC"
			    ((org-agenda-overriding-header "Cancelled Projects")
			     (org-agenda-files org-agenda-files)))))))

	    (setq org-capture-templates
		  `(("t" "Tasks / Projects")

		    ("tt" "Inbox" entry (file+olp "~/OrgFiles/Tasks.org" "Inbox")
		     "* TODO %?\n %a\n  %i"
		     :empty-lines 1)

      ("td" "Dowding" entry (file+olp "~/OrgFiles/Tasks.org" "Dowding")
       "* TODO %?\n %a\n  %i\nSCHEDULED: <%<%Y-%m-%d>>"
       :empty-lines 1)


		    ("j" "Journal Entries")
		    ("jj" "Journal" entry
		     (file+olp+datetree "~/OrgFiles/Journal.org")
		     "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
		     ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
		     :hook (delete-other-windows)
		     :clock-in :clock-resume
		     :empty-lines 1)

		    ("jw" "Workout" entry
		     (file+olp+datetree "~/OrgFiles/Goals/Fitness.org" "Journal")
		     "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
		     ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
		     :hook (delete-other-windows)
		     :clock-in :clock-resume
		     :empty-lines 1)

		    ("jm" "Meeting" entry
		     (file+olp+datetree "~/OrgFiles/Journal.org")
		     "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
		     :clock-in :clock-resume
		     :empty-lines 1)

		    ("w" "Workflows")
		    ("we" "Checking Email" entry (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
		     "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

		    ("m" "Metrics Capture")


		    ("mb" "Bench" table-line (file+headline "~/OrgFiles/Goals/Fitness.org" "Bench")
		     "| %U | %^{Bench}" :kill-buffer t)

		    ("mS" "Squat" table-line (file+headline "~/OrgFiles/Goals/Fitness.org" "Squat")
		     "| %U | %^{Squat}" :kill-buffer t)

		    ("mD" "Deadlift" table-line (file+headline "~/OrgFiles/Goals/Fitness.org" "Deadlift")
		     "| %U | %^{Deadlift}" :kill-buffer t)

		    ("mW" "Body Weight" table-line (file+headline "~/OrgFiles/Goals/Fitness.org" "Body Weight")
		     "| %U | %^{Bodyweight}" :kill-buffer t)
))


	    )

	  (define-key global-map (kbd "C-c j")
		      (lambda () (interactive) (org-capture nil "jj")))


	  (use-package org-super-agenda
	    :ensure t
	    :config
	    (org-super-agenda-mode))


	(setq org-super-agenda-groups
	      '(
		     (:name ""
		     :time-grid t ; Items that appear on the time grid
		     :order 1)
		(:name "Habits"
		       :tag "Morning"
		       :order 2)
		(:name "Chores"
		       :tag "@errand"
		       :order 3)
	      (:name "Workout"
		     :tag "Workout"
		     :order 4)
		(:name "Deep work"
		       :tag "@work"
		       :order 5)

	      (:name "Computer Science"
		     :tag "@study"
		     :order 5)
    ))


	  (efs/org-font-setup)

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun isaiah/org-mode-visual-fill ()
   (setq visual-fill-column-width 100
	 visual-fill-column-center-text t)
   (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . isaiah/org-mode-visual-fill))

(setq org-habit-show-all-today t)

(org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (C . t)
))

  (push '("conf-unix" . conf-unix) org-src-lang-modes)
(setq org-confirm-babel-evaluate nil)

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("cc" . "src c"))

;; Automatically tangle our Emacs.org config file when we save it
(defun isaiah/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.emacs.d/Config.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'isaiah/org-babel-tangle-config)))

(use-package tree-sitter)
(use-package tree-sitter-langs)
(require 'tree-sitter)
(require 'tree-sitter-hl)
(require 'tree-sitter-langs)
(require 'tree-sitter-debug)
(require 'tree-sitter-query)

;; Ensure all-the-icons and dired-icons are installed
(use-package all-the-icons-dired
  :ensure t)

(add-hook 'dired-mode-hook 'dired-omit-mode)

(use-package vterm)

(use-package python-mode
				    :ensure t)

				  (use-package typescript-mode

				    :ensure t)

				  (use-package web-mode
				    :ensure t
				    :mode "\\.html\\'" "\\.css\\'" "\\.js\\'")

			      (use-package yasnippet
				:ensure t
				:config
				(yas-global-mode 1))


			    (use-package yasnippet-snippets
			      :ensure t
			      )


	(use-package company)

      (use-package lsp-mode
	:init
	;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
	(setq lsp-keymap-prefix "C-c l")
	:hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
	       (XXX-mode . lsp)
	       ;; if you want which-key integration
	       (lsp-mode . lsp-enable-which-key-integration))
	:commands lsp)

      ;; optionally
      (use-package lsp-ui :commands lsp-ui-mode)
      ;; if you are helm user
      (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
      (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

      ;; (use-package dap-LANGUAGE) to load the dap adapter for your language

      ;; optional if you want which-key integration
      (use-package which-key
	  :config
	  (which-key-mode))


    (setq lsp-ui-sideline-enable nil)
    (setq lsp-ui-doc-enable nil)

(setq lsp-clients-angular-language-server-command
      '("ngserver" "--stdio"
        "--tsProbeLocations" "/home/isaiah/Projects/Code/Dowding/node_modules"
        "--ngProbeLocations" "/home/isaiah/Projects/Code/Dowding/node_modules"))

(setq company-idle-delay 0.3)  ; Adjust to your preference
(setq company-minimum-prefix-length 2)  ; Adjust to your preference

(setq flycheck-check-syntax-automatically '(save mode-enabled))

(use-package magit
:commands (magit-status magit-get-current-branch)
:custom (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package forge
    :after magit)



(use-package harpoon)

    (use-package perspective
    :custom
    (persp-show-modestring nil)
    (persp-mode-prefix-key (kbd "C-c c"))  ; pick your own prefix key here
    (persp-initial-frame-name "~")
    :config
    (persp-mode)
    )

    (use-package projectile
    :diminish projectile-mode
    :bind-keymap ("C-c p" . projectile-command-map)
    :init
    (setq projectile-project-search-path '("~/Projects/Code" "~/OrgFiles") )
    (setq projectile-switch-project-action #'projectile-dired)
    :config
    (projectile-mode))

(use-package persp-projectile)

(use-package counsel-projectile
:config (counsel-projectile-mode))

(use-package rainbow-delimiters)

(rainbow-delimiters-mode)

(use-package general)

(general-create-definer isaiah/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "M-m"
    :global-prefix "M-m")

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(isaiah/leader-keys
  "g" 'magit)

;; ORG MODE
(isaiah/leader-keys
    "o" '(:ignore t :which-key "Org keybindings")
    "oa" '(org-agenda :which-key "agenda")
    "oc" '(org-capture :which-key "capture"))

(general-define-key "M-`" 'harpoon-quick-menu-hydra)
(general-define-key "M-0" 'harpoon-add-file)
(general-define-key "M-1" 'harpoon-go-to-1)
(general-define-key "M-2" 'harpoon-go-to-2)
(general-define-key "M-3" 'harpoon-go-to-3)
(general-define-key "M-4" 'harpoon-go-to-4)
(general-define-key "M-5" 'harpoon-go-to-5)
(general-define-key "M-6" 'harpoon-go-to-6)
(general-define-key "M-7" 'harpoon-go-to-7)
(general-define-key "M-8" 'harpoon-go-to-8)
(general-define-key "M-9" 'harpoon-go-to-9)

(general-define-key "M-p" 'projectile-find-file)

  (isaiah/leader-keys
    "p" '(projectile-persp-switch-project :which-key "Switch project")
    "P" '(counsel-projectile-rg :which-key "Ripgrep project")

    "4" '((lambda () (interactive) (projectile-persp-switch-project "~/.emacs.d"))
	   :which-key "Config")
    "1" '((lambda () (interactive) (projectile-persp-switch-project "~/Projects/Code/Dowding"))

	   :which-key "Dowding")
    "2" '((lambda () (interactive) (projectile-persp-switch-project "~/Projects/Code/CSAPP"))

	   :which-key "csapp")


    "3" '((lambda () (interactive) (projectile-persp-switch-project "~/OrgFiles"))

	   :which-key "csapp")

  "9" '((lambda () (interactive) (magit))
	 :which-key "Magit")

"0" '((lambda () 
	 (interactive)
	 (let ((org-agenda-span 'day))
	   (org-agenda nil "a")))
       :which-key "Open Org Agenda")
  )

(isaiah/leader-keys
    "i" 'persp-counsel-switch-buffer
    "r" 'previous-buffer)

(general-define-key :states 'normal
"-" (lambda () (interactive) (dired default-directory)))

(isaiah/leader-keys
"-" (lambda () (interactive) (dired default-directory)))

(isaiah/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "ts" '(hydra-text-scale/body :which-key "scale text"))

;; Define window resizing functions
  (defun my/enlarge-window-horizontally ()
    "Increase the width of the current window."
    (interactive)
    (enlarge-window-horizontally 5))

  (defun my/shrink-window-horizontally ()
    "Decrease the width of the current window."
    (interactive)
    (shrink-window-horizontally 5))

  (defun my/enlarge-window ()
    "Increase the height of the current window."
    (interactive)
    (enlarge-window 5))

  (defun my/shrink-window ()
    "Decrease the height of the current window."
    (interactive)
    (shrink-window 5))

  (general-define-key

      :keymaps 'global
      "M-C-j" 'windmove-down
      "M-C-k" 'windmove-up
      "M-C-l" 'windmove-right
      "M-C-h" 'windmove-left
      "M-C-w" 'delete-window
)


       (isaiah/leader-keys
       "h" `(split-window-below :which-key  "Split window")
       "v" `(split-window-right :which-key  "Split window"))

;; Set up keybindings using general
(general-define-key
 :states 'normal
 "gd" 'lsp-find-definition
 "gr" 'lsp-find-references
 "gp" 'hydra-lsp-peek/body)  ;; Note the direct function call without quotes

(general-define-key
 :keymaps 'magit-mode-map
 :states '(normal visual)
 "C-r" 'magit-refresh
 ;; Add more bindings as needed
)


	      (isaiah/leader-keys
	      "mp" 'profiler-start 
	      "mr" 'profiler-report 
	      )

  (defun my/projectile-find-or-create-project (project-dir)
    "Find or create a project and switch to it."
    (interactive)

      (if (projectile-project-p project-dir)
	  (projectile-switch-project-by-name dir)
	(progn
	  (projectile-add-known-project dir)
	  (projectile-switch-project-by-name dir))))

(beacon-mode 1)

(map! :leader
      (:prefix ("b". "buffer")
       :desc "Listar marcadores" "L" #'list-bookmarks
       :desc "Salvar los marcadores actuales al documento de marcadores" "w" #'bookmark-save))

(setq centaur-tabs-set-bar 'over
      centaur-tabs-set-icons t
      centaur-tabs-gray-out-icons 'buffer
      centaur-tabs-height 24
      centaur-tabs-set-modified-marker t
      centaur-tabs-style "bar"
      centaur-tabs-modified-marker "•")
(map! :leader
      :desc "Alternar pestañas globalmente" "t c" #'centaur-tabs-mode
      :desc "Alternar pestañas en la pantalla local" "t C" #'centaur-tabs-local-mode)
; Aca usas las flechas para nagevar las pestañas. Flecha derecha (right) e izquierda (left) son para ir a la pestaña siguiente y previa, respectivamente. Abajo (down) y arriba (up) son para alternar entre grupos de pestaña (siguiente y previa, respectivamente).
(evil-define-key 'normal centaur-tabs-mode-map (kbd "g <right>") 'centaur-tabs-forward
                                               (kbd "g <left>")  'centaur-tabs-backward
                                               (kbd "g <down>")  'centaur-tabs-forward-group
                                               (kbd "g <up>")    'centaur-tabs-backward-group)

(map! :leader
      (:prefix ("c h" . "Invocar a Clippy")
       :desc "Clippy describe una funcion bajo el cursor" "f" #'clippy-describe-function
       :desc "Clippy describe una variable bajo el cursor" "v" #'clippy-describe-variable))

(add-hook! '+doom-dashboard-functions :append
  (insert "\n" (+doom-dashboard--center +doom-dashboard--width "Salve Regina")))
(defun title ()
  (let* ((banner '(" ████████╗ █████╗ ██████╗ ██████╗  ██████╗ ██╗     ██╗███╗   ██╗ ██████╗ █████╗  "
                   " ╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔═══██╗██║     ██║████╗  ██║██╔════╝██╔══██╗ "
                   "    ██║   ███████║██████╔╝██████╔╝██║   ██║██║     ██║██╔██╗ ██║███████╗╚██████║ "
                   "    ██║   ██╔══██║██╔══██╗██╔══██╗██║   ██║██║     ██║██║╚██╗██║██╔═══██╗╚═══██║ "
                   "    ██║   ██║  ██║██║  ██║██████╔╝╚██████╔╝███████╗██║██║ ╚████║╚██████╔╝█████╔╝ "
                   "    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚════╝  "
                   "                               ~~  Avra Kehdabra ~~                              "))

         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat line (make-string (max 0 (- longest-line (length line))) 32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(setq +doom-dashboard-ascii-banner-fn #'title)

; Aca remuevo algunos botones, ya sea porque no los uso o porque los abro de otra manera.
(assoc-delete-all "Reload last session" +doom-dashboard-menu-sections)
(assoc-delete-all "Open documentation" +doom-dashboard-menu-sections)
(assoc-delete-all "Open org-agenda" +doom-dashboard-menu-sections)

(setq doom-fallback-buffer-name "*dashboard*")

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Abrir dired" "d" #'dired
       :desc "Dired saltar al actual" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Vista previa de image peep-dired" "d p" #'peep-dired
        :desc "Dired ver archivo" "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file ; usar dired-find-file en vez de dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill
  (kbd "Z") 'dired-do-compress
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-do-kill-lines
  (kbd "% l") 'dired-downcase
  (kbd "% m") 'dired-mark-files-regexp
  (kbd "% u") 'dired-upcase
  (kbd "* %") 'dired-mark-files-regexp
  (kbd "* .") 'dired-mark-extension
  (kbd "* /") 'dired-mark-directories
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; Obtener iconos para dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; Con el plugin dired-open, podes lanzar programas externos para ciertas extensiones
;; Por ejemplo, todos los .png se abren en 'sxiv' y todos los .mp4 en 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(setq doom-theme 'doom-dracula)
(map! :leader
      :desc "Load new theme" "h t" #'counsel-load-theme)

(use-package emojify
  :hook (after-init . global-emojify-mode))

(map! :leader
      (:prefix ("e". "evaluate/ERC/EWW")
       :desc "Evaluar elisp en el buffer" "b" #'eval-buffer
       :desc "Evaluar defun" "d" #'eval-defun
       :desc "Evaluar expresion elisp" "e" #'eval-expression
       :desc "Evaluar ultima sexpression" "l" #'eval-last-sexp
       :desc "Evluar elisp en la region" "r" #'eval-region))

(setq doom-font (font-spec :family "JetBrains Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 14)
      doom-big-font (font-spec :family "JetBrains Mono" :size 24))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(defun dt/insert-todays-date (prefix)
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%A, %B %d, %Y")
                 ((equal prefix '(4)) "%m-%d-%Y")
                 ((equal prefix '(16)) "%Y-%m-%d"))))
    (insert (format-time-string format))))

(require 'calendar)
(defun dt/insert-any-date (date)
  "Insert DATE using the current locale."
  (interactive (list (calendar-read-date)))
  (insert (calendar-date-string date)))

(map! :leader
      (:prefix ("i d" . "Insertar fecha")
        :desc "Insertar cualquier fecha" "a" #'dt/insert-any-date
        :desc "Insertar fecha de hoy" "t" #'dt/insert-todays-date))

(setq ivy-posframe-display-functions-alist
      '((swiper                     . ivy-posframe-display-at-point)
        (complete-symbol            . ivy-posframe-display-at-point)
        (counsel-M-x                . ivy-display-function-fallback)
        (counsel-esh-history        . ivy-posframe-display-at-window-center)
        (counsel-describe-function  . ivy-display-function-fallback)
        (counsel-describe-variable  . ivy-display-function-fallback)
        (counsel-find-file          . ivy-display-function-fallback)
        (counsel-recentf            . ivy-display-function-fallback)
        (counsel-register           . ivy-posframe-display-at-frame-bottom-window-center)
        (dmenu                      . ivy-posframe-display-at-frame-top-center)
        (nil                        . ivy-posframe-display))
      ivy-posframe-height-alist
      '((swiper . 20)
        (dmenu . 20)
        (t . 10)))
(ivy-posframe-mode 1) ; 1 abilita posframe-mode, 0 lo desabilita.

(map! :leader
      (:prefix ("v" . "Ivy")
       :desc "Ivy empuje vista" "v p" #'ivy-push-view
       :desc "Ivy cambiar vista" "v s" #'ivy-switch-view))

(setq display-line-numbers-type 'relative)
(map! :leader
      :desc "Comentar o descomentar líneas" "TAB TAB" #'comment-line
      (:prefix ("t" . "alternar")
       :desc "Alternar numero de línea" "l" #'doom/toggle-line-numbers
       :desc "Alternar el resaltado de líneas en el marco actual" "h" #'hl-line-mode
       :desc "Alternar el resaltado de líneas globalmente" "H" #'global-hl-line-mode
       :desc "Alternar truncamiento de línea" "t" #'toggle-truncate-lines))

(setq minimap-window-location 'right)
(map! :leader
      (:prefix ("t" . "alternar")
       :desc "Alternar modo-minimapa" "m" #'minimap-mode))

(set-face-attribute 'mode-line nil :font "Ubuntu Mono-13")
(setq doom-modeline-height 30     ;; ajusta la altura de la linea de modos
      doom-modeline-bar-width 5   ;; ajusta el ancho de la barra derecha
      doom-modeline-persp-name t  ;; añade nombre perspectivo a la linea de modos
      doom-modeline-persp-icon t) ;; añade un icono de carpeta al lado del nombre persp

(xterm-mouse-mode 1)

(after! neotree
  (setq neo-smart-open t
        neo-window-fixed-size nil))
(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t))
(map! :leader
      :desc "Alternar neotree" "t n" #'neotree-toggle
      :desc "Abrir directorio en neotree" "d n" #'neotree-dir)

(map! :leader
      (:prefix ("=" . "abrir archivo")
       :desc "Editar archivo de agenda" "a" #'(lambda () (interactive) (find-file "~/Org/agenda.org"))
       :desc "Editar doom config.org" "c" #'(lambda () (interactive) (find-file "~/.doom.d/config.org"))
       :desc "Editar doom init.el" "i" #'(lambda () (interactive) (find-file "~/.doom.d/init.el"))
       :desc "Editar doom packages.el" "p" #'(lambda () (interactive) (find-file "~/.doom.d/packages.el"))))
(map! :leader
      (:prefix ("= e" . "abrir archivos de eshell")
       :desc "Editar aliases de eshell" "a" #'(lambda () (interactive) (find-file "~/.doom.d/eshell/aliases"))
       :desc "Editar perfil de eshell" "p" #'(lambda () (interactive) (find-file "~/.doom.d/eshell/profile"))))

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)
(after! org
  (setq org-directory "~/Org/"
        org-agenda-files '("~/Org/agenda.org")
        org-default-notes-file (expand-file-name "notas.org" org-directory)
        org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("❂" "❁" "❀" "✿" "✾" "✽" "✢")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; cambia los simbolos +/- en las listas de items
        org-log-done 'time
        org-hide-emphasis-markers t
        ;; ej. de org-link-abbrev-alist en accion
        ;; [[arch-wiki:Nombre_de_Pagina][Descripcion]]
        org-link-abbrev-alist    ; Esto sobrescribe el org-link-abbrev-list por defecto de DOOM
          '(("google" . "http://www.google.com/search?q=")
            ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
            ("ddg" . "https://duckduckgo.com/?q=")
            ("wiki" . "https://en.wikipedia.org/wiki/"))
        org-table-convert-region-max-lines 20000
        org-todo-keywords        ; Esto sobrescribe los valores por defecto de org-todo-keywords en DOOM
          '((sequence
             "TODO(t)"           ; Una tarea para completar
             "BLOG(b)"           ; Tarea de escritura de blog
             "GYM(g)"            ; Cosas para hacer en el gimnasio
             "PROJ(p)"           ; Un projecto que continene otras tareas
             "VIDEO(v)"          ; Tareas de video
             "WAIT(w)"           ; Algo esta retrasando la tarea
             "|"                 ; Simbolo necesario para separar estados "activos" de estados "inactivos"
             "DONE(d)"           ; La tarea ha sido completada
             "CANCELLED(c)" )))) ; La tarea ha sido cancelada

(use-package ox-man)
(use-package ox-gemini)

(setq org-journal-dir "~/Org/diario/"
      org-journal-date-prefix "* "
      org-journal-time-prefix "** "
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org")

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(define-globalized-minor-mode global-rainbow-mode rainbow-mode
  (lambda ()
    (when (not (memq major-mode
                (list 'org-agenda-mode)))
     (rainbow-mode 1))))
(global-rainbow-mode 1 )

(map! :leader
      (:prefix ("r" . "registros")
       :desc "Copiar al registro" "c" #'copy-to-register
       :desc "Frameset a registro" "f" #'frameset-to-register
       :desc "Insertar contenidos del registro" "i" #'insert-register
       :desc "Saltar a registro" "j" #'jump-to-register
       :desc "Listar registros" "l" #'list-registers
       :desc "Numero a registro" "n" #'number-to-register
       :desc "Elehjir interactivamente un registro" "r" #'counsel-register
       :desc "Ver un registro" "v" #'view-register
       :desc "Configuracion de ventana a registro" "w" #'window-configuration-to-register
       :desc "Incrementar registro" "+" #'increment-register
       :desc "Apuntar a registro" "SPC" #'point-to-register))

(setq shell-file-name "/bin/sh"
      vterm-max-scrollback 5000)
(setq eshell-rc-script "~/.doom.d/eshell/profile"
      eshell-aliases-file "~/.doom.d/eshell/aliases"
      eshell-history-size 5000
      eshell-buffer-maximum-lines 5000
      eshell-hist-ignoredups t
      eshell-scroll-to-bottom-on-input t
      eshell-destroy-buffer-when-process-dies t
      eshell-visual-commands'("zsh" "bash" "fish" "htop" "ssh" "top"))
(map! :leader
      :desc "Eshell" "e s" #'eshell
      :desc "Alternar eshell emergente" "e t" #'+eshell/toggle
      :desc "Historial eshell" "e h" #'counsel-esh-history
      :desc "Alternar vterm emergente" "v t" #'+vterm/toggle)

(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; bajar como se vaya necesitando
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clonar buffer indirecto otra ventana" "b c" #'clone-indirect-buffer-other-window)

(map! :leader
      (:prefix ("w" . "window")
       :desc "Winner rehacer" "<derecha>" #'winner-redo
       :desc "Winner deshacer" "<izquierda>" #'winner-undo))

(map! :leader
      :desc "Zap to char" "z" #'zap-to-char
      :desc "Zap up to char" "Z" #'zap-up-to-char)

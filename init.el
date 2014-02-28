;;kuanyui's ~/.emacs

(setq user-mail-address "azazabc123@gmail.com")
(setq user-full-name "kuanyui")

;;掃描~/.emacs.d目錄
(add-to-list 'load-path "~/.emacs.d/lisps")

;;Emacs24開始內建的package.el相關設定
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;;執行Shell外部程式的搜尋路徑(意同$PATH)
(setenv "PATH" (concat (getenv "PATH") ":"(getenv "HOME")"/.scripts/"))

(setq shell-file-name "/bin/zsh")
(setq shell-command-switch "-ic")

;;======================================================
;; GUI Emacs
;;======================================================

;;GUI Emacs調整字體大小
(defun sacha/increase-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (ceiling (* 1.10
                                  (face-attribute 'default :height))))
  (apply-font-setting))

(defun sacha/decrease-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (floor (* 0.9
								(face-attribute 'default :height))))
  (apply-font-setting))

;;　GUI版本下的中文字體問題
(defun apply-font-setting ()
  (interactive)
  (if (window-system)
      (progn
        (dolist (charset '(han kana symbol cjk-misc bopomofo))
          (set-fontset-font (frame-parameter nil 'font)
                            charset
                            (font-spec :family "文泉驛等寬微米黑" :size nil))))))

(if (window-system)
    (progn
      (set-face-attribute 'default nil :height 90)
      (apply-font-setting)))

(global-set-key (kbd "C-+") 'sacha/increase-font-size)
(global-set-key (kbd "C--") 'sacha/decrease-font-size)

;;======================================================
;; 基本設定
;;======================================================

;;超變態的undo-tree-mode
;;(提醒：redo會變成C-?)
;;C-x u 進入 undo-tree-visualizer-mode，t顯示時間戳。
(require 'undo-tree)
(global-undo-tree-mode)
(global-set-key (kbd"C-M-_") 'undo-tree-redo)

;;行號
(global-linum-mode t)
;; 已經有行號就不用modeline裡的行號
(setq line-number-mode nil)
(column-number-mode)

;; Highlight line number
(require 'hlinum)
(hlinum-activate)


;;當前行高亮顯示
;; (global-hl-line-mode 1)

;;在標題顯示文件名稱(%b)與路徑(%f)
(setq frame-title-format "%n%b (%f) - %F")
;;(setq frame-title-format '((:eval default-directory)))

;;把捲軸移到右側
(customize-set-variable 'scroll-bar-mode 'right)

;;======================================================
;; IBuffer
;;======================================================

;;啟用ibuffer
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

;; Let's group buffers with ibuffer!!!
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("Dired" (mode . dired-mode))
               ("Note" (or
						(name . "^diary$")
						(mode . markdown-mode)
						(mode . rst-mode)))
			   ("Web" (or
					   (mode . css-mode)
					   (mode . html-mode)
					   (mode . stylus-mode)
					   (mode . web-mode)
					   (mode . javascript-mode)
					   (name . "\\.yml$")))
			   ("Programming" (or
							   (mode . emacs-lisp-mode)
							   (mode . lisp-mode)))
               ("Org" (or
                       (mode . org-mode)
                       (name . "^\\*Calendar\\*$")))
			   ("IRC" (or
					   (mode . erc-mode)
					   (mode . rcirc-mode)))
			   ("Twitter" (mode . twittering-mode))
               ("Emacs" (or
                         (name . "^\\*scratch\\*$")
                         (name . "^\\*Messages\\*$")
						 (name . "^\\*Compile-Log\\*$")
                         (name . "^\\.emacs$")))
               ("Magit" (name . "*magit*"))
               ("Help" (or
                        (name . "\*Help\*")
                        (name . "\*Apropos\*")
                        (mode . "help")
                        (name . "\*info\*")))))))

;; auto update ibuffer
(add-hook 'ibuffer-mode-hook
		  '(lambda ()
			 (ibuffer-auto-mode 1)
			 (ibuffer-switch-to-saved-filter-groups "default")))

;; Do not show empty group
(setq ibuffer-show-empty-filter-groups nil)

;;讓Isearch不會再主動清除搜尋的高亮顯示
(setq lazy-highlight-cleanup nil)

;;======================================================
;; 插入時間
;;======================================================

;;我最愛的插入日期，格式為習慣的YYYY/mm/dd（星期），使用方法為C-c d
(defun my-insert-date ()
  (interactive)
  (cond
   ((equal current-prefix-arg nil)     ; universal-argument not called
    (insert (format-time-string "[%Y-%m-%d %a]" (current-time))))
   ((equal current-prefix-arg '(4))    ; C-u
    (insert (format-time-string "[%Y-%m-%d %a %H:%M]" (current-time))))
   ((equal current-prefix-arg 1)     ; C-u 1
    (insert (format-time-string "%Y/%m/%d（%a）" (current-time))))
))
(global-set-key (kbd "C-c d") 'my-insert-date)

;; 煩死了直接拿org-mode來用就好了。我幹麼自找麻煩啊真白痴。
(global-set-key (kbd "C-c !") 'org-time-stamp-inactive)

(defun display-prefix (arg)
  "Display the value of the raw prefix arg."
  (interactive "P")
  (message "%s" arg))

;;凸顯括號位置（而不是來回彈跳）
(show-paren-mode t)
;;(setq show-paren-style 'parentheses)
(setq show-paren-style 'expression) ;;另一種突顯方式(突顯整個括號範圍)

;; 隱藏沒在用的工具列
(tool-bar-mode -1)
;; 隱藏沒在用的選單
(menu-bar-mode -1)
;;X Clipboard在游標處插入，而不是滑鼠點擊的地方插入。
(setq mouse-yank-at-point t)

;;讓Emacs可以直接打開/顯示圖片。
(setq auto-image-file-mode t)

;;recents最近開啟的檔案，C-x C-r
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 35)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
;;(run-with-timer 0 (* 10 60) 'recentf-save-list)

;;同名檔案不混淆（同名檔案同時開啟時，會在buffer加上目錄名稱）
(require 'uniquify)
(setq
 uniquify-buffer-name-style 'post-forward
 uniquify-separator ":")

;;換掉歡迎畫面的難看GNU Logo
;;(setq  fancy-splash-image "~/.emacs.d/icon.png")
;;完全隱藏歡迎畫面
(setq inhibit-splash-screen t)

;;自動啟動flyspell-mode拼字檢查
;;(setq-default flyspell-mode t)
;;flyspell-prog-mode是為程式設計師的輔模式，Emacs将只在注释和字符串里高亮错误的拼写。
;;(setq-default flyspell-prog-mode t)
(global-set-key (kbd "C-x <f3>") 'flyspell-mode)
(global-set-key (kbd "C-c <f3>") 'flyspell-buffer)
(global-set-key (kbd "<f3>") 'flyspell-check-previous-highlighted-word)
(global-set-key (kbd "C-x <f4>") 'ispell-buffer)
(global-set-key (kbd "<f4>") 'ispell-word) ;;M-$，有夠難記，很容易跟query-replace的M-%搞混

;; aspell
(setq ispell-program-name "aspell"
	  ispell-extra-args '("--sug-mode=ultra"))
(setq ispell-dictionary "american")


;;靠近螢幕邊緣三行時就開始捲動，比較容易看上下文
(setq scroll-margin 3)

;;關閉煩人的錯誤提示音，改為在螢幕上提醒。
(setq visible-bell t)

;;超大kill-ring. 防止不小心删掉重要的東西。
(setq kill-ring-max 200)

;;设置tab为4个空格的宽度
(setq default-tab-width 4)

;;Tab改為插入空格
;;abs look fine on a terminal or with ordinary printing, but they produce badly indented output when you use TeX or Texinfo since TeX ignores tabs.
(setq standard-indent 4)
(setq-default indent-tabs-mode nil)

;;每次修改文件自動更新Time-stamp
;;将time-stamp加入write-file-hooks，就能在每次保存文件时自动更新time-stamp
(add-hook 'write-file-hooks 'time-stamp)
(setq time-stamp-format
      "此文件最後是在%04y-%02m-%02d %02H:%02M:%02S由%:u修改"
      time-stamp-active t
      time-stamp-warn-inactive t)

;;======================================================
;; Markdown
;;======================================================

(require 'markdown-mode)
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown\\'" . markdown-mode))

(setq markdown-enable-math t)
(setq markdown-command "/usr/lib/node_modules/marked/bin/marked")

;; [FIXME] 把markdown的outline搞得跟org-mode的key-binding接近一點

;;======================================================
;; Org-mode
;;======================================================
;; 不要安裝最新版org-mode，export 一堆問題
;; (add-to-list 'load-path "~/.emacs.d/lisps/org-mode/lisp/")
;; (add-to-list 'load-path "~/.emacs.d/lisps/org-8.2.3c/lisp/")
(require 'org-install)
(require 'org)
(require 'ox)
(require 'ob)
(setq org-directory "~/org")

;;解决org-mode下中文不自动换行的问题
(add-hook 'org-mode-hook
		  (lambda () (setq truncate-lines nil)))

;;org-mode裡的項目變成done時會自動加上CLOSED: [timestamp]戳記；改成'note為筆記
(setq org-log-done 'time)
;;(setq org-log-done 'note)
(defun org-insert-bold ()
  "Insert *bold* at cursor point."
  (interactive)
  (insert " ** ")
  (backward-char 2))
(define-key org-mode-map (kbd "C-c b") 'org-insert-bold)

(defun org-insert-blockquote ()
  "Insert *bold* at cursor point."
  (interactive)
  (move-end-of-line 1)(newline 2)(insert "#+BEGIN_QUOTE")(newline 2)(insert "#+END_QUOTE")(previous-line 1))
(define-key org-mode-map (kbd "C-c i q") 'org-insert-blockquote)

(defun org-insert-center-block ()
  "Insert *bold* at cursor point."
  (interactive)
  (move-end-of-line 1)(newline 2)(insert "#+BEGIN_CENTER")(newline 2)(insert "#+END_CENTER")(previous-line 1))
(define-key org-mode-map (kbd "C-c i c") 'org-insert-center-block)


(defun org-insert-image ()
  "Insert image in org-mode"
  (interactive)
  (let* ((insert-default-directory nil))
	(insert-string (concat "[[file:" (read-file-name "Enter the image file ") "]]"))))
(define-key org-mode-map (kbd "C-c i i") 'org-insert-image)


;;(setq org-export-default-language "zh"
;;      org-export-html-extension "html"
;;      org-export-with-timestamps nil
;;      org-export-with-section-numbers t
;;      org-export-with-tags 'not-in-toc
;;      org-export-skip-text-before-1st-heading nil
;;      org-export-with-sub-superscripts '{}
;;      org-export-with-LaTeX-fragments t
;;      org-export-with-archived-trees nil
;;      org-export-highlight-first-table-line t
;;      org-export-latex-listings-w-names nil
;;      org-html-head-include-default-style nil
;;      org-html-head ""
;;      org-export-htmlize-output-type 'css
;;      org-startup-folded nil
;;      org-export-allow-BIND t
;;      org-publish-list-skipped-files t
;;      org-publish-use-timestamps-flag t
;;      org-export-babel-evaluate nil
;;      org-confirm-babel-evaluate nil)

;;輸出上下標？
;;(setq org-export-with-sub-superscripts nil)

(setq org-file-apps '((auto-mode . emacs)
                      ("\\.mm\\'" . default)
                      ("\\.x?html?\\'" . "xdg-open %s")
                      ("\\.pdf\\'" . default)))
;; Syntax Highlight in outputed files
(setq org-src-fontify-natively t)

(setq org-html-style "<style type=\"text/css\">
* {
    font-family:WenQuanYi Micro Hei,Microsoft JhengHei,Helvetica,sans-serif;
    color: #555555;
    }

body {
    text-align: center;
    background-color: hsl(45,30%,80%);
    background-image:
    repeating-linear-gradient(120deg, rgba(255,255,255,.1), rgba(255,255,255,.1) 2px, transparent 1px, transparent 60px),
    repeating-linear-gradient(60deg, rgba(255,255,255,.1), rgba(255,255,255,.1) 2px, transparent 1px, transparent 60px),
    linear-gradient(60deg, rgba(0,0,0,.06) 25%, transparent 25%, transparent 75%, rgba(0,0,0,.06) 75%, rgba(0,0,0,.06)),
    linear-gradient(120deg, rgba(0,0,0,.06) 25%, transparent 25%, transparent 75%, rgba(0,0,0,.06) 75%, rgba(0,0,0,.06));
    background-size: 70px 120px;
}

#content {
    margin: 0px auto;
    width: 800px;
    text-align:left;
    background-color: rgba(255, 255, 255, 1);
    border-radius: 7px 7px 0 0;
    box-shadow: 0 0 0.5em rgba(0,0,0,0.2);
    padding-bottom: 30px;
}

#postamble {
    position: relative;
    z-index: 1;
    font-size:0.8em;
    color: #ffffff !important;
    background-color: #555555 !important;
    margin: -1.2em auto 0;
    width: 780px;
    background-color: #ffffff;
    border-radius: 0 0 7px 7px;
    padding: 30px 10px 10px 10px;
    box-shadow: 0 0 0.5em rgba(0,0,0,0.2);
    text-shadow: 0px -1px rgba(0, 0, 0, 0.3);

    background-color: #828282;
    background-image: radial-gradient(#707070 50%, transparent 51%);
    background-size: 4px 4px;
}
#postamble p {
    margin: 0;
    color: #eeeeee !important;
}

#postamble a {
    color: #5fafd7;
}

#table-of-contents {
    margin: 0 30px;
    padding: 0 15px 10px 15px;
    border-top: 4px solid #D4DDE0;
    border-bottom: 4px solid #D4DDE0;
    background-color: #E9EEF1;
    text-shadow: 0 1px 0 hsl(202,100%,100%);
}

#table-of-contents h2 {
    color: hsl(202,40%,52%);
    text-shadow: 0 1px 0 hsl(202,100%,100%);
    border-left: none;
    margin-left: 0;
    padding-left: 0;
}
a {
    color: #005f87;
    text-decoration: none;
}

a:hover {
    color: #005f87;
    text-decoration: underline;
}

h1 {
    color: #eeeeee;
    text-shadow: 0px -1px rgba(0, 0, 0, 0.5);
    font-family: Lato,Lucida Grande,LiHei Pro,WenQuanYi Micro Hei,Arial,sans-serif;
    font-weight: 400;
    margin-top: 0px;
    padding: 20px 0 10px 0;
    background-color: #828282;
    background-image: radial-gradient(#707070 50%, transparent 51%);
    background-size: 4px 4px;
    border-radius: 7px 7px 0 0;
}
h2 {
    color: #777;
    border-left: 5px solid #777;
    margin-left: -30px;
    padding-left: 25px;
}

.outline-2 { padding: 0px 30px; }
.outline-3 { padding: 0px 30px; }

.outline-text-2 { padding: 0px 0px; }
.outline-text-3 { padding: 0px 0px; }
.example { }
pre {
    border: 1pt solid #ddd;
    background-color: #f2f2f2;
    box-shadow: 0 0 1em rgba(0,0,0,0.05);
    border-radius:5px;
    padding: 5pt;
    font-family: courier, monospace;
    font-size: 90%;
    overflow:auto;
    margin: 0.5em 2em;
}

pre.src:before {
    background-color: rgba(0, 0, 0, 0.5);
    color: #fff;
    border-radius: 5px;
    border: none;
    top: -10px;
    right: 10px;
    padding: 3px 7px;
    position: absolute;
}

code {
    border: 1pt solid #ddd;
    background-color: #eee;
    padding: 0 3px;
    border-radius: 3px;
    position: relative;
    margin-top: -3px;
    font-family: courier, monospace;
    font-size: 80%;
}

blockquote {
    font-style:italic;
    background: hsl(44,80%,95%);
    border-left: 5px solid hsl(44,25%,70%);
    margin: 1.5em 2em;
    padding: 0.5em 10px 0.5em 4em;
    quotes: '\\201C''\\201D''\\2018''\\2019';
}
blockquote:before {
    color: #ccc;
    position: absolute;
    margin-top: -0.1em;
    margin-left: -1.3em;
    color: hsl(44,25%,85%);
    font-size: 5em;
    content: '\\201C' !important;
}
blockquote p {
    display: inline;
    font-family:'Times New Roman', Times, serif !important;
}
blockquote p a {
    font-family:'Times New Roman', Times, serif !important;
      }

.done {
    background-color: #d7ff87;
    color: #008700;
    border: 1px solid #5faf00;
    border-radius: 3px;
    padding:0px 2px;
    top: -1px;
    position: relative;
    font-family:WenQuanYi Micro Hei,Microsoft JhengHei,Helvetica,sans-serif;
    font-weight: bold;
    font-size:0.8em;
}
.todo {
    background-color: #ffafaf;
    color: #a40000;
    border: 1px solid #dd0000;
    border-radius: 3px;
    padding:0px 2px;
    top: -1px;
    position: relative;
    font-family:WenQuanYi Micro Hei,Microsoft JhengHei,Helvetica,sans-serif;
    font-weight: bold;
    font-size:0.8em;
}
.tag { float:right; color:red; }

</style>")

;;(add-function :override org-html-checkbox 
;;(defun org-html-checkbox (checkbox)
;;  "Format CHECKBOX into HTML."
;;  (case checkbox (on "<code>[X]</code>")
;;	(off "<code>[&#xa0;]</code>")
;;	(trans "<code>[-]</code>")
;;	(t "")))


;;org輸出html時中文不要有奇怪的空白。（by coldnew the God）
(defadvice org-html-paragraph (before org-html-paragraph-advice
                                      (paragraph contents info) activate)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to html."
  (let* ((origin-contents (ad-get-arg 1))
         (fix-regexp "[[:multibyte:]]")
         (fixed-contents
          (replace-regexp-in-string
           (concat
            "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)") "\\1\\2" origin-contents)))

    (ad-set-arg 1 fixed-contents)))

;; 指定agenda檔案位置清單
(setq org-agenda-files (list (concat org-directory "/todo.org")))
(global-set-key "\C-ca" 'org-agenda)

;; 啊啊啊啊Agenda自訂
;; shortcut可以一個字母以上
(setq org-agenda-custom-commands
      '(
        ("w" todo "STARTED") ;; (1) (3) (4)
        ;; ...other commands here

        ("D" "Daily Action List"
         ((agenda "" ((org-agenda-ndays 1)
                      (org-agenda-sorting-strategy
                       (quote ((agenda time-up priority-down tag-up) )))
                      (org-deadline-warning-days 0)
                      ))))

        ("P" "Projects"
         ((tags "Project")))

        ("W" "Weekly Review"
         ((agenda "" ((org-agenda-ndays 7)
                      (org-deadline-warning-days 45))) ;; review upcoming deadlines and appointments
          ;; type "l" in the agenda to review logged items
          (stuck "") ;; review stuck projects as designated by org-stuck-projects
          (todo "PROJECT") ;; review all projects (assuming you use todo keywords to designate projects)
          (todo "MAYBE") ;; review someday/maybe items
          (todo "WAITING"))) ;; review waiting items
        ;; ...other commands here

        ("d" "Upcoming deadlines" agenda ""
         ((org-agenda-entry-types '(:deadline))
          ;; a slower way to do the same thing
          ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'notdeadline))
          (org-agenda-ndays 1)
          (org-deadline-warning-days 60)
          (org-agenda-time-grid nil)))
        ;; ...other commands here

        ("c" "Weekly schedule" agenda ""
         ((org-agenda-ndays 7)          ;; agenda will start in week view
          (org-agenda-repeating-timestamp-show-all t)   ;; ensures that repeating events appear on all relevant dates
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))
        ;; limits agenda view to timestamped items
        ;; ...other commands here

        ("P" "Printed agenda"
         ((agenda "" ((org-agenda-ndays 7)                      ;; overview of appointments
                      (org-agenda-start-on-weekday nil)         ;; calendar begins today
                      (org-agenda-repeating-timestamp-show-all t)
                      (org-agenda-entry-types '(:timestamp :sexp))))
          (agenda "" ((org-agenda-ndays 1)                      ;; daily agenda
                      (org-deadline-warning-days 7)             ;; 7 day advanced warning for deadlines
                      (org-agenda-todo-keyword-format "[ ]")
                      (org-agenda-scheduled-leaders '("" ""))
                      (org-agenda-prefix-format "%t%s")))
          (todo "TODO"                                          ;; todos sorted by context
                ((org-agenda-prefix-format "[ ] %T: ")
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "")
                 (org-agenda-overriding-header "\nTasks by Context\n------------------\n"))))
         ((org-agenda-with-colors nil)
          (org-agenda-compact-blocks t)
          (org-agenda-remove-tags t)
          (ps-number-of-columns 2)
          (ps-landscape-mode t))
         ("~/agenda.ps"))
        ;; other commands go here
        ))

;;To save the clock history across Emacs sessions, use

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
;; Use a drawer to place clocking info
(setq org-clock-into-drawer t)
;; Global clocking key
(global-set-key (kbd "C-c C-x C-x") 'org-clock-in-last)
(global-set-key (kbd "C-c C-x C-i") 'org-clock-in)
(global-set-key (kbd "C-c C-x C-o") 'org-clock-out)

                                        ;Now that OrgMode and RememberMode are included in Emacs (as of Emacs 23), activation is as simple as:
;;(org-remember-insinuate)
;;This excellent feature inspired Capture in OrgMode and that is now (Aug2010) recommended for new users, see http://orgmode.org/manual/Capture.html#Capture

;;Org-Capture
(setq org-default-notes-file (concat org-directory "/notes.org"))

(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline (concat org-directory "/todo.org") "Tasks")
         "** TODO %?\n  %i")
        ("b" "Buy" entry (file+headline (concat org-directory "/todo.org") "Buy")
         "** TODO %?\n  %i")
        ("r" "Reading" entry (file+headline (concat org-directory "/todo.org") "Reading")
         "** %? %i :Reading:")
        ("d" "Diary" entry (file+datetree (concat org-directory "/diary/diary.org")
                                          "* %?\n %i"))))

;; capture jump to link
(define-key global-map "\C-cx"
  (lambda () (interactive) (org-capture nil "x")))

;; used by org-clock-sum-today-by-tags
(defun filter-by-tags ()
  (let ((head-tags (org-get-tags-at)))
    (member current-tag head-tags)))

;; 每日時間統計
;; http://www.mastermindcn.com/2012/02/org_mode_quite_a_life/
(defun org-clock-sum-today-by-tags (timerange &optional tstart tend noinsert)
  (interactive "P")
  (let* ((timerange-numeric-value (prefix-numeric-value timerange))
         (files (org-add-archive-files (org-agenda-files)))
         (include-tags '("ACADEMIC" "ENGLISH" "SCHOOL"
                         "LEARNING" "OUTPUT" "OTHER"))
         (tags-time-alist (mapcar (lambda (tag) `(,tag . 0)) include-tags))
         (output-string "")
         (tstart (or tstart
                     (and timerange (equal timerange-numeric-value 4) (- (org-time-today) 86400))
                     (and timerange (equal timerange-numeric-value 16) (org-read-date nil nil nil "Start Date/Time:"))
                     (org-time-today)))
         (tend (or tend
                   (and timerange (equal timerange-numeric-value 16) (org-read-date nil nil nil "End Date/Time:"))
                   (+ tstart 86400)))
         h m file item prompt donesomething)
    (while (setq file (pop files))
      (setq org-agenda-buffer (if (file-exists-p file)
                                  (org-get-agenda-file-buffer file)
                                (error "No such file %s" file)))
      (with-current-buffer org-agenda-buffer
        (dolist (current-tag include-tags)
          (org-clock-sum tstart tend 'filter-by-tags)
          (setcdr (assoc current-tag tags-time-alist)
                  (+ org-clock-file-total-minutes (cdr (assoc current-tag tags-time-alist)))))))
    (while (setq item (pop tags-time-alist))
      (unless (equal (cdr item) 0)
        (setq donesomething t)
        (setq h (/ (cdr item) 60)
              m (- (cdr item) (* 60 h)))
        (setq output-string (concat output-string (format "[-%s-] %.2d:%.2d\n" (car item) h m)))))
    (unless donesomething
      (setq output-string (concat output-string "[-Nothing-] Done nothing!!!\n")))
    (unless noinsert
      (insert output-string))
    output-string))

(define-key org-mode-map (kbd "C-c C-x t") 'org-clock-sum-today-by-tags)

;;快速插入自訂org export template
(define-skeleton org-export-skeleton
  "Inserts my org export skeleton into current buffer.
    This only makes sense for empty buffers."
  "Title: "
  "#+TITLE:     " str | " *** Title *** " " " \n
  "#+AUTHOR:    "(getenv "USER")" " \n
  "#+EMAIL:     user-mail-address" \n
  "#+DATE:      "(insert (format-time-string "%Y/%m/%d（%a）%H:%M" )) \n
  "#+DESCRIPTION:" \n
  "#+KEYWORDS:" \n
  "#+LANGUAGE:  zh" \n
  "#+OPTIONS:   H:3 num:nil toc:nil \\n:t @:t ::t |:t ^:t -:t f:t *:t <:t" \n
  "#+OPTIONS:   TeX:t LaTeX:t skip:nil d:nil todo:t pri:nil tags:not-in-toc" \n
  "#+INFOJS_OPT: view:nil toc:nil ltoc:t mouse:underline buttons:0 path:http://orgmode.org/org-info.js" \n
  "#+EXPORT_SELECT_TAGS: export" \n
  "#+EXPORT_EXCLUDE_TAGS: noexport" \n
  "#+LINK_UP:   " \n
  "#+LINK_HOME: " \n
  "#+XSLT:" \n
  )
(global-set-key (kbd "C-c i t") 'org-export-skeleton)

;;======================================================
;; shell-script-mode
;;======================================================

;;較完整地支援shell script語法高亮。
(defface font-lock-system-command-face
  '((((class color)) (:foreground "purple")))
  "I am comment"
  :group 'font-lock-faces)

(defun font-lock-system-command (&optional limit)
  ""
  (and (search-forward-regexp "\\<[a-zA-Z\\-]+\\>" limit t)
       (executable-find
        (buffer-substring-no-properties (car (bounds-of-thing-at-point 'word))
                                        (cdr (bounds-of-thing-at-point 'word))))))

(font-lock-add-keywords 'sh-mode
                        '((font-lock-system-command . 'font-lock-system-command-face)))

;;Emacs內建的自動補完hippie-expand
(global-set-key [(meta ?/)] 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev                 ; 搜索当前 buffer
        try-expand-dabbrev-visible         ; 搜索当前可见窗口
        try-expand-dabbrev-all-buffers     ; 搜索所有 buffer
        try-expand-dabbrev-from-kill       ; 从 kill-ring 中搜索
        try-complete-file-name-partially   ; 文件名部分匹配
        try-complete-file-name             ; 文件名匹配
        try-expand-all-abbrevs             ; 匹配所有缩写词
        try-expand-list                    ; 补全一个列表
        try-expand-line                    ; 补全当前行
        try-complete-lisp-symbol-partially ; 部分补全 elisp symbol
        try-complete-lisp-symbol))         ; 补全 lisp symbol

(load "~/.emacs.d/lisps/complete-with-calc.el")

;;補全另一選擇company-mode
;;(add-to-list 'load-path "~/.emacs.d/lisps/company")
;;(autoload 'company-mode "company" nil t)
;;(company-mode 1)

;;popup-kill-ring
(add-to-list 'load-path "~/.emacs.d/lisps/popup-kill-ring/")
;;(require 'popup)
(require 'pos-tip)
(require 'popup-kill-ring)
(global-set-key "\M-y" 'popup-kill-ring)

;;Twittering-mode:用Emacs上Twitter
(add-to-list 'load-path "~/.emacs.d/lisps/twittering-mode/")
(require 'twittering-mode)
(setq twittering-use-master-password t) ;;This requires GnuPG. And also, either EasyPG or alpaca.el (0.13) is necessary.
(twittering-enable-unread-status-notifier) ;;顯示未讀訊息數
;;(setq-default twittering-icon-mode t) ;;預設顯示頭像

;;開啟自己的favorite timeline
(defun my-twittering-favorites-timeline ()
  (interactive)
  (twittering-visit-timeline ":favorites"))

;;(defun twittering-mode-hook-func ()
;;  (set-face-bold-p 'twittering-username-face t)
;;  (set-face-foreground 'twittering-username-face "SkyBlue3"))
;;(add-hook 'twittering-mode-hook 'twittering-mode-hook-func)

(define-key twittering-mode-map (kbd "R") 'twittering-replies-timeline)
(define-key twittering-mode-map (kbd "U") 'twittering-user-timeline)
(define-key twittering-mode-map (kbd "W") 'twittering-update-status-interactive)
(define-key twittering-mode-map (kbd "O") 'twittering-organic-retweet)
(define-key twittering-mode-map (kbd "N") 'twittering-native-retweet)
(define-key twittering-mode-map (kbd "H") 'twittering-home-timeline)
(define-key twittering-mode-map (kbd "F") 'twittering-favorite)
(define-key twittering-mode-map (kbd "V") 'twittering-visit-timeline)
(define-key twittering-mode-map (kbd "M") 'my-twittering-favorites-timeline)
(define-key twittering-mode-map (kbd "M-w") 'twittering-push-tweet-onto-kill-ring)
(define-key twittering-mode-map (kbd "C-w") 'twittering-push-uri-onto-kill-ring)
(define-key twittering-mode-map (kbd "D") 'twittering-direct-messages-timeline)

;;讓twittering-status-buffer支援換行
(setq twittering-status-format
      "%i %s,%p %@:
%FOLD[  ]{%T // from %f%L%r%R}
 ")

(setq twittering-retweet-format
      '(nil _ " RT: %t (via @%s)")
      )

;; [FIXME] twittering-update-status沒有hook可用，看看要不要自己定義一個發推用function，可以把發出的推也一起加入diary.org的結尾。

;;類似pentadactyl按[f]後輸入數字開啟連結
(autoload 'twittering-numbering "twittering-numbering" nil t)
(add-hook 'twittering-mode-hook 'twittering-numbering)

;;;; Filtering for Tweets
(defvar twittering-filter-users '()
  "*List of strings containing usernames (without '@' prefix) whose tweets should not be displayed in timeline.")
(defvar twittering-filter-tweets '()
  "*List of strings containing phrases which will prevent a tweet containing one of those phrases from being displayed in timeline.")

(defun twittering-filters-apply ()
  (setq non-matching-statuses '())
  (dolist (status twittering-new-tweets-statuses)
    (setq matched-tweets 0)
    (dolist (pat twittering-filter-users)
      (if (string-match pat (cdr (assoc 'user-screen-name status)))
          (setq matched-tweets (+ 1 matched-tweets))))
    (dolist (pat twittering-filter-tweets)
      (if (string-match pat (twittering-make-fontified-tweet-text-with-entity status))
          (setq matched-tweets (+ 1 matched-tweets))))
    (if (= 0 matched-tweets)
        (setq non-matching-statuses (append non-matching-statuses `(,status)))))
  (setq new-statuses non-matching-statuses))

(add-hook 'twittering-new-tweets-hook 'twittering-filters-apply)

(setq twittering-filter-tweets '("http://4sq.com/.*" "http://adf.ly/.*" "I liked a @YouTube video" "我喜歡一部 .*@YouTube 影片" "爆卦" "中時" "郭董" "nikeplus" "采潔" ))

(load-file "~/.emacs.d/private/twittering-filter-users.el")

;;高亮特定使用者，但搞不出來先擺著。
;;(defface twittering-star-username-face
;;  `((t (:underline t :foreground "a40000" :background "#ffaf87"))) "" :group 'faces)
;;
;;(font-lock-add-keywords 'twittering-mode
;;                        '(("jserv" 0 'twittering-star-username-face)))
;;
;;(defface twittering-keyword-face
;;  `((t (:underline t :foreground "a40000"))) "" :group 'faces)
;;
;;(font-lock-add-keywords 'twittering-mode
;;                        '(("keyword" 0 'twittering-keyword-face)))


;;(assq 'text (twittering-find-status (twittering-get-id-at)))

(load-file "~/.emacs.d/git/twittering-myfav/twittering-myfav.el")
(require 'twittering-myfav)
(setq twittering-myfav-file-name "twittering_myfav") ; The org and html file's name.
(setq twittering-myfav-file-path "~/Dropbox/Blog/kuanyui.github.io/source/") ; remember "/" in the end
(setq twittering-myfav-your-username "azazabc123") ; without "@"
(define-key twittering-mode-map (kbd "A") 'twittering-myfav-add-to-file)

(defun twittering-myfav-export-to-hexo ()
  (interactive)
  (twittering-myfav-export-to-html)
  (write-file "~/Dropbox/Blog/kuanyui.github.io/source/twittering_myfav.html" nil)
  (goto-char (point-min))
  (insert "layout: false\n---\n\n")
  (save-buffer))


(global-set-key (kbd "<f9>") 'open-note)
(defun open-note ()
  "Open stick note."
  (interactive)(find-file (concat org-directory "/notes.org")))

(global-set-key (kbd "C-x <f9>") 'open-computer-notes)
(defun open-computer-notes ()
  "open-computer-notes"
  (interactive)(find-file (concat org-directory "/computer_notes.org")))

(global-set-key (kbd "<f10>") 'open-todo)
(defun open-todo ()
  "Open todo list."
  (interactive)(find-file (concat org-directory "/todo.org")))

(global-set-key (kbd "C-x <f10>") 'open-nihongo-note)
(defun open-nihongo-note ()
  "Open nihongo note."
  (interactive)(find-file (concat org-directory "/日本語のノート.org")))

(global-set-key (kbd "C-x <f11>") 'open-diary)
(defun open-diary ()
  "Open diary."
  (interactive)(find-file (concat org-directory "/diary/diary.org")))

(global-set-key (kbd "<f11>") 'open-material-notes)
(defun open-material-notes ()
  "Open material notes."
  (interactive)(find-file (concat org-directory "/materials.org")))

(global-set-key [(f12)] 'twit)

(defun open-blog-dir ()
  (interactive)(find-file "~/Dropbox/Blog"))
(global-set-key (kbd "C-x <f12>") 'open-blog-dir)

;; StarDict for Emacs
;; author: pluskid
;; 调用 stardict 的命令行接口来查辞典，如果选中了 region 就查询 region 的内容，否则就查询当前光标所在的词
(global-set-key (kbd "C-c k") 'kid-star-dict)
(defun kid-star-dict ()
  (interactive)
  (let ((begin (point-min))
		(end (point-max)))
    (if mark-active
		(setq begin (region-beginning)
			  end (region-end))
	  (save-excursion
		(backward-word)
		(mark-word)
		(setq begin (region-beginning)
			  end (region-end))))
    ;; 有时候 stardict 会很慢，所以在回显区显示一点东西
    ;; 以免觉得 Emacs 在干什么其他奇怪的事情。
    (message "searching for %s ..." (buffer-substring begin end))
    (popup-tip
     (shell-command-to-string
      (concat "sdcv -n "
			  (buffer-substring begin end))))))


;; Stardict in Emacs
;; (require 'sdcv-mode)
;; (global-set-key (kbd "C-c s") 'sdcv-search)

;;======================================================
;; Tmux 相關設定
;;======================================================

(global-set-key (kbd "<f1>") 'kmacro-start-macro-or-insert-counter)
(global-set-key (kbd "<f2>") 'kmacro-end-or-call-macro)
(defun zsh () (interactive) (term "/bin/zsh"))

;;解決tmux下無法切換buffer以及一些key-binding的問題
(global-set-key (kbd "C-x M-[ d") 'previous-buffer)
(global-set-key (kbd "C-x M-[ c") 'next-buffer)
(global-set-key (kbd "M-[ c") 'forward-word)
(global-set-key (kbd "M-[ d") 'backward-word)
(global-set-key (kbd "C-c M-[ d") 'backward-sexp)
(global-set-key (kbd "C-c M-[ c") 'forward-sexp)
(global-set-key (kbd "C-c M-[ a") 'backward-up-list)
(global-set-key (kbd "C-c M-[ b") 'down-list)

;;下面這幾個原本的binding不好按或者會跟kwin衝。
(global-set-key (kbd "C-c <C-left>") 'backward-sexp)
(global-set-key (kbd "C-c <C-right>") 'forward-sexp)
(global-set-key (kbd "C-c <C-up>") 'backward-up-list)
(global-set-key (kbd "C-c <C-down>") 'down-list)

(global-set-key (kbd "C-c C-e") 'eval-buffer) ;;這樣測試.emacs方便多了...

;;Linux下與其他Applications的剪貼簿
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
;; [FIXME] 這不知是啥
;;(load-file "~/.emacs.d/lisps/copypaste.el")
(defun cp ()
  (interactive)
  (if (region-active-p)
	  (progn
        (shell-command-on-region (region-beginning) (region-end) "xsel -i")
		(message "Yanked region to clipboard!")
		(deactivate-mark))
	(message "No region active; can't yank to clipboard!")))

;; xclip-mode
(load "~/.emacs.d/lisps/xclip-1.0.el")
(define-minor-mode xclip-mode
  "Minor mode to use the `xclip' program to copy&paste."
  :global t
  (if xclip-mode
      (turn-on-xclip)
    (turn-off-xclip)))
(xclip-mode t)

;;======================================================
;; misc 雜項
;;======================================================

;; 統計中英日文字數
(defvar wc-regexp-chinese-char-and-punc
      (rx (category chinese)))
(defvar wc-regexp-chinese-punc
     "[。，！？；：「」『』（）、【】《》〈〉—]")
(defvar wc-regexp-english-word
      "[a-zA-Z0-9-]+")
(defun wc ()
  "「較精確地」統計中/日/英文字數。
- 平假名與片假名亦包含在「中日文字數」內，每個平/片假名都算單獨一個字（但片假
  名不含連音「ー」）。
- 英文只計算「單字數」，不含標點。
- 韓文不包含在內。

※計算標準太多種了，例如英文標點是否算入、以及可能有不太常用的標點符號沒算入等
。且中日文標點的計算標準要看 Emacs 如何定義特殊標點符號如ヴァランタン・アルカン
中間的點也被 Emacs 算為一個字而不是標點符號。"
  (interactive)
  (let ((chinese-char-and-punc 0)
        (chinese-punc 0)
        (english-word 0)
        (chinese-char 0))
    (save-excursion
      ;; 中文（含標點、片假名）
      (goto-char (point-min))
      (while (re-search-forward wc-regexp-chinese-char-and-punc nil :no-error)
        (setq chinese-char-and-punc (1+ chinese-char-and-punc)))
      ;; 中文標點符號
      (goto-char (point-min))
      (while (re-search-forward wc-regexp-chinese-punc nil :no-error)
        (setq chinese-punc (1+ chinese-punc)))
      ;; 英文字數（不含標點）
      (goto-char (point-min))
      (while (re-search-forward wc-regexp-english-word nil :no-error)
        (setq english-word (1+ english-word))))
    (setq chinese-char (- chinese-char-and-punc chinese-punc))
    (message
     (format "中日文字數（不含標點）：%s
中日文字數（包含標點）：%s
英文字數（不含標點）：%s
=======================
中英文合計（不含標點）：%s"
            chinese-char chinese-char-and-punc english-word
            (+ chinese-char english-word)))))


;;emacs內建書籤存檔
(setq bookmark-save-flag 1)

;;靠杯，連這都要自己設定會不會太蠢了?
(setq snake-score-file
	  "~/.emacs.d/snake-scores")

;; helm-mode(前anything.el)
;;(add-to-list 'load-path "~/.emacs.d/lisps/helm")
;;(require 'helm-config)
;;(helm-mode)
;;(global-set-key (kbd "C-x C-f") 'helm-find-files)
;;(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
;;(global-set-key (kbd "C-c C-f") 'helm-for-files)
;;(global-set-key (kbd "M-x") 'helm-M-x)

;;======================================================
;; Frames 操作加強
;;======================================================
;; smart-window.el
(add-to-list 'load-path "~/.emacs.d/lisps/smart-window/")
(require 'smart-window)
;;(setq smart-window-remap-keys 0)
(global-set-key (kbd "C-x w") 'smart-window-move)
(global-set-key (kbd "C-x W") 'smart-window-buffer-split)
(global-set-key (kbd "C-x M-w") 'smart-window-file-split)
(global-set-key (kbd "C-x R") 'smart-window-rotate)
(global-set-key (kbd "C-x 2") 'sw-below)
(global-set-key (kbd "C-x 3") 'sw-right)

;;switch frames in a visual way (C-x o)
(require 'switch-window)

;;一個簡單的minor-mode，用來調整frame大小
;;(define-minor-mode resize-frame
;;  "A simple minor mode to resize-frame.
;;C-c C-c to apply."
;;  ;; The initial value.
;;  :init-value nil
;;  ;; The indicator for the mode line.
;;  :lighter " ResizeFrame"
;;  ;; The minor mode bindings.
;;  :keymap
;;  `(([up] . enlarge-window)
;;    ([down] . shrink-window)
;;    ([right] . enlarge-window-horizontally)
;;    ([left] . shrink-window-horizontally)
;;    ("\C-c\C-c" . (lambda ()
;;                         (interactive)
;;                         (setq resize-frame nil)
;;                         (message "Done."))))
;;  :global t)
;;(global-set-key (kbd "C-x <f5>") 'resize-frame)

;;======================================================
;; Theme
;;======================================================

(add-to-list 'custom-theme-load-path "~/.emacs.d/git/moe-theme/")
(add-to-list 'load-path "~/.emacs.d/git/moe-theme/")
(require 'powerline)
(require 'moe-theme)
(setq moe-theme-highlight-buffer-id nil)
(moe-light)

;;(enable-theme 'moe-dark)


;;======================================================
;; moedict 萌典
;;======================================================
(add-to-list 'load-path "~/.emacs.d/git/moedict/")
(require 'moedict)

;;======================================================
;; zlc
;;======================================================
;;;;Zsh style completetion!
;;  目前zlc有bug尚未修復，故不使用
;;  (require 'zlc)
;;  (zlc-mode t)
;;  (let ((map minibuffer-local-map))
;;  ;;; like menu select
;;  (define-key map (kbd "<down>")  'zlc-select-next-vertical)
;;  (define-key map (kbd "<up>")    'zlc-select-previous-vertical)
;;  (define-key map (kbd "<right>") 'zlc-select-next)
;;  (define-key map (kbd "<left>")  'zlc-select-previous)
;;
;;  ;;; reset selection
;;  (define-key map (kbd "C-c") 'zlc-reset))

;; 其實以下六行我好像根本沒在按，已經習慣按M-p跟M-n了
(define-key minibuffer-local-must-match-map "\C-p" 'previous-history-element)
(define-key minibuffer-local-must-match-map "\C-n" 'next-history-element)
(define-key minibuffer-local-completion-map "\C-p" 'previous-history-element)
(define-key minibuffer-local-completion-map "\C-n" 'next-history-element)
(define-key minibuffer-local-map "\C-p" 'previous-history-element)
(define-key minibuffer-local-map "\C-n" 'next-history-element)


;;======================================================
;; Auto-complete
;;======================================================
;;(add-to-list 'load-path "~/.emacs.d/lisps/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-user-dictionary-files "~/.emacs.d/ac-dict")
(ac-config-default)
(global-auto-complete-mode 1)

(define-key ac-mode-map (kbd "C-c h") 'ac-last-quick-help)
(define-key ac-mode-map (kbd "C-c H") 'ac-last-help)

;;(require 'ac-company)
;;(ac-company-define-source ac-source-company-elisp company-elisp)
;;(add-hook 'emacs-lisp-mode-hook
;;       (lambda ()
;;         (add-to-list 'ac-sources 'ac-source-company-elisp)))

(add-hook 'css-mode-hook 'ac-css-mode-setup)
(add-hook 'css-mode-hook
          (lambda ()
;;            (add-to-list 'ac-sources 'ac-source-company-css)
            (define-key css-mode-map (kbd "<RET>") 'newline-and-indent)))

(setq ac-use-menu-map t)
;; 讓C-s可以在auto-complete選單裡使用。
(define-key ac-complete-mode-map (kbd "C-s") 'ac-isearch)
(define-key ac-complete-mode-map (kbd "M-p") 'ac-quick-help-scroll-up)
(define-key ac-complete-mode-map (kbd "M-n") 'ac-quick-help-scroll-down)

;;======================================================
;; multiple-cursors
;;======================================================
;;
(require 'multiple-cursors)
(global-set-key (kbd "C-x C-@") 'mc/edit-lines)
;;以下四種key-binding皆無法在terminal下使用orz改用M-'與M-"應該就沒問題，有空再來研究。
;;(global-set-key (kbd "C->") 'mc/mark-next-like-this)
;;(global-set-key (kbd "C-;") 'mc/mark-next-like-this)
;;(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;;(global-set-key (kbd "C-:") 'mc/mark-previous-like-this)
(global-set-key (kbd "M-'") 'mc/mark-next-like-this)
(global-set-key (kbd "M-\"") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c M-'") 'mc/mark-all-like-this)

;; set-mark, multiple-cursors & cua-mode
;; (cua-mode t)
;; (setq cua-enable-cua-keys nil) ;;変なキーバインド禁止
;; (global-set-key (kbd "C-c C-@") 'cua-set-rectangle-mark)
;; (global-set-key (kbd "M-RET") 'set-mark-command) ;這他媽的會跟org-mode衝啊！
;; (global-set-key (kbd "C-c RET") 'cua-set-rectangle-mark)
;;(global-set-key (kbd "C-x RET") 'mc/edit-lines)

(add-hook 'org-mode-hook
          (lambda ()
            (define-key org-mode-map (kbd "M-RET") 'set-mark-command) ;;讓org-mode能用M-RET來set-mark-command
            (define-key org-mode-map (kbd "C-c SPC") 'ace-jump-word-mode)
            (define-key org-mode-map (kbd "C-c C-e") 'org-export-dispatch)
            ))

;; ace-jump
(global-set-key (kbd "C-c SPC") 'ace-jump-word-mode)

;; goto-chg
(global-set-key (kbd "C-x j") 'goto-last-change)
(global-set-key (kbd "C-x C-j") 'goto-last-change-reverse)

;;======================================================
;; Dired
;;======================================================

(require 'dired+)

;; M-RET to call `kde-open` to open file.
(defun dired-open-file ()
  "Open file with external program in dired"
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (message "Opening %s..." file)
    (call-process "kde-open" nil 0 nil file)
    (message "Opening %s done" file)))

(add-hook 'dired-mode-hook
		  (lambda ()
			(define-key dired-mode-map (kbd "M-RET") 'dired-open-file)))

;; Use single dired buffer.
(require 'dired-single)
(define-key dired-mode-map (kbd "C-x RET") 'dired-find-file)

;; dired hide/show detail infomation
;; [FIXME] Emacs 24.4 will build-in `dired-hide-details-mode'.
(require 'dired-details)
(dired-details-install)
(defun my-dired-init ()
  "Bunch of stuff to run for dired, either immediately or when it's
   loaded."
  ;; <add other stuff here>
  (define-key dired-mode-map (kbd "RET") 'dired-single-buffer)
  (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse)
  (define-key dired-mode-map "^"
	(function
	 (lambda nil (interactive) (dired-single-buffer ".."))))
  (define-key dired-mode-map "q"
	(function
	 (lambda nil (interactive) (dired-single-buffer "..")))))
;; if dired's already loaded, then the keymap will be bound
(if (boundp 'dired-mode-map)
	;; we're good to go; just add our bindings
	(my-dired-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'my-dired-init))

;; 這玩意我根本從沒用過，不確定是什麼。
;; (global-set-key [(f5)] 'dired-single-magic-buffer)
;; (global-set-key [(meta f5)] 'dired-single-toggle-buffer-name)

;;hide didden file
(require 'dired-x)
(setq dired-omit-files "^\\...+$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

;;human-readable file size
(setq dired-listing-switches "-alh")

;;sort file
(require 'dired-sort)

;;sort directories first
(defun dired-directory-sort ()
  "Dired sort hoOBok to list directories first."
  (save-excursion
	(let (buffer-read-only)             ; 原來解除read-only是這樣寫的OAO...
	  (forward-line 2) ;; beyond dir. header
	  (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max))))
  (and (featurep 'xemacs)
       (fboundp 'dired-insert-set-properties)
       (dired-insert-set-properties (point-min) (point-max)))
  (set-buffer-modified-p nil))

(add-hook 'dired-after-readin-hook 'dired-directory-sort)

(defun dired-show-only (regexp)
  (interactive "sFiles to show (regexp): ")
  (dired-mark-files-regexp regexp)
  (dired-toggle-marks)
  (dired-do-kill-lines))
(define-key dired-mode-map (kbd "C-i") 'dired-show-only)

(defun dired-open-mounted-media-dir ()
  (interactive)
  (find-file "/var/run/media/"))
(define-key dired-mode-map (kbd "C-c m") 'dired-open-mounted-media-dir)

(defun dired-add-to-smplayer-playlist ()
  "Add a multimedia file or all multimedia files under a directory into SMPlayer's playlist via Dired."
  (interactive)
  (require 'cl)
  (let* (PATTERN FILE full-path-FILE n)
    (setq PATTERN "\\(\\.mp4\\|\\.flv\\|\\.rmvb\\|\\.mkv\\|\\.avi\\|\\.rm\\|\\.mp3\\|\\.wav\\|\\.wma\\|\\.m4a\\|\\.mpeg\\|\\.aac\\|\\.ogg\\|\\.flac\\|\\.ape\\|\\.mp2\\|\\.wmv\\)$")
    (setq FILE (dired-get-filename nil t))
    (setq n 0)
    (if (file-directory-p FILE)	;if it's a dir.
		(progn
		  (setq full-path-FILE (cl-loop for i in (directory-files FILE nil PATTERN)
										collect (concat FILE "/" i)))
		  (message "Opening %s files..." (list-length full-path-FILE))
		  (cl-loop for i in full-path-FILE
				   do (call-process "smplayer" nil 0 nil "-add-to-playlist" i)
				   (sit-for 0.1))	;Or playlist will be not in order.
		  (dired-next-line 1)
		  )
      (if (string-match PATTERN FILE)	;if it's a file
		  (progn
			(call-process "smplayer" nil 0 nil "-add-to-playlist" FILE)
			(dired-next-line 1))
		(progn
		  (message "This is not a supported audio or video file.")
		  (dired-next-line 1))))))

(define-key dired-mode-map (kbd "M-a") 'dired-add-to-smplayer-playlist)
(define-key dired-mode-map (kbd "<f2>") 'wdired-change-to-wdired-mode)


(defun dired-tar (tarname files &optional arg)
  "A dired-mode extension to archive files marked.
With one prefix argument, the tarball is gziped."
  (interactive (let ((files (dired-get-marked-files)))
                 (list (read-string "Tarball name: "
                                    (concat (file-relative-name (car files)) ".tar.gz"))
                       files "P")))
  (let ((tar (if arg
                 (if dired-guess-shell-gnutar
                     (concat dired-guess-shell-gnutar " zcf %s %s")
                   "tar cf - %2s | gzip > %1s")
               "tar cf %s %s")))
    (shell-command (format tar tarname (mapconcat 'file-relative-name files " ")))))
(add-hook 'dired-load-hook (lambda () (define-key dired-mode-map "T" 'dired-tar)))

;;======================================================
;; Magit!
;;======================================================

(require 'magit)
(global-set-key (kbd "C-x g i t s") 'magit-status)
(global-set-key (kbd "C-x g i t l") 'magit-log)
(define-key magit-mode-map (kbd "C-x p") 'magit-pull)

;;======================================================
;; Templates
;;======================================================

;; 開新檔案名為 .gitignore 時，自動插入template
(add-hook 'find-file-hooks 'insert-gitignore-template)
(defun insert-gitignore-template ()
  (interactive)
  (when (and
         (string-match "^\\.gitignore$" (buffer-file-name))
         (eq 1 (point-max)))
    (insert-file "~/.emacs.d/templates/gitignore")))

;;======================================================
;; Rainbow-delimiters 括號上色
;;======================================================
(require 'rainbow-delimiters)
;; 只在程式相關mode中使用
(require 'cl)
(dolist (x '(emacs-lisp-mode-hook
             lisp-mode-hook
             lisp-interaction-mode-hook))
  (add-hook x
            (lambda ()
              (rainbow-delimiters-mode t)
              (setq show-trailing-whitespace t))))

;;======================================================
;; Rainbow-mode 自動顯示色碼顏色，如 #ffeeaa
;;======================================================
(require 'rainbow-mode)
(global-set-key (kbd "C-x r a") 'rainbow-mode)
(add-hook 'prog-mode-hook 'rainbow-mode)


;; CSS and Rainbow modes
(defun all-css-modes() (css-mode) (rainbow-mode))
(add-to-list 'auto-mode-alist '("\\.css$" . all-css-modes)) ;; Load both major and minor modes in one call based on file type

(defun my-xml-mode () (rainbow-mode) (xml-mode))
(add-to-list 'auto-mode-alist '("\\.xml$" . my-xml-mode))

(defun my-stylus-mode () (stylus-mode) (rainbow-mode))
(add-to-list 'auto-mode-alist '("\\.styl$" . my-stylus-mode))
(add-to-list 'auto-mode-alist '("\\.ejs$" . web-mode))

;; 去你的C-j
(require 'stylus-mode)
(require 'web-mode)
(define-key stylus-mode-map (kbd "RET") 'newline-and-indent)
(define-key web-mode-map (kbd "RET") 'newline-and-indent)

;;(setq-default show-trailing-whitespace nil)
(defun toggle-show-trailing-whitespace ()
  "Toggle show-trailing-whitespace between t and nil"
  (interactive)
  (cond ((equal current-prefix-arg nil)
         (setq show-trailing-whitespace (not show-trailing-whitespace)))
        ((equal current-prefix-arg '(4))
         (progn
           (if (yes-or-no-p "Deleting all useless whitespace, continue? ")
               (delete-trailing-whitespace))))))
(global-set-key (kbd "C-x ,") 'toggle-show-trailing-whitespace)

;;(require 'org-html5presentation)

;;======================================================
;; SLIME
;;======================================================
(require 'slime)
(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))
(add-hook 'cperl-mode-hook (lambda () (perl-completion-mode t)))
(defalias 'perl-mode 'cperl-mode)
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
;; Optionally, specify the lisp program you are using. Default is "lisp"
(setq inferior-lisp-program "clisp")
(setq slime-net-coding-system 'utf-8-unix)
(slime-setup)
;;(defun keyboard-quit-custom ()
;;  (interactive)
;;  (lazy-highlight-cleanup)(keyboard-quit))
;;(global-set-key (kbd "C-g") 'keyboard-quit-custom)

;;======================================================
;; mmm-mode
;;======================================================

(require 'mmm-mode)
(require 'mmm-auto)
(setq mmm-global-mode 'maybe)
(mmm-add-classes
 '((mmm-ml-css-mode
    :submode css-mode
    :face mmm-code-submode-face
    :front "<style[^>]*>"
    :back "\n?[ \t]*</style>"
    )
   (mmm-ml-javascript-mode
    :submode javascript-mode
    :face mmm-code-submode-face
    :front "<script[^>]*>[^<]"
    :front-offset -1
    :back "\n?[ \t]*</script>"
    )
   ))
(mmm-add-mode-ext-class 'html-mode nil 'mmm-ml-javascript-mode)
(mmm-add-mode-ext-class 'html-mode nil 'mmm-ml-css-mode)

;;======================================================
;; Emacs Lisp 相關加強
;;======================================================
;;
;; 超混亂lisp的function highlight
;;
;;(defvar font-lock-func-face
;;  (defface font-lock-func-face
;;      '((nil (:weight bold))
;;        (t (:bold t :italic t)))
;;    "Font Lock mode face used for function calls."
;;    :group 'font-lock-highlighting-faces))

(font-lock-add-keywords 'emacs-lisp-mode
                        '(
						  ("'[-a-zA-Z_][-a-zA-Z0-9_/]*" 0 'font-lock-constant-face)
						  ("(\\([-a-zA-Z0-9_/]+\\)" 1 'font-lock-keyword-face)
						  ("(setq \\([-a-zA-Z0-9_/]+\\)" 1 'font-lock-variable-name-face)))

(defun lookup-elisp-function-doc ()
  "Look up the elisp function under the cursor."
  (interactive)
  (let (begin end)
    (save-excursion
      (re-search-backward "(")
      (right-char)
      (setq begin (point))
      (re-search-forward "[A-z-/]+")
      (setq end (point)))
    (describe-function (intern (buffer-substring-no-properties begin end)))))

(defun lookup-elisp-variable-doc ()
  "Look up the variable under the cursor."
  (interactive)
  (let (begin end)
    (save-excursion
      (re-search-backward "[^A-z-_/]")
      (right-char)
      (setq begin (point))
      (re-search-forward "[^A-z-_/]")
      (left-char 1)
      (setq end (point)))
    (describe-variable (intern (buffer-substring-no-properties begin end)))))

(define-key emacs-lisp-mode-map (kbd "C-h 1") 'lookup-elisp-function-doc)
(define-key emacs-lisp-mode-map (kbd "C-h 2") 'lookup-elisp-variable-doc)
(define-key lisp-interaction-mode-map (kbd "C-h 1") 'lookup-elisp-function-doc)
(define-key lisp-interaction-mode-map (kbd "C-h 2") 'lookup-elisp-variable-doc)

;; Makes eval elisp sexp more convenient
(defun eval-elisp-sexp ()
  "Eval Elisp code at the point, and remove current s-exp
With one `C-u' prefix, insert output following an arrow"
  (interactive)
  (cond ((equal current-prefix-arg nil)      ;if no prefix
         (let ((OUTPUT (eval (preceding-sexp))))
           (kill-sexp -1)
           (insert (format "%S" OUTPUT))))
        ((equal current-prefix-arg '(4)) ;one C-u prefix
         (save-excursion
           (let ((OUTPUT (eval (preceding-sexp))))
             (insert (format "%s%S" " => " OUTPUT)))))))

(global-set-key (kbd "C-c C-x C-e") 'eval-elisp-sexp)
;; avoid key-binding conflict with org
(define-key org-mode-map (kbd "C-c C-x C-e") 'org-clock-modify-effort-estimate)

;;======================================================
;; Emacs 本身key-binding改進
;;======================================================

;;discover-mode
(global-discover-mode 1)

;;有時會按錯C-x C-c，所以叫Emace確認後再關掉！
(defun save-buffers-kill-terminal-after-confirm ()
  "老是不小心關掉Emacs，揪咪。"
  (interactive)
  (if (yes-or-no-p "Really quit Emacs?")
      (save-buffers-kill-terminal)
    "好極了！"))
(global-unset-key (kbd "C-x C-c"))
(global-set-key (kbd "C-x C-c") 'save-buffers-kill-terminal-after-confirm)

;; C-z 太常按錯了，直接關掉這binding
(global-unset-key (kbd "C-z"))

;; 跳到行號
(global-set-key (kbd "C-x SPC") 'goto-line)

(defun twittering-scroll-up()
  "Scroll up if possible; otherwise invoke `twittering-goto-next-status',
which fetch older tweets on non reverse-mode."
  (interactive)
  (cond
   ((= (point) (point-max))
    (twittering-goto-next-status))
   ((= (window-end) (point-max))
    (goto-char (point-max)))
   (t
    (scroll-up))))

(defun twittering-scroll-down()
  "Scroll down if possible; otherwise invoke `twittering-goto-previous-status',
which fetch older tweets on reverse-mode."
  (interactive)
  (cond
   ((= (point) (point-min))
    (twittering-goto-previous-status))
   ((= (window-start) (point-min))
    (goto-char (point-min)))
   (t
    (scroll-down))))

(add-to-list 'auto-mode-alist '("\\.yml\\'" . conf-mode))

;;======================================================
;; pangu-spacing： 中英文之間自動插入空白
;;======================================================

(require 'pangu-spacing)

;; 只在 org-mode 和 markdown-mode 中啟用 pangu-spacing
(add-hook 'org-mode-hook
          '(lambda ()
             (set (make-local-variable 'pangu-spacing-real-insert-separtor) nil)))
(add-hook 'markdown-mode-hook
		  '(lambda ()
			 (pangu-spacing-mode 1)
			 (set (make-local-variable 'pangu-spacing-real-insert-separtor) t)))

;;======================================================
;; Tree-mode 樹狀顯示檔案清單
;;======================================================

(require 'tree-mode)
(require 'windata)
(require 'dirtree)
(set-face-foreground 'widget-button "orange")

;;======================================================
;; "[FIXME]"高亮，但這個會讓web-mode的faces失效
;;======================================================
;;(add-hook 'prog-mode-hook
;;          (lambda ()
;;            (font-lock-add-keywords nil
;;                                    '(("\\<\\(FIXME\\|DEBUG\\)" 1 font-lock-warning-face prepend)))))

;;======================================================
;; EShell/Term
;;======================================================
;;Term下不要使用當行高亮，避免使用如MOC(music on console)等程式時出現的無意義當行高亮。
(add-hook 'term-mode-hook
		  (lambda ()
            (setq global-hl-line-mode nil)
            (setq global-linum-mode nil)))

;; open javascript interactive shell.
(defun jsc ()
  (interactive)
  (eshell "JSC")
  (insert "rhino")
  (eshell-send-input ""))

;; 如果當前user是root，prompt改成#
(setq eshell-prompt-function
      '(lambda ()
         (concat
          user-login-name "@" system-name " "
          (if (search (directory-file-name (expand-file-name (getenv "HOME"))) (eshell/pwd))
              (replace-regexp-in-string (expand-file-name (getenv "HOME")) "~" (eshell/pwd))
            (eshell/pwd))
          (if (= (user-uid) 0) " # " " $ "))))


;; 高亮 prompt...好像不是很有必要
(defun colorfy-eshell-prompt ()
  "Colorfy eshell prompt according to `user@hostname' regexp."
  (let* ((mpoint)
         (user-string-regexp (concat "^" user-login-name "@" system-name)))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward (concat user-string-regexp ".*[$#]") (point-max) t)
        (setq mpoint (point))
        (overlay-put (make-overlay (point-at-bol) mpoint) 'face '(:foreground "#729fcf")))
      (goto-char (point-min))
      (while (re-search-forward user-string-regexp (point-max) t)
        (setq mpoint (point))
        (overlay-put (make-overlay (point-at-bol) mpoint) 'face '(:foreground "#72cf6c"))
        ))))

;; Make eshell prompt more colorful
;;(add-to-list 'eshell-output-filter-functions 'colorfy-eshell-prompt)

;; Show line-number in the mode line
(line-number-mode 1)
;; Show column-number in the mode line
;;(column-number-mode t)

;;======================================================
;; Hexo相關
;;======================================================

;;插入blog的動態行間註解(需搭配CSS)
;; [FIXME] 請想個更好的function名...這個太容易忘記了
(defun html-insert-inline-note ()
  (interactive)
  (insert "<span class=\"note\"><span class=\"content\"></span></span>")
  (backward-char 36))
(define-key markdown-mode-map (kbd "C-c i n") 'html-insert-inline-note)

;; 在hexo根目錄下執行，會呼叫`hexo new`新增文章，並自動打開。
;; (defun hexo-new ()
;;   (interactive)
;;   (let (OUTPUT current-dir)
;;     (setq current-dir )
;;     (setq OUTPUT (shell-command-to-string
;;      (concat "hexo new '" (read-from-minibuffer "Title of the new article: ") "'")))
;;   (string-match "/.*\\.md$" OUTPUT)
;;   (find-file (match-string 0 OUTPUT))))

;; 如果在一個 hexo repository 下，執行 hexo new
(require 'dired-single) ; 如果已經 require 過就不需要再加這行。
(defun hexo-new ()
  "Call `hexo new` if under a hexo's child directory."
  (interactive)
  (let (BUFFER-STRING OUTPUT)
    (if (file-exists-p (format "%s%s" default-directory "_config.yml")) ;用這個
        (progn
          (with-temp-buffer
            (insert-file-contents (format "%s%s" default-directory "_config.yml"))
            (setq BUFFER-STRING (buffer-string)))
          (if (and (string-match "title: " BUFFER-STRING)
             (string-match "url: " BUFFER-STRING)
             (string-match "new_post_name: " BUFFER-STRING))
              (progn
                (setq OUTPUT (shell-command-to-string
                              (concat "hexo new '"
                                      (read-from-minibuffer
                                       "Title of the new article: ") "'")))
          (string-match "/.*\\.md$" OUTPUT)
          (find-file (match-string 0 OUTPUT)))))
      (progn
        (find-file default-directory)
        (if (not (equal default-directory "/"))
          (progn (dired-single-buffer "..")
                 (hexo-new))
          (progn
            (kill-buffer)
            (message "Not in a hexo or its child directory.")))))))

;; 根據文章內容來 touch -t 文章以方便按照時間排序。
(defun hexo-touch-files-in-dir-by-time ()
  "`touch' markdown article files according their \"date: \" to
make it easy to sort file according date in Dired.
Please run this under _post/ or _draft/ within Dired buffer."
  (interactive)
  (let (current-file-name file-list)
    (setq file-list (directory-files (dired-current-directory)))
    (progn
      (mapcar
       (lambda (current-file-name)
         (if (and (not (string-match "#.+#$" current-file-name))
                  (not (string-match ".+~$" current-file-name))
                  (not (string-match "^\.\.?$" current-file-name))
                  (string-match ".+\.md$" current-file-name))
             (let (touch-cmd head)
               (setq head
                     (shell-command-to-string
                      (format "head -n 5 '%s'" current-file-name)))
               (save-match-data
                 (string-match "^date: \\([0-9]+\\)-\\([0-9]+\\)-\\([0-9]+\\) \\([0-9]+\\):\\([0-9]+\\):\\([0-9]+\\)$" head)
                 (setq touch-cmd
                       (format "touch -t %s%s%s%s%s.%s %s"
                               (match-string 1 head)
                               (match-string 2 head)
                               (match-string 3 head)
                               (match-string 4 head)
                               (match-string 5 head)
                               (match-string 6 head)
                               current-file-name
                               )))
               (shell-command touch-cmd))
           ))
       file-list))) ;; 這個file-list為lambda的arg
  (revert-buffer)
  (message "Done."))


;; 將當前檔案在 _post 與 _drafts 兩者之間切換（mv）。
(defun hexo-move-article ()
  "Move current file between _post and _draft"
  (interactive)
  (let* ((cur-file (buffer-name))
         (cur-dir default-directory)
         (cur-path (buffer-file-name)))
    (save-buffer)
    (save-match-data
      (if (string-match "\\(.+/\\)_posts/$" cur-dir)
          (let* ((new-file-name (format "%s%s%s" (match-string 1 cur-dir) "_drafts/" cur-file)))
            (kill-buffer)
            (rename-file cur-path new-file-name)
            (find-file new-file-name)
            (message "Now in \"_drafts\""))
        (if (string-match "\\(.+/\\)_drafts/$" cur-dir)
            (let* ((new-file-name (format "%s%s%s" (match-string 1 cur-dir) "_posts/" cur-file)))
              (kill-buffer)
              (rename-file cur-path new-file-name)
              (find-file new-file-name)
              (message "Now in \"_posts\""))
          (message "Current file doesn't in _posts or _drafts directory."))))))


;; [自用] 把livedoor Reader輸出的opml檔轉成markdown，然後吐到hexo目錄。
(defun hexo-opml-to-markdown ()
  (interactive)
  (let (output-markdown opml-copy-to trans input-file)
    (setq output-markdown "~/Dropbox/Blog/kuanyui.github.io/source/blogrolls/index.md"
          opml-copy-to "~/Dropbox/Blog/kuanyui.github.io/source/blogrolls/" ;記得是填目錄，而且最後要加斜線。
          input-file (read-file-name "OPML file's location: "))
    (if (not (string-match "\\(\.opml\\|\.xml\\)$" input-file))
        (progn "It's not an OPML file."
               (opml-to-markdown))
      (progn
        (copy-file input-file (format "%sfeed-from-rss-reader.xml" opml-copy-to) 'overwrite)
        (copy-file input-file output-markdown 'overwrite)
        (find-file output-markdown)
        (goto-char (point-min))
        (re-search-forward "<\\?xml\\(?:.\\|\n\\)*<outline title=\"Subscriptions\">" nil :no-error)
        (replace-match "")
        (while (re-search-forward "<outline title=\"\\(.+\\)\">" nil :no-error)
          (replace-match (format "###%s###" (match-string 1))))
        (goto-char (point-min))
        (while (re-search-forward "<outline title=\"\n?*\\(.+?\\)\n?*\" htmlUrl=\"\\(.+?\\)\".*/>" nil :no-error)
          (replace-match (format "- [%s](%s)" (match-string 1) (match-string 2))))
        (goto-char (point-min))
        (while (re-search-forward "</outline>" nil :no-error)
          (replace-match ""))
        (goto-char (point-min))
        (while (re-search-forward "</body></opml>" nil :no-error)
          (replace-match ""))
        (goto-char (point-min))
        (while (re-search-forward "^ +" nil :no-error)
          (replace-match ""))
        (goto-char (point-min))
        (insert (concat
                 (format-time-string "title: Subscribed Feeds
date: %Y-%m-%d %H:%M:%S
---\n" (current-time))
                 (format-time-string "<blockquote class=\"pullquote\">我有每天讀RSS reader的習慣，這個頁面就是我所訂閱的完整RSS feeds列表。嗯...或許可以把這個頁面視為blog聯播？<br>
部份飼料的分類標準不明不白為正常現象，敬請安心食用。<br>
原始的OPML檔可以在<a href=\"feed-from-rss-reader.xml\">這裡</a>取得。<br>
<span style='font-style:italic;color:#999;font-size:0.8em;'>此頁面於%Y/%m/%d  %H:%M:%S產生</span></blockquote>" (current-time))
                 ))
        (save-buffer)))))

;;======================================================
;; 寫作加強
;;======================================================
;; 在 Markdown-mode中插入URL或Flickr圖片等。
(add-to-list 'load-path "~/.emacs.d/git/writing-utils/")
(load-file "~/.emacs.d/git/writing-utils/writing-utils.el")
(load-file "~/.emacs.d/private/flickr.el")

;;======================================================
;; Python
;;======================================================

(require 'highlight-indentation)
(add-hook 'python-mode-hook 'highlight-indentation)
(add-hook 'python-mode-hook 'highlight-indentation-current-column-mode)
(set-face-background 'highlight-indentation-face "#e3e3d3")
(set-face-background 'highlight-indentation-current-column-face "#ffafff")
(setq highlight-indentation-set-offset '2)

;; Info-look
(require 'info-look)
(info-lookup-add-help
 :mode 'python-mode
 :regexp "[[:alnum:]_]+"
 :doc-spec
 '(("(python)Index" nil "")))

(setq
 python-shell-interpreter "python3"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
   "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")


;;======================================================
;; Color code convert (from Xah Lee's CSS Mode)
;;======================================================
;; (I rename the functions because they are easier to memorize...)

(require 'color)
(defun color-code-rgb-to-hsl ()
  "Convert color spec under cursor from “#rrggbb” to CSS HSL format.
#ffefd5 → hsl(37,100%,91%)"
  (interactive)
  (let* (
         (bds (bounds-of-thing-at-point 'word))
         (p1 (car bds))
         (p2 (cdr bds))
         (currentWord (buffer-substring-no-properties p1 p2)))

    (if (string-match "[a-fA-F0-9]\\{6\\}" currentWord)
        (progn
          (delete-region p1 p2 )
          (if (looking-back "#") (delete-char -1))
          (insert (color-code-hex-to-hsl currentWord )))
      (progn
        (error "The current word 「%s」 is not of the form #rrggbb." currentWord)
        )
      )))

(defun color-code-hex-to-hsl (hexStr)
  "Convert hexStr color to CSS HSL format.
Return a string.
 (color-code-hex-to-hsl \"#ffefd5\") ⇒ \"hsl(37,100%,91%)\""
  (let* (
         (colorVec (color-code-convert-hex-to-vec hexStr))
         (xR (elt colorVec 0))
         (xG (elt colorVec 1))
         (xB (elt colorVec 2))
         (hsl (color-rgb-to-hsl xR xG xB) )
         (xH (elt hsl 0))
         (xS (elt hsl 1))
         (xL (elt hsl 2))
         )
    (format "hsl(%d,%d%%,%d%%)" (* xH 360) (* xS 100) (* xL 100) )
    ))

(defun color-code-convert-hex-to-vec (hexcolor)
  "Convert HEXCOLOR from “\"rrggbb\"” string to a elisp vector [r g b], where the values are from 0 to 1.
Example:
 (color-code-convert-hex-to-vec \"00ffcc\") ⇒ [0.0 1.0 0.8]

Note: The input string must NOT start with “#”. If so, the return value is nil."
  (vector
   (color-code-normalize-number-scale
    (string-to-number (substring hexcolor 0 2) 16) 255)
   (color-code-normalize-number-scale
    (string-to-number (substring hexcolor 2 4) 16) 255)
   (color-code-normalize-number-scale
    (string-to-number (substring hexcolor 4) 16) 255)
   ))

(defun color-code-normalize-number-scale (myVal rangeMax)
  "Return a number between [0, 1] that's a rescaled myVal.
myVal's original range is [0, rangeMax].

The arguments can be int or float.
Return value is float."
  (/ (float myVal) (float rangeMax)))

(global-set-key (kbd "C-c m l") (lambda () (interactive) (moe-light)))
(global-set-key (kbd "C-c m d") (lambda () (interactive) (moe-dark)))



;;======================================================
;; gnus
;;======================================================
;;


(setq gnus-select-method
      '(nnimap "gmail"
	       (nnimap-address "imap.gmail.com")
	       (nnimap-server-port 993)
	       (nnimap-stream ssl)))

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587 user-mail-address nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

(setq gnus-default-charset 'utf-8)

;; 發信用coding-system
(setq mm-coding-system-priorities '(utf-8))

(setq gnus-thread-sort-functions
      '((not gnus-thread-sort-by-score)))


;;======================================================
;; Flymake
;;======================================================
(require 'flymake)

(defun flymake-elisp-init ()
  (unless (string-match "^ " (buffer-name))
    (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
           (local-file  (file-relative-name
                         temp-file
                         (file-name-directory buffer-file-name))))
      (list
       (expand-file-name invocation-name invocation-directory)
       (list
        "-Q" "--batch" "--eval"
        (prin1-to-string
         (quote
          (dolist (file command-line-args-left)
            (with-temp-buffer
              (insert-file-contents file)
              (condition-case data
                  (scan-sexps (point-min) (point-max))
                (scan-error
                 (goto-char(nth 2 data))
                 (princ (format "%s:%s: error: Unmatched bracket or quote\n"
                                file (line-number-at-pos)))))))
          )
         )
        local-file)))))
(push '("\\.el$" flymake-elisp-init) flymake-allowed-file-name-masks)
(add-hook 'emacs-lisp-mode-hook
          ;; workaround for (eq buffer-file-name nil)
          (function (lambda () (if buffer-file-name (flymake-mode)))))

(add-hook 'find-file-hook (lambda ()
                            (when (> (buffer-size) (* 1024 1024))
                              (setq buffer-read-only t)
                              (buffer-disable-undo)
                              (fundamental-mode))))
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;;======================================================
;; customize 以下為Emacs自動生成，不要動
;;======================================================
;;


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#5f5f5f" "#ff4b4b" "#a1db00" "#fce94f" "#5fafd7" "#d18aff" "#afd7ff" "#ffffff"])
 '(custom-safe-themes
   (quote
    ("dbfa6f95b6e56fb7b1592f610583e87ebb16d3e172416a107f0aceef1351aad0" "9ba004f6d3e497c9f38859ae263b0ddd3ec0ac620678bc291b4cb1a8bca61c14" "6aae982648e974445ec8d221cdbaaebd3ff96c3039685be9207ca8ac6fc4173f" default)))
 '(delete-selection-mode nil)
 '(mark-even-if-inactive t)
 '(resize-frame t)
 '(scroll-bar-mode (quote right))
 '(transient-mark-mode 1))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

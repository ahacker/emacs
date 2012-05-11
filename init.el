;;取消欢迎界面
(setq inhibit-startup-message t)
;;去掉工具栏
(tool-bar-mode nil)
;;标题栏显示文件路径
(setq frame-title-format 
      '((buffer-file-name "%f "
			  (dired-directory dired-directory "%b" ))))
;;显示行号
(require 'linum)
(global-linum-mode t)
;;滚动条置于右侧
(customize-set-variable 'scroll-bar-mode 'right)
;;使用系统剪贴板
(setq x-select-enable-clipboard t)
;;个人信息
(setq user-full-name "********")
(setq user-mail-address "********")

;;; =============================  键绑定  =============================
;;y/n代表 yes/no
(fset 'yes-or-no-p 'y-or-n-p)
;;C-k删除当前行
(setq-default kill-whole-line t)
;;绑定C-z为撤销
(global-set-key (kbd "C-z") 'undo)
;;用shift+空格标记
(global-set-key [?\S- ] 'set-mark-command)

;;窗口切换
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)

;;按段移动
(global-set-key (kbd "C-;") 'backward-paragraph)
(global-set-key (kbd "C-'") 'forward-paragraph)
;;文件首尾
(global-set-key (kbd "M-;") 'backward-page)
(global-set-key (kbd "M-'") 'forward-page) 

;;光标靠近时，鼠标移开
;(mouse-avoidance-mode 'animate)

;;把缺省的major mode设置为text-mode
;(setq default-major-mode 'text-mode)

;;M-w，当未选中内容时，复制当前行
(defadvice kill-line (before check-position activate)
  (if (member major-mode
	      '(emacs-lisp-mode
		lisp-mode
		c-mode
		c++-mode
		objc-mode
		js-mode
		plain-tex-mode))
      (if (and (eolp) (not (bolp)))
	  (progn (forward-char 1)
		 (just-one-space 0)
		 (backward-char 1)))))
(defadvice kill-ring-save (before slick-copy activate compile)
  "Copy a single line"
  (interactive (if mark-active (list (region-beginning) (region-end))
		 (message "Copied line")
		 (list (line-beginning-position)
		       (line-beginning-position 2)))))
(defadvice kill-region (before slick-cut activate compile)
  "kill a single line"
  (interactive (if mark-active (list (region-beginning) (region-end))
		 (list (line-beginning-position)
		       (line-beginning-position 2)))))
(defun qiang-copy-line (arg)
  "Copy line"
  (interactive "p")
  (kill-ring-save (point)
		  (line-end-position))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))
(global-set-key (kbd "M-k") 'qiang-copy-line)

;;; ============================  鼠标、光标  ============================
;;关闭鼠标选中即复制
(setq mouse-drag-copy-region nil)

;;光标为竖线
(setq-default cursor-type 'bar)
;;光标行尾上下移动
(setq line-move-visual nil)
(setq track-eol t)

;;括号匹配，不跳转
(show-paren-mode t)
(setq show-paren-style 'parentheses)
;;括号匹配颜色
(set-face-foreground 'show-paren-match "#004242")
;;加粗显示括号
;(set-face-bold-p 'show-paren-match t)
(set-face-background 'show-paren-match "#B0B7B0")
;;括号跳转
(global-set-key "'" 'match-paren)

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert '."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))
;; end [] match

;;鼠标滚轮滚动速度为3行
(defun up-slightly () (interactive) (scroll-up 3))
(defun down-slightly () (interactive) (scroll-down 3))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

;;; ============================  tabbar  ============================
;;标签
(load-file "~/.emacs.d/tabbar.el")
(require 'tabbar)
(tabbar-mode)
(global-set-key (kbd "M-j") 'tabbar-backward)
(global-set-key (kbd "M-k") 'tabbar-forward)

;;标签栏默认主题
(set-face-attribute 
 'tabbar-default nil
 :family "Bitstream Vera Sans Mono"
 :background "gray80"
 :foreground "gray30"
 :height 1.0
 )
(set-face-attribute 'tabbar-button nil
		    :inherit 'tabbar-default
		    :box '(:line-width 1 :color "black")
		    )
;;当前tab主题
(set-face-attribute
 'tabbar-selected nil
 :inherit 'tabbar-default
 :foreground "DarkGreen"
 :background "LightGoldenrod"
 :box '(:line-width 2 :color "DarkGoldenrod")
 :overline "black"
 :underline "black"
 :weight 'bold
 )
(set-face-attribute 'tabbar-unselected nil
		    :inherit 'tabbar-default
		    )

;;; ============================  主题  ============================
;;自定义主题，需要color-theme
(defun my-ecolor ()
  (interactive)
  (color-theme-install
   '(my-ecolor
     ((background-color . "#252825")
      (background-mode . light)
      (border-color . "#e1defd")
      (cursor-color . "#ffffff")
      (foreground-color . "#33f726")
      (mouse-color . "black"))
     (fringe ((t (:background "#4d4c57"))))
     (mode-line ((t (:foreground "#080808" :background "#6fb7e2"))))
     (region ((t (:background "#9d3939"))))
     (font-lock-builtin-face ((t (:foreground "#f17979"))))
     (font-lock-comment-face ((t (:foreground "chocolate1"))))
     (font-lock-function-name-face ((t (:foreground "#f4b1f6"))))
     (font-lock-keyword-face ((t (:foreground "#66cee1"))))
     (font-lock-string-face ((t (:foreground "LightSalmon"))))
     (font-lock-type-face ((t (:foreground"#d95f20"))))
     (font-lock-variable-name-face ((t (:foreground "#dafbe0"))))
     (minibuffer-prompt ((t (:foreground "#ffffff" :bold t))))
     (font-lock-warning-face ((t (:foreground "Red" :bold t))))
     )))
(provide 'my-ecolor)

;;主题
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(color-theme-initialize)
(color-theme-calm-forest)
;(my-ecolor)

;;lisp缩进提示线
;(load-file "~/.emacs.d/ran9er/00_func.el")
;(load-file "~/.emacs.d/ran9er/20_aux-line.el")
;(indent-vline)
;(indent-vline-lisp)

;;; ============================  C风格  ============================
;kernel代码风格，8字符缩进
;;花括号对齐
(c-set-offset 'substatement-open 0)

;; K&R风格
(add-hook 'c-mode-hook
	  '(lambda ()
	     (c-set-style "k&r")
	     (c-set-offset 'case-label '+);;case缩进
	     (setq tab-width 8)
	     (setq indent-tabs-mode t)
	     (setq c-basic-offset 8)));;8字节缩进

;; google-c-style
(load-file "~/.emacs.d/google-c-style.el")
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;;语法高亮
(global-font-lock-mode t)

;;; ============================  Slime  ============================
(add-to-list 'load-path "~/.emacs.d/slime/")
(setq inferior-lisp-program "/usr/bin/sbcl")
(require 'slime)
(slime-setup '(slime-fancy))
;(slime-setup)

;;; ============================  golang  ============================
(setq load-path (cons (expand-file-name "~/.emacs.d/go/") load-path))
(require 'go-mode-load)

;;; ============================  sml  ============================
(add-to-list 'load-path "~/.emacs.d/sml-mode/")
(autoload 'sml-mode "sml-mode" "Major mode for editing SML." t)
(autoload 'run-sml "sml-proc" "Run an inferiro SML process." t)
(add-to-list 'auto-mode-alist '("\\.\\(sml\\|sig\\)\\'" . sml-mode))

;;; ============================  格式化代码  ============================
;;一键格式化
(defun indent-whole ()
  (interactive)
  (indent-region (point-min) (point-max))
  (message "format successful"))
;;绑定到F7
(global-set-key [f7] 'indent-whole)

;;拷贝代码自动格式化
(dolist (command '(yank yank-pop))
  (eval
   `(defadvice ,command (after indent-region activate)
      (and (not current-prefix-arg)
	   (member major-mode
		   '(emacs-lisp-mode
		     lisp-mode
		     c-mode
		     c++-mode
		     objc-mode
		     js-mode
		     plain-tex-mode))
	   (let ((mark-even-if-inactive transient-mark-mode))
	     (indent-region (region-beginning) (region-end) nil))))))

;;添加删除注释，不在行尾时注释/反注释当前行，在行尾是添加注释
(defun qiang-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key "\M-;" 'qiang-comment-dwim-line)

;; auto pair
(load-file "~/.emacs.d/autopair.el")
(require 'autopair)
;(autopair-global-mode)
(add-hook 'c-mode-common-hook '(lambda () (autopair-mode)))

;;; ============================  GNU global  ============================
(load-file "~/.emacs.d/global-6.2.2/gtags.el")
(autoload 'gtags-mode "gtags" "" t)

;;; ============================  cedet  ============================
;;语法分析
(setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
				  global-semantic-minor-mode
				  global-idle-summary-mode
				  global-semantic-mru-bookmark-mode))
(semantic-mode 1)

;;代码折叠
(load-file "~/.emacs.d/semantic-tag-folding.el")
(global-semantic-tag-folding-mode 1)

;;函数提示，高亮起始行
(global-semantic-decoration-mode 1)
(require 'semantic/decorate/include nil 'noerror)

;;; ============================  自动补全  ============================
;; yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet-0.6.1c")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet-0.6.1c/snippets")

;; AC
(add-to-list 'load-path "~/.emacs.d/auto-complete-1.3.1");
(require 'auto-complete)
(require 'auto-complete-config)

(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete-1.3.1/dict")

;;用tab补全，回车键换行
(define-key ac-completing-map "\t" 'ac-complete)
(define-key ac-completing-map "\r" nil)

(global-auto-complete-mode t)

;; clang
(load-file "~/.emacs.d/auto-complete-clang.el")
(require 'auto-complete-clang)

(setq ac-clang-flags
      (mapcar (lambda (item)(concat "-I" item))
	      (split-string
	       "
/usr/include/c++/4.7.0
/usr/include/c++/4.7.0/i686-pc-linux-gnu
/usr/include/c++/4.7.0/backward
/usr/lib/gcc/i686-pc-linux-gnu/4.7.0/include
/usr/local/include
/usr/lib/gcc/i686-pc-linux-gnu/4.7.0/include-fixed
/usr/include
"
	       )))

(setq-default ac-sources '(ac-source-clang
			   ac-source-yasnippet
			   ac-source-semantic
			   ac-source-functions
			   ac-source-variables
			   ac-source-symbols
			   ac-source-features
			   ac-source-imenu
			   ac-source-words-in-buffer
			   ac-source-abbrev
			   ac-source-words-in-all-buffer
			   ac-source-files-in-current-dir
			   ac-source-filename))

(add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols)))
(add-hook 'auto-complete-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-filename)))

(set-face-background 'ac-candidate-face "lightgray")
(set-face-underline 'ac-candidate-face "darkgray")
(set-face-background 'ac-selection-face "steelblue")

(setq ac-auto-start 2)
(setq ac-dwim t)

;;; ============================  ECB  ============================
(add-to-list 'load-path "~/.emacs.d/ecb")
(require 'ecb)

;(setq ecb-auto-activate t)
;;取消欢迎界面
(setq ecb-tip-of-the-day nil)
;;绑定键 F12, C-F12
(global-set-key [f12] 'ecb-activate)
(global-set-key [C-f12] 'ecb-deactivate)

;;定制左侧显示界面
(ecb-layout-define "my-cscope-layout" left nil
		   (ecb-set-sources-buffer)
		   (ecb-split-ver 0.2 t)
		   (other-window 1)
		   (ecb-set-methods-buffer)
		   (ecb-split-ver 0.4 t)
		   (other-window 1)
		   (ecb-set-cscope-buffer))

(defecb-window-dedicator-to-ecb-buffer ecb-set-cscope-buffer t " *ECB cscope-buf*"
  (switch-to-buffer "*cscope*"))

(setq ecb-layout-name "my-cscope-layout")

(setq ecb-history-make-buckets 'never)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; ============================  cscope  ============================
(load-file "~/.emacs.d/xcscope.el")
(require 'xcscope)

;;; ============================  GDB  ============================
(setq gdb-many-windows t)
(setq gdb-use-separate-io-buffer t)

(defun kill-buffer-when-exit ()
  "Close assotiated buffer when a process exited"
  (let ((current-process (ignore-errors (get-buffer-process (current-buffer)))))
    (when current-process
      (set-process-sentinel current-process
			    (lambda (watch-process change-state)
			      (when (string-match "\\(finished\\|exited\\)" change-state)
				(kill-buffer (process-buffer watch-process))))))))
(add-hook 'gdb-mode-hook 'kill-buffer-when-exit)
(add-hook 'shell-mode-hook 'kill-buffer-when-exit)
;;启动gdb，关闭ecb
(defadvice gdb (before ecb-deactivate activate)
  (when (and (boundp 'ecb-minor-mode) ecb-minor-mode)
    (ecb-deactivate)))


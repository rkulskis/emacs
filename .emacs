  
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(vterm multi-term docker lsp-mode rustic typescript-mode jtsx exec-path-from-shell markdown-soma impatient-mode markdown-mode grip-mode ## emms pdf-tools latex-preview-pane auctex))
 '(warning-suppress-types '((treesit))))
  
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
  (setq doc-view-resolution 600)

  (require 'package)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'visual)

(defun bugfix-display-line-numbers--turn-on (fun &rest args)
  "Avoid `display-line-numbers-mode' in `image-mode' and related.
  Around advice for FUN with ARGS."
  (unless (derived-mode-p 'image-mode 'docview-mode 'pdf-view-mode)
    (apply fun args)))

(advice-add 'display-line-numbers--turn-on :around #'bugfix-display-line-numbers--turn-on)
(put 'upcase-region 'disabled nil)

(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
           (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://ndossougbe.github.io/strapdown/dist/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
         (current-buffer)))

(add-hook 'yaml-mode-hook
          (lambda ()
            (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(defun disable-line-numbers-in-doc-view ()
  (display-line-numbers-mode -1))

(add-hook 'doc-view-mode-hook 'disable-line-numbers-in-doc-view)

;; Associate .ino files with C++ mode
(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode))

(with-eval-after-load 'tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))
(setq tramp-remote-path '(tramp-own-remote-path "/bin" "/usr/bin" "/sbin" "/usr/sbin" "/usr/local/bin" "/home/ross/.local/bin"))

;; -*- mode: elisp -*-

;; Disable the splash screen (to enable it agin, replace the t with 0)
(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;;;;Org mode configuration
;; Enable Org mode
(require 'org)

(require 'ob-js)

(add-to-list 'org-babel-load-languages '(js . t))
(org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
(add-to-list 'org-babel-tangle-lang-exts '("js" . "js"))

;; Make Org mode work with files ending in .org
;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen
;;{{{ Set up package and use-package

;; Bootstrap 'use-package'
(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)

;;}}}
(use-package rustic)
(setq rustic-analyzer-command '("~/.cargo/bin/rust-analyzer"))
(org-babel-do-load-languages
 'org-babel-load-languages
 '((plantuml . t)
   (shell . t)
   (emacs-lisp . t)
   (latex . t)
   (ditaa . t)
   (js . t)
   (python . t)
   ))

(require 'ox-html)
(add-to-list 'load-path "~/emacs-libvterm")
(require 'vterm)

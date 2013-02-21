;; save-frame-posize.el

;; Copyright (C) 2012 by nishikawasasaki
;; Author: nishikawasasaki
;; https://github.com/nishikawasasaki/save-frame-posize.el


;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;; What is this?
;; Save GNU Emacs frame size and position.
;; Restore the size and position when you launch Emacs.


;; Install
;; Move this file into directory in load-path.
;; And this add to init.el
;; (require 'save-frame-posize)

;; ChangeLog
;; see https://github.com/nishikawasasaki/save-frame-posize.el

;; var ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar sfps-save-file "~/.emacs.d/.frameposize")
(defvar sfps-delimiter ",")


;; func ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sfps-save-when-kill-emacs ()
  "終了時にウインドウの位置とサイズを記憶"
  (interactive)
  ;; 保存用バッファ作成
  (get-buffer-create "*sfps*")
  (switch-to-buffer "*sfps*")
  ;; 位置とサイズをバッファに書き込み
  (with-output-to-temp-buffer "*sfps*"
    (princ (frame-height)) ; ウィンドウ高さ
    (princ sfps-delimiter) ; デリミタ
    (princ (frame-width)) ; ウィンドウ幅
    (princ sfps-delimiter) ; デリミタ
    (princ (assoc-default 'left (frame-parameters (selected-frame)))) ; ウィンドウX位置
    (princ sfps-delimiter) ; デリミタ
    (princ (assoc-default 'top (frame-parameters (selected-frame)))) ; ウィンドウY位置
    )
  ;; バッファ内容を保存
  (let ((coding-system-for-write 'utf-8))
    (write-region (point-min) (point-max) sfps-save-file))
  ;; バッファ削除
  (kill-buffer "*sfps*")
)

;; 開始時にウインドウの位置とサイズを読み込み
(defun sfps-restore-when-start-emacs ()
  (interactive)
  (get-buffer-create "*sfps*")
  (switch-to-buffer "*sfps*")

  ;; 位置とサイズの保存ファイルを読み込み
  (insert-file-contents sfps-save-file)
  ;; 保存した位置とサイズをカンマ区切りでファイルから取得
  (let ((sfps-posize-str (buffer-substring (point-max) (point-min))))
    ;; カンマでスプリットしてリストへ変換
    (let ((sfps-posize-list (split-string sfps-posize-str sfps-delimiter)))
      ;; 縦幅セット (ミニバッファ分の 1 を足す)
      (set-frame-height (selected-frame) (+ 1 (string-to-number (nth 0 sfps-posize-list))))
      ;; 横幅セット
      (set-frame-width (selected-frame) (string-to-number (nth 1 sfps-posize-list)))
      ;; 座標セット
      (set-frame-position (selected-frame)
                          (string-to-number (nth 2 sfps-posize-list))
                          (string-to-number (nth 3 sfps-posize-list)))))
  ;; バッファ削除
  (kill-buffer "*sfps*"))

;; Emacs 開始時に呼び出す
(add-hook 'emacs-startup-hook 'sfps-restore-when-start-emacs)

;; Emacs 終了時に呼び出す
(add-hook 'kill-emacs-hook 'sfps-save-when-kill-emacs)


(provide 'save-frame-posize)

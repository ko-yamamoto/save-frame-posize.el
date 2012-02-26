===========================================
save-frame-posize.el
===========================================

What is this? これはなに？
-----------------------------------

Save GUI Emacs frame size and position.
Restore the size and position when you launch Emacs.

GUI Emacs 終了時のフレーム位置とサイズを保存します。
また、起動時に保存した位置とサイズを復元します。



Install  インストール
----------------------------------

First, you remove initial-frame-alist settings.

まず設定していればフレームサイズと位置の設定を削除します。

::

    ;; example
    -(setq initial-frame-alist
    -        (append (list
    -                 '(width . 80)
    -                 '(height . 40)
    -                 '(top . 50)
    -                 '(left . 50)
    -                 )
    -                initial-frame-alist))
    -  (setq default-frame-alist initial-frame-alist)


Move this file into directory in load-path.
And this add to init.el

このファイルをロードパスの通った場所に移動し、
下記を init.el に追加してください。

::

   (require 'win-pos)


First Launch  初回起動
----------------------------------

win-pos.el needs .winposize file that save frame size and position.
So, you run "rwps-save-when-kill-emacs" for creating .winposize.

win-pos.el はフレームサイズと位置の保存に .winposize ファイルを必要とします。
 



Use  使い方
----------------------------------

+ rwps-save-when-kill-emacs

   Save frame size and position

   フレーム位置とサイズを保存します。


+ rwps-restore-when-start-emacs

   Restore the size and position

   保存したフレーム位置とサイズを復元します。



TODO
----------------------------------

* 初回起動時に位置サイズ保存ファイルの存在チェックをするように


ChangeLog
----------------------------------

+ 0.02

   位置取得ロジックの修正


+ 0.01

   最低限の機能で実装。

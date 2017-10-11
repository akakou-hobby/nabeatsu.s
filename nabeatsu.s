section  .data                  ; データセクションの定義
message  db 'Hello, World', 0x0a
length   equ $ -message         ; 文字列の長さ
section  .text
global   _start                 ; エントリーポイント

_start:
mov     rcx, message            ; 文字列の先頭アドレス
mov     rdx, length             ; 文字列の長さ
mov     rax, 4                  ; 出力(sys_write)
mov     rbx, 1                  ; ファイルハンドル(1 = 標準出力)
int     0x80                    ; システムコール
mov     rax, 1                  ; sys_exit
mov     rbx, 0                  ; 終了ステータスコード
int     0x80                    ; システムコール

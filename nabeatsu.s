; nabeatsu.s
; 最強のNABEATSU☆を目指す

; 各レジスタの内容
;   r8: 2進数カウント
;   r9: BCDカウント
;   r10: （ ＾ω＾）おっを格納

; コードセクション
section .text
    global _start                           ; _startを指名

; スタート
_start:                                     ; メインのポイント
                                            ; 必要な値の代入
    mov r8, 1                             ; カウントの初期化

                                            ; 100回ループする
    mov rcx, 10000                       ; ループ回数の指定
    ; 数値とボケの表示
    mov r9, 0x32; 00110010 => 32

SET_FORMAT:
    mov rax, r9
    mov rsp, message + 0x14
    mov r15, message + length

SET_FORMAT_LOOP:
    mov r10, 0xF
    and r10, rax
    add r10, 0x30
    push r10
    shr rax, 4
    jnz SET_FORMAT_LOOP

PRINT:
    mov rcx, message         ;メッセージ
    mov rdx, length         ;メッセージの長さ
    mov rbx, 1           ;標準出力を指定
    mov rax, 4           ;システムコール番号 (sys_write)
    int 0x80

    ;loop  CHECK_THREE_MALTIPLE             ; ループバック

; 後処理
FIN:
    ; プロセス終了
    mov rax, 1                            ; 返り値を1にする
    mov rbx, 0                            ; 終了ステータスコード
    int 0x80                              ; システムコール

; 3の倍数か調べる（今回は無視）
CHECK_THREE_MALTIPLE:
    mov   rdx, 0                            ; 除算 r8÷3(rbx)=rax...rdx
    mov   rax, r8
    mov   rbx, 3
    div   rbx

    cmp   rdx, 0                            ; 除算のあまりと0を比較し
    ;je    SET_ABNOMAL_FMT                  ; 0ならprint_abnomalにジャンプ
    mov   r9,  r8

; 3がつく数字か調べる（今回は無視）
CHECK_IN_THREE:
    mov   rdx, 0                            ; 除算 r9÷10(rbx)=rax...rdx
    mov   rax, r9
    mov   rbx, 10
    div   rbx

    mov   r9, rax                           ; 次のループで10で割られた後の数値をかけるようにする

    cmp   rdx, 3                            ; 除算のあまりと3を比較し
    je    SET_ABNOMAL_FMT                  ; 0ならprint_abnomalにジャンプ
    cmp   rax, 0                            ; 除算のあまりと0を比較し
    jne   CHECK_IN_THREE                   ; 0ならprint_abnomalにジャンプ

    ;mov   rdi, nomal_fmt                    ; printfのフォーマットをレジスタに置く



; 3で割り切れる数字、もしくは３のつく数字がついたとき、呼び出される
; printfのフォーマットのレジスタを変更する（今回は無視）
SET_ABNOMAL_FMT:
;    mov   rdi, abnomal_fmt                  ; printfのフォーマットをレジスタに格納
;    jmp   PRINT                            ; もとの場所に戻る


section  .data                  ; データセクションの定義
    message  db 'AAAA'
    times 9 db 0x00
    point equ $
    length   equ point - message         ; 文字列の長さ

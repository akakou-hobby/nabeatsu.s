; nabeatsu.s
; 最強のNABEATSU☆を目指す

; 各レジスタの内容
;   r12: 2進数カウント
;   r13: BCDカウント
;   r10: （ ＾ω＾）おっを格納

; コードセクション
section .text
    global _start                           ; _startを指名

; スタート
_start:                                     ; メインのポイント
                                            ; 必要な値の代入
    mov r12, 1                               ; カウントの初期化

                                            ; 100回ループする
    mov rcx, 99                            ; ループ回数の指定
                                            ; 数値とボケの表示
    mov r13, 1                               ; 00110010 => 32

SET_FORMAT:
    mov rsp, message + 0x17
    mov rbp, message
    mov rax, r13

SET_FORMAT_LOOP:
    inc r8
    mov rbx, 0xF
    and rbx, rax
    add rbx, 0x30
    push rbx
    shr rax, 4
    jnz SET_FORMAT_LOOP

PRINT:
    mov r14, rcx
    mov rcx, message                        ;メッセージ
    mov rdx, 17                             ;メッセージの長さ
    mov rbx, 1                              ;標準出力を指定
    mov rax, 4                              ;システムコール番号 (sys_write)
    int 0x80

    mov rcx, r14

COUNT:
    inc r12
    inc r13
    mov rax, r13
    and rax, 0xF
    cmp rax, 0xA

    jne LOOP_BACK

CARRY_UP:
    add r13, 6

LOOP_BACK:
    loop SET_FORMAT

; 後処理
FIN:
                                            ; プロセス終了
    mov rax, 1                              ; 返り値を1にする
    mov rbx, 0                              ; 終了ステータスコード
    int 0x80                                ; システムコール



section  .data                  ; データセクションの定義
    message  db 0xA, '(BOKE)'
    times 9 db 0x00

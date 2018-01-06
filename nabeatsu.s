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
                                            ; 数値とボケの表示
    mov r13, 1                               ; 00110010 => 32

CHECK_THREE_MULTIPLE:
    mov rdx, 0                            ; 除算 r12÷3(rbx)=rax...rdx
    mov rax, r12
    mov rbx, 3
    div rbx

    cmp rdx, 0                            ; 除算のあまりと0を比較し
    je SET_BOKE_FMT                  ; 0ならprint_abnomalにジャンプ

    mov r9,  r12

CHECK_IN_THREE:
    mov rdx, 0                            ; 除算 r9÷10(rbx)=rax...rdx
    mov rax, r9
    mov rbx, 10
    div rbx

    mov r9, rax                           ; 次のループで10で割られた後の数値をかけるようにする

    cmp rdx, 3                            ; 除算のあまりと3を比較し
    je SET_BOKE_FMT                  ; 0ならprint_abnomalにジャンプ
    cmp rax, 0                            ; 除算のあまりと0を比較し
    jne CHECK_IN_THREE                   ; 0ならprint_abnomalにジャンプ


SET_NOMAL_FORMAT:
    mov rbp, normal_message
    mov rax, r13
    mov r15, 15
    add r15, rbp

SET_FORMAT_LOOP:
    dec r15
    mov rbx, 0xF
    and rbx, rax
    add rbx, 0x30
    mov [r15], bl
    shr rax, 4
    jnz SET_FORMAT_LOOP

PRINT:
    mov r14, rcx
    mov rcx, rbp                            ;メッセージ
    mov rdx, 17                             ;メッセージの長さ
    mov rbx, 1                              ;標準出力を指定
    mov rax, 4                              ;システムコール番号 (sys_write)
    int 0x80

    mov rcx, r14

COUNT:
    inc r12
    inc r13
    mov r9, r13
    mov r11, 0xF
    xor r8, r8

CARRY_UP:
    inc r8
    cmp r8, 9
    je LOOP_BACK

    mov r10, 0xF
    and r10, r9
    cmp r10, 0xA
    je CARRY_UP_BCD

    cmp r10, 0xB
    je CARRY_UP_BCD

    shr r9, 4
    shl r11, 4
    or r11, 0xF

LOOP_BACK:
    cmp r12, 100000
    jne CHECK_THREE_MULTIPLE

; 後処理
FIN:
                                            ; プロセス終了
    mov rax, 1                              ; 返り値を1にする
    mov rbx, 0                              ; 終了ステータスコード
    int 0x80                                ; システムコール

CARRY_UP_BCD:
    or r13, r11
    inc r13

    or r9, 0xF
    inc r9

    shr r9, 4
    shl r11, 4
    or r11, 0xF

    jmp CARRY_UP

SET_BOKE_FMT:
    mov rbp, boke_message
    mov rax, r13

    mov r15, 15
    add r15, rbp

    jmp SET_FORMAT_LOOP

section  .data                  ; データセクションの定義
    boke_message  db 0xA, "(BOKE)          "
    times 20 db 0x00
    normal_message db 0xA, "                "
    times 20 db 0x00

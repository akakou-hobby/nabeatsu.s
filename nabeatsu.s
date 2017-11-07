                                            ; 初期設定
extern  printf                              ; printf関数を持ってくる

; データセクション
section .data                               ; printfで使うフォーマット
    nomal_fmt:    db "%d", 10, 0            ; 普通の方
    abnomal_fmt:  db "%d （ ＾ω＾）", 10, 0  ; ボケる方
; コードセクション
section .text
    global _start                           ; _startを指名


; スタート
_start:                                     ; メインのポイント
                                            ; 必要な値の代入
    push  rbp                               ; スタックフレームのセット
    mov   r8, 1                             ; カウントの初期化

                                            ; 100回ループする
    mov   rcx, 100                          ; ループ回数の指定

; 3の倍数か調べる
_check_three_multiple:
    mov   rdx, 0                            ; 除算 r8÷3(rbx)=rax...rdx
    mov   rax, r8
    mov   rbx, 3
    div   rbx
                                            ; printfに使うレジスタの値を指定のレジスタに移動
    mov   rsi, r8                           ; 表示する値を指定のレジスタに置く

    cmp   rdx, 0                            ; 除算のあまりと0を比較し
    je    _set_abnomal_fmt                  ; 0ならprint_abnomalにジャンプ
    mov   r9,  r8

; 3がつく文字か調べる
_check_in_three:
    mov   rdx, 0                            ; 除算 r9÷10(rbx)=rax...rdx
    mov   rax, r9
    mov   rbx, 10
    div   rbx

    mov   r9, rax                           ; 次のループで10で割られた後の数値をかけるようにする
    
    cmp   rdx, 3                            ; 除算のあまりと3を比較し
    je    _set_abnomal_fmt                  ; 0ならprint_abnomalにジャンプ
    cmp   rax, 0                            ; 除算のあまりと0を比較し
    jne   _check_in_three                   ; 0ならprint_abnomalにジャンプ

    mov   rdi, nomal_fmt                    ; printfのフォーマットをレジスタに置く

; 数値とボケの表示
_print:
    push  rcx                               ; 必要なレジスタの値をスタックに避難
    push  r8
    mov   rax, 0                            ; 各レジスタを初期化
    mov   rbx, 0
    mov   rdx, 0

    call  printf                            ; printfを呼ぶ

    pop   r8                                ; スタックの値をレジスタに戻す
    pop   rcx
    inc   r8                                ; r8のカウントをすすめる

    loop  _check_three_multiple             ; ループバック

; 後処理
_end:
    pop   rbp                               ; スタックを戻す

    ; プロセス終了
    mov   rax, 1                            ; 返り値を1にする
    mov   rbx, 0                            ; 終了ステータスコード
    int   0x80                              ; システムコール

; 3で割り切れる数字、もしくは３のつく数字がついたとき、呼び出される
; printfのフォーマットのレジスタを変更する
_set_abnomal_fmt:
    mov   rdi, abnomal_fmt                  ; printfのフォーマットをレジスタに格納
    jmp   _print                            ; もとの場所に戻る

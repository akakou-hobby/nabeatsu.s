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

_loop:
    mov   rdx, 0                            ; 除算 r8÷3(rbx)=rax...rdx
    mov   rax, r8
    mov   rbx, 3
    div   rbx

                                            ; printfに使うレジスタの値を指定のレジスタに移動
    mov   rsi, r8                           ; 表示する値を指定のレジスタに置く

    cmp   rdx, 0                            ; 除算のあまりと0を比較し
    je    print_abnomal                     ; 0ならprint_abnomalにジャンプ

    mov   rdi, nomal_fmt                    ; printfのフォーマットをレジスタに置く
    print_abnomal_back:

    push  rcx                               ; 必要なレジスタの値をスタックに避難
    push  r8
    mov   rax, 0                            ; 各レジスタを初期化
    mov   rbx, 0
    mov   rdx, 0

    call  printf                            ; printfを呼ぶ

    pop   r8                                ; スタックの値をレジスタに戻す
    pop   rcx
    inc   r8                                ; r8のカウントをすすめる

    loop  _loop                             ; ループバック

; 後処理
_end:
    pop   rbp                               ; スタックを戻す

    ; プロセス終了
    mov   rax, 1                            ; 返り値を1にする
    mov   rbx, 0                            ; 終了ステータスコード
    int   0x80                              ; システムコール

                                            ; 3で割り切れる数字、もしくは３のつく数字がついたとき、呼び出される
                                            ; printfのフォーマットのレジスタを変更する
print_abnomal:
    mov   rdi, abnomal_fmt                  ; printfのフォーマットをレジスタ
    jmp   print_abnomal_back                ; もとの場所に戻る

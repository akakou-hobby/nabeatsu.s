; 初期設定
extern  printf                  ; printf関数を持ってくる

; データセクション
section .data
    fmt:    db "%d", 10, 0      ; printfで使うフォーマット

; コードセクション
section .text
    global _start               ; _startを指名


; スタート
_start:                         ; メインのポイント
    ; 必要な値の代入
    push  rbp                   ; スタックフレームのセット
    mov   rdx, 1                ; カウントの初期化

    ; 100回ループする
    mov rcx, 100                ; ループ回数の指定


_loop:
    ; レジスタの値をスタックに移動
    push  rcx               ; rcxをスタックに置く
    push  rdx               ; rdxをスタックに置く
    ; printfに使うレジスタの値を指定のレジスタに移動
    mov    rdi, fmt         ; printfのフォーマットをレジスタに置く
    mov    rsi, rdx         ; 表示する値を指定のレジスタに置く
    mov    rax, 0           ; わからない → 消すとセグフォする

    call  printf            ; printfを呼ぶ
    ; スタックの値をレジスタに戻す
    pop   rdx               ; rdxをスタックから持ってくる
    pop   rcx               ; rcxをスタックから持ってくる
    add   rdx, 1            ; rdxに１加算

    loop _loop              ; ループバック


_end:
    ; 後処理
    pop   rbp                   ; スタックを戻す

    ; プロセス終了
    mov   rax, 1                ; sys_exit
    mov   rbx, 0                ; 終了ステータスコード
    int   0x80                  ; システムコール

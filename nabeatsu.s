; nabeatsu.s
; 最強のNABEATSU☆を目指す


; コードセクション
section .text
    global _start                           ; _startを指名

; スタート
_start:
                                            ; カウント用レジスタの初期化
    mov r12, 1                              ; ボケるか判定用カウントレジスタ（普通にカウントする）
    mov r13, 1                              ; 表示用カウントレジスタ（BCDでカウントする）

; 3の倍数かをチェックする
CHECK_THREE_MULTIPLE:
    xor rdx, rdx
                                            ; r12を3で割る
    mov rax, r12                            ; r12/3(rbx) = rax...rdx
    mov rbx, 3
    div rbx

    cmp rdx, 0                              ; 除算の余りと0を比較する
    je SET_BOKE_FMT                         ; 0ならprint_abnomalにジャンプする

    mov r9,  r12                            ; r12(ボケるか判定用カウントレジスタ)をr9（3を含む数値か判定用レジスタ）にコピー

; 3のつく数字化をチェックする
CHECK_IN_THREE:
    xor rdx, rdx
                                            ; r9を10で割る（左から1桁取り出す）
    mov rax, r9                             ; r9/10 = rax...rdx(取り出した1桁)
    mov rbx, 10
    div rbx

    mov r9, rax                             ; r9を10で割った値をr9に格納

    cmp rdx, 3                              ; 除算の余りと3を比較する
    je SET_BOKE_FMT                         ; 余りが0ならprint_abnomalにジャンプする

    cmp rax, 0                              ; 除算のあまりと0を比較し
    jne CHECK_IN_THREE                      ; 余りが0ならprint_abnomalにジャンプする

; 普通のフォーマット（数値のみを表示）をrbpに格納する。
SET_NOMAL_FORMAT:
    mov rbp, normal_message                 ; rbpに数値のみ表示するフォーマットを格納する

; 次の処理の準備 & `SET_NOMAL_FORMAT`からのジャンプバック用ラベル
READY_TO_SET_FORMAT_LOOP:
    mov rax, r13                            ; rax(今回表示する値が入ってるレジスタ)にr13（表示用カウントレジスタ）の値をコピー
    mov r15, 15                             ; r15に15（最大このプログラムの耐えられる最大桁数）
    add r15, rbp                            ; rbpの値(指定したフォーマットの文字列)と最大値を足した値をr15（次に格納する文字のアドレス先）に格納

; r13から1文字ずつ取り出す
SET_FORMAT_LOOP:
    dec r15                                 ; r15を1つ減算する
    mov rbx, 0xF                            ; rbxに0xFを格納
    and rbx, rax                            ; raxと0xFに論理和をかけることで、16進数での1桁分取り出し、rbxに格納
    add rbx, 0x30                           ; rbxに格納された1桁の数値に0x30を足すことで、ASCIIの文字のデータにする
    mov [r15], bl                           ; bl(rbxから1バイト分のデータ)をr15の持つアドレス先に書き込む
    shr rax, 4                              ; 16進数におけるBCDでの1桁分右にシフトする。
    jnz SET_FORMAT_LOOP                     ; raxが0になるまでSET_FORMAT_LOOPを回し続ける

; 文字列を表示
PRINT:
    mov r14, rcx                            ; rcxの値をr14に退避

    mov rcx, rbp                            ; メッセージのアドレス
    mov rdx, 17                             ; メッセージの長さ
    mov rbx, 1                              ; 標準出力を指定
    mov rax, 4                              ; システムコール番号 (sys_write)
    int 0x80                                ; 割り込み

    mov rcx, r14                            ; r14に退避させた値をrcxに戻す

; カウントをする
COUNT:
    inc r12                                 ; r12に1加算
    inc r13                                 ; r13に1加算

    mov r9, r13                             ; r9（繰り上がれてないか確認用レジスタ）にr13（表示用カウントレジスタ）をコピー
    mov r11, 0xF                            ; r11に0xFを格納
    xor r8, r8

; 表示用カウントレジスタ(BCD)の桁上がりチェック
CARRY_UP:
                                            ; 各桁に0xAが含まれていないか確認し、含まれていたら`CARRY_UP_BCD`を呼ぶ
    mov r10, 0xF                            ; r10に0xFを格納
    and r10, r9                             ; r10にr9の右から1桁分を格納させる
    cmp r10, 0xA                            ; r10（上の処理で取った1桁分）と0xA（BCDではありえない値）かを確認
    je CARRY_UP_BCD                         ; r10が0xAなら繰り上がりをする

                                            ; 二重繰り上がりが起きたときの処理
    cmp r10, 0xB                            ; r10に0xBが格納されていないかを確認
    je CARRY_UP_BCD                         ; r10が0xBなら繰り上がりをする（0xC以上は理論上ありえない）

; 次のカウント後の処理へジャンプする
LOOP_BACK:
    cmp r12, 1000000                        ; 最大カウント回数（100000）とr12（通常カウント）を比較
    jne CHECK_THREE_MULTIPLE                ; 同じになるまでCHECK_THREE_MULTIPLEに戻る

; 終了処理
FIN:
                                            ; プロセス終了
    mov rax, 1                              ; 返り値を1にする
    mov rbx, 0                              ; 終了ステータスコード
    int 0x80                                ; システムコール

; 表示用カウントレジスタ(BCD)の桁上がり処理
CARRY_UP_BCD:
    or r13, r11                             ; うまく繰り上がれてない値(r13)の、繰り上がれてない部分をすべて二進数の1で埋めて
    inc r13                                 ; 1を足す → 強制的に繰り上がらせる

    or r9, 0xF                              ; r9（繰り上がれてないか確認用レジスタ）の方も
    inc r9                                  ; 繰り上がりしておく（ここで二重繰り上がりの可能性あり）

    shr r9, 4                               ; r9の値を右に1文字分（16進数ひと桁分）シフトする
    shl r11, 4                              ; `CARRY_UP_BCD`で使う対象以下の2進数での桁を1で埋めたもの（マスク）を更新する
    or r11, 0xF

    jmp CARRY_UP                            ; `CARRY_UP`に戻る

; ボケるときのフォーマットをrbpに格納
SET_BOKE_FMT:
    mov rbp, boke_message                   ; rbpにボケたときのメッセージフォーマットを格納
    jmp READY_TO_SET_FORMAT_LOOP            ; `READY_TO_SET_FORMAT_LOOP`にジャンプする（戻る）


; データセクション
section  .data                              ; データセクションの定義
    boke_message  db 0xA, "(BOKE)          "    ; boke_messageの内容
    times 20 db 0x00

    normal_message db 0xA, "                "   ; normal_messageの内容
    times 20 db 0x00

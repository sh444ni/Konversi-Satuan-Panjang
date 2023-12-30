.MODEL SMALL
.STACK 100H
.DATA

MSG1 DB '*=========================*$'
MSG2 DB 10,13,'||KONVERSI SATUAN PANJANG||$'
MSG3 DB 10,13,'*=========================*$'
MSG4 DB 10,13,'|| KM -> HM KETIK    : 1  ||$'
MSG5 DB 10,13,'|| KM -> DAM KETIK   : 2  ||$'
MSG6 DB 10,13,'|| KM -> M KETIK     : 3  ||$'
MSG7 DB 10,13,'|| KM -> DM KETIK    : 4  ||$'
MSG8 DB 10,13,'*=========================*$'
MSG9 DB 10,13,'MASUKKAN PILIHAN :$'
MSG10 DB 10,13,10,13,'MASUKKAN KM:$'
MSG11 DB 10,13,10,13,'HASILNYA ADALAH:$'

NUM1 DB ?
HASIL DW ?
OP DB ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Print judul
    MOV AH, 9
    LEA DX, MSG1
    INT 21H

    ; Tampilkan pilihan konversi
    MOV AH, 9
    LEA DX, MSG2
    INT 21H
    MOV AH, 9
    LEA DX, MSG3
    INT 21H
    MOV AH, 9
    LEA DX, MSG4
    INT 21H
    MOV AH, 9
    LEA DX, MSG5
    INT 21H
    MOV AH, 9
    LEA DX, MSG6
    INT 21H
    MOV AH, 9
    LEA DX, MSG7
    INT 21H
    MOV AH, 9
    LEA DX, MSG8
    INT 21H

    ; Input pilihan
    MOV AH, 9
    LEA DX, MSG9
    INT 21H
    MOV AH, 1
    INT 21H
    SUB AL, '0'    ; Konversi karakter ke angka
    MOV OP, AL

    ; Input KM
    MOV AH, 9
    LEA DX, MSG10
    INT 21H
    MOV AH, 1
    INT 21H
    SUB AL, '0'    ; Konversi karakter ke angka
    MOV NUM1, AL

    ; Proses konversi
    CMP OP, 1
    JE  KM_HM
    CMP OP, 2
    JE  KM_DAM
    CMP OP, 3
    JE  KM_M
    CMP OP, 4
    JE  KM_DM

KM_HM:
    MOV AX, NUM1
    MOV BL, 10       ; Konversi KM ke HM (1 KM = 10 HM)
    MUL BL           ; AX = AX * BL
    MOV HASIL, AX   ; Gunakan AX sebagai hasil 16-bit
    JMP  HASIL_AKHIR
KM_DAM:
    MOV AX, 0         ; Reset AX
    MOV AL, NUM1
    MOV CX, 100      ; Konversi KM ke DAM (1 KM = 100 DAM)
    MUL CX           ; AX = AX * CX
    MOV HASIL, AX
    JMP  HASIL_AKHIR
KM_M:
    MOV AX, 0         ; Reset AX
    MOV AL, NUM1
    MOV CX, 1000     ; Konversi KM ke M (1 KM = 1000 M)
    MUL CX           ; AX = AX * CX
    MOV HASIL, AX
    JMP  HASIL_AKHIR
KM_DM:
    MOV AX, 0         ; Reset AX
    MOV AL, NUM1
    MOV CX, 10000    ; Konversi KM ke DM (1 KM = 10000 DM)
    MUL CX           ; AX = AX * CX
    MOV HASIL, AX
    JMP  HASIL_AKHIR

HASIL_AKHIR:

    ; Tampilkan hasil konversi  
    MOV AH, 9
    LEA DX, MSG11
    INT 21H

    ; Tampilkan hasil digit per digit
    MOV BX, 10
    MOV CX, 0
    MOV AX, HASIL
    
ANGKA: 
    MOV DX, 0
    DIV BX ; AX = QUOTIENT, DX = REMAINDER
    PUSH DX
    INC CX
    CMP AX, 0 
    JNE ANGKA
    
CETAK:
    POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    DEC CX
    JNZ CETAK

    ; Akhir program
    MOV AH, 4CH  
    INT 21H

MAIN ENDP
END MAIN
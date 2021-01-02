            
_reset:             DWI _sieve

.advance 16

_trap_div_by_0:     DWI _end

.advance 64
.dw 1, 4, 7, 0, 2, 5, 8, 10, 3, 6, 9, 16, 11, 12, 13, 14

.advance 464
bench_size:         DWI 8192    

.advance 512

_end:       BRA     _end        ; 100
            BRA     _end        ; 101

_boot:      LD      A, #0       ; 102
            LH      X, #0xFF    ; 103
            ST      X, 44       ; 105
            ADD     X, #4       ; 106
            LD      Y, #4       ; 107
.L0:        ST      A, (X, 0)   ; 108
            ADD     X, #1       ; 109
            SUB     Y, #1       ; 110
            BNE     Y, .L0      ; 111
            LD      X, 44       ; 111
            LD      A, #3       ; 112
            ST      A, 32
.L2:        CALL    _digit
            LD      A, 44
            ADD     A, #5           ; 0xFF05
            CALL    _shl_digit      ; 0xFF04
            ADD     A, #2           ; 0xFF06
            CALL    _shl_digit      ; 0xFF05
            ADD     A, #2           ; 0xFF07
            CALL    _shl_digit      ; 0xFF06
            ADD     A, #1
            LD      Y, 50
            ST      Y, (A, 0)
            LD      A, 32
            SUB     A, #1
            BNE     A, .L2
            
            ADD     X, 4
            LD      A, #0
            ST      A, 42
            LD      Y, #3
.stop:      LD      A, (X, 0)
            ADD     A, 42
            ASL     A
            ST      A, 40
            ASL     A
            ASL     A
            ADD     A, 40
            ST      A, 42
            SUB     Y, #1
            ADD     X, #1
            BNE     Y, .stop
.st:        ST      A, 200
            BRA     .st

_shl_digit: LD      Y, (A, 0)
            SUB     A, #1
            ST      Y, (A, 0)
            RET
           
_digit:     LD      Y, (X, 1)
            BEQ     Y, _digit
            LD      Y, (X, 0)
            LD      Y, (Y, 32)
            ST      Y, 50
            RET
           
            ; sieve( iter : u16 )
_sieve:     LH      X, #0xA0
            ST      A, 200
            CALL    _bin2bcd
            LD      A, 200
            SUB     A, #1
        
            ; FOR 1 TO 10
.L0:        BEQ     A, .RET
            ST      A, 200
            LD      X, bench_size
            LD      Y, bench_size
            LD      A, #1
            CALL    _memset
            LD      X, #0
            ST      X, 198
        
            ; FOR I := 0 TO 8192
.L1:        LD      X, 198
            SUB     X, bench_size
            BEQ     X, .L0
            LD      Y, bench_size
            ADD     Y, 198
            LD      A, (Y, 0)
                
            ; IF FLAGS[I]
            BNE     A, .L1
            LD      X, 200
            ASL     X
            ADD     X, #3
            ST      X, 194  ; PRIME
            LD      A, #1
            ADD     A, 194  ; K
                
            ; WHILE K < SIZE
.L2:        LD      Y, #0
            SUB     X, bench_size
            BEQ     X, .L1
            ICY     Y
            BEQ     Y, .L1
            
            SUB     Y, #1
            ST      Y, (A, 0)
            ST      A, 196
            LD      X, 196
            ADD     A, 194
            ADD     X, 194
            BRA     .L2

.RET:       LD      Y, bench_size
            LD      X, bench_size
            LD      A, (X, 0)
            ST      A, 192
            ADD     A, 192
            SUB     Y, #1
            ADD     Y, #1
            BNE     Y, .RET
            RET
            
        
.include     "rt.s"
            
            
            

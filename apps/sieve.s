            
_reset:             DWI _main

.advance 16

_trap_div_by_0:     DWI _end

.advance 464
bench_size:         DWI 8192    

.advance 512

_end:       BRA     _end
            BRA     _end
            
_main:
            LD      A, #10
            CALL    _sieve
            BRA     _end
           
            ; sieve( iter : u16 )
_sieve:     LD      X, #200
            ST      A, 199
            CALL    _bin2bcd
            LD      A, 199
            SUB     A, #1
        
            ; FOR 1 TO 10
.L0:        BEQ     A, .RET
            ST      A, 199
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
            LD      X, 199
            ASL     X
            ADD     X, #3
            ST      X, 197  ; PRIME
            LD      A, #1
            ADD     A, 197  ; K
                
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
            ADD     A, 197
            ADD     X, 197
            BRA     .L2

.RET:       LD      Y, bench_size
            LD      X, bench_size
            LD      A, (X, 0)
            ST      A, 195
            ADD     A, 195
            SUB     Y, #1
            ADD     Y, #1
            BNE     Y, .RET
            RET

_find:      LD      Y, (A, 0)
            ST      Y, 17   ; 17 = array_0, 18 = arr*, 19 = ret, 20 = grt, 21 = FFFF
            ST      A, 18
            ST      L, 19
            LD      L, #30
            LD      Y, #0
            ST      Y, 20
            SUB     Y, #1
            ST      Y, 21
.L0:        SUB     L, #1
            BEQ     L, .FAIL
            LD      A, (X, 0)
            ST      A, 22
            LD      Y, #0
            CMP     A, 17
            ICY     Y
            EOR     Y, 21
            ADD     Y, #2
            ADD     Y, 20
            ST      Y, 20
            SUB     A, #255
            LD      X, 22
            ADD     X, 18
            BNE     Y, .L0
            LD      L, 19
            RET
.FAIL:      LD      A, #255
            LD      L, 19
            RET
            
        
.include     "rt.s"
            
            
            

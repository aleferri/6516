            
_reset:             .word _main

.advance 8

_trap_div_by_0:     .word _halt

.advance 232
bench_size:         .word #8192    

.advance 256

_end:       JMP     P, _end
            JMP     P, _end
            
_main:
            LD      A, #10
            CALL    _sieve
            JMP     _end
           
            ; sieve( iter : u16 )
_sieve:     LD      X, #200
.alias i        199
.alias j        198
.alias count    197
            ST      A, .i
            CALL    _dec2bcd
            LD      A, .i
            SUB     A, #1
        
            ; FOR 1 TO 10
.L0:        BEQ     A, .RET
            ST      A, .i
            LD      X, bench_size
            LD      Y, bench_size
            LD      A, #1
            CALL    _memset
            LD      X, #0
            ST      X, .j
        
            ; FOR I := 0 TO 8192
.L1:        LD      X, .j
            SUB     X, bench_size
            BEQ     X, .BREAK
            LD      Y, bench_size
            ADD     Y, .j
            LD      A, (Y, 0)
                
            ; IF FLAGS[I]
            BNE     A, .L1
            LD      X, .i
            ASL     X
            ADD     X, #3
            ST      X, 197  ; PRIME
            LD      A, #1
            ADD     A, 197  ; K
                
            ; WHILE K < SIZE
.L2:        LD      Y, #0
            SUB     X, .bench_size
            BEQ     X, .L1
            ICY     Y
            BEQ     Y, .L1
            
            SUB     Y, #1
            ST      Y, (A, 0)
            ST      A, 196
            LD      X, 196
            ADD     A, 197
            ADD     X, 197
            JMP     .L2

.RET:       LD      Y, bench_size
            LD      X, bench_size
            LD      A, (X, 0)
            ST      A, 195
            ADD     A, 195
            SUB     Y, #1
            ADD     Y. #1
            BNE     Y, .RET
            RET
        
.include     "rt.s"
            
            ; div_u16( a : u16, b : u16 ) -> u16
_div_u16:   BNE     A, .L0
            RET
.L0:        BNE     X, .setup
            LD      A, 16
            LD      Y, _trap_div_by_0
            JMP     Y, 0
.setup:
            
            
            

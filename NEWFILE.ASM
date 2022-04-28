; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                ld b,255
                        ld hl, 5800h
bucle1                   ld a, 00101000b
                        ld (hl), a
                        inc hl
                        djnz bucle1


bucle2                   ld a, 00101000b
                        ld (hl), a
                        inc hl
                        djnz bucle2

bucle3                   ld a, 00101000b
                        ld (hl), a
                        inc hl
                        djnz bucle3
ld (hl),a               ld b,32                 ld hl,5800h

borde1                  ld a, 01001000b
                        ld (hl),a
                        inc hl
                        djnz borde1


ld b,32                ADD hl,32*22

borde2                 ld a, 01001000b
                        ld (hl),a
                        inc hl
                        djnz borde2
ld b,24                 ld hl,5800h

borde3                  ld a,01001000b
                        ld (hl),a
                        ADD hl,32
                        djnz borde3

ld b,24                 ld hl,5800h     ADD hl,31

borde4                  ld a,01001000b
                        ld (hl),a
                        ADD hl,32
                        djnz borde4

actualizar              halt
                        ld a,00101000b
                        ld hl,(bomba_pos)
                        ld (hl),a
                        ld a,(bomba_pos)
                        ADD a,32
                        ld (bomba_pos),a
                        ld hl,(bomba_pos)
                        ld a,01010000b
                        ld (hl),a
                        ld hl,(jugador_pos)
                        ld a,01100000b
                        ld (hl),a
jp actualizar





fin                     halt                            ; Replace these lines with your code
                        jp fin

bomba_pos defw 5810h
jugador_pos defw 5800h+2B0h


; Stop planting code after this. (When generating a tape file we save bytes below here)
AppLast                 equ *-1                         ; The last used byte's address

; Generate some useful debugging commands

                        profile AppFirst,AppLast-AppFirst+1     ; Enable profiling for all the code

; Setup the emulation registers, so Zeus can emulate this code correctly

Zeus_PC                 equ AppEntry                            ; Tell the emulator where to start
Zeus_SP                 equ $FF40                               ; Tell the emulator where to put the stack

; These generate some output files

                        ; Generate a SZX file
                        output_szx AppFilename+".szx",$0000,AppEntry    ; The szx file

                        ; If we want a fancy loader we need to load a loading screen
;                        import_bin AppFilename+".scr",$4000            ; Load a loading screen

                        ; Now, also generate a tzx file using the loader
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry ; A tzx file using the loader



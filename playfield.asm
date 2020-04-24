
	processor 6502
  include "vcs.h"
  include "macro.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Variables segment

  seg.u Variables
	org $80

Temp		.byte

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code segment

	seg Code
  org $f000

Start:
	CLEAN_START
        
  ldx #$64
  stx COLUBK
        
  lda #$1C
  sta COLUPF

StartFrame:
	lda #02
  sta VBLANK
  sta VSYNC
        
  repeat 3
    sta WSYNC
  repend
  lda #0
  sta VSYNC
         
  repeat 37
    sta WSYNC
  repend
  lda #0
  sta VBLANK
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set the CTRLPF to allow playfield reflection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
        LDX #%00000001	       ;CTRLPF register (D0 means reflect the PF)
        stx CTRLPF
        
        ;Skip 7 scanlines with no PF set
        ldx #0
        stx PF0
        stx PF1
        stx PF2
        repeat 7
        	sta WSYNC
        repend
        
        ; Set the PF0 to 1110 (LSB FIRST) AND PF1/2 A 11111111
        ldx #%11100000
        stx PF0
        ldx #%11111111
        stx PF1
        stx PF2
        repeat 7
        	sta WSYNC
        repend
        
       ;set the next 164 lines only with PF0 third bit enabled
       ldx #%00100000
       stx PF0
       ldx #0
       stx PF1
       ldx #%10000000
       stx PF2
       repeat 164
       		sta WSYNC
       repend
               
        ; Set the PF0 to 1110 (LSB FIRST) AND PF1/2 A 11111111
        ldx #%11100000
        stx PF0
        ldx #%11111111
        stx PF1
        stx PF2
        repeat 7
        	sta WSYNC
        repend
        
        ;Skip 7 scanlines with no PF set
        ldx #0
        stx PF0
        stx PF1
        stx PF2
        repeat 7
        	sta WSYNC
        repend
       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Output 30 more VBLANK overscan lines to complete frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       
       lda #2
       sta VBLANK
       repeat 30
       		sta WSYNC
       repend
       
       jmp StartFrame
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Epilogue

	org $fffc
        .word Start	; reset vector
        .word Start	; BRK vector

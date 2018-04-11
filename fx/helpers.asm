\ ******************************************************************
\ *	FX Helper functions
\ ******************************************************************

.helpers_start

\\ Move these to FX helper module

.crtc_reset
{
	LDX #13
	.crtcloop
	STX &FE00
	LDA crtc_regs_high,X
	STA &FE01
	DEX
	BPL crtcloop
	RTS
}

.crtc_regs_high
{
	EQUB 127			; R0  horizontal total
	EQUB 80				; R1  horizontal displayed
	EQUB 98				; R2  horizontal position
	EQUB &28			; R3  sync width 40 = &28
	EQUB 38				; R4  vertical total
	EQUB 0				; R5  vertical total adjust
	EQUB 32				; R6  vertical displayed
	EQUB 35				; R7  vertical position; 35=top of screen
	EQUB 0				; R8  interlace
	EQUB 7				; R9  scanlines per row
	EQUB 32				; R10 cursor start
	EQUB 8				; R11 cursor end
	EQUB HI(screen_base_addr/8)		; R12 screen start address, high
	EQUB LO(screen_base_addr/8)		; R13 screen start address, low
}

.ula_pal_reset
{
	LDX #15
	.palloop
	LDA ula_pal_defaults, X
	STA &FE21
	DEX
	BPL palloop
	RTS	
}

.ula_pal_defaults
{
	EQUB &00 + PAL_black
	EQUB &10 + PAL_red
	EQUB &20 + PAL_green
	EQUB &30 + PAL_yellow
	EQUB &40 + PAL_blue
	EQUB &50 + PAL_magenta
	EQUB &60 + PAL_cyan
	EQUB &70 + PAL_white
	EQUB &80 + PAL_black
	EQUB &90 + PAL_red
	EQUB &A0 + PAL_green
	EQUB &B0 + PAL_yellow
	EQUB &C0 + PAL_blue
	EQUB &D0 + PAL_magenta
	EQUB &E0 + PAL_cyan
	EQUB &F0 + PAL_white
}

.ula_control_reset
{
    LDA #ULA_Mode2
    STA &FE30
    RTS
}

.screen_clear_all
{
  ldx #HI(SCREEN_SIZE_BYTES)
  lda #HI(screen_base_addr)

  sta loop+2
  lda #0
  ldy #0
  .loop
  sta &3000,Y
  iny
  bne loop
  inc loop+2
  dex
  bne loop
  rts
}

.screen_clear_line0
{
	LDA #0
	FOR n,0,79
	STA screen_base_addr + n * 8
	NEXT
	RTS
}

.helpers_end
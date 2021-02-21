;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Author:	DTsebrii
;	Date:	02/21/2021
;	Description:	Program to turn on the LED on PIC12F1822 using
;					Assembly language
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;  Pin 1 VDD (+5V)		+5V
;  Pin 2 RA5		LED_1 (Active high output)
;  Pin 3 RA4		N/O
;  Pin 4 RA3		MCLR 
;  Pin 5 RA2		N/O
;  Pin 6 RA1/ICSPCLK
;  Pin 7 RA0/ICSPDAT/AN0
;  Pin 8 VSS (Ground)		Ground
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	list	p=12f1822,r=hex,w=0	; list directive to define processor
	
	nolist
	include	p12f1822.inc	; processor specific variable definitions
	list
;;;; CONFIGURATION WORDS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	__CONFIG _CONFIG1,_FOSC_INTOSC & _WDTE_OFF & _MCLRE_ON & _IESO_OFF
;	Internal oscillator, wdt is off, Pin4 is MCLR 
	__CONFIG _CONFIG2, _WRT_OFF & _PLLEN_OFF & _LVP_OFF
;	Global Variables
InitPort	EQU	b'00000000'	; PORTA all Voltage are low
TRISconf	EQU	b'11011111'	; All inputs except RA5 
AllDigit	EQU	b'00000000'	; Variable to conf ANSELA
LED			EQU	b'00000101'	; Representation of 5-th bit 

	ORG 0x00

MainRoutine
	CALL sysInit	; Function to initialize the system
loop1
	BANKSEL	LATA 
	BSF	LATA, LED
	GOTO loop1 

;;;; sysConfig ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Author:	DTsebrii
;Date:		02/21/2021
;Description:	Calling all subroutines required to 
;				configure the system
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sysInit 
	CALL portConfig
	
	RETURN

portConfig
	BANKSEL ANSELA
	MOVLW	AllDigit
	MOVWF	ANSELA		; All pins are digital
	
	BANKSEL LATA
	MOVLW	InitPort
	MOVWF	LATA		; Output voltage is low 
	
	BANKSEL TRISA
	MOVLW	TRISconf
	MOVWF	TRISA		; RA5 is output 
	
	RETURN



	END
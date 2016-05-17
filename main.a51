;Timer ile ilgili k1s1mlarda R0 registirini kullaniliyor. Bu registira karisma.

;vector table
org 0000h
	jmp main

org 0003h
	jmp ISR_EX0  ;Interrupt Service Routine External 0
	
org 001Bh
	jmp ISR_TM1  ;Interrupt Service Routine Timer 1
;-----------------------------------------	


;main program akisi
org 0030h
	main:
		;interrupt aktiflestir
		setb EX0
		setb ET1
		setb EA
		
		SETB IT0 ; set external interrupt 0 as edge activated
		
		clr P1.3; ledi sondur
		mov r1, #0 ;sure
		
		;deneme
		;mov r1, #2
		;clr P1.1
		
		;clr INT0
		;setb INT0
		
		;
		
		JMP $ ;sonsuz dongu
;----------------------------------------

;Interrupt Service Routine Timer 1
ISR_TM1:
		inc r2 ;r2 kac tane 50ms oldugunu tutacak
		CJNE r2, #20, timer ;50ms'yi 20 kez calistirip 1sn elde edecegiz
		mov r2, #0
		
		mov a, r1 ;Jz komutu a'ya bakiyor diye.
		JZ endIsr
		
		dec r1;
		JNZ timer

timer: 
	call setTimer50ms
	RETI

endIsr:
	clr P1.3 ;ledi söndür
	clr tr1 ;timer'i durdur
	RETI

;----------------------------------



;Interrupt Service Routine External 0'in handle edildigi yer
ISR_EX0:
	JNB P1.0, sureArttir
	JNB P1.1, calistir
	JNB P1.2, durdur
	RETI

	sureArttir:
		inc r1
		RETI ;interrup'i bitir

	calistir:
		SETB P1.3 ;calisinca ledi yak
		call setTimer50ms
		RETI ;interrupt'i bitir
	durdur:
		mov r1, #0
		RETI ;interrupt'i bitir
;---------------------------------------------------------------


;timer

setTimer50ms:
	MOV TMOD, #00010000b
	MOV th1, #3ah
	mov tl1, #0b1h

	setb tr1

	RET
;-----------------------------------------------------------------
finish:
	end

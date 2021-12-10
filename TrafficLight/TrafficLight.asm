;
; file:    TrafficLight.asm
; Created: 12/4/2021 3:48:11 PM
; Authors: Ragy Costa de jesus, Diego Grisales, Anthony Zarzana
; Desc:    Two way traffic light
;----------------------------------------------------------


main:

     ldi r16, 0b00111111               ; load bitmask to r16
     out DDRC, r16                     ; out bitmask to PORTC

     sbi PORTC, PC5                    ; set PORTC PC5 to output 
     sbi PORTC, PC2                    ; set PORTC PC 2 to output 

     ; bitmasks used to toogle LED's
     ldi r17, 0b00000110                  
     ldi r19, 0b00101011
     ldi r22, 0b00011000
     ldi r23, 0b00110101

     call T1Normal_3s

Red_Led:
     in  r18, PINC                     ; load data from PINC to r18
     eor r18, R17                      ; exclusive or r18 and r17 and save result in r18
     out PORTC, r18                    ; out result from eor to PORTC

     call T1Normal_3s

Yellow_Led:
     in  r20, PINC                     ; load data from PINC to r20
     eor r20, R19                      ; exclusive or r20 and r19 and save result in r20
     out PORTC, r20                    ; out result from eor to PORTC

     call T1Normal_3s

Green_Led:
     in r21, PINC                      ; load data from PINC to r21
     eor r21, r22                      ; exclusive or r21 and r22 and save result in r21
     out PORTC, r21                    ; out result from eor to PORTC

     call T1Normal_3s

While_Loop:
     in r24, PINC                      ; load data from PINC to r21
     eor r24, r23                      ; exclusive or r24 and r23 and save result in r24
     out PORTC, r24                    ; out result from eor to PORTC
     call T1Normal_3s           

     rjmp Red_Led                       



end_main:                              ; end main
     rjmp end_main



; 3 second timer
T1Normal_3s:
     ;1. Load TCNT0 with initial count

     ldi r20, $0E5                     ; 3,000,000 us clk/1024
     sts TCNT1L, r20 

     ldi r20, $48                      ; 3,000,000 us clk/1024
     sts TCNT1H, r20 

     ; Load TCCR0A & TCCR0B
     clr r20
     sts TCCR1A, r20                   ; normal mode

     ldi r20, $5
     sts TCCR1B, r20                   ; Clock prescaler - setting the clock starts the timer 

     ; Monitor TOV1 flag in TIFR0
TOV1_wait:
     sbis TIFR1, TOV1
     rjmp TOV1_wait

     ; stop timer by clearing clock (clear TCCR1B)
     clr r20
     sts TCCR1B, r20

     ; clear TOV1 flag - write a 1 to TOV0 bit in TIFR1 
     sbi TIFR1, TOV1

     ret                               ; end T1Normal_3s





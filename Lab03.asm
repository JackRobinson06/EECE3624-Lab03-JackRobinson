/**************************************************************************
 *     File: Lab03.asm
 * Lab Name: Lab 03
 *   Author: Jack Robinson
 *  Created: 09/9/2026
 *
 * This program simulates reading sensor data and doing operations on them.
 * It uses memory locations for sensors and result writes.
 * We hope to learn more about branching in assembly.
 *************************************************************************/

/************************************************************************
 * NOTE!  To populate the sensor data to memory, follow these steps!
 * 1) Set breakpoint on 1st instruction RJMP
 * 2) Set the stimulus file
 *    - Debug->Set Stimufile.  Select Lab03.stim
 *    - This only needs to be done ONCE (will save in project file)
 *    - Should be in your Project file from the Repo, but do once to be sure.
 * 3) Execute stimulus file
 *    - Debug->Execute Stimufile
 *    - This needs to be run EVERY TIME you restart a debug session.  :-(
 * 4) single step code
 * 5) Check that data IRAM at 0x0100 has changed "61 97"
 * 
 * Sensor1 Located at 0x0100 (preset to 0x61)
 * Sensor2 Located at 0x0101 (preset to 0x97)
 * 
 * NOTE:  For testing, you can modify these after loading them
 * to make sure all of your branches work properly
 ***********************************************************************/

.equ THRESHOLD = 0x90 ; Create a constant
.def Sensor1   = R20  ; Define a nickname for R20
.def Sensor2   = R21  ;Define a nickname for R20

.org 0x0000 ; next instruction will be written to address 0x0000
            ; (the location of the reset vector)
RJMP main	; set reset vector to point to the main code entry point

main:       ; jump here on reset

	; initialize the stack (RAMEND = 0x10FF by default for the ATmega128A)
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	LDI R16, low(RAMEND)
	OUT SPL, R16 
	  
	; student-written code begins here

	
	LDI YH, high(0x0100)
	LDI YL, low(0x0100)
	LD Sensor1, Y+       ; Sensor1 
	LD Sensor2, Y        ; Sensor2 

	
	LDI YH, high(0x0110)
	LDI YL, low(0x0110)

	; Test 1: Sensor1 >= THRESHOLD (unsigned)
	CPI Sensor1, THRESHOLD
	BRSH Higher
	LDI R16, 0x50
	RJMP store1
Higher:
	LDI R16, 0x46
store1:
	ST Y+, R16           ; (0x0110) <- R16, Y -> 0x0111
	ST Y+, Sensor1       ; (0x0111) <- Sensor1, Y -> 0x0112

	; Test 2: Sensor2 < THRESHOLD (signed)
	CPI Sensor2, THRESHOLD
	BRLT storei
	LDI R16, 's'
	RJMP store3
storei:
	LDI R16, 'i'
store3:
	ST Y+, R16           

	; 
	CP Sensor1, Sensor2
	BRNE notEqual
	LDI R16, 0x6C
	RJMP store4
notEqual:
	LDI R16, 0x73
store4:
	ST Y, R16            ; (0x0113) <- R16

	NOP
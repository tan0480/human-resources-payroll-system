TITLE   Assignment 	Human Resources Payroll System
.MODEL  SMALL
.STACK  64

.DATA

;--------------------------Icon-------------------------------
	COIN_ICON 	DB "    ||     ",13,10
	  		DB "   @@@@   ",13,10
            		DB "  @ || @  ",13,10
            		DB "  @ ||    ",13,10
            		DB "   @@@@   ",13,10
           		DB "    || @  ",13,10
            		DB "  @ || @  ",13,10
            		DB "   @@@@   ",13,10
			DB "    ||    ",13,10,"$"

; ---------------- User Interface Messages ----------------
; Main menu text and user prompts
	MSG1		DB	10,13,"--------------------",13,10
			DB	"Main Menu",13,10
			DB	"--------------------",13,10
			DB	"1. Gross Salary",13,10
			DB	"2. Overtime (OT)",13,10
			DB	"3. Net Salary",13,10
			DB	"4. Exit",13,10,"$"

	MSG2		DB	10,13,"Select the option (1-4) : $"      ; Menu selection prompt
	MSG3		DB	10,13,"==================================",10,13,"$"

; Input prompts for employee salary components
	MSG_ID		DB	10,13,"1. Staff Id	   : $"              
	MSG5		DB	10,13,"2. Basic Salary    : $"
	MSG6		DB	10,13,"3. Allowance       : $"
	MSG7		DB	10,13,"4. Commission      : $"
	MSG8		DB	10,13,"5. Bonus           : $"

; ---------------- Error / Validation Messages ----------------
	MSG9		DB	10,13,"Invalid Number!! Input Must Be Numeric.$"
	MSG10		DB	10,13,"You can now get the Net Salary.$"
	MSG_REPEAT	DB	10,13,"Do you want to continue using the system(Y or N): $"
	MSG_REPEAT_OT	DB	10,13,"Do you Have OT(Y or N): $"
	MSG_PINPUT_OT	DB	10,13,"You can input your OT now.$"
	MSG_INVALID_OT	DB	10,13,"Invalid option!! Enter Y or N only.$ $"
	MSG_INVALID1	DB	10,13,"Invalid option!! Enter Y or N only.$"
	MSG_EXIT	DB	10,13,"Thanks for using our Human Resources Payroll System.$"
	MSG_INVALID2	DB	10,13,"Invalid option!! Enter 1-4 only.$"
	MSG_INVALID_NET	DB	10,13,"Please enter the gross salary first.",13,10,"$"

; ---------------- Section Titles & Display Labels ----------------
	MSG_GROSS1	DB	"           Gross Salary           $"
	MSG_OT1		DB	"           Overtime(OT)           $"
	MSG4		DB	10,13,"Staff ID              :$"
	MSG_POSITION	DB	10,13,"Position              :$"
	MSG_GROSS2	DB	10,13,"Gross Salary	      :$"
	MSG_OT2		DB	10,13,"Overtime(OT)          :$"
	MSG_DEDUCTION	DB	10,13,"Deduction	      :$"
	MSG_EPF		DB	10,13,"EPF		      :$"
	MSG_SOCSO	DB	10,13,"SOCSO		      :$"
	MSG_NET		DB	      "Net Salary            :$"
	MSG_DOT		DB	".$"
	MSG_NEXTLINE	DB	10,13,"$"

; ---------------- Login System Messages ----------------
	MSG_WELCOME	DB	10,13,"Welcome to Human Resources Payroll System $"
	MSG_LOGIN	DB	10,13,"Please Login to Use the System.$"
	MSG_HR_ID	DB	10,13,"HR Staff ID  :$"
	MSG_PASSWORD	DB	10,13,"Password     :$"
	MSG_WEEKDAY	DB	10,13,"1. Duration(Weekday)		: $"
	MSG_WEEKEND	DB	10,13,"2. Duration(Weekend)		: $"
	MSG_HOLIDAYS	DB	10,13,"3. Duration(Public Holidays)	: $"
	MSG_INVALID_ID	DB	10,13,"Invalid Staff ID! Try again.$"
	MSG_INVALID_NUM	DB	10,13,"Invalid Duration! Input Must Be Numeric.$"
	MSG_LOGIN_SUCCESS	DB	10,13,"Login Successful! Welcome to the system.$"
	MSG_LOGIN_FAILED	DB	10,13,"Invalid Password! Access Denied.$"
	MSG_HR_ID_FAILED	DB	10,13,"Invalid HR Staff ID! Access Denied.$"
	MSG_INVALID_WAGES	DB	10,13,"Please input your Staff ID in Gross Salary first$"

; ---------------- Authentication Credentials ----------------
	CORRECT_PASSWORD	DB	"1234$"      ; Predefined valid password
	CORRECT_HR_ID		DB	"HR@1234$"   ; Predefined valid HR staff ID

; ---------------- Login Input Buffers ----------------
; Format for DOS buffered input (first byte = max length,
; second byte = actual input length, followed by buffer).
	PASSWORD_INPUT	LABEL	BYTE
	PASS_MAX	DB	5                ; Maximum 5 chars allowed
	PASS_ACTUAL	DB	?                ; Actual number of chars entered
	PASS_BUFFER	DB	5 DUP('$')       ; Buffer to hold entered password

	HR_ID_INPUT	LABEL	BYTE
	HR_ID_MAX	DB	8
	HR_ID_ACTUAL	DB	?
	HR_ID_BUFFER	DB	8 DUP('$')

; ---------------- Program Variables ----------------
	OPTION1		DB	?      ; Menu option
	OPTION2		DB	?      ; Repeat option (Y/N)
	OPTION3		DB	?      ; Overtime option (Y/N)
	BASIC_SALARY	DW	?      ; Basic salary input
	ALLOWANCE	DW	?      ; Allowance input
	COMMISSION	DW	?      ; Commission input
	BONUS		DW	?      ; Bonus input
	GROSS_SALARY	DW	?      ; Total gross salary
	EPF		DW	?      ; EPF deduction
	EPF_R		DW	?      ; EPF remainder (for sen)
	SOCSO		DW	?      ; SOCSO deduction
	SOCSO_R		DW	?      ; SOCSO remainder (for sen)
	DEDUCTION	DW	?      ; Total deductions
	DEDUCTION_R	DW	?      ; Deduction remainder
	NET_SALARY	DW	?      ; Final net salary
	NET_SALARY_R	DW	?      ; Net salary remainder
	WEEKDAY		DW	?      ; Weekday OT hours
	WEEKEND		DW	?      ; Weekend OT hours
	HOLIDAYS	DW	?      ; Holiday OT hours
	ID_STR		DW	?      ; For staff ID string
	POSITION	DW	?      ; Position string (Intern, etc.)
	WAGES		DW	?      ; Wage rate per hour
	WEEKDAY_OT	DW	?      ; Weekday OT total
	WEEKEND_OT	DW	?      ; Weekend OT total
	HOLIDAYS_OT	DW	?      ; Holiday OT total
	OVERTIME_TOTAL	DW	?      ; Total overtime pay

; ---------------- String Buffers for Results ----------------
	RESULT_GROSS	DB	5 DUP('$')
	RESULT_EPF	DB	5 DUP('$')
	RESULT_EPF_R	DB	3 DUP('$')
	RESULT_SOCSO	DB	5 DUP('$')
	RESULT_SOCSO_R	DB	3 DUP('$')
	RESULT_NET	DB	5 DUP('$')
	RESULT_NET_R	DB	3 DUP('$')
	RESULT_DEDUCTION	DB	5 DUP('$')
	RESULT_DEDUCTION_R	DB	3 DUP('$')
	RESULT_OT	DB	5 DUP('$')

; ---------------- Staff Id Input Buffer ----------------
	ID_INPUT	LABEL	BYTE
	MAX		DB	6
	ACTUAL		DB	?
	SPACE		DB	6 DUP('$')

; ---------------- Employee Position Strings ----------------
	INTERN_STR	DB	"Intern$"
	TECH_STR	DB	"Technician$"
	EXEC_STR	DB	"Executive$"
	MANAG_STR	DB	"Manager$"


; --------------------------------------------------------------------------------------
.CODE
	MAIN PROC FAR

	; ---------------- Initialization ----------------
	; Load data segment into DS register and display welcome messages.
	MOV	AX, @DATA
	MOV	DS, AX

	MOV 	AH,09H
    	LEA 	DX,COIN_ICON
    	INT 	21H

	MOV	AH, 09H
	LEA	DX, MSG_WELCOME
	INT	21H

	MOV	AH, 09H
	LEA	DX, MSG_LOGIN
	INT	21H

; ---------------- Login Section ----------------
; Prompt for HR ID, verify against stored CORRECT_HR_ID.
LOGIN:
	MOV	AH, 09H
	LEA	DX, MSG_HR_ID
	INT	21H

	MOV	AH, 0AH
	LEA	DX, HR_ID_INPUT
	INT	21H

	.386                               ; Enable 80386+ instructions (for MOVZX)
	MOVZX	CX, HR_ID_ACTUAL            ; Load actual length entered
	CMP	CX, 7                        ; HR ID must be exactly 7 characters
	JNE	WRONG_HR_ID

	MOV	BX, 0
	MOV	SI, 0

; Compare HR_ID_BUFFER with CORRECT_HR_ID, character by character
CHECKING_HR_ID:
	MOV	AL, HR_ID_BUFFER[BX]
	MOV	AH, CORRECT_HR_ID[SI]
	CMP	AL, AH
	JNE	WRONG_HR_ID
	
	INC	BX
	INC	SI
	LOOP	CHECKING_HR_ID

	JMP	RIGHT_HR_ID

; ---------------- Invalid HR ID ----------------
WRONG_HR_ID:
	MOV	AH, 09H
	LEA	DX, MSG_HR_ID_FAILED
	INT	21H
	JMP	LOGIN

; ---------------- Password Input ----------------
; If HR ID matches, ask for password and validate.
RIGHT_HR_ID:
	MOV	AH, 09H
	LEA	DX, MSG_PASSWORD
	INT	21H

	MOV	AH, 0AH
	LEA	DX, PASSWORD_INPUT
	INT	21H

	MOVZX	CX, PASS_ACTUAL
	CMP	CX, 4                       ; Password must be exactly 4 chars
	JNE	WRONG_PASS

	MOV	BX, 0
	MOV	SI, 0

; Compare PASS_BUFFER with CORRECT_PASSWORD
CHECKING_PASSWORD:
	MOV	AL, PASS_BUFFER[BX]
	MOV	AH, CORRECT_PASSWORD[SI]
	CMP	AL, AH
	JNE	WRONG_PASS
	
	INC	BX
	INC	SI
	LOOP	CHECKING_PASSWORD

	JMP	RIGHT_PASS

; ---------------- Invalid Password ----------------
WRONG_PASS:
	MOV	AH, 09H
	LEA	DX, MSG_LOGIN_FAILED
	INT	21H
	JMP	RIGHT_HR_ID

; ---------------- Successful Login ----------------
RIGHT_PASS:
	MOV	AH, 09H
	LEA	DX, MSG_LOGIN_SUCCESS
	INT	21H

; ---------------- Main Menu ----------------
; Show menu options and process user choice.
START_MENU:
	MOV	AH, 09H
	LEA	DX, MSG1
	INT	21H

	MOV	AH, 09H
	LEA	DX, MSG2
	INT	21H

	MOV	AH, 01H
	INT	21H
	MOV	OPTION1, AL

; ---------------- Menu Routing ----------------
; 1 = Gross Salary
	CMP	OPTION1, '1'
	JNE	NOT_1
	JMP	GROSS

NOT_1:
; 2 = Overtime
	CMP	OPTION1, '2'
	JNE	NOT_2
	JMP	OT

NOT_2:
; 3 = Net Salary
	CMP	OPTION1, '3'
	JNE	NOT_3
	JMP	NET

NOT_3:
; 4 = Exit program
	CMP	OPTION1, '4'
	JNE	INVALID_CHOICE
	JMP	EXIT_PROGRAM

; ---------------- Invalid Menu Option ----------------
INVALID_CHOICE:
	MOV	AH, 09H
	LEA	DX, MSG_INVALID2
	INT	21H
	JMP	START_MENU

; ---------------- Gross Salary Menu Display ----------------
GROSS:  
	MOV	AH,09H
	LEA	DX,MSG3             ; Print separator line
	INT	21H

	MOV	AH,09H
	LEA	DX,MSG_GROSS1       ; Print "Gross Salary" title/message
	INT	21H

	MOV	AH,09H
	LEA	DX,MSG3             ; Print separator line
	INT	21H

; ---------------- Staff ID Input ----------------
STAFF_ID_INPUT:
	MOV	AH, 09H
	LEA	DX, MSG_ID          ; Prompt: Enter Staff ID
	INT	21H

	MOV	AH, 0AH
	LEA	DX, ID_INPUT        ; Read Staff ID input string
	INT	21H

; ---------------- Staff ID Validation ----------------
VALIDATION_ID:
	CMP	ACTUAL, 0           ; If input length = 0 → invalid
	JE	INVALID_ID_MSG

	MOV	AL, SPACE[0]        ; Get first character of ID

	; Convert lowercase → uppercase if needed
	CMP	AL, 'a'
	JL	CHECK_UPPERCASE
	CMP	AL, 'z'
	JG	CHECK_UPPERCASE
	SUB	AL, 32              ; Convert 'a'-'z' → 'A'-'Z'

; ---------------- Position Checking ----------------
CHECK_UPPERCASE:
	CMP	AL, 'I'
	JE	SET_INTERN

	CMP	AL, 'T'
	JE	SET_TECHNICIAN

	CMP	AL, 'E'
	JE	SET_EXECUTIVE

	CMP	AL, 'M'
	JE	SET_MANAGER

	; If none matched → invalid ID
	JMP	INVALID_ID_MSG

; ---------------- Set Position and Wages ----------------
SET_INTERN:
	MOV	WAGES, 8
	LEA	BX, INTERN_STR      ; Load position string "Intern"
	MOV	POSITION, BX
	JMP	BASIC

SET_TECHNICIAN:
	MOV	WAGES, 22
	LEA	BX, TECH_STR
	MOV	POSITION, BX
	JMP	BASIC

SET_EXECUTIVE:
	MOV	WAGES, 28
	LEA	BX, EXEC_STR
	MOV	POSITION, BX
	JMP	BASIC

SET_MANAGER:
	MOV	WAGES, 75
	LEA	BX, MANAG_STR
	MOV	POSITION, BX
	JMP	BASIC

; ---------------- Invalid ID Handling ----------------
INVALID_ID_MSG:
	MOV	AH, 09H
	LEA	DX, MSG_INVALID_ID  ; Print error: Invalid Staff ID
	INT	21H
	JMP	STAFF_ID_INPUT       ; Retry

; ---------------- Basic Salary Input ----------------
BASIC:
	MOV	AH,09H
	LEA	DX,MSG_NEXTLINE     ; Print newline
	INT	21H

	MOV	AH,09H
	LEA	DX,MSG5             ; Prompt: Enter Basic Salary
	INT	21H 

	MOV	SI, 0
	MOV	BASIC_SALARY, 0
	MOV	CX, 6               ; Allow up to 6 digits

; Input loop for Basic Salary
INPUTLOOP1: 
	MOV	AH, 01H
	INT	21H

	CMP	AL, 13              ; If ENTER → move on
	JE	ALLOW

	CMP	AL, '0'             ; Must be between '0'-'9'
	JL	INVALID_NUM1
	CMP	AL, '9'
	JG	INVALID_NUM1

	SUB	AL, 30H             ; Convert ASCII → number
	XOR	AH, AH
	MOV	BX, AX

	MOV	AX, BASIC_SALARY    ; Accumulate into BASIC_SALARY
	MOV	DX, 10
	MUL	DX
	ADD	AX, BX
	MOV	BASIC_SALARY, AX
	
	LOOP	INPUTLOOP1
	JMP	ALLOW

; Invalid number handling for Basic Salary
INVALID_NUM1: 
	MOV	AH,09H
	LEA	DX,MSG9
	INT	21H
	JMP	BASIC

; ---------------- Allowance Input ----------------
ALLOW:  
	MOV	AH, 09H
	LEA	DX, MSG6            ; Prompt: Enter Allowance
	INT	21H                             

	MOV	ALLOWANCE, 0
	MOV	CX, 6
	MOV	SI, 0

INPUTLOOP2: 
	MOV	AH, 01H
	INT	21H

	CMP	AL, 13
	JE	COMMISS

	CMP	AL, '0'
	JL	INVALID_NUM2
	CMP	AL, '9'
	JG	INVALID_NUM2

	SUB	AL, 30H
	XOR	AH, AH
	MOV	BX, AX

	MOV	AX, ALLOWANCE
	MOV	DX, 10
	MUL	DX
	ADD	AX, BX
	MOV	ALLOWANCE, AX
	
	LOOP	INPUTLOOP2
	JMP	COMMISS

INVALID_NUM2: 
	MOV	AH, 09H
	LEA	DX, MSG9
	INT	21H
	JMP	ALLOW

; ---------------- Commission Input ----------------
COMMISS: 
	MOV	AH, 09H
	LEA	DX, MSG7            ; Prompt: Enter Commission
	INT	21H                             

	MOV	COMMISSION, 0
	MOV	CX, 6
	MOV	SI, 0

INPUTLOOP3: 
	MOV	AH, 01H
	INT	21H

	CMP	AL, 13
	JE	BON

	CMP	AL, '0'
	JL	INVALID_NUM3
	CMP	AL, '9'
	JG	INVALID_NUM3

	SUB	AL, 30H
	XOR	AH, AH
	MOV	BX, AX

	MOV	AX, COMMISSION
	MOV	DX, 10
	MUL	DX
	ADD	AX, BX
	MOV	COMMISSION, AX
	
	LOOP	INPUTLOOP3
	JMP	BON

INVALID_NUM3: 
	MOV	AH, 09H
	LEA	DX, MSG9
	INT	21H
	JMP	COMMISS

; ---------------- Bonus Input ----------------
BON:  
	MOV	AH, 09H
	LEA	DX, MSG8            ; Prompt: Enter Bonus
	INT	21H       

	MOV	BONUS, 0
	MOV	CX, 6
	MOV	SI, 0

INPUTLOOP4: 
	MOV	AH, 01H
	INT	21H

	CMP	AL, 13
	JE	OT_VALIDATION

	CMP	AL, '0'
	JL	INVALID_NUM4
	CMP	AL, '9'
	JG	INVALID_NUM4

	SUB	AL, 30H
	XOR	AH, AH
	MOV	BX, AX

	MOV	AX, BONUS
	MOV	DX, 10
	MUL	DX
	ADD	AX, BX
	MOV	BONUS, AX
	
	LOOP	INPUTLOOP4
	JMP	OT_VALIDATION

INVALID_NUM4: 
	MOV	AH, 09H
	LEA	DX, MSG9
	INT	21H
	JMP	BON

; ---------------- Overtime Validation ----------------
OT_VALIDATION:
	MOV	AH, 09H
	LEA	DX, MSG_REPEAT_OT   ; Ask: Any Overtime? (Y/N)
	INT	21H

	MOV	AH, 01H
	INT	21H
	MOV	OPTION3, AL

	; If 'Y' or 'y' → redirect to Overtime section
	CMP	OPTION3, 'Y'
	JNE	OT_V_Y1
	MOV	AH, 09H
	LEA	DX, MSG_PINPUT_OT
	INT	21H
	JMP	START_MENU

OT_V_Y1:
	CMP	OPTION3, 'y'
	JNE	OT_V_Y2
	MOV	AH, 09H
	LEA	DX, MSG_PINPUT_OT
	INT	21H
	JMP	START_MENU

	; If 'N' or 'n' → set OT = 0 and continue calculation
OT_V_Y2:
	CMP	OPTION3, 'N'
	JNE	OT_V_N1
	MOV OVERTIME_TOTAL,0
	JMP	CALCULATION

OT_V_N1:
	CMP	OPTION3, 'n'
	JNE	INVALID_OT_V
	MOV OVERTIME_TOTAL,0
	JMP	CALCULATION

	; Invalid option → retry
INVALID_OT_V:
	MOV	AH, 09H
	LEA	DX, MSG_INVALID_OT
	INT	21H
	JMP	OT_VALIDATION

; ---------------- Repeat/Exit Prompt ----------------
REPEAT1:
	MOV	AH, 09H
	LEA	DX, MSG_REPEAT      ; Ask: Continue? (Y/N)
	INT	21H

	MOV	AH, 01H
	INT	21H
	MOV	OPTION2, AL

	CMP	OPTION2, 'Y'
	JNE	GROSS_NOT_Y1
	MOV	AH, 09H
	LEA	DX, MSG10           ; Print message
	INT	21H
	JMP	START_MENU

GROSS_NOT_Y1:
	CMP	OPTION2, 'y'
	JNE	GROSS_NOT_Y2
	MOV	AH, 09H
	LEA	DX, MSG10
	INT	21H
	JMP	START_MENU

GROSS_NOT_Y2:
	CMP	OPTION2, 'N'
	JNE	GROSS_NOT_N1
	JMP	EXIT_PROGRAM

GROSS_NOT_N1:
	CMP	OPTION2, 'n'
	JNE	INVALID_GROSS
	JMP	EXIT_PROGRAM

INVALID_GROSS:
	MOV	AH, 09H
	LEA	DX, MSG_INVALID1    ; Invalid input → retry
	INT	21H
	JMP	REPEAT1

; ---------------- OT Menu Display ----------------
OT:
	MOV	AH, 09H
	LEA	DX, MSG3          ; Print separator line
	INT	21H

	MOV	AH, 09H
	LEA	DX, MSG_OT1       ; Print "Overtime" title/message
	INT	21H

	MOV	AH, 09H
	LEA	DX, MSG3          ; Print separator line again
	INT	21H

; ---------------- Weekday OT Input ----------------
WEEKDAY_INPUT:
	MOV	AH, 09H
	LEA	DX, MSG_WEEKDAY   ; Prompt user: Enter weekday OT hours
	INT	21H

	MOV	WEEKDAY, 0        ; Reset weekday OT accumulator
	MOV	CX, 4             ; Max 4 digits allowed
	MOV	SI, 0             ; SI not used, but cleared

; Input loop for weekday OT hours
INPUTLOOP5:
	MOV	AH, 01H           ; Read one char from keyboard
	INT	21H

	CMP	AL, 13            ; If ENTER pressed → done
	JE	WEEKEND_INPUT

	CMP	AL, '0'           ; Validate: must be >= '0'
	JL	INVALID_NUM5
	CMP	AL, '9'           ; Validate: must be <= '9'
	JG	INVALID_NUM5

	SUB	AL, 30H           ; Convert ASCII → number
	XOR	AH, AH
	MOV	BX, AX            ; BX = digit

	MOV	AX, WEEKDAY       ; Accumulate multi-digit number
	MOV	DX, 10
	MUL	DX
	ADD	AX, BX
	MOV	WEEKDAY, AX

	LOOP	INPUTLOOP5       ; Continue until CX exhausted
	JMP	WEEKEND_INPUT

; Invalid numeric input for weekday OT
INVALID_NUM5:
	MOV	AH, 09H
	LEA	DX, MSG_INVALID_NUM ; Show error message
	INT	21H
	JMP	WEEKDAY_INPUT       ; Retry weekday input

; ---------------- Weekend OT Input ----------------
WEEKEND_INPUT:
	MOV	AH, 09H
	LEA	DX, MSG_WEEKEND   ; Prompt: Enter weekend OT hours
	INT	21H

	MOV	WEEKEND, 0        ; Reset weekend OT accumulator
	MOV	CX, 4             ; Max 4 digits allowed
	MOV	SI, 0

; Input loop for weekend OT hours
INPUTLOOP6:
	MOV	AH, 01H
	INT	21H

	CMP	AL, 13
	JE	HOLIDAYS_INPUT

	CMP	AL, '0'
	JL	INVALID_NUM6
	CMP	AL, '9'
	JG	INVALID_NUM6

	SUB	AL, 30H
	XOR	AH, AH
	MOV	BX, AX

	MOV	AX, WEEKEND
	MOV	DX, 10
	MUL	DX
	ADD	AX, BX
	MOV	WEEKEND, AX

	LOOP	INPUTLOOP6
	JMP	HOLIDAYS_INPUT

; Invalid numeric input for weekend OT
INVALID_NUM6:
	MOV	AH, 09H
	LEA	DX, MSG_INVALID_NUM
	INT	21H
	JMP	WEEKEND_INPUT

; ---------------- Holidays OT Input ----------------
HOLIDAYS_INPUT:
	MOV	AH, 09H
	LEA	DX, MSG_HOLIDAYS  ; Prompt: Enter holiday OT hours
	INT	21H

	MOV	HOLIDAYS, 0       ; Reset holidays OT accumulator
	MOV	CX, 4             ; Max 4 digits allowed
	MOV	SI, 0

; Input loop for holiday OT hours
INPUTLOOP7:
	MOV	AH, 01H
	INT	21H

	CMP	AL, 13
	JE	WAGES_VALID

	CMP	AL, '0'
	JL	INVALID_NUM7
	CMP	AL, '9'
	JG	INVALID_NUM7

	SUB	AL, 30H
	XOR	AH, AH
	MOV	BX, AX

	MOV	AX, HOLIDAYS
	MOV	DX, 10
	MUL	DX
	ADD	AX, BX
	MOV	HOLIDAYS, AX

	LOOP	INPUTLOOP7
	JMP	WAGES_VALID

; Invalid numeric input for holidays OT
INVALID_NUM7:
	MOV	AH, 09H
	LEA	DX, MSG_INVALID_NUM
	INT	21H
	JMP	HOLIDAYS_INPUT

; ---------------- Wages Validation ----------------
WAGES_VALID:
	MOV	AX, WAGES
	CMP	AX, 0
	JE	INVALID_WAGES      ; Cannot calculate if wages = 0

	JMP	CALCULATION2       ; Proceed if wages valid

INVALID_WAGES:
	MOV	AH, 09H
	LEA	DX, MSG_INVALID_WAGES
	INT	21H
	JMP	START_MENU         ; Return to main menu

; ---------------- Overtime Calculation ----------------
CALCULATION2:
	; Weekday OT = WAGES * weekday_hours * 2
	XOR	AX, AX
	MOV	AX, WAGES
	MOV	BX, WEEKDAY
	MUL	BX
	MOV	BX, 2
	MUL	BX
	MOV	WEEKDAY_OT, AX

	; Weekend OT = WAGES * weekend_hours * 3
	MOV	AX, WAGES
	MOV	BX, WEEKEND
	MUL	BX
	MOV	BX, 3
	MUL	BX
	MOV	WEEKEND_OT, AX

	; Holiday OT = WAGES * holiday_hours * 4
	MOV	AX, WAGES
	MOV	BX, HOLIDAYS
	MUL	BX
	MOV	BX, 4
	MUL	BX
	MOV	HOLIDAYS_OT, AX

	; OVERTIME_TOTAL = sum of all OT categories
	MOV	AX, WEEKDAY_OT
	ADD	AX, WEEKEND_OT
	ADD	AX, HOLIDAYS_OT
	MOV	OVERTIME_TOTAL, AX

	JMP	CALCULATION        ; Jump to gross salary calculation

; ---------------- Repeat/Exit Prompt ----------------
REPEAT2:
	MOV	AH, 09H
	LEA	DX, MSG_REPEAT     ; Ask user: Continue or Exit?
	INT	21H

	MOV	AH, 01H
	INT	21H
	MOV	OPTION2, AL

	CMP	OPTION2, 'Y'       ; If 'Y' → back to start menu
	JNE	OT_NOT_Y1
	JMP	START_MENU

OT_NOT_Y1:
	CMP	OPTION2, 'y'
	JNE	OT_NOT_Y2
	JMP	START_MENU

OT_NOT_Y2:
	CMP	OPTION2, 'N'       ; If 'N' → exit program
	JNE	OT_NOT_N2
	JMP	EXIT_PROGRAM

OT_NOT_N2:
	CMP	OPTION2, 'n'
	JNE	INVALID_OT
	JMP	EXIT_PROGRAM

; Invalid input at repeat prompt
INVALID_OT:
	MOV	AH, 09H
	LEA	DX, MSG_INVALID1
	INT	21H
	JMP	REPEAT2


REPEAT3:
	; Display repeat prompt (ask user to continue Y/N)
    	MOV 	AH, 09H
    	LEA 	DX, MSG_REPEAT
    	INT 	21H

    	; Read single key from user input
   	MOV 	AH, 01H
    	INT 	21H
    	MOV 	OPTION2, AL
	
    	; If input = 'Y', return to main menu
    	CMP 	OPTION2, 'Y'
    	JNE 	NET_NOT_Y1
    	JMP 	START_MENU

NET_NOT_Y1:
    	; If input = 'y', return to main menu
    	CMP 	OPTION2, 'y'
    	JNE 	NET_NOT_Y2
    	JMP 	START_MENU

NET_NOT_Y2:
    	; If input = 'N', exit program
    	CMP 	OPTION2, 'N'
    	JNE 	NET_NOT_N3
    	JMP 	EXIT_PROGRAM

NET_NOT_N3:
    	; If input = 'n', exit program
    	CMP 	OPTION2, 'n'
    	JNE 	INVALID_NET
    	JMP 	EXIT_PROGRAM

INVALID_NET:
    	; Handle invalid input → show error and ask again
    	MOV 	AH, 09H
    	LEA 	DX, MSG_INVALID1
    	INT 	21H
    	JMP 	REPEAT3


; ---------------- EXIT ----------------
EXIT_PROGRAM:
    	; Display exit message
    	MOV 	AH, 09H
    	LEA 	DX, MSG_EXIT
    	INT 	21H

    	; Exit program and return to DOS
    	MOV 	AX, 4C00H
    	INT 	21H

	MAIN ENDP
END MAIN


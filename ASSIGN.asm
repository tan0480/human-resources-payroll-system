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
	MAIN ENDP
END MAIN


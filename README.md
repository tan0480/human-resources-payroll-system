# Human Resources Payroll System

A DOS console payroll assignment written in x86 assembly. The original application is contained in `ASSIGN.asm` and uses the small memory model, DOS `INT 21h` services, and 386-era instructions such as `MOVZX`.

## Features

- Preset HR login and menu navigation.
- Staff ID input, position selection from the ID prefix, and predefined hourly wages.
- Basic salary, allowance, commission, and bonus input with numeric checks.
- Weekday, weekend, and public-holiday overtime calculations.
- Gross salary, EPF/SOCSO deductions, net salary, and integer/remainder handling for currency.
- Formatted salary output and continue/exit prompts.

## Environment and build status

This is legacy DOS assembly, not a native 64-bit Windows application. It needs a MASM-compatible assembler that supports the source's syntax and 16-bit DOS object generation, a compatible DOS linker, and a DOS runtime/emulator with support for the instructions used. Modern 64-bit-only assembler/linker tools are not a drop-in replacement.

The exact original assembler/linker versions have not been established, and no reproducible build command has been verified during this import. To run from source, use a compatible toolchain to assemble `ASSIGN.asm`, link a DOS executable, and launch that executable in the DOS environment. Tool binaries and the existing locally supplied EXE are not distributed in this repository.

The source defines a preset HR ID and password for classroom demonstration. Inspect the `CORRECT_HR_ID` and `CORRECT_PASSWORD` declarations when using the demo; do not reuse these credentials for any real system.

## Coding contributions

| Contributor | Confirmed coding responsibility | Main source sections |
| --- | --- | --- |
| [Lam Yi Hen](https://github.com/lamyihen77-beep) | Login, menus, staff ID input/validation, and continue/exit flow | Login checks, `START_MENU`, staff ID checks, repeat prompts, `EXIT_PROGRAM` |
| [Cheah Yong Shun](https://github.com/ys012007) | Salary-component input, wage setup, overtime input/calculation, and numeric validation | Position-to-wage assignments, `BASIC`, `ALLOW`, `COMMISS`, `BON`, overtime validation, `OT`, `CALCULATION2` |
| [Tan Yi Heng](https://github.com/tan0480) | Gross salary, deductions, net salary, and currency remainder/carry handling | `CALCULATION`, `DEDUCTION_CALC`, `NET_S`, `NO_SEN` |
| [Lim Jun Yi](https://github.com/ljunyi0212) | Salary details, payslip presentation, numeric-to-text conversion, and monetary formatting | `NET` output section, conversion and printing labels |

Shared declarations, messages, buffers, and program structure are imported by Tan Yi Heng with all three teammates credited as co-authors. This mapping follows the confirmed contribution-based import plan. Tan Yi Heng is the committing operator and performs the push; the commit authors credit the contributions above.

These commits import an existing assignment using current timestamps; they do not reconstruct its original development timeline. Early commits are partial source snapshots with unresolved cross-section references, not standalone runnable versions. The completed import preserves the original source bytes without refactoring.

## Limitations

- This is an educational prototype, not a production payroll or authentication system.
- Login credentials are hardcoded in plain text.
- EPF/SOCSO percentages, wage values, and overtime multipliers are assignment constants, not verified current statutory payroll rules.
- The arithmetic uses fixed-width registers and variables. Overflow, rounding behavior, and all input boundaries have not been verified during import.
- No source fixes or functional changes were made as part of uploading the project.

## Verification and repository contents

The import checks source hashes, section reconstruction, Git contents, and author metadata. A static scan found no missing direct branch targets among the labels it recognized. This is not an assembler or runtime test: successful assembly, salary results, and interactive workflows have not been verified.

Only `ASSIGN.asm`, this README, and `.gitignore` are tracked. The local executable, assignment report, originality report, and generated build/test files are excluded and remain untouched.

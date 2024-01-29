# Scheme Interpreter in Scheme

This repository contains a simple Scheme interpreter implemented in Scheme. The interpreter supports basic functionality such as arithmetic operations, conditionals, variable bindings, and lambda expressions.
This project done under Programing Languages Course (CS305) of Sabanci University.
## Features

### REPL (Read-Eval-Print Loop)
The interpreter includes a REPL for interactive use. It prompts the user with "cs305>" and evaluates Scheme expressions entered by the user.

### Expression Types
1. **Numbers**: Supports numeric values in expressions.
2. **Variables**: Handles variable references within the environment.
3. **Conditionals**: Supports `if` statements for conditional execution.
4. **Let Bindings**: Implements the `let` expression for local variable bindings.
5. **Lambda Expressions**: Supports the definition and execution of lambda functions.
6. **Basic Arithmetic Operators**: Addition (`+`), Subtraction (`-`), Multiplication (`*`), and Division (`/`).

### Error Handling
The interpreter includes basic error handling for malformed expressions or undefined variables.

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/Scheme-Interpreter.git
   cd Scheme-Interpreter
   ```

2. Load the Scheme interpreter or use your preferred Scheme implementation (e.g., Racket or Guile).

3. Load the file containing the interpreter code (e.g., `interpreter.scm`).

4. Call the `cs305` function to start the REPL and interact with the interpreter.

## Examples

```scheme
; Example 1: Arithmetic Operations
(cs305)
; cs305> (+ 5 7)
; cs305: 12

; Example 2: Conditionals
(cs305)
; cs305> (if (= 1 1) 10 20)
; cs305: 10

; Example 3: Let Bindings
(cs305)
; cs305> (let ((x 5) (y 10)) (* x y))
; cs305: 50

; Example 4: Lambda Expressions
(cs305)
; cs305> ((lambda (x) (+ x 5)) 10)
; cs305: 15
```


(define repl
  (lambda (env)
    (let* ((dummy1 (display "cs305> "))
           (expr (read))
           (new-env (if (define-stmt? expr)
                       (extend-env (cadr expr) (s7-interpret (caddr expr) env) env)
                       env))
           (val (if (define-stmt? expr) (cadr expr) (s7-interpret expr env)))
           (dummy2 (display "cs305: "))
           (dummy3 (display val))
           (dummy4 (newline))
           (dummy5 (newline)))
      (repl new-env))))

(define s7-interpret
  (lambda (expr env)
    (cond
      ((number? expr) expr)
      ((symbol? expr) (get-value expr env))
      ((not (list? expr)) ("ERROR"))
      ((if-stm? expr) (if-exec expr env))
      ((let-stm? expr) (let-exec expr env))
      ((lambda-stm? expr) expr)
      ((valid-operator? expr env) (apply (valid-operator? expr env) (edit-list (cdr expr) env)))
      (else (lambda-tuple expr env)))))

(define if-stm?
  (lambda (e)
    (and (list? e) (equal? (car e) 'if) (= (length e) 4))))

(define let-stm?
  (lambda (e)
    (and (list? e) (equal? (car e) 'let) (= (length e) 3) (list? (cadr e)))))

(define lambda-stm?
  (lambda (e)
    (and (list? e) (equal? (car e) 'lambda) (= (length e) 3) (formalList? (cadr e)))))

(define formalList?
  (lambda (lst)
    (cond
      ((not (list? lst)) #f)
      ((null? lst) #t)
      (else (and (symbol? (car lst)) (formalList? (cdr lst)))))))

(define tuple?
  (lambda (t)
    (and (list? t) (= (length t) 2) (symbol? (car t)))))

(define define-stmt?
  (lambda (e)
    (and (list? e) 
         (equal? (car e) 'define) 
         (symbol? (cadr e)) 
         (= (length e) 3))))

(define lambda-tuple
  (lambda (expr env)
    (cond
      ((lambda-stm? (car expr)) (exec-lambda (car expr) (cdr expr) env))
      ((symbol? (car expr))
       (if (lambda-stm? (get-lambda (car expr) env))
           (exec-lambda (get-lambda (car expr) env) (cdr expr) env)
           "ERROR"))
      (else "ERROR"))))

(define get-lambda
  (lambda (var env)
    (cond
      ((null? env) "ERROR")
      ((equal? (caar env) var) (if (lambda-stm? (cadar env)) (cadar env) "ERROR"))
      (else (get-lambda var (cdr env))))))

(define if-exec
  (lambda (lst env)
    (let ((condition-result (s7-interpret (cadr lst) env)))
      (if (equal? condition-result "ERROR")
          "ERROR"
          (if (zero? condition-result)
              (s7-interpret (cadddr lst) env)
              (s7-interpret (caddr lst) env))))))


(define valid-operator?
  (lambda (expr env)
    (cond
      ((equal? (car expr) '+) +)
      ((equal? (car expr) '-) -)
      ((equal? (car expr) '* ) *)
      ((equal? (car expr) '/) /)
      (else #f))))

(define extend-env
  (lambda (var val old-env)
    (append (list (list var val)) old-env)))

(define get-value
  (lambda (var env)
    (cond
      ((or (equal? '+ var) (equal? '- var) (equal? '* var) (equal? '/ var)) "[PROCEDURE]")
      ((null? env) "ERROR")
      ((equal? (caar env) var) (if (lambda-stm? (cadar env)) "[PROCEDURE]" (cadar env)))
      (else (get-value var (cdr env))))))

(define temp-env
  (lambda (lst1 env)
    (cond
      ((null? lst1) env)
      (else (temp-env (cdr lst1) (extend-env (caar lst1) (s7-interpret (cadar lst1) env) env))))))

(define let-exec 
  (lambda (expr env)
    (if (var-bind-list? (cadr expr))
        (s7-interpret (caddr expr) (temp-env (let-bind (cadr expr) env) env))
        "ERROR")))

(define andExtended
  (lambda (lst)
    (cond
      ((not (list? lst)) #f)
      ((null? lst) #t)
      (else (and (car lst) (andExtended (cdr lst)))))))

(define var-bind-list?
  (lambda (lst)
    (andExtended (map tuple? lst))))

(define edit-list
  (lambda (lst env)
    (if (null? lst) (list)
        (append (list (s7-interpret (car lst) env)) (edit-list (cdr lst) env)))))

(define bind-variable
  (lambda (lst1 lst2)
    (cond
      ((not (= (length lst1) (length lst2))) "ERROR")
      ((null? lst2) (list))
      (else (append (list (list (car lst1) (car lst2))) (bind-variable (cdr lst1) (cdr lst2)))))))

(define let-bind
  (lambda (lst env)
    (cond
      ((null? lst) (list))
      ((number? (cadar lst)) (append (list (car lst)) (let-bind (cdr lst) env)))
      (else (append (list (list (caar lst) (s7-interpret (cadar lst) env))) (let-bind (cdr lst) env))))))

(define exec-lambda
  (lambda (lmd param env)
    (s7-interpret (caddr lmd) (append (bind-variable (cadr lmd) param) env))))

(define cs305
  (lambda () (repl '())))
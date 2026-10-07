# Análisis Teórico y Simplificación Lógica — Reto 14
## Procesador de Verificación

- **Estudiante:** Urik Camilo Valenzuela Flynn
- **Matrícula:** 20250469
- **Asignatura:** Sistemas Digitales con FPGA (ITLA)
- **Docente:** Prof. Wilkins Gabriel Cedano Del Rosario

---

## 1. Definición del Problema y Minitérminos

El sistema recibe 4 variables de control binarias de 1 bit: `a`, `b`, `c`, `d`, donde `a` es el bit más significativo (MSB) y `d` el menos significativo (LSB). El índice del minitérmino se calcula formalmente como:

$$m = 8a + 4b + 2c + d$$

Las funciones lógicas de control asignadas para el Reto 14 son:
- **Función $u(a, b, c, d)$:**
  $$u(a,b,c,d) = \sum m(1, 5, 9, 10, 11, 12, 13, 14, 15)$$
- **Función $v(a, b, c, d)$:**
  $$v(a,b,c,d) = \sum m(2, 4, 5, 6, 7, 10, 13, 14, 15)$$

El vector de control resultante $\{v, u\}$ selecciona la operación a ejecutar sobre dos operandos sin signo de 4 bits $A[3:0]$ y $B[3:0]$:
- `{v, u} = 2'b00` $\rightarrow$ **XOR** ($Y = A \oplus B$, bandera: paridad impar)
- `{v, u} = 2'b01` $\rightarrow$ **SUMA** ($Y = (A + B)[3:0]$, bandera: acarreo de salida)
- `{v, u} = 2'b10` $\rightarrow$ **MAYOR** ($Y = \max(A, B)$, bandera: igualdad $A == B$)
- `{v, u} = 2'b11` $\rightarrow$ **RESTA** ($Y = (A - B)[3:0]$, bandera: préstamo / borrow $A < B$)

---

## 2. Tabla de Verdad de 16 Estados

A continuación se detalla la tabla de verdad para todas las combinaciones posibles de las entradas de control $(a, b, c, d)$, evaluando la pertenencia a los sumatorios de minitérminos de $u$ y $v$, junto con la operación seleccionada por $\{v, u\}$:

| $m$ | $a$ | $b$ | $c$ | $d$ | $u$ | $v$ | $\{v, u\}$ | Operación Seleccionada | Comportamiento del Datapath |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: | :--------: | :--------------------: | :-------------------------- |
|  0  |  0  |  0  |  0  |  0  |  0  |  0  |    `00`    | XOR                    | $Y = A \oplus B$, `flag` = `^Y` (paridad impar) |
|  1  |  0  |  0  |  0  |  1  |  1  |  0  |    `01`    | SUMA                   | $Y = (A + B)[3:0]$, `flag` = acarreo ($A+B > 15$) |
|  2  |  0  |  0  |  1  |  0  |  0  |  1  |    `10`    | MAYOR                  | $Y = \max(A, B)$, `flag` = ($A == B$) |
|  3  |  0  |  0  |  1  |  1  |  0  |  0  |    `00`    | XOR                    | $Y = A \oplus B$, `flag` = `^Y` (paridad impar) |
|  4  |  0  |  1  |  0  |  0  |  0  |  1  |    `10`    | MAYOR                  | $Y = \max(A, B)$, `flag` = ($A == B$) |
|  5  |  0  |  1  |  0  |  1  |  1  |  1  |    `11`    | RESTA                  | $Y = (A - B)[3:0]$, `flag` = préstamo ($A < B$) |
|  6  |  0  |  1  |  1  |  0  |  0  |  1  |    `10`    | MAYOR                  | $Y = \max(A, B)$, `flag` = ($A == B$) |
|  7  |  0  |  1  |  1  |  1  |  0  |  1  |    `10`    | MAYOR                  | $Y = \max(A, B)$, `flag` = ($A == B$) |
|  8  |  1  |  0  |  0  |  0  |  0  |  0  |    `00`    | XOR                    | $Y = A \oplus B$, `flag` = `^Y` (paridad impar) |
|  9  |  1  |  0  |  0  |  1  |  1  |  0  |    `01`    | SUMA                   | $Y = (A + B)[3:0]$, `flag` = acarreo ($A+B > 15$) |
| 10  |  1  |  0  |  1  |  0  |  1  |  1  |    `11`    | RESTA                  | $Y = (A - B)[3:0]$, `flag` = préstamo ($A < B$) |
| 11  |  1  |  0  |  1  |  1  |  1  |  0  |    `01`    | SUMA                   | $Y = (A + B)[3:0]$, `flag` = acarreo ($A+B > 15$) |
| 12  |  1  |  1  |  0  |  0  |  1  |  0  |    `01`    | SUMA                   | $Y = (A + B)[3:0]$, `flag` = acarreo ($A+B > 15$) |
| 13  |  1  |  1  |  0  |  1  |  1  |  1  |    `11`    | RESTA                  | $Y = (A - B)[3:0]$, `flag` = préstamo ($A < B$) |
| 14  |  1  |  1  |  1  |  0  |  1  |  1  |    `11`    | RESTA                  | $Y = (A - B)[3:0]$, `flag` = préstamo ($A < B$) |
| 15  |  1  |  1  |  1  |  1  |  1  |  1  |    `11`    | RESTA                  | $Y = (A - B)[3:0]$, `flag` = préstamo ($A < B$) |

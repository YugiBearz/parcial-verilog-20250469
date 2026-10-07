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

## 3. Mapa de Karnaugh y Minimización para la Función $u(a, b, c, d)$

La función de control $u$ está definida por el conjunto de 9 minitérminos:
$$u(a,b,c,d) = \sum m(1, 5, 9, 10, 11, 12, 13, 14, 15)$$

### Rejilla del Mapa de Karnaugh (4x4 en Código Gray)

Las filas representan las combinaciones de $(a, b)$ y las columnas $(c, d)$:

```
           cd
  u      00   01   11   10
      +----+----+----+----+
   00 |  0 |  1 |  0 |  0 |   m0,  m1,  m3,  m2
      +----+----+----+----+
   01 |  0 |  1 |  0 |  0 |   m4,  m5,  m7,  m6
ab    +----+----+----+----+
   11 |  1 |  1 |  1 |  1 |   m12, m13, m15, m14
      +----+----+----+----+
   10 |  0 |  1 |  1 |  1 |   m8,  m9,  m11, m10
      +----+----+----+----+
```

### Identificación de Grupos e Implicantes Primos Esenciales (EPI)

Para cubrir los 9 unos con el número mínimo de términos de mayor tamaño posible (potencias de 2):

1. **Grupo 1 — Fila completa $ab = 11$ (4 celdas):**
   - **Celdas:** $m_{12}, m_{13}, m_{15}, m_{14}$.
   - **Variables invariantes:** $a = 1, b = 1$; las variables $c$ y $d$ cambian en todas sus combinaciones.
   - **Término producto:** $ab$.
   - **Esencialidad:** El minitérmino $m_{12}$ solo pertenece a este grupo, lo que hace que $ab$ sea un **Implicante Primo Esencial**.

2. **Grupo 2 — Bloque $2 \times 2$ en filas $\{11, 10\}$ y columnas $\{11, 10\}$ (4 celdas):**
   - **Celdas:** $m_{15}, m_{14}, m_{11}, m_{10}$.
   - **Variables invariantes:** $a = 1, c = 1$; las variables $b$ y $d$ alternan entre 0 y 1.
   - **Término producto:** $ac$.
   - **Esencialidad:** El minitérmino $m_{10}$ solo está cubierto por este bloque, haciendo que $ac$ sea un **Implicante Primo Esencial**.

3. **Grupo 3 — Columna completa $cd = 01$ (4 celdas):**
   - **Celdas:** $m_1, m_5, m_{13}, m_9$.
   - **Variables invariantes:** $c = 0, d = 1$; las variables $a$ y $b$ varían a lo largo de las 4 filas.
   - **Término producto:** $\bar{c}d$.
   - **Esencialidad:** Los minitérminos $m_1$ y $m_5$ solo pueden ser cubiertos por esta columna, haciendo que $\bar{c}d$ sea un **Implicante Primo Esencial**.

### Expresión Mínima Suma de Productos (SOP)

Todos los 9 minitérminos quedan cubiertos por los 3 implicantes primos esenciales:
$$u = ab + ac + \bar{c}d$$

- **Número de términos producto:** 3.
- **Número de literales:** $2 + 2 + 3 = 7$ literales.

## 4. Mapa de Karnaugh y Minimización para la Función $v(a, b, c, d)$

La función de control $v$ está definida por el conjunto de 9 minitérminos:
$$v(a,b,c,d) = \sum m(2, 4, 5, 6, 7, 10, 13, 14, 15)$$

### Rejilla del Mapa de Karnaugh (4x4 en Código Gray)

Las filas representan las combinaciones de $(a, b)$ y las columnas $(c, d)$:

```
           cd
  v      00   01   11   10
      +----+----+----+----+
   00 |  0 |  0 |  0 |  1 |   m0,  m1,  m3,  m2
      +----+----+----+----+
   01 |  1 |  1 |  1 |  1 |   m4,  m5,  m7,  m6
ab    +----+----+----+----+
   11 |  0 |  1 |  1 |  1 |   m12, m13, m15, m14
      +----+----+----+----+
   10 |  0 |  0 |  0 |  1 |   m8,  m9,  m11, m10
      +----+----+----+----+
```

### Identificación de Grupos e Implicantes Primos Esenciales (EPI)

Para agrupar los 9 unos optimizando el tamaño de los lazos:

1. **Grupo 1 — Fila completa $ab = 01$ (4 celdas):**
   - **Celdas:** $m_4, m_5, m_7, m_6$.
   - **Variables invariantes:** $a = 0, b = 1$; las variables $c$ y $d$ recorren todas sus combinaciones.
   - **Término producto:** $\bar{a}b$.
   - **Esencialidad:** El minitérmino $m_4$ es cubierto de forma exclusiva por este grupo, convirtiendo a $\bar{a}b$ en un **Implicante Primo Esencial**.

2. **Grupo 2 — Bloque $2 \times 2$ en filas $\{01, 11\}$ y columnas $\{01, 11\}$ (4 celdas):**
   - **Celdas:** $m_5, m_7, m_{13}, m_{15}$.
   - **Variables invariantes:** $b = 1, d = 1$; las variables $a$ y $c$ cambian entre 0 y 1.
   - **Término producto:** $bd$.
   - **Esencialidad:** El minitérmino $m_{13}$ solo está cubierto por este lazo, por lo que $bd$ es un **Implicante Primo Esencial**.

3. **Grupo 3 — Columna completa $cd = 10$ (4 celdas):**
   - **Celdas:** $m_2, m_6, m_{14}, m_{10}$.
   - **Variables invariantes:** $c = 1, d = 0$; las variables $a$ y $b$ recorren todas sus combinaciones.
   - **Término producto:** $c\bar{d}$.
   - **Esencialidad:** Los minitérminos $m_2$ y $m_{10}$ únicamente están contenidos en esta columna, haciendo que $c\bar{d}$ sea un **Implicante Primo Esencial**.

### Expresión Mínima Suma de Productos (SOP)

La unión de los 3 implicantes primos esenciales cubre de forma exacta y mínima los 9 minitérminos:
$$v = \bar{a}b + bd + c\bar{d}$$

- **Número de términos producto:** 3.
- **Número de literales:** $3 + 2 + 3 = 7$ literales.

## 5. Implementación a Nivel de Compuertas Lógicas

A partir de las ecuaciones mínimas SOP deducidas:

### Circuito para $u(a,b,c,d) = ab + ac + \bar{c}d$
- **Inversores (NOT):** 1 compuerta para generar $\bar{c}$.
- **Compuertas AND de 2 entradas:** 3 compuertas:
  - $T_{u1} = a \cdot b$
  - $T_{u2} = a \cdot c$
  - $T_{u3} = \bar{c} \cdot d$
- **Compuerta OR de 3 entradas:** 1 compuerta:
  - $u = T_{u1} + T_{u2} + T_{u3}$
- **Total de compuertas para $u$:** 1 NOT + 3 AND-2 + 1 OR-3 = **5 compuertas**.

```
a ──────┬─────────┐ (AND)
b ──────┼────┐    ├── Tu1 ──┐
        │    │    │         │
a ──────┴────┼────┤ (AND)   │
c ──────┬────┼────┤── Tu2 ──┼──┐ (OR)
        │    │    │         │  ├── u
c ──[NOT]──┐ │    │         │  │
d ─────────┴─┴────┤ (AND)   │  │
                  └── Tu3 ──┘──┘
```

### Circuito para $v(a,b,c,d) = \bar{a}b + bd + c\bar{d}$
- **Inversores (NOT):** 2 compuertas para generar $\bar{a}$ y $\bar{d}$.
- **Compuertas AND de 2 entradas:** 3 compuertas:
  - $T_{v1} = \bar{a} \cdot b$
  - $T_{v2} = b \cdot d$
  - $T_{v3} = c \cdot \bar{d}$
- **Compuerta OR de 3 entradas:** 1 compuerta:
  - $v = T_{v1} + T_{v2} + T_{v3}$
- **Total de compuertas para $v$:** 2 NOT + 3 AND-2 + 1 OR-3 = **6 compuertas**.

```
a ──[NOT]──┬──────┐ (AND)
b ─────────┼───┐  ├── Tv1 ──┐
           │   │  │         │
b ─────────┴───┼──┤ (AND)   │
d ─────────┬───┼──┤── Tv2 ──┼──┐ (OR)
           │   │  │         │  ├── v
c ─────────┼───┴──┤ (AND)   │  │
d ──[NOT]──┴──────┤── Tv3 ──┘──┘
```

---

## 6. Respuestas a las Preguntas Teóricas del Mandato

### Pregunta 1: ¿Cuántos términos producto tiene la expresión SOP mínima de cada función?
- La función $u(a, b, c, d)$ tiene **3 términos producto**: $ab$, $ac$ y $\bar{c}d$.
- La función $v(a, b, c, d)$ tiene **3 términos producto**: $\bar{a}b$, $bd$ y $c\bar{d}$.

### Pregunta 2: ¿Cuántos literales tiene la expresión SOP mínima en total?
- Para la función $u$:
  - $ab$ (2 literales) + $ac$ (2 literales) + $\bar{c}d$ (3 literales) = **7 literales**.
- Para la función $v$:
  - $\bar{a}b$ (3 literales) + $bd$ (2 literales) + $c\bar{d}$ (3 literales) = **7 literales**.
- **Total combinado:** $7 + 7 = \mathbf{14\ \text{literales}}$.

### Pregunta 3: ¿Qué combinación de control $\{v, u\}$ se activa con mayor frecuencia sobre los 16 minitérminos?
Analizando la distribución sobre los 16 minitérminos posibles:
- **`{v, u} = 2'b00` (XOR):** 3 minitérminos ($m_0, m_3, m_8$) $\rightarrow 18.75\%$
- **`{v, u} = 2'b01` (SUMA):** 4 minitérminos ($m_1, m_9, m_{11}, m_{12}$) $\rightarrow 25.00\%$
- **`{v, u} = 2'b10` (MAYOR):** 4 minitérminos ($m_2, m_4, m_6, m_7$) $\rightarrow 25.00\%$
- **`{v, u} = 2'b11` (RESTA):** 5 minitérminos ($m_5, m_{10}, m_{13}, m_{14}, m_{15}$) $\rightarrow 31.25\%$

**Respuesta:** La combinación de control con mayor frecuencia es **`{v, u} = 2'b11` (operación RESTA)**, la cual se activa en **5 de las 16 combinaciones** ($31.25\%$ del espacio total).

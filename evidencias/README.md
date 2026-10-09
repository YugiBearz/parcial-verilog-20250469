# Evidencias de Funcionamiento — Reto 14
## Procesador de Verificación en FPGA Sipeed Tang Primer 25K

- **Estudiante:** Urik Camilo Valenzuela Flynn
- **Matrícula:** 20250469
- **Asignatura:** Sistemas Digitales con FPGA (ITLA)
- **Docente:** Prof. Wilkins Gabriel Cedano Del Rosario

---

### 1. Enlace a Video Demostrativo
- **Plataforma:** YouTube / Google Drive / Loom
- **Enlace:** `[INSERTAR_ENLACE_AQUI]`
- **Descripción:** Demostración del funcionamiento en tiempo real sobre la tarjeta Tang Primer 25K, verificando:
  1. Estado inicial tras reset mediante pulsador `btn_rst_n`.
  2. Operación **XOR** (`{v, u} = 00`) con paridad impar en `led_flag`.
  3. Operación **SUMA** (`{v, u} = 01`) con acarreo en `led_flag`.
  4. Operación **MAYOR** (`{v, u} = 10`) con bandera de igualdad en `led_flag`.
  5. Operación **RESTA** (`{v, u} = 11`) con préstamo en `led_flag`.
  6. Función del habilitador `btn_en` congelando y actualizando el registro `Q`.

---

### 2. Registro Fotográfico del Montaje
*(Adjuntar fotografías de la tarjeta Tang Primer 25K conectada y los LEDs encendidos según los casos de prueba).*

- **Foto 1: Placa Tang Primer 25K conectada y programada**
  - Ubicación: `evidencias/foto_placa_montaje.jpg`
- **Foto 2: Ejecución de operación con indicador LED activo**
  - Ubicación: `evidencias/foto_operacion_leds.jpg`

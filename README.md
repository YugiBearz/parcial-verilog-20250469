# Primer Parcial — Sistemas Digitales con FPGA (ITLA)
## Reto 14: Procesador de Verificación

- **Estudiante:** Urik Camilo Valenzuela Flynn
- **Matrícula:** 20250469
- **Correo Institucional:** 20250469@itla.edu.do
- **Placa de Desarrollo:** Sipeed Tang Primer 25K (Gowin GW5A-LV25MG121)

---

### Descripción del Proyecto
Diseño, implementación y verificación en Verilog 2001 de una unidad digital que procesa dos lecturas sin signo de 4 bits (`A` y `B`), selecciona una operación mediante 4 variables de control (`a, b, c, d`) y almacena el resultado en un registro con habilitación y reset asíncrono.

### Especificaciones del Reto 14
- **Lógica de Control:**
  - $u(a,b,c,d) = \sum m(1, 5, 9, 10, 11, 12, 13, 14, 15)$
  - $v(a,b,c,d) = \sum m(2, 4, 5, 6, 7, 10, 13, 14, 15)$
- **Operaciones {v, u}:**
  - `00` $\rightarrow$ XOR
  - `01` $\rightarrow$ SUMA
  - `10` $\rightarrow$ MAYOR
  - `11` $\rightarrow$ RESTA

---

### Estado del Desarrollo
- [x] Paso 01-03: Estructura del proyecto y configuración de control de versiones.
- [ ] Fase 1: Tablas de verdad y mapas de Karnaugh.
- [ ] Fase 2: Implementación de módulos RTL (`control_logic`, `datapath`, `result_register`).
- [ ] Fase 3: Integración de simulación (`top_20250469`) y testbench exhaustivo (4096 vectores + 12 temporales).
- [ ] Fase 4: Adaptador físico para Tang Primer 25K (`tang_top_20250469`), CST y SDC.
